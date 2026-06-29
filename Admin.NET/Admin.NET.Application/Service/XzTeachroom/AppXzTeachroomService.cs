// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Admin.NET.Application.Entity;
using Admin.NET.Core.Service;
using Admin.NET.Core.Utils;
using Dm.util;
using Furion.DatabaseAccessor;
using Furion.FriendlyException;
using Mapster;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Options;
using NewLife;
using SqlSugar;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
namespace Admin.NET.Application;

/// <summary>
/// 导师直播间服务 🧩
/// </summary>
[ApiDescriptionSettings(ApplicationConst.AppGroupName, Order = 100)]
public partial class AppXzTeachroomService : IDynamicApiController, ITransient
{
    private readonly SqlSugarRepository<XzTeachroom> _xzTeachroomRep;
    private readonly ISqlSugarClient _sqlSugarClient;
    private readonly AppUserManager _userManager;
    private readonly SqlSugarRepository<XzUser> _xzUserRep;
    private readonly SysFileService _sysFileService;
    private readonly SqlSugarRepository<XzTeacher> _xzTeacherRep;
    private readonly SqlSugarRepository<XzImlog> _xzImlogRep;
    RoomConfigOptions _roomConfigOptions;
    private readonly SysCacheService _sysCacheService;
    private readonly SqlSugarRepository<XzSubscribe> _xzXzSubscribeRep;


    public AppXzTeachroomService(SysCacheService sysCacheService, SqlSugarRepository<XzImlog> xzImlogRep, IOptions<RoomConfigOptions> roomConfigOptions,
        SqlSugarRepository<XzTeacher> xzTeacherRep, SysFileService sysFileService, AppUserManager userManager, SqlSugarRepository<XzUser> xzUserRep, 
        SqlSugarRepository<XzTeachroom> xzTeachroomRep, ISqlSugarClient sqlSugarClient, SqlSugarRepository<XzSubscribe> xzXzSubscribeRep)
    {
        _xzTeachroomRep = xzTeachroomRep;
        _sqlSugarClient = sqlSugarClient;
        _userManager = userManager;
        _xzUserRep = xzUserRep;
        _sysFileService = sysFileService;
        _xzTeacherRep = xzTeacherRep;
        _roomConfigOptions = roomConfigOptions.Value;
        _xzImlogRep = xzImlogRep;
        _sysCacheService = sysCacheService;
        _xzXzSubscribeRep = xzXzSubscribeRep;
    }

    #region 文件上传

    /// <summary>
    /// 直播文件上传
    /// </summary>
    /// <param name="file"></param>
    /// <returns></returns>
    [DisplayName("上传单文件")]
    public async Task<SysFile> UploadFile(IFormFile file)
    {
        if (file == null) throw Oops.Oh(ErrorCodeEnum.D2102);
        return await _sysFileService.UploadFile(new UploadFileInput { File = file, AllowSuffix = ".jpeg.jpg.png.bmp.gif.tif" }, "upload/live");
    }
    #endregion

    /// <summary>
    /// 用户端推荐直播间列表 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("用户端直播间列表")]
    [ApiDescriptionSettings(Name = "UserTopPage"), HttpPost]
    public async Task<SqlSugarPagedList<XzTeachroomOutput>> UserTopPage(PageXzTeachroomInput input)
    {
        var query = _xzTeachroomRep.AsQueryable()
            .Includes(f=>f.teacher)
            .Where(f => f.state < 2 && f.istop == 1)
            .OrderByDescending(f => new { f.lookrum, f.istop, f.createtime });
        var listData = await query.OrderBuilder(input).ToPagedListAsync(input.Page, input.PageSize);
        return listData.Adapt<SqlSugarPagedList<XzTeachroomOutput>>();
    }

    /// <summary>
    /// 用户端直播间列表 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("用户端直播间列表")]
    [ApiDescriptionSettings(Name = "UserPage"), HttpPost]
    public async Task<SqlSugarPagedList<XzTeachroomOutput>> UserPage(PageXzTeachroomInput input)
    {
        var query = _xzTeachroomRep.AsQueryable()
            .Includes(f => f.teacher)
            .Where(f => f.state < 2)
            .WhereIF(input.state < 2, f => f.state == input.state)
            .OrderByDescending(f => new { f.lookrum, f.ishot, f.createtime });
        var listData = await query.OrderBuilder(input).ToPagedListAsync(input.Page, input.PageSize);
        return listData.Adapt<SqlSugarPagedList<XzTeachroomOutput>>();
    }

    /// <summary>
    /// 用户端 用户第一次进入直播间 只需要传roomid
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("用户第一次进入直播间")]
    [ApiDescriptionSettings(Name = "FirstInRoom"), HttpPost]
    public async Task<List<XzRoomUserOutput>> FirstInRoom(AddXzTeachroomInput input)
    {
        var room = await _xzTeachroomRep.AsQueryable().Where(f => f.roomid == input.roomid).FirstAsync();
        //查询直播间信息
        if (room == null)
        {
            throw new Exception("直播间已结束");
        }
        room.lookrum += 1;
        await _xzTeachroomRep.AsUpdateable(room).UpdateColumns(f => f.lookrum).ExecuteCommandAsync();


        var userlist = _sysCacheService.Get<List<XzRoomUserOutput>>(room.roomid + "_users");
        if (userlist == null)
        {
            userlist = new List<XzRoomUserOutput>();
        }
        var findUserCount = userlist.Where(f => f.Id == _userManager.userid).Count();
        if (findUserCount == 0)
        {
            var user = await _xzUserRep.AsQueryable().Where(f => f.Id == _userManager.userid)
            .Select<XzRoomUserOutput>(f => new XzRoomUserOutput
            {
                Id = f.Id,
                nickname = f.nickname,
                level = f.level,
                headimg = f.headimg,
                address = f.address,
                createtime = f.createtime,
                sex = f.sex,
                birthday = f.birthday,
                roomtime = DateTime.Now
            })
            .FirstAsync();
            userlist.add(user);
            //设置缓存
            _sysCacheService.Set(room.roomid + "_users", userlist);
        }
        return await Task.FromResult<List<XzRoomUserOutput>>(userlist);
    }


    /// <summary>
    /// 用户端 用户退出直播间 只需要传roomid
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("用户退出直播间")]
    [ApiDescriptionSettings(Name = "UserOutRoom"), HttpPost]
    public async Task<List<XzRoomUserOutput>> UserOutRoom(AddXzTeachroomInput input)
    {
        var room = await _xzTeachroomRep.AsQueryable().Where(f => f.roomid == input.roomid).FirstAsync();
        //查询直播间信息
        if (room == null)
        {
            throw new Exception("直播间已结束");
        }

        room.lookrum -= 1;
        await _xzTeachroomRep.AsUpdateable(room).UpdateColumns(f => f.lookrum).ExecuteCommandAsync();

        var userlist = _sysCacheService.Get<List<XzRoomUserOutput>>(room.roomid + "_users");
        if (userlist == null)
        {
            userlist = new List<XzRoomUserOutput>();
        }

        var finduser = userlist.Where(f => f.Id == _userManager.userid).ToList();

        finduser.ForEach(f =>
        {
            userlist.Remove(f);
        });
        //设置缓存
        _sysCacheService.Set(room.roomid + "_users", userlist);

        return await Task.FromResult<List<XzRoomUserOutput>>(userlist);
    }


    /// <summary>
    /// 每隔几秒用户请求刷新直播间数据 只需要传roomid
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("每隔几秒用户请求刷新直播间数据")]
    [ApiDescriptionSettings(Name = "RefreshRoom"), HttpPost]
    public async Task<List<XzRoomUserOutput>> RefreshRoom(AddXzTeachroomInput input)
    {

        var userlist = _sysCacheService.Get<List<XzRoomUserOutput>>(input.roomid + "_users");
        if (userlist == null)
        {
            userlist = new List<XzRoomUserOutput>();
        }
        var finduser = userlist.Where(f => f.Id == _userManager.userid).FirstOrDefault();

        if (finduser == null)
        {
            finduser = await _xzUserRep.AsQueryable().Where(f => f.Id == _userManager.userid)
              .Select<XzRoomUserOutput>(f => new XzRoomUserOutput
              {
                  Id = f.Id,
                  nickname = f.nickname,
                  level = f.level,
                  headimg = f.headimg,
                  address = f.address,
                  createtime = f.createtime,
                  sex = f.sex,
                  birthday = f.birthday,
                  roomtime = DateTime.Now,
              })
              .FirstAsync();
            userlist.add(finduser);
        }
        else
        {
            finduser.roomtime = DateTime.Now;
        }
        //设置缓存
        _sysCacheService.Set(input.roomid + "_users", userlist);


        return await Task.FromResult<List<XzRoomUserOutput>>(userlist);
    }

    /// <summary>
    /// 用户点赞后增加直播间点赞数量 只需要传roomid 和 likenum
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("用户点赞后增加直播间点赞数量")]
    [ApiDescriptionSettings(Name = "AddLikenum"), HttpPost]
    public async Task<int?> AddLikenum(AddXzTeachroomInput input)
    {
        var room = await _xzTeachroomRep.GetByIdAsync(input.Id);
        //查询直播间信息
        if (room == null)
        {
            throw new Exception("参数错误");
        }
        room.likerum += (input.likenum ?? 0);
        await _xzTeachroomRep.AsUpdateable(room).UpdateColumns(f => f.likerum).ExecuteCommandAsync();
        return room.likerum;
    }


    /// <summary>
    /// 老师端直播间列表 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("分页查询导师直播间")]
    [ApiDescriptionSettings(Name = "Page"), HttpPost]
    public async Task<SqlSugarPagedList<XzTeachroomOutput>> Page(PageXzTeachroomInput input)
    {
        var query = _xzTeachroomRep.AsQueryable()
            .Where(f => f.tid == _userManager.tid)
            .WhereIF(input.state < 2, f => f.state == input.state)
            .OrderByDescending(f => f.createtime)
            .Select<XzTeachroomOutput>();
        return await query.OrderBuilder(input).ToPagedListAsync(input.Page, input.PageSize);
    }

    /// <summary>
    /// 获取导师直播间详情 ℹ️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("获取导师直播间详情")]
    [ApiDescriptionSettings(Name = "Detail"), HttpGet]
    public async Task<XzTeachroomOutput> Detail([FromQuery] QueryByIdXzTeachroomInput input)
    {
        var teacheRoom = await _xzTeachroomRep.AsQueryable()
            .Includes(f => f.teacher).FirstAsync(u => u.Id == input.Id);
        var teacheRoomOutput = teacheRoom.Adapt<XzTeachroomOutput>();
        //查询是否关注导师
        if (teacheRoomOutput.teacher != null)
        {
            var isSubscribe = await _xzXzSubscribeRep.AsQueryable().AnyAsync(f => f.stype == 1 && f.uid == _userManager.userid && f.corrid== teacheRoomOutput.teacher.Id);
            teacheRoomOutput.teacher.IsSubscribe = isSubscribe ? 1 : 0 ;
        }
        return teacheRoomOutput;
    }

    /// <summary>
    /// 老师端 增加导师直播间 ➕
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("增加导师直播间")]
    [ApiDescriptionSettings(Name = "Add"), HttpPost]
    public async Task<long> Add(AddXzTeachroomInput input)
    {
        var entity = input.Adapt<XzTeachroom>();
        if (_userManager.utype != 1 && _userManager.utype != 2)
        {
            throw new Exception("无直播权限");
        }

        uint random = (uint)new Random().Next(256); // 8位
        var teacher = await _xzTeacherRep.GetByIdAsync(_userManager.tid);
        entity.uid = _userManager.userid;
        entity.tid = teacher.Id;
        entity.level = teacher.level;
        entity.major = teacher.tags;
        entity.ishot = teacher.istop;
        entity.lookrum = 0;
        entity.ishot = 0;
        entity.istop = 0;
        entity.state = 0;
        entity.roomid = (_userManager.roomid + _userManager.roomid * random.ToString().Length) + random;
        entity.uroomid = _userManager.roomid;
        entity.createtime = DateTime.Now;
        entity.rnum = 0;
        return await _xzTeachroomRep.InsertAsync(entity) ? entity.Id : 0;


    }

    /// <summary>
    /// 老师端 结束直播间
    /// </summary>
    /// <param name="id"></param>
    /// <returns></returns>
    [DisplayName("导师结束直播间")]
    [ApiDescriptionSettings(Name = "Close"), HttpGet]
    public async Task<long> Close([FromQuery]long id)
    {
        var room = await _xzTeachroomRep.AsQueryable().Where(f => f.Id == id).FirstAsync();
        //查询直播间信息
        if (room == null)
        {
            throw new Exception("直播间已结束");
        }
        room.state = 2;
        room.overtime = DateTime.Now;
        return await _xzTeachroomRep.AsUpdateable(room).UpdateColumns(it => new { it.state, it.overtime }).ExecuteCommandAsync();
    }

    /// <summary>
    /// 用户申请直播连麦
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("用户申请直播连麦")]
    [ApiDescriptionSettings(Name = "TeacherConnectUser"), HttpPost]
    [UnitOfWork]
    public async Task<XzImlogOutput> TeacherConnectUser(TeacherConnectUserInput input)
    {
        var onlineuser = await _xzUserRep.GetByIdAsync(_userManager.userid);
        var teachermodel = await _xzTeacherRep.AsQueryable()
            .RightJoin<XzTeachroom>((f, o) => f.Id == o.tid)
            .Where((f, o) => o.Id == input.RoomId).Select(f => f).FirstAsync();

        if (teachermodel.liveprice > onlineuser.xzmoney)
        {
            throw new Exception("星币不足");
        }
        var findLog = await _xzImlogRep.AsQueryable().Where(f => f.roomid == input.RoomId && f.itype == input.itype && f.state == 0).FirstAsync();
        if(findLog!=null)
        {
            //return findLog.Adapt<XzImlogOutput>();
            throw new Exception("已申请连麦，请等待主播接入");
        }

        // 更新一次导师的连麦次数
        _xzTeacherRep.AsUpdateable()
            .SetColumns(it => it.livenum == (it.livenum ?? 0) + 1)
            .Where(it => it.Id == teachermodel.Id)
            .ExecuteCommand();


        var price = teachermodel.liveprice;
        if (input.itype == 1)
        {
            price = teachermodel.oliveprice;
        }

        XzImlog xzImlog = new XzImlog();
        xzImlog.uid = onlineuser.Id;
        xzImlog.createtime = DateTime.Now;
        xzImlog.tid = teachermodel.Id;
        xzImlog.price = price;
        xzImlog.paytime = 0;
        xzImlog.freetime = 0;
        xzImlog.state = 0;
        xzImlog.imtime = 0;
        xzImlog.isdel = 0;
        xzImlog.itype = input.itype ?? 0;
        xzImlog.orderno = "LM" + DateTime.Now.Ticks;
        xzImlog.ostate = 0;
        xzImlog.roomid = input.RoomId;

        try
        {
            var resultid = await _xzImlogRep.InsertReturnSnowflakeIdAsync(xzImlog);

            var resultim = xzImlog.Adapt<XzImlogOutput>();
            resultim.userxzmoney = onlineuser.xzmoney;
            if (resultid > 0)
            {
                //var builder = new RtcTokenBuilder2();
                //string token2 = builder.BuildTokenWithRtm(
                //            _roomConfigOptions.APP_ID, _roomConfigOptions.APP_CERTIFICATE,
                //           "*", (uint)onlineuser.roomid,
                //           RtcTokenBuilder2.Role.Publisher,
                //           3600 * 9, 3600 * 9);
                //resultim.appid = _roomConfigOptions.APP_ID;
                //resultim.roomtoken = token2;
                return resultim;
            }
        }
        catch { }

        throw new Exception("加入直播间失败");
    }

    /// <summary>
    /// 更新用户连麦时长
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("更新连麦时长")]
    [ApiDescriptionSettings(Name = "UpdateImTime"), HttpPost]
    [UnitOfWork]
    public async Task<int> UpdateImTime(AddXzTeachroomInput input)
    {
        var onlineuser = await _xzUserRep.GetByIdAsync(_userManager.userid);
        var imlog = await _xzImlogRep.GetByIdAsync(input.Id);
        //var teachermodel = await _xzTeacherRep.AsQueryable()
        //     .RightJoin<XzTeachroom>((f, o) => f.Id == o.tid)
        //     .Where((f, o) => o.Id == input.Id).Select(f => f).FirstAsync();
        int state = 0;
        //List<Task> tasks = new List<Task>();
        var totaltime = Math.Ceiling((DateTime.Now - imlog.starttime.Value).TotalMinutes);
        if (imlog.imtime == totaltime)
        {
            return state;
        }

        if (imlog.price > onlineuser.xzmoney)
        {
            totaltime = totaltime - 1;
            imlog.overtime = DateTime.Now;
            //imlog.imtime = totaltime.ToInt();
            //imlog.paytime = totaltime.ToInt();
            imlog.state = 2;
            //imlog.xzmoney = imlog.price * totaltime;
            //onlineuser.xzmoney -= imlog.xzmoney;
            state = -1;
        }
        else
        {
            imlog.overtime = DateTime.Now;
            imlog.imtime = totaltime.ToInt();
            imlog.paytime = totaltime.ToInt();
            imlog.xzmoney = imlog.price * totaltime;
            onlineuser.xzmoney -= imlog.xzmoney;
        }
        if (onlineuser.xzmoney < 0)
        {
            onlineuser.xzmoney = 0;
        }
        //tasks.Add();
        //tasks.Add();

        try
        {
            await _xzUserRep.AsUpdateable(onlineuser).UpdateColumns(f => f.xzmoney).ExecuteCommandAsync();
            await _xzImlogRep.AsUpdateable(imlog).UpdateColumns(f => new { f.overtime, f.imtime, f.paytime, f.state, f.xzmoney }).ExecuteCommandAsync();
            //await Task.WhenAll(tasks);
        }
        catch { }
        return state;
    }


    /// <summary>
    /// 获取房间token ➕
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("获取房间token")]
    [ApiDescriptionSettings(Name = "GetRoomToken"), HttpPost]
    public async Task<dynamic> GetRoomToken(AddXzTeachroomInput input, [FromQuery] string? type)
    {
        //获取私密连麦token
        if (type == "private")
        {
            var imLog = await _xzImlogRep.GetByIdAsync(input.Id);
            if(imLog==null)
            {
                throw new Exception("私密连麦不存在");
            }
            string channelPrivateName = "private_" + imLog.roomid.ToString() + "_" + imLog.uid.ToString();
            var builder = new RtcTokenBuilder2();
            string token2 = builder.BuildTokenWithRtm(
                    _roomConfigOptions.APP_ID, _roomConfigOptions.APP_CERTIFICATE,
                   channelPrivateName, (uint)_userManager.roomid,
                   RtcTokenBuilder2.Role.Publisher,
                   3600 * 9, 3600 * 9);
            return new
            {
                token = token2,
                appid = _roomConfigOptions.APP_ID,
                channelName = channelPrivateName
            };
        }

        var room = await _xzTeachroomRep.GetByIdAsync(input.Id);
        //查询直播间信息
        if (room == null)
        {
            throw new Exception("直播间已结束");
        }
        string channelName = "public_" + room.Id.ToString();
        
        if (_userManager.utype == 1)
        {
            var builder = new RtcTokenBuilder2();
            // room.roomid.ToString();
            string token2 = builder.BuildTokenWithRtm(
                    _roomConfigOptions.APP_ID, _roomConfigOptions.APP_CERTIFICATE,
                   channelName, (uint)_userManager.roomid,
                   RtcTokenBuilder2.Role.Publisher,
                   3600 * 9, 3600 * 9);
            return new
            {
                token = token2,
                appid = _roomConfigOptions.APP_ID,
                channelName = channelName
            };
        }
        else
        {
            //查询直播间信息
            if (room.state == 2)
            {
                throw new Exception("直播间已结束");
            }
            var builder = new RtcTokenBuilder2();
            string token2 = builder.BuildTokenWithRtm(
                    _roomConfigOptions.APP_ID, _roomConfigOptions.APP_CERTIFICATE,
                  channelName, (uint)_userManager.roomid,
                   RtcTokenBuilder2.Role.Publisher,
                   3600 * 9, 3600 * 9);
            return new
            {
                token = token2,
                appid = _roomConfigOptions.APP_ID,
                channelName
            };
        }
    }
}
