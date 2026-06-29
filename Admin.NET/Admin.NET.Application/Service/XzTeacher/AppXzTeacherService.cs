// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Admin.NET.Application.Entity;
using Admin.NET.Core.Service;
using Furion.DatabaseAccessor;
using SqlSugar;
using System.ComponentModel;
namespace Admin.NET.Application;

/// <summary>
/// 用户端星座咨询师服务 🧩
/// </summary>
[ApiDescriptionSettings(ApplicationConst.AppGroupName, Order = 100)]
public class AppXzTeacherService : IDynamicApiController, ITransient
{
    private readonly SqlSugarRepository<XzTeacher> _xzTeacherRep;
    private readonly ISqlSugarClient _sqlSugarClient;
    private readonly AppUserManager _userManager;

    public AppXzTeacherService(
        SqlSugarRepository<XzTeacher> xzTeacherRep,
        ISqlSugarClient sqlSugarClient,
        AppUserManager userManager)
    {
        _xzTeacherRep = xzTeacherRep;
        _sqlSugarClient = sqlSugarClient;
        _userManager = userManager;
    }

    /// <summary>
    /// 用户端分页查询咨询师列表
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("用户端分页查询咨询师列表")]
    [ApiDescriptionSettings(Name = "Page"), HttpPost]
    public async Task<SqlSugarPagedList<AppXzTeacherInput>> Page(PageXzTeacherInput input)
    {
        input.Keyword = input.Keyword?.Trim();
        var query = _xzTeacherRep.AsQueryable()
            .Where(f => f.state == 0)
            .WhereIF(!string.IsNullOrWhiteSpace(input.Keyword),
                u => u.name.Contains(input.Keyword) || u.tags.Contains(input.Keyword) || u.introduction.Contains(input.Keyword))
            .WhereIF(input.level != null, u => u.level == input.level)
            .WhereIF(input.istop != null, u => u.istop == input.istop)
            .WhereIF(input.livestate != null, u => u.livestate == input.livestate)
            .Select<AppXzTeacherInput>();

        if (!string.IsNullOrWhiteSpace(input.Field))
            query = query.OrderBuilder(input);
        else
            query = query.OrderByDescending(f => new { f.sortcode, f.createtime });

        return await query.ToPagedListAsync(input.Page, input.PageSize);
    }

    /// <summary>
    /// 用户端通过Id获取导师详情
    /// </summary>
    /// <param name="id">导师Id</param>
    /// <returns></returns>
    [DisplayName("用户端获取导师详情")]
    [ApiDescriptionSettings(Name = "Detail"), HttpGet]
    public async Task<AppXzTeacherInput> Detail([FromQuery]AppXzTeacherDetailInput input)
    {
        return await _xzTeacherRep.AsQueryable()
            .WhereIF(input.Id > 0, f => f.Id == input.Id && f.state == 0)
            .WhereIF(input.Uid > 0, f => f.uid == input.Uid && f.state == 0)
            .Select<AppXzTeacherInput>()
            .FirstAsync();
    }
}
