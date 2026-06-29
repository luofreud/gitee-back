// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Admin.NET.Core.Service;
using Microsoft.AspNetCore.Http;
using Furion.DatabaseAccessor;
using Furion.FriendlyException;
using Mapster;
using SqlSugar;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using Admin.NET.Application.Entity;
namespace Admin.NET.Application;

/// <summary>
/// app用户发布文章服务 🧩
/// </summary>
[ApiDescriptionSettings(ApplicationConst.AppGroupName, Order = 100)]
public partial class AppXzArticleService : IDynamicApiController, ITransient
{
    private readonly SqlSugarRepository<XzArticle> _xzArticleRep;
    private readonly ISqlSugarClient _sqlSugarClient;
    private readonly AppUserManager _userManager;
    private readonly SqlSugarRepository<XzArticlelike> _xzArticlelikeRep;
    private readonly SqlSugarRepository<XzXblog> _xzXblog;
    private readonly SqlSugarRepository<XzUser> _xzUser;
    private readonly SqlSugarRepository<XzArticleplate> _xzArticleplateRep;


    public AppXzArticleService(SqlSugarRepository<XzUser> xzUser, SqlSugarRepository<XzXblog> xzXblog, SqlSugarRepository<XzArticleplate> xzArticleplateRep, SqlSugarRepository<XzArticle> xzArticleRep, ISqlSugarClient sqlSugarClient, AppUserManager userManager, SqlSugarRepository<XzArticlelike> xzArticlelikeRep)
    {
        _xzArticleRep = xzArticleRep;
        _sqlSugarClient = sqlSugarClient;
        _userManager = userManager;
        _xzArticlelikeRep = xzArticlelikeRep;
        _xzXblog = xzXblog;
        _xzUser = xzUser;
        _xzArticleplateRep = xzArticleplateRep;
    }

    /// <summary>
    /// 分页查询用户发布文章 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("分页查询用户发布文章")]
    [ApiDescriptionSettings(Name = "Page"), HttpPost]
    public async Task<SqlSugarPagedList<XzArticleOutput>> Page(PageXzArticleInput input)
    {
        input.Keyword = input.Keyword?.Trim();
        var query = _xzArticleRep.AsQueryable()
            .Includes(f => f.user.ToList(it => new XzUser() { nickname = it.nickname, headimg = it.headimg }))
            .WhereIF(!string.IsNullOrWhiteSpace(input.Keyword), u => u.content.Contains(input.Keyword) || u.imgs.Contains(input.Keyword) || u.videos.Contains(input.Keyword) || u.tags.Contains(input.Keyword))
            .WhereIF(!string.IsNullOrWhiteSpace(input.tags), u => u.tags.Contains(input.tags.Trim()))
            .WhereIF(input.plateid != null, u => u.plateid == input.plateid)
            .WhereIF(input.topicid != null, u => u.topicid == input.topicid)
            .WhereIF(input.atype != null, u => u.atype == input.atype)
            .Where(u=>u.state==0)
            .OrderByDescending(f => new { f.istop, f.createtime });
        var pageListData = await query.OrderBuilder(input).ToPagedListAsync(input.Page, input.PageSize);
        var output = pageListData.Adapt<SqlSugarPagedList<XzArticleOutput>>();

        var uids = output.Items.Where(i => i.uid.HasValue).Select(i => i.uid.Value).Distinct().ToList();
        if (uids.Any())
        {
            var allRooms = await _sqlSugarClient.Queryable<XzTeachroom>()
                .Includes(t => t.teacher.ToList(it => new XzTeacher() { name = it.name, headimg = it.headimg }))
                .Where(t => uids.Contains(t.uid!.Value) && t.state != 2)
                .OrderByDescending(t => t.createtime)
                .ToListAsync();
            var roomDict = allRooms
                .GroupBy(t => t.uid!.Value)
                .ToDictionary(g => g.Key, g => g.First());
            foreach (var item in output.Items)
            {
                if (item.uid.HasValue && roomDict.TryGetValue(item.uid.Value, out var room))
                    item.teachroom = room;
            }
        }

        return output;
    }

    /// <summary>
    /// 获取用户发布文章详情 ℹ️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("获取用户发布文章详情")]
    [ApiDescriptionSettings(Name = "Detail"), HttpGet]
    public async Task<XzArticleOutput> Detail([FromQuery] QueryByIdXzArticleInput input)
    {
        var detail =  await _xzArticleRep.AsQueryable()
            .Includes(f => f.user.ToList(it => new XzUser() { nickname = it.nickname, headimg = it.headimg, level = it.level }))
            .Includes(f => f.xzArticlelike.Where(d => d.uid == _userManager.userid && d.ltype == 0).ToList())
            .Where(u => u.Id == input.Id && u.state == 0)
            .FirstAsync();

        var output = detail.Adapt<XzArticleOutput>();
        output.islike = await _sqlSugarClient.Queryable<XzArticlelike>().Where(t => t.uid == _userManager.userid && t.aid == input.Id && t.ltype == 0).AnyAsync() ? 1 : 0;

        output.iscollection = await _sqlSugarClient.Queryable<XzSubscribe>().Where(t => t.uid == _userManager.userid && t.corrid == input.Id && t.stype == 3).AnyAsync() ? 1 : 0;

        return output;
    }

    /// <summary>
    /// 增加用户发布文章 ➕
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("增加用户发布文章")]
    [ApiDescriptionSettings(Name = "Add"), HttpPost]
    [UnitOfWork]
    public async Task Add(AddXzArticleInput input)
    {
        //文章编码 user_article
        var user = await _xzUser.GetByIdAsync(_userManager.userid);

        var entity = input.Adapt<XzArticle>();

        entity.uid = _userManager.userid;
        entity.createtime = DateTime.Now;
        entity.collectioncount = 0;
        entity.likecount = 0;
        entity.commentcount = 0;
        entity.istop = 0;
        entity.state = 1;
        //根据后续添加任务 

        var taskmodel = await _sqlSugarClient.Queryable<XzTask>()
             .Includes(f => f.tasklog.Where(d => d.uid == _userManager.userid).ToList())
             .FirstAsync();
        List<Task> task = new List<Task>();

        if (taskmodel != null && taskmodel.tasklog.Count <= 0)
        {
            task.Add(_xzXblog.InsertAsync(new XzXblog { uid = _userManager.userid, xb = 10, createtime = DateTime.Now, mark = "首次发布文章", xbye = user.xbmoney }));
            user.xbmoney += taskmodel.xbmoney;
            task.Add(_xzUser.AsUpdateable(user).UpdateColumns(it => new { it.xbmoney }).ExecuteCommandAsync());
            task.Add(_sqlSugarClient.Insertable<XzFinishtasklog>(new XzFinishtasklog()
            {
                createtime = DateTime.Now,
                taskid = taskmodel.Id,
                uid = _userManager.userid
            }).ExecuteCommandAsync());
        }
        task.Add(_xzArticleRep.InsertAsync(entity));

        await Task.WhenAll(task);


        if (input.topicid != null)
        {
            await _sqlSugarClient.Updateable<XzArticleplate>()
                .SetColumns(it => new XzArticleplate() { count = it.count + 1 })
                .Where(it => it.Id == input.topicid)
                .ExecuteCommandAsync();
        }
    }

    /// <summary>
    /// 更新用户发布文章 ✏️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("更新用户发布文章")]
    [ApiDescriptionSettings(Name = "Update"), HttpPost]
    public async Task Update(UpdateXzArticleInput input)
    {
        var entity = input.Adapt<XzArticle>();
        await _xzArticleRep.AsUpdateable(entity).UpdateColumns(f => new { f.content, f.imgs, f.tags, f.videos }).Where(f => f.Id == entity.Id && f.uid == _userManager.userid)
        .ExecuteCommandAsync();
    }

    /// <summary>
    /// 删除用户发布文章
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("删除用户发布文章")]
    [ApiDescriptionSettings(Name = "Delete"), HttpPost]
    public async Task<bool> Delete(BaseIdInput input)
    {
        var entity = await _xzArticleRep.GetFirstAsync(u => u.Id == input.Id && u.uid == _userManager.userid) ?? throw Oops.Oh(ErrorCodeEnum.D1002);
        return await _xzArticleRep.DeleteAsync(entity);   //真删除
    }


    /// <summary>
    /// 点赞用户文章
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("点赞用户文章")]
    [ApiDescriptionSettings(Name = "Like"), HttpPost]
    [UnitOfWork]
    public async Task Like(BaseIdInput input)
    {
        var entity = await _xzArticleRep.GetFirstAsync(u => u.Id == input.Id) ?? throw Oops.Oh(ErrorCodeEnum.D1002);
        var count = await _xzArticlelikeRep.AsQueryable().
             Where(f => f.uid == _userManager.userid && f.aid == input.Id && f.ltype == 0).CountAsync();
        if (count <= 0)
        {
            entity.likecount += 1;
            await _xzArticlelikeRep.InsertAsync(new XzArticlelike
            {
                aid = input.Id,
                uid = _userManager.userid,
                createtime = DateTime.Now,
                ltype = 0
            });
            await _xzArticleRep.AsUpdateable(entity).UpdateColumns(f => f.likecount).Where(f => f.Id == entity.Id).ExecuteCommandAsync();
        }
        else
        {
            entity.likecount -= 1;
            if (entity.likecount < 0)
            {
                entity.likecount = 0;
            }
            await _xzArticlelikeRep.AsDeleteable().Where(f => f.uid == _userManager.userid && f.aid == entity.Id && f.ltype == 0).ExecuteCommandAsync();
            await _xzArticleRep.AsUpdateable(entity).UpdateColumns(f => f.likecount).Where(f => f.Id == entity.Id).ExecuteCommandAsync();
        }
    }

    ///// <summary>
    ///// 删除用户发布文章
    ///// </summary>
    ///// <param name="input"></param>
    ///// <returns></returns>
    //[DisplayName("删除用户发布文章")]
    //[ApiDescriptionSettings(Name = "Delete"), HttpPost]
    //public async Task Delete(DeleteXzArticleInput input)
    //{
    //    var entity = await _xzArticleRep.GetFirstAsync(u => u.Id == input.Id && u.uid == _userManager.userid) ?? throw Oops.Oh(ErrorCodeEnum.D1002);
    //    await _xzArticleRep.DeleteAsync(entity);   //真删除

    //}
    ///// <summary>
    ///// 删除用户发布文章
    ///// </summary>
    ///// <param name="input"></param>
    ///// <returns></returns>
    //[DisplayName("删除用户发布文章")]
    //[ApiDescriptionSettings(Name = "Delete"), HttpPost]
    //public async Task Delete(DeleteXzArticleInput input)
    //{
    //    var entity = await _xzArticleRep.GetFirstAsync(u => u.Id == input.Id && u.uid == _userManager.userid) ?? throw Oops.Oh(ErrorCodeEnum.D1002);
    //    await _xzArticleRep.DeleteAsync(entity);   //真删除

    //}

    /// <summary>
    /// 获取板块列表
    /// </summary>
    /// <returns></returns>
    [DisplayName("获取板块列表")]
    [ApiDescriptionSettings(Name = "GetPlate"), HttpGet]
    public async Task<List<XzArticleplateOutput>> GetPlate([FromQuery] int? type)
    {
        return await _xzArticleplateRep.AsQueryable()
            .WhereIF(type != null, f => f.ltype == type)
            .OrderByDescending(f => new { f.ishot, f.istop })
            .Select<XzArticleplateOutput>()
            .ToListAsync();
    }


    /// <summary>
    /// 分页查询板块
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("分页查询板块")]
    [ApiDescriptionSettings(Name = "PlatePage"), HttpPost]
    public async Task<SqlSugarPagedList<XzArticleplateOutput>> PlatePage(PageXzArticleplateInput input)
    {
        var query = _xzArticleplateRep.AsQueryable()
            .WhereIF(!string.IsNullOrWhiteSpace(input.Keyword), u => u.title.Contains(input.Keyword.Trim()))
            .WhereIF(input.ishot != null, u => u.ishot == input.ishot)
            .WhereIF(input.isnew != null, u => u.isnew == input.isnew)
            .WhereIF(input.istop != null, u => u.istop == input.istop)
            .WhereIF(input.ltype != null, u => u.ltype == input.ltype)
            .OrderByDescending(f => new { f.ishot, f.istop })
            .Select<XzArticleplateOutput>();
        return await query.OrderBuilder(input).ToPagedListAsync(input.Page, input.PageSize);
    }

    /// <summary>
    /// 获取板块详情
    /// </summary>
    /// <returns></returns>
    [DisplayName("获取板块详情")]
    [ApiDescriptionSettings(Name = "PlateDetail"), HttpGet]
    public async Task<XzArticleplateOutput> PlateDetail([FromQuery]BaseIdInput input)
    {
        return await _xzArticleplateRep.AsQueryable()
            .Where(f => f.Id == input.Id)
            .Select<XzArticleplateOutput>().FirstAsync();
    }
}
