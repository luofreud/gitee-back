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
using NewLife;
namespace Admin.NET.Application;

/// <summary>
/// app用户签到服务 🧩
/// </summary>
[ApiDescriptionSettings(ApplicationConst.AppGroupName, Order = 100)]
public partial class AppXzCheckService : IDynamicApiController, ITransient
{
    private readonly SqlSugarRepository<XzCheck> _xzCheckRep;
    private readonly ISqlSugarClient _sqlSugarClient;
    private readonly AppUserManager _userManager;
    private readonly SqlSugarRepository<XzUser> _xzUserRep;
    private readonly SqlSugarRepository<XzTask> _xzTask;
    private readonly SqlSugarRepository<XzXblog> _xzXblog;
    public AppXzCheckService(SqlSugarRepository<XzCheck> xzCheckRep, ISqlSugarClient sqlSugarClient, AppUserManager userManager, SqlSugarRepository<XzUser> xzUserRep, SqlSugarRepository<XzTask> xzTask, SqlSugarRepository<XzXblog> xzXblog)
    {
        _xzCheckRep = xzCheckRep;
        _sqlSugarClient = sqlSugarClient;
        _userManager = userManager;
        _xzUserRep = xzUserRep;
        _xzTask = xzTask;
        _xzXblog = xzXblog;
    }

    /// <summary>
    /// 点击签到 🔖
    /// </summary>
    /// <returns></returns>
    [DisplayName("点击签到")]
    [UnitOfWork]
    public virtual async Task UseCheck()
    {
        var count = await _xzCheckRep.AsQueryable().Where
             (f => f.uid == _userManager.userid && f.qdtime > DateTime.Now.ToString("yyyy-MM-dd").ToDateTime())
             .CountAsync();
        if (count > 0)
        {
            throw new Exception("已签过到！");
        }

        var user = await _xzUserRep.GetByIdAsync(_userManager.userid);
        user.xbmoney += 5;

        XzCheck xzCheck = new XzCheck();
        xzCheck.uid = _userManager.userid;
        xzCheck.qdtime = DateTime.Now;
        xzCheck.createtime = DateTime.Now;

        //插入日志
        await _xzXblog.InsertAsync(new XzXblog { uid = _userManager.userid, xb = 5, createtime = DateTime.Now, mark = "用户签到", xbye = user.xbmoney });
        //插入签到信息
        await _xzCheckRep.InsertAsync(xzCheck);
        //更新用户星币
        await _xzUserRep.AsUpdateable(user).UpdateColumns(it => new { it.xbmoney })
             .ExecuteCommandAsync();
    }

    /// <summary>
    /// 获取用户签到日志 🔖
    /// </summary>
    /// <returns></returns>
    [DisplayName("获取用户签到日志 是否连续签到")]
    [UnitOfWork]
    public virtual async Task<List<XzCheck>> GetUseCheck()
    {
        var query = _xzCheckRep.AsQueryable().Where(f => f.uid == _userManager.userid).Take(7).OrderBy(f => f.createtime, OrderByType.Desc);
        return await query.ToListAsync();
    }

    /// <summary>
    /// 获取用户每日任务，日常任务 🔖
    /// </summary>
    /// <returns></returns>
    [DisplayName("获取用户每日任务，日常任务")]
    [UnitOfWork]
    public virtual async Task<(List<XzTask>, List<XzTask>)> GetUseTask()
    {
        var query1 = await _xzTask.AsQueryable()
            .Includes(u => u.tasklog.Where(d=>d.uid == _userManager.userid).ToList())
            .Where(f => f.ttype == 0)
            .OrderBy(f => f.sortcode, OrderByType.Desc).ToListAsync();
        var query2 = await _xzTask.AsQueryable()
            .Includes(u => u.tasklog.Where(d => d.uid == _userManager.userid).ToList())
            .Where(f => f.ttype == 1)
            .OrderBy(f => f.sortcode, OrderByType.Desc).ToListAsync();
        return (query1, query2);
    }


}
