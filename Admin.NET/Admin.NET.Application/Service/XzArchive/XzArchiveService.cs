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
[ApiDescriptionSettings(ApplicationConst.GroupName, Order = 100)]
public partial class XzArchiveService : IDynamicApiController, ITransient
{
    private readonly SqlSugarRepository<XzArchive> _xzArchiveRep;
    private readonly ISqlSugarClient _sqlSugarClient;

    public XzArchiveService(SqlSugarRepository<XzArchive> xzArchiveRep, ISqlSugarClient sqlSugarClient)
    {
        _xzArchiveRep = xzArchiveRep;
        _sqlSugarClient = sqlSugarClient;
    }

    /// <summary>
    /// 分页查询用户档案 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("分页查询用户档案")]
    [ApiDescriptionSettings(Name = "Page"), HttpPost]
    public async Task<SqlSugarPagedList<XzArchiveOutput>> Page(PageXzArchiveInput input)
    {
        input.Keyword = input.Keyword?.Trim();
        var query = _xzArchiveRep.AsQueryable()
            .WhereIF(!string.IsNullOrWhiteSpace(input.Keyword), u => u.name.Contains(input.Keyword) || u.relation.Contains(input.Keyword) || u.birthday.Contains(input.Keyword) || u.address.Contains(input.Keyword) || u.nowaddress.Contains(input.Keyword))
            .WhereIF(!string.IsNullOrWhiteSpace(input.name), u => u.name.Contains(input.name.Trim()))
            .WhereIF(!string.IsNullOrWhiteSpace(input.relation), u => u.relation.Contains(input.relation.Trim()))
            .WhereIF(!string.IsNullOrWhiteSpace(input.birthday), u => u.birthday.Contains(input.birthday.Trim()))
            .WhereIF(!string.IsNullOrWhiteSpace(input.address), u => u.address.Contains(input.address.Trim()))
            .WhereIF(!string.IsNullOrWhiteSpace(input.nowaddress), u => u.nowaddress.Contains(input.nowaddress.Trim()))
            .WhereIF(input.sex != null, u => u.sex == input.sex)
            .WhereIF(input.createtimeRange?.Length == 2, u => u.createtime >= input.createtimeRange[0] && u.createtime <= input.createtimeRange[1])
            .Select<XzArchiveOutput>();
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
        await _xzArchiveRep.AsUpdateable(entity)
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
        //await _xzArchiveRep.FakeDeleteAsync(entity);   //假删除
        await _xzArchiveRep.DeleteAsync(entity);   //真删除
    }

    /// <summary>
    /// 批量删除用户档案 ❌
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("批量删除用户档案")]
    [ApiDescriptionSettings(Name = "BatchDelete"), HttpPost]
    public async Task<bool> BatchDelete([Required(ErrorMessage = "主键列表不能为空")]List<DeleteXzArchiveInput> input)
    {
        var exp = Expressionable.Create<XzArchive>();
        foreach (var row in input) exp = exp.Or(it => it.Id == row.Id);
        var list = await _xzArchiveRep.AsQueryable().Where(exp.ToExpression()).ToListAsync();
   
        //return await _xzArchiveRep.FakeDeleteAsync(list);   //假删除
        return await _xzArchiveRep.DeleteAsync(list);   //真删除
    }
    
    /// <summary>
    /// 导出用户档案记录 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("导出用户档案记录")]
    [ApiDescriptionSettings(Name = "Export"), HttpPost, NonUnify]
    public async Task<IActionResult> Export(PageXzArchiveInput input)
    {
        var list = (await Page(input)).Items?.Adapt<List<ExportXzArchiveOutput>>() ?? new();
        if (input.SelectKeyList?.Count > 0) list = list.Where(x => input.SelectKeyList.Contains(x.Id)).ToList();
        return ExcelHelper.ExportTemplate(list, "用户档案导出记录");
    }
    
    /// <summary>
    /// 下载用户档案数据导入模板 ⬇️
    /// </summary>
    /// <returns></returns>
    [DisplayName("下载用户档案数据导入模板")]
    [ApiDescriptionSettings(Name = "Import"), HttpGet, NonUnify]
    public IActionResult DownloadTemplate()
    {
        return ExcelHelper.ExportTemplate(new List<ExportXzArchiveOutput>(), "用户档案导入模板");
    }
    
    private static readonly object _xzArchiveImportLock = new object();
    /// <summary>
    /// 导入用户档案记录 💾
    /// </summary>
    /// <returns></returns>
    [DisplayName("导入用户档案记录")]
    [ApiDescriptionSettings(Name = "Import"), HttpPost, NonUnify, UnitOfWork]
    public IActionResult ImportData([Required] IFormFile file)
    {
        lock (_xzArchiveImportLock)
        {
            var stream = ExcelHelper.ImportData<ImportXzArchiveInput, XzArchive>(file, (list, markerErrorAction) =>
            {
                _sqlSugarClient.Utilities.PageEach(list, 2048, pageItems =>
                {
                    
                    // 校验并过滤必填基本类型为null的字段
                    var rows = pageItems.Where(x => {
                        if (!string.IsNullOrWhiteSpace(x.Error)) return false;
                        return true;
                    }).Adapt<List<XzArchive>>();
                    
                    var storageable = _xzArchiveRep.Context.Storageable(rows)
                        .SplitError(it => it.Item.name?.Length > 50, "长度不能超过50个字符")
                        .SplitError(it => it.Item.relation?.Length > 20, "长度不能超过20个字符")
                        .SplitError(it => it.Item.birthday?.Length > 50, "长度不能超过50个字符")
                        .SplitError(it => it.Item.address?.Length > 100, "长度不能超过100个字符")
                        .SplitError(it => it.Item.nowaddress?.Length > 100, "长度不能超过100个字符")
                        .SplitInsert(_=> true) // 没有设置唯一键代表插入所有数据
                        .ToStorage();
                    
                    storageable.AsInsertable.ExecuteCommand();// 不存在插入
                    storageable.AsUpdateable.UpdateColumns(it => new
                    {
                        it.name,
                        it.relation,
                        it.sex,
                        it.birthday,
                        it.address,
                        it.nowaddress,
                        it.createtime,
                    }).ExecuteCommand();// 存在更新
                    
                    // 标记错误信息
                    markerErrorAction.Invoke(storageable, pageItems, rows);
                });
            });
            
            return stream;
        }
    }
}
