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
/// 内容的标签服务 🧩
/// </summary>
[ApiDescriptionSettings(ApplicationConst.GroupName, Order = 100)]
public partial class XzNewitemService : IDynamicApiController, ITransient
{
    private readonly SqlSugarRepository<XzNewitem> _xzNewitemRep;
    private readonly ISqlSugarClient _sqlSugarClient;

    public XzNewitemService(SqlSugarRepository<XzNewitem> xzNewitemRep, ISqlSugarClient sqlSugarClient)
    {
        _xzNewitemRep = xzNewitemRep;
        _sqlSugarClient = sqlSugarClient;
    }

    /// <summary>
    /// 分页查询内容的标签 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("分页查询内容的标签")]
    [ApiDescriptionSettings(Name = "Page"), HttpPost]
    public async Task<SqlSugarPagedList<XzNewitemOutput>> Page(PageXzNewitemInput input)
    {
        input.Keyword = input.Keyword?.Trim();
        var query = _xzNewitemRep.AsQueryable()
            .WhereIF(!string.IsNullOrWhiteSpace(input.Keyword), u => u.title.Contains(input.Keyword) || u.seotitle.Contains(input.Keyword))
            .WhereIF(!string.IsNullOrWhiteSpace(input.title), u => u.title.Contains(input.title.Trim()))
            .WhereIF(!string.IsNullOrWhiteSpace(input.seotitle), u => u.seotitle.Contains(input.seotitle.Trim()))
            .WhereIF(input.sortcode != null, u => u.sortcode == input.sortcode)
            .WhereIF(input.createtimeRange?.Length == 2, u => u.createtime >= input.createtimeRange[0] && u.createtime <= input.createtimeRange[1])
            .Select<XzNewitemOutput>();
		return await query.OrderBuilder(input).ToPagedListAsync(input.Page, input.PageSize);
    }

    /// <summary>
    /// 获取内容的标签详情 ℹ️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("获取内容的标签详情")]
    [ApiDescriptionSettings(Name = "Detail"), HttpGet]
    public async Task<XzNewitem> Detail([FromQuery] QueryByIdXzNewitemInput input)
    {
        return await _xzNewitemRep.GetFirstAsync(u => u.Id == input.Id);
    }

    /// <summary>
    /// 增加内容的标签 ➕
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("增加内容的标签")]
    [ApiDescriptionSettings(Name = "Add"), HttpPost]
    public async Task<long> Add(AddXzNewitemInput input)
    {
        var entity = input.Adapt<XzNewitem>();
        return await _xzNewitemRep.InsertAsync(entity) ? entity.Id : 0;
    }

    /// <summary>
    /// 更新内容的标签 ✏️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("更新内容的标签")]
    [ApiDescriptionSettings(Name = "Update"), HttpPost]
    public async Task Update(UpdateXzNewitemInput input)
    {
        var entity = input.Adapt<XzNewitem>();
        await _xzNewitemRep.AsUpdateable(entity)
        .ExecuteCommandAsync();
    }

    /// <summary>
    /// 删除内容的标签 ❌
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("删除内容的标签")]
    [ApiDescriptionSettings(Name = "Delete"), HttpPost]
    public async Task Delete(DeleteXzNewitemInput input)
    {
        var entity = await _xzNewitemRep.GetFirstAsync(u => u.Id == input.Id) ?? throw Oops.Oh(ErrorCodeEnum.D1002);
        //await _xzNewitemRep.FakeDeleteAsync(entity);   //假删除
        await _xzNewitemRep.DeleteAsync(entity);   //真删除
    }

    /// <summary>
    /// 批量删除内容的标签 ❌
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("批量删除内容的标签")]
    [ApiDescriptionSettings(Name = "BatchDelete"), HttpPost]
    public async Task<bool> BatchDelete([Required(ErrorMessage = "主键列表不能为空")]List<DeleteXzNewitemInput> input)
    {
        var exp = Expressionable.Create<XzNewitem>();
        foreach (var row in input) exp = exp.Or(it => it.Id == row.Id);
        var list = await _xzNewitemRep.AsQueryable().Where(exp.ToExpression()).ToListAsync();
   
        //return await _xzNewitemRep.FakeDeleteAsync(list);   //假删除
        return await _xzNewitemRep.DeleteAsync(list);   //真删除
    }
    
    /// <summary>
    /// 导出内容的标签记录 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("导出内容的标签记录")]
    [ApiDescriptionSettings(Name = "Export"), HttpPost, NonUnify]
    public async Task<IActionResult> Export(PageXzNewitemInput input)
    {
        var list = (await Page(input)).Items?.Adapt<List<ExportXzNewitemOutput>>() ?? new();
        if (input.SelectKeyList?.Count > 0) list = list.Where(x => input.SelectKeyList.Contains(x.Id)).ToList();
        return ExcelHelper.ExportTemplate(list, "内容的标签导出记录");
    }
    
    /// <summary>
    /// 下载内容的标签数据导入模板 ⬇️
    /// </summary>
    /// <returns></returns>
    [DisplayName("下载内容的标签数据导入模板")]
    [ApiDescriptionSettings(Name = "Import"), HttpGet, NonUnify]
    public IActionResult DownloadTemplate()
    {
        return ExcelHelper.ExportTemplate(new List<ExportXzNewitemOutput>(), "内容的标签导入模板");
    }
    
    private static readonly object _xzNewitemImportLock = new object();
    /// <summary>
    /// 导入内容的标签记录 💾
    /// </summary>
    /// <returns></returns>
    [DisplayName("导入内容的标签记录")]
    [ApiDescriptionSettings(Name = "Import"), HttpPost, NonUnify, UnitOfWork]
    public IActionResult ImportData([Required] IFormFile file)
    {
        lock (_xzNewitemImportLock)
        {
            var stream = ExcelHelper.ImportData<ImportXzNewitemInput, XzNewitem>(file, (list, markerErrorAction) =>
            {
                _sqlSugarClient.Utilities.PageEach(list, 2048, pageItems =>
                {
                    
                    // 校验并过滤必填基本类型为null的字段
                    var rows = pageItems.Where(x => {
                        if (!string.IsNullOrWhiteSpace(x.Error)) return false;
                        return true;
                    }).Adapt<List<XzNewitem>>();
                    
                    var storageable = _xzNewitemRep.Context.Storageable(rows)
                        .SplitError(it => it.Item.title?.Length > 200, "长度不能超过200个字符")
                        .SplitError(it => it.Item.seotitle?.Length > 200, "长度不能超过200个字符")
                        .SplitInsert(_=> true) // 没有设置唯一键代表插入所有数据
                        .ToStorage();
                    
                    storageable.AsInsertable.ExecuteCommand();// 不存在插入
                    storageable.AsUpdateable.UpdateColumns(it => new
                    {
                        it.newid,
                        it.title,
                        it.seotitle,
                        it.sortcode,
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
