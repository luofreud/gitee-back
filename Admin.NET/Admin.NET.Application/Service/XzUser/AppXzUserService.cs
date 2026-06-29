// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Admin.NET.Application.Entity;
using Admin.NET.Core.Service;
using Furion.DatabaseAccessor;
using Furion.FriendlyException;
using Mapster;
using Microsoft.AspNetCore.Http;
using SqlSugar;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
namespace Admin.NET.Application;

/// <summary>
/// 用户信息服务 🧩
/// appid:dc78519832564e9b99ff3aa2e63c9ffe  a9da19a8ef2c40d0bca9c83d4f7315fa
/// </summary>
[ApiDescriptionSettings(ApplicationConst.AppGroupName, Name = "AppXzUser", Order = 100)]
public partial class AppXzUserService : IDynamicApiController, ITransient
{
    private readonly AppUserManager _userManager;
    private readonly SqlSugarRepository<XzUser> _xzUserRep;
    private readonly ISqlSugarClient _sqlSugarClient;
    private readonly SysSmsService _sysSmsService;
    private readonly SysFileService _sysFileService;
    private readonly SqlSugarRepository<XzUsercoupon> _xzUserCoupon;
    private readonly SqlSugarRepository<XzSubscribe> _xzXzSubscribeRep;

    public AppXzUserService(SqlSugarRepository<XzUser> xzUserRep, ISqlSugarClient sqlSugarClient, AppUserManager userManager, SysSmsService sysSmsService, SysFileService sysFileService, SqlSugarRepository<XzUsercoupon> xzUserCoupon, SqlSugarRepository<XzSubscribe> xzXzSubscribeRep)
    {
        _xzUserRep = xzUserRep;
        _sqlSugarClient = sqlSugarClient;
        _userManager = userManager;
        _sysSmsService = sysSmsService;
        _sysFileService = sysFileService;
        _xzUserCoupon = xzUserCoupon;
        _xzXzSubscribeRep = xzXzSubscribeRep;
    }
    #region 文件上传
    /// <summary>
    /// 文件上传 base64
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("上传单文件")]
    public async Task<SysFile> UploadFileFromBase64(UploadFileFromBase64Input input)
    {
        if (input == null) throw Oops.Oh(ErrorCodeEnum.D2102);

        return await _sysFileService.UploadFileFromBase64(input);
    }

    /// <summary>
    /// 文件上传
    /// </summary>
    /// <param name="file"></param>
    /// <returns></returns>
    [DisplayName("上传单文件")]
    public async Task<SysFile> UploadFile(IFormFile file)
    {
        if (file == null) throw Oops.Oh(ErrorCodeEnum.D2102);
        return await _sysFileService.UploadFile(new UploadFileInput { File = file, AllowSuffix = ".jpeg.jpg.png.bmp.gif.tif" }, "upload/appavatar");
    }

    /// <summary>
    /// 上传多文件 🔖
    /// </summary>
    /// <param name="files"></param>
    /// <returns></returns>
    [DisplayName("上传多文件")]
    public async Task<List<SysFile>> UploadFiles([Required] List<IFormFile> files)
    {
        var fileList = new List<SysFile>();
        foreach (var file in files)
        {
            var uploadedFile = await _sysFileService.UploadFile(new UploadFileInput { File = file, AllowSuffix = ".jpeg.jpg.png.bmp.gif.tif" });
            fileList.Add(uploadedFile);
        }
        return fileList;
    }

    #endregion

    #region 用户接口
    /// <summary>
    /// 获取用户信息 🔖
    /// </summary>
    /// <returns></returns>
    [DisplayName("获取用户信息")]
    public virtual async Task<XzUserOutput> GetUserInfo()
    {
        var user = await _xzUserRep.AsQueryable().ClearFilter().FirstAsync(u => u.Id == _userManager.userid) ?? throw Oops.Oh(ErrorCodeEnum.D1011).StatusCode(401);

        var loginUserOutput = user.Adapt<XzUserOutput>();
        //优惠劵数量
        loginUserOutput.couponcount = _xzUserCoupon.AsQueryable().Where(t => t.uid == user.Id && t.state == 0 && t.etime <= DateTime.Now).Count();
        return loginUserOutput;

    }

    /// <summary>
    /// 修改手机号 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("修改手机号")]
    public virtual async Task<int> EditLogin([Required] LoginPhoneInput input)
    {
        // 校验短信验证码
        _sysSmsService.VerifyCode(new SmsVerifyCodeInput { Phone = input.Phone, Code = input.Code });
        var xzuser = new XzUser();
        xzuser.Id = _userManager.userid;
        xzuser.phone = input.Phone;
        return await _xzUserRep.AsUpdateable(xzuser).UpdateColumns(it => new { it.phone })
            .Where(t => t.Id == xzuser.Id).ExecuteCommandAsync();
    }

    /// <summary>
    /// 修改个性签名 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("修改个性签名")]
    public virtual async Task<int> EditSignature([Required] XzUserBaseInput input)
    {
        var xzuser = new XzUser();
        xzuser.Id = _userManager.userid;
        xzuser.sign = input.sign;
        return await _xzUserRep.AsUpdateable(xzuser).UpdateColumns(it => new { it.sign })
            .Where(t => t.Id == xzuser.Id).ExecuteCommandAsync();
    }

    /// <summary>
    /// 修改用户昵称 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("修改用户昵称")]
    public virtual async Task<int> EditNick([Required] XzUserBaseInput input)
    {
        var xzuser = new XzUser();
        xzuser.Id = _userManager.userid;
        xzuser.nickname = input.nickname;
        return await _xzUserRep.AsUpdateable(xzuser).UpdateColumns(it => new { it.nickname })
            .Where(t => t.Id == xzuser.Id).ExecuteCommandAsync();
    }

    /// <summary>
    /// 修改性别 🔖
    /// </summary>
    /// <param name="input">0:男，1:女</param>
    /// <returns></returns>
    [DisplayName("修改性别")]
    public virtual async Task<int> EditSex([Required] XzUserBaseInput input)
    {
        var xzuser = new XzUser();
        xzuser.Id = _userManager.userid;
        xzuser.sex = input.sex;
        return await _xzUserRep.AsUpdateable(xzuser).UpdateColumns(it => new { it.sex })
            .Where(t => t.Id == xzuser.Id).ExecuteCommandAsync();
    }

    /// <summary>
    /// 修改出生日期 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("修改出生日期")]
    public virtual async Task<int> EditBirthday([Required] XzUserBaseInput input)
    {
        var xzuser = new XzUser();
        xzuser.Id = _userManager.userid;
        xzuser.birthday = input.birthday;
        xzuser.xzname = GetZodiac(xzuser.birthday.Value);
        xzuser.xzimg = string.Empty;
        return await _xzUserRep.AsUpdateable(xzuser).UpdateColumns(it => new { it.birthday, it.xzname, it.xzimg })
            .Where(t => t.Id == xzuser.Id).ExecuteCommandAsync();
    }


    /// <summary>
    /// 修改出生地址 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("修改出生地址")]
    public virtual async Task<int> EditAddress([Required] XzUserBaseInput input)
    {
        var xzuser = new XzUser();
        xzuser.Id = _userManager.userid;
        xzuser.address = input.address;
        return await _xzUserRep.AsUpdateable(xzuser).UpdateColumns(it => new { it.address })
            .Where(t => t.Id == xzuser.Id).ExecuteCommandAsync();
    }

    /// <summary>
    /// 修改现地址 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("修改现地址")]
    public virtual async Task<int> EditNowAddress([Required] XzUserBaseInput input)
    {
        var xzuser = new XzUser();
        xzuser.Id = _userManager.userid;
        xzuser.nowaddress = input.nowaddress;
        return await _xzUserRep.AsUpdateable(xzuser).UpdateColumns(it => new { it.nowaddress })
            .Where(t => t.Id == xzuser.Id).ExecuteCommandAsync();
    }

    /// <summary>
    /// 修改头像 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("修改头像")]
    public virtual async Task<int> EditAvatar([Required] XzUserBaseInput input)
    {
        var xzuser = new XzUser();
        xzuser.Id = _userManager.userid;
        xzuser.headimg = input.headimg;
        return await _xzUserRep.AsUpdateable(xzuser).UpdateColumns(it => new { it.headimg })
            .Where(t => t.Id == xzuser.Id).ExecuteCommandAsync();
    }

    /// <summary>
    /// 注销用户 🔖
    /// </summary>
    /// <returns></returns>
    [DisplayName("注销用户")]
    public virtual async Task<int> DeleteUse()
    {
        var xzuser = new XzUser();
        xzuser.Id = _userManager.userid;
        xzuser.isdelete = 1;
        return await _xzUserRep.AsUpdateable(xzuser).UpdateColumns(it => new { it.isdelete })
            .Where(t => t.Id == xzuser.Id).ExecuteCommandAsync();
    }

    #endregion

    #region 用户关注接口
    /// <summary>
    /// 分页查询用户关注列表(0：用户关注，1：老师关注，2：话题，3：文章) 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("分页查询用户关注列表")]
    [ApiDescriptionSettings(Name = "UserSubPage"), HttpPost]
    public async Task<SqlSugarPagedList<XzSubscribe>> UserSubPage(PageXzSubscribeInput input)
    {
        var query = _xzXzSubscribeRep.AsQueryable();
        if (input.stype == 0)
        {
            query.Includes(t => t.gzuser)
                .WhereIF(!string.IsNullOrWhiteSpace(input.Keyword), t => t.gzuser.nickname.Contains(input.Keyword));
                
        }
        else if (input.stype == 1)
        {
            query.Includes(t => t.gzteacher)
                .WhereIF(!string.IsNullOrWhiteSpace(input.Keyword),t => t.gzteacher.name.Contains(input.Keyword));
        }
        else if (input.stype == 2)
        {
            query.Includes(t => t.gztopic)
                .WhereIF(!string.IsNullOrWhiteSpace(input.Keyword), t => t.gztopic.title.Contains(input.Keyword));
        }
        else if(input.stype == 3)
        {
            query.Includes(t => t.xzArticle)
                .WhereIF(!string.IsNullOrWhiteSpace(input.Keyword), t => t.xzArticle.title.Contains(input.Keyword));
        }
        return await query.Where(u => u.uid == _userManager.userid && u.stype == (input.stype ?? 2))
                .WhereIF(input.corrid!=null, u=>u.corrid==input.corrid)
                .OrderByDescending(f => new { f.createtime })
                .Select<XzSubscribe>().OrderBuilder(input)
                .ToPagedListAsync(input.Page, input.PageSize);
    }

    /// <summary>
    /// 关注 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("关注")]
    [ApiDescriptionSettings(Name = "UserSubAdd"), HttpPost]
    public virtual async Task<bool> UserSubAdd([Required] XzSubscribe input)
    {
        if(input.corrid==null || input.corrid==0 || input.stype==null)
        {
            throw new Exception("参数错误");
        }
        var isAdd = await _xzXzSubscribeRep.AsQueryable().AnyAsync(f => f.uid == _userManager.userid && f.corrid == input.corrid);
        if (isAdd)
        {
            return true;
        }
        input.uid = _userManager.userid;
        input.createtime = DateTime.Now;

        if (input.stype == 3)
        {
            //收藏文章，需要为文章的收藏+1
            await _sqlSugarClient.Updateable<XzArticle>().SetColumns(it => it.collectioncount == it.collectioncount+ 1)
            .Where(it => it.Id == input.corrid)
            .ExecuteCommandAsync();
        }


        return await _xzXzSubscribeRep.InsertAsync(input);

    }

    /// <summary>
    /// 取消关注 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("取消关注")]
    [ApiDescriptionSettings(Name = "UserSubDel"), HttpPost]
    public virtual async Task<bool> UserSubDel([Required] XzSubscribe input)
    {
        var subdata = await _xzXzSubscribeRep.GetByIdAsync(input.Id);
        if (subdata!=null && subdata.stype == 3)
        {
            //收藏的是文章，需要为文章的收藏-1
            await _sqlSugarClient.Updateable<XzArticle>().SetColumns(it => it.collectioncount == it.collectioncount - 1)
            .Where(it => it.Id == subdata.corrid)
            .ExecuteCommandAsync();
        }

        return await _xzXzSubscribeRep.DeleteByIdAsync(input.Id);
    }


    #endregion
    /// <summary>
    /// 根据出生日期返回星座名称（中文）。
    /// </summary>
    /// <param name="date">出生日期</param>
    /// <returns>星座名称</returns>
    [NonAction]
    private string GetZodiac(DateTime date)
    {
        int month = date.Month;
        int day = date.Day;

        // 星座日期范围（公历）
        if ((month == 1 && day >= 20) || (month == 2 && day <= 18))
            return "水瓶座";
        if ((month == 2 && day >= 19) || (month == 3 && day <= 20))
            return "双鱼座";
        if ((month == 3 && day >= 21) || (month == 4 && day <= 19))
            return "白羊座";
        if ((month == 4 && day >= 20) || (month == 5 && day <= 20))
            return "金牛座";
        if ((month == 5 && day >= 21) || (month == 6 && day <= 21))
            return "双子座";
        if ((month == 6 && day >= 22) || (month == 7 && day <= 22))
            return "巨蟹座";
        if ((month == 7 && day >= 23) || (month == 8 && day <= 22))
            return "狮子座";
        if ((month == 8 && day >= 23) || (month == 9 && day <= 22))
            return "处女座";
        if ((month == 9 && day >= 23) || (month == 10 && day <= 23))
            return "天秤座";
        if ((month == 10 && day >= 24) || (month == 11 && day <= 22))
            return "天蝎座";
        if ((month == 11 && day >= 23) || (month == 12 && day <= 21))
            return "射手座";
        // 摩羯座：12月22日 - 1月19日
        return "摩羯座";
    }
}
