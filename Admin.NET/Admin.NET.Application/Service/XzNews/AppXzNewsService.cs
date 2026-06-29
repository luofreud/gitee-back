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
/// app各类内容信息接口 🧩
/// </summary>
[ApiDescriptionSettings(ApplicationConst.AppGroupName, Name = "AppXzNews", Order = 100)]
public partial class AppXzNewsService : IDynamicApiController, ITransient
{
    private readonly SqlSugarRepository<XzNews> _xzNewsRep;
    private readonly ISqlSugarClient _sqlSugarClient;

    public AppXzNewsService(SqlSugarRepository<XzNews> xzNewsRep, ISqlSugarClient sqlSugarClient)
    {
        _xzNewsRep = xzNewsRep;
        _sqlSugarClient = sqlSugarClient;
    }

    /// <summary>
    /// 通过code查询app首页导航数据 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("通过code查询app首页导航数据")]
    [ApiDescriptionSettings(Name = "CodeList"), HttpPost]
    [AllowAnonymous]
    public async Task<List<XzNewsOutput>> CodeList(PageXzNewsInput input)
    {
        input.Keyword = input.Keyword?.Trim();
        var query = _xzNewsRep.AsQueryable()
            .WhereIF(!string.IsNullOrWhiteSpace(input.titlecode), u => u.titlecode.Equals(input.titlecode.Trim())).
            OrderBy(u => u.sortcode, OrderByType.Desc)
            .Select<XzNewsOutput>();
        return await query.ToListAsync();
    }

    /// <summary>
    /// 获取新闻内容详情 ℹ️
    /// </summary>
    /// <param name="input">根据titlecode 编号查询内容</param>
    /// <returns></returns>
    [DisplayName("获取内容详情")]
    [ApiDescriptionSettings(Name = "Detail"), HttpPost]
    [AllowAnonymous]
    public async Task<XzNews> Detail([FromQuery] XzNewsBaseInput input)
    {
        return await _xzNewsRep.GetFirstAsync(u => u.titlecode == input.titlecode);
    }


}
