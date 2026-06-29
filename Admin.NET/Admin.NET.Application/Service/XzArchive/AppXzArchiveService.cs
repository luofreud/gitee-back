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
/// 用户档案服务 🧩
/// </summary>
[ApiDescriptionSettings(ApplicationConst.AppGroupName, Order = 100)]
public partial class AppXzArchiveService : IDynamicApiController, ITransient
{
    private readonly SqlSugarRepository<XzArchive> _xzArchiveRep;
    private readonly ISqlSugarClient _sqlSugarClient;
    private readonly AppUserManager _userManager;

    //256745d6cc01a054a55e669dfcd201c0 星盘秘钥
    public AppXzArchiveService(SqlSugarRepository<XzArchive> xzArchiveRep, ISqlSugarClient sqlSugarClient, AppUserManager userManager)
    {
        _xzArchiveRep = xzArchiveRep;
        _sqlSugarClient = sqlSugarClient;
        _userManager = userManager;

    }

    /// <summary>
    /// 分页查询用户档案 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("分页查询用户档案")]
    [ApiDescriptionSettings(Name = "Page"), HttpPost]
    public async Task<SqlSugarPagedList<XzArchive>> Page(PageXzArchiveInput input)
    {

        input.Keyword = input.Keyword?.Trim();
        var query = _xzArchiveRep.AsQueryable()
            .Where(u => u.uid == _userManager.userid)
            .WhereIF(!string.IsNullOrWhiteSpace(input.Keyword), t => t.name.Contains(input.Keyword))
            .OrderByDescending(u => u.createtime);
        return await query.OrderBuilder(input).ToPagedListAsync(input.Page, input.PageSize);
    }

    /// <summary>
    /// 获取用户档案详情 ℹ️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("获取用户档案详情")]
    [ApiDescriptionSettings(Name = "Detail"), HttpGet]
    public async Task<XzArchive> Detail([FromQuery] QueryByIdXzArchiveInput input)
    {
        return await _xzArchiveRep.GetFirstAsync(u => u.Id == input.Id);
    }

    /// <summary>
    /// 增加用户档案 ➕
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("增加用户档案")]
    [ApiDescriptionSettings(Name = "Add"), HttpPost]
    public async Task<long> Add(AddXzArchiveInput input)
    {
        var entity = input.Adapt<XzArchive>();
        entity.createtime = DateTime.Now;
        entity.uid = _userManager.userid;
        return await _xzArchiveRep.InsertAsync(entity) ? entity.Id : 0;
    }

    /// <summary>
    /// 更新用户档案 ✏️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("更新用户档案")]
    [ApiDescriptionSettings(Name = "Update"), HttpPost]
    public async Task Update(UpdateXzArchiveInput input)
    {
        var entity = input.Adapt<XzArchive>();
        await _xzArchiveRep.AsUpdateable(entity).IgnoreColumns(f => new { f.uid, f.createtime }).IgnoreNullColumns(true)
        .ExecuteCommandAsync();
    }

    /// <summary>
    /// 删除用户档案 ❌
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("删除用户档案")]
    [ApiDescriptionSettings(Name = "Delete"), HttpPost]
    public async Task Delete(DeleteXzArchiveInput input)
    {
        var entity = await _xzArchiveRep.GetFirstAsync(u => u.Id == input.Id) ?? throw Oops.Oh(ErrorCodeEnum.D1002);
        await _xzArchiveRep.DeleteAsync(entity);   //真删除
    }


}
