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
/// 板块服务 🧩
/// </summary>
[ApiDescriptionSettings(ApplicationConst.GroupName, Order = 100)]
public partial class XzArticleplateService : IDynamicApiController, ITransient
{
    private readonly SqlSugarRepository<XzArticleplate> _xzArticleplateRep;
    private readonly ISqlSugarClient _sqlSugarClient;

    public XzArticleplateService(SqlSugarRepository<XzArticleplate> xzArticleplateRep, ISqlSugarClient sqlSugarClient)
    {
        _xzArticleplateRep = xzArticleplateRep;
        _sqlSugarClient = sqlSugarClient;
    }

    /// <summary>
    /// 分页查询板块 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("分页查询板块")]
    [ApiDescriptionSettings(Name = "Page"), HttpPost]
    public async Task<SqlSugarPagedList<XzArticleplateOutput>> Page(PageXzArticleplateInput input)
    {
        var query = _xzArticleplateRep.AsQueryable()
            .WhereIF(!string.IsNullOrWhiteSpace(input.content), u => u.content.Contains(input.content.Trim()))
            .WhereIF(input.ishot != null, u => u.ishot == input.ishot)
            .WhereIF(input.isnew != null, u => u.isnew == input.isnew)
            .WhereIF(input.istop != null, u => u.istop == input.istop)
            .OrderByDescending(f => new { f.ishot, f.istop })
            .Select<XzArticleplateOutput>();
        return await query.OrderBuilder(input).ToPagedListAsync(input.Page, input.PageSize);
    }

    /// <summary>
    /// 增加板块
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("增加板块")]
    [ApiDescriptionSettings(Name = "Add"), HttpPost]
    public async Task<long> Add(AddXzArticleplateInput input)
    {
        var entity = input.Adapt<XzArticleplate>();
        return await _xzArticleplateRep.InsertAsync(entity) ? entity.Id : 0;
    }

    /// <summary>
    /// 更新板块
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("更新板块")]
    [ApiDescriptionSettings(Name = "Update"), HttpPost]
    public async Task Update(UpdateXzArticleplateInput input)
    {
        var entity = input.Adapt<XzArticleplate>();
        await _xzArticleplateRep.AsUpdateable(entity)
        .ExecuteCommandAsync();
    }

    /// <summary>
    /// 删除板块
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("删除板块")]
    [ApiDescriptionSettings(Name = "Delete"), HttpPost]
    public async Task Delete(DeleteXzArticleplateInput input)
    {
        var entity = await _xzArticleplateRep.GetFirstAsync(u => u.Id == input.Id) ?? throw Oops.Oh(ErrorCodeEnum.D1002);
        //await _xzArticleRep.FakeDeleteAsync(entity);   //假删除
        await _xzArticleplateRep.DeleteAsync(entity);   //真删除
    }
}
