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
/// APP用户投诉记录表服务 🧩
/// </summary>
[ApiDescriptionSettings(ApplicationConst.AppGroupName, Name = "AppXzComplaintlog", Order = 99)]
public partial class APPXzComplaintlogService : IDynamicApiController, ITransient
{
    private readonly SqlSugarRepository<XzComplaintlog> _xzComplaintlogRep;
    private readonly ISqlSugarClient _sqlSugarClient;
    private readonly AppUserManager _userManager;
    private readonly SqlSugarRepository<XzQuestion> _xzXzQuestionRep;
    private readonly SqlSugarRepository<XzImlog> _xzXzImlogRep;

    public APPXzComplaintlogService(SqlSugarRepository<XzComplaintlog> xzComplaintlogRep, ISqlSugarClient sqlSugarClient, AppUserManager userManager, SqlSugarRepository<XzQuestion> xzXzQuestionRep, SqlSugarRepository<XzImlog> xzXzImlogRep)
    {
        _xzComplaintlogRep = xzComplaintlogRep;
        _sqlSugarClient = sqlSugarClient;
        _userManager = userManager;
        _xzXzQuestionRep = xzXzQuestionRep;
        _xzXzImlogRep = xzXzImlogRep;

    }

    /// <summary>
    /// 分页查询用户投诉记录表 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("分页查询用户投诉记录表")]
    [ApiDescriptionSettings(Name = "Page"), HttpPost]
    public async Task<SqlSugarPagedList<XzComplaintlogOutput>> Page(PageXzComplaintlogInput input)
    {
        var query = _xzComplaintlogRep.AsQueryable()
            .Where(u => u.uid == _userManager.userid)
            .WhereIF(!string.IsNullOrWhiteSpace(input.cnum), u => u.cnum.Contains(input.cnum.Trim()))
            .Select<XzComplaintlogOutput>();
        return await query.OrderBuilder(input).ToPagedListAsync(input.Page, input.PageSize);
    }

    /// <summary>
    /// 获取用户投诉记录表详情 ℹ️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("获取用户投诉记录表详情")]
    [ApiDescriptionSettings(Name = "Detail"), HttpGet]
    public async Task<XzComplaintlog> Detail([FromQuery] QueryByIdXzComplaintlogInput input)
    {
        return await _xzComplaintlogRep.GetFirstAsync(u => u.Id == input.Id);
    }

    /// <summary>
    /// 增加用户投诉记录表 ➕
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("增加用户投诉记录表")]
    [ApiDescriptionSettings(Name = "Add"), HttpPost]
    [UnitOfWork]
    public async Task Add(AddXzComplaintlogInput input)
    {
        var entity = input.Adapt<XzComplaintlog>();
        entity.uid = _userManager.userid;
        entity.createtime = DateTime.Now;
        entity.cnum = "com" + DateTime.Now.Ticks;
        entity.cstate = 0;
        List<Task> tasks = new List<Task>();
        if (input.ctype == 0)
        {
            tasks.Add(_xzXzQuestionRep.AsUpdateable(new XzQuestion { Id = input.relevanceid.Value, orderstate = 2 }).UpdateColumns(it => new { it.orderstate })
                .WhereColumns(f => f.Id).ExecuteCommandAsync());
        }
        else if (input.ctype == 1 || input.ctype == 2)
        {
            tasks.Add(_xzXzImlogRep.AsUpdateable(new XzImlog { Id = input.relevanceid.Value, state = 3 })
                .UpdateColumns(it => new { it.state })
                .WhereColumns(f => f.Id).ExecuteCommandAsync());
        }
        //测评
        tasks.Add(_xzComplaintlogRep.InsertAsync(entity));
        await Task.WhenAll(tasks);
    }

    /// <summary>
    /// 更新用户投诉记录表 ✏️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("更新用户投诉记录表")]
    [ApiDescriptionSettings(Name = "Update"), HttpPost]
    public async Task Update(UpdateXzComplaintlogInput input)
    {
        var entity = input.Adapt<XzComplaintlog>();
        if (input.cstate == 1)
        {
            input.overtime = DateTime.Now;

        }
        await _xzComplaintlogRep.AsUpdateable(entity).UpdateColumns(f => new { f.overtime, f.cstate })
        .ExecuteCommandAsync();
    }

    /// <summary>
    /// 删除用户投诉记录表 ❌
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("删除用户投诉记录表")]
    [ApiDescriptionSettings(Name = "Delete"), HttpPost]
    [UnitOfWork]
    public async Task Delete(DeleteXzComplaintlogInput input)
    {


        List<Task> tasks = new List<Task>();

        var entity = await _xzComplaintlogRep.GetFirstAsync(u => u.Id == input.Id) ?? throw Oops.Oh(ErrorCodeEnum.D1002);

        if (entity.ctype == 0)
        {
            tasks.Add(_xzXzQuestionRep.AsUpdateable(new XzQuestion { Id = entity.relevanceid.Value, orderstate = 1 }).UpdateColumns(it => new { it.orderstate })
                .WhereColumns(f => f.Id).ExecuteCommandAsync());
        }
        else if (entity.ctype == 1 || entity.ctype == 2)
        {
            tasks.Add(_xzXzImlogRep.AsUpdateable(new XzImlog { Id = entity.relevanceid.Value, state = 2 }).UpdateColumns(it => new { it.state })
                .WhereColumns(f => f.Id).ExecuteCommandAsync());
        }


        //await _xzComplaintlogRep.FakeDeleteAsync(entity);   //假删除
        tasks.Add(_xzComplaintlogRep.DeleteAsync(entity));   //真删除

        await Task.WhenAll(tasks);
    }


}
