// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Admin.NET.Application.Entity;
using Admin.NET.Core.Service;
using Dm.util;
using Furion.DatabaseAccessor;
using Furion.FriendlyException;
using Mapster;
using Microsoft.AspNetCore.Http;
using SqlSugar;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
namespace Admin.NET.Application;

/// <summary>
/// app 系统用户评测服务 🧩
/// </summary>
[ApiDescriptionSettings(ApplicationConst.AppGroupName, Order = 100)]
public partial class AppXzReviewService : IDynamicApiController, ITransient
{
    private readonly SqlSugarRepository<XzReview> _xzReviewRep;
    private readonly ISqlSugarClient _sqlSugarClient;
    private readonly SysDictDataService _sysDictData;
    private readonly SqlSugarRepository<XzUserreviewlog> _xzXzUserreviewlogRep;
    private readonly AppUserManager _userManager;
    private readonly SqlSugarRepository<XzUser> _xzUser;
    private readonly SqlSugarRepository<XzXblog> _xzXblog;


    public AppXzReviewService(SqlSugarRepository<XzReview> xzReviewRep, ISqlSugarClient sqlSugarClient, SysDictDataService sysDictData, SqlSugarRepository<XzUserreviewlog> xzXzUserreviewlogRep, AppUserManager userManager, SqlSugarRepository<XzUser> xzUser, SqlSugarRepository<XzXblog> xzXblog)
    {
        _xzReviewRep = xzReviewRep;
        _sqlSugarClient = sqlSugarClient;
        _sysDictData = sysDictData;
        _xzXzUserreviewlogRep = xzXzUserreviewlogRep;
        _userManager = userManager;
        _xzUser = xzUser;
        _xzXblog = xzXblog;
    }

    /// <summary>
    /// 分页查询系统评测列表 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("分页查询系统用户评测列表")]
    [ApiDescriptionSettings(Name = "Page"), HttpPost]
    [AllowAnonymous]
    public async Task<SqlSugarPagedList<XzReviewOutput>> Page(PageXzReviewInput input)
    {
        var query = _xzReviewRep.AsQueryable()
            .WhereIF(input.rtype != null, u => u.rtype == input.rtype)
            .OrderByDescending(f => new { f.istop, f.sortcode })
            .Select<XzReviewOutput>();
        return await query.OrderBuilder(input).ToPagedListAsync(input.Page, input.PageSize);
    }





    /// <summary>
    /// 评测导航栏目---需要调整字典 🔖
    /// </summary>
    /// <returns></returns>
    [DisplayName("评测导航栏目")]
    [ApiDescriptionSettings(Name = "ReviewItem"), HttpPost]
    [AllowAnonymous]
    public async Task<List<SysDictData>> ReviewItem()
    {
        return await _sysDictData.GetDataList("cptype");
    }


    /// <summary>
    /// 分页查询用户评测列表 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("分页查询用户评测列表")]
    [ApiDescriptionSettings(Name = "UserPage"), HttpPost]
    public async Task<SqlSugarPagedList<XzUserreviewlog>> UserPage(PageXzUserreviewlogInput input)
    {
        var query = _xzXzUserreviewlogRep.AsQueryable()
            .Includes(t => new { t.tid, t.rid })// 一个层级查询
            .Where(u => u.uid == _userManager.userid)
            .OrderByDescending(f => new { f.createtime })
            .Select<XzUserreviewlog>();
        return await query.OrderBuilder(input).ToPagedListAsync(input.Page, input.PageSize);
    }

    /// <summary>
    /// 添加评测 ℹ️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("添加评测")]
    [ApiDescriptionSettings(Name = "UserReviewAdd"), HttpGet]
    [UnitOfWork]
    public async Task<bool> UserReviewAdd([FromQuery] PageXzUserreviewlogInput input)
    {
        var review = input.Adapt<XzUserreviewlog>();

        var reviewmodel = await _xzReviewRep.GetByIdAsync(input.rid);
        var user = await _xzUser.GetByIdAsync(_userManager.userid);


        if (reviewmodel.money > user.xzmoney)
            throw Oops.Oh("星钻不足");


        reviewmodel.count += 1;
        user.xzmoney -= reviewmodel.money;

        review.createtime = DateTime.Now;
        review.rstate = 0;
        review.uid = _userManager.userid;
        review.ordernum = "xzpc" + DateTime.Now.Ticks.ToString();
        review.money = reviewmodel.money;


        XzXblog xzXblog = new XzXblog();
        xzXblog.uid = _userManager.userid;
        xzXblog.xb = reviewmodel.money;
        xzXblog.xbye = user.xzmoney.ToInt16();
        xzXblog.createtime = DateTime.Now;

        List<Task> tasks = new List<Task>();
        tasks.Add(_xzXzUserreviewlogRep.InsertAsync(review));
        tasks.Add(_xzXblog.InsertAsync(xzXblog));
        tasks.Add(_xzUser.AsUpdateable(user).UpdateColumns(f => f.xzmoney).ExecuteCommandAsync());
        await Task.WhenAll(tasks);

        return true;
    }

    /// <summary>
    /// 获取评测详情 ℹ️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("获取评测详情")]
    [ApiDescriptionSettings(Name = "UserReviewDetail"), HttpGet]
    public async Task<XzUserreviewlog> UserReviewDetail([FromQuery] PageXzUserreviewlogInput input)
    {
        return await _xzXzUserreviewlogRep.AsQueryable()
            .Includes(t => new { t.tid, t.rid })
            .Where(u => u.Id == input.id).FirstAsync();
    }


}
