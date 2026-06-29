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
/// 注册首页选择服务 🧩
/// </summary>
[ApiDescriptionSettings(ApplicationConst.GroupName, Order = 100)]
public partial class XzRegselectnewService : IDynamicApiController, ITransient
{
    private readonly SqlSugarRepository<XzRegselectnew> _xzRegselectnewRep;
    private readonly ISqlSugarClient _sqlSugarClient;

    public XzRegselectnewService(SqlSugarRepository<XzRegselectnew> xzRegselectnewRep, ISqlSugarClient sqlSugarClient)
    {
        _xzRegselectnewRep = xzRegselectnewRep;
        _sqlSugarClient = sqlSugarClient;
    }

    /// <summary>
    /// 分页查询注册首页选择 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("分页查询注册首页选择")]
    [ApiDescriptionSettings(Name = "Page"), HttpPost]
    public async Task<SqlSugarPagedList<XzRegselectnewOutput>> Page(PageXzRegselectnewInput input)
    {
        input.Keyword = input.Keyword?.Trim();
        var query = _xzRegselectnewRep.AsQueryable()
            .WhereIF(!string.IsNullOrWhiteSpace(input.Keyword), u => u.title.Contains(input.Keyword) || u.selectitem.Contains(input.Keyword))
            .WhereIF(!string.IsNullOrWhiteSpace(input.title), u => u.title.Contains(input.title.Trim()))
            .WhereIF(!string.IsNullOrWhiteSpace(input.selectitem), u => u.selectitem.Contains(input.selectitem.Trim()))
            .WhereIF(input.uid.HasValue, u => u.uid == input.uid)
            .WhereIF(input.createtimeRange?.Length == 2, u => u.createtime >= input.createtimeRange[0] && u.createtime <= input.createtimeRange[1])
            .Select<XzRegselectnewOutput>();
		return await query.OrderBuilder(input).ToPagedListAsync(input.Page, input.PageSize);
    }

    /// <summary>
    /// 获取注册首页选择详情 ℹ️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("获取注册首页选择详情")]
    [ApiDescriptionSettings(Name = "Detail"), HttpGet]
    public async Task<XzRegselectnew> Detail([FromQuery] QueryByIdXzRegselectnewInput input)
    {
        return await _xzRegselectnewRep.GetFirstAsync(u => u.Id == input.Id);
    }

    /// <summary>
    /// 增加注册首页选择 ➕
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("增加注册首页选择")]
    [ApiDescriptionSettings(Name = "Add"), HttpPost]
    public async Task<long> Add(AddXzRegselectnewInput input)
    {
        var entity = input.Adapt<XzRegselectnew>();
        return await _xzRegselectnewRep.InsertAsync(entity) ? entity.Id : 0;
    }

    /// <summary>
    /// 更新注册首页选择 ✏️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("更新注册首页选择")]
    [ApiDescriptionSettings(Name = "Update"), HttpPost]
    public async Task Update(UpdateXzRegselectnewInput input)
    {
        var entity = input.Adapt<XzRegselectnew>();
        await _xzRegselectnewRep.AsUpdateable(entity)
        .ExecuteCommandAsync();
    }

    /// <summary>
    /// 删除注册首页选择 ❌
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("删除注册首页选择")]
    [ApiDescriptionSettings(Name = "Delete"), HttpPost]
    public async Task Delete(DeleteXzRegselectnewInput input)
    {
        var entity = await _xzRegselectnewRep.GetFirstAsync(u => u.Id == input.Id) ?? throw Oops.Oh(ErrorCodeEnum.D1002);
        //await _xzRegselectnewRep.FakeDeleteAsync(entity);   //假删除
        await _xzRegselectnewRep.DeleteAsync(entity);   //真删除
    }

    /// <summary>
    /// 批量删除注册首页选择 ❌
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("批量删除注册首页选择")]
    [ApiDescriptionSettings(Name = "BatchDelete"), HttpPost]
    public async Task<bool> BatchDelete([Required(ErrorMessage = "主键列表不能为空")]List<DeleteXzRegselectnewInput> input)
    {
        var exp = Expressionable.Create<XzRegselectnew>();
        foreach (var row in input) exp = exp.Or(it => it.Id == row.Id);
        var list = await _xzRegselectnewRep.AsQueryable().Where(exp.ToExpression()).ToListAsync();
   
        //return await _xzRegselectnewRep.FakeDeleteAsync(list);   //假删除
        return await _xzRegselectnewRep.DeleteAsync(list);   //真删除
    }
    
    /// <summary>
    /// 导出注册首页选择记录 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("导出注册首页选择记录")]
    [ApiDescriptionSettings(Name = "Export"), HttpPost, NonUnify]
    public async Task<IActionResult> Export(PageXzRegselectnewInput input)
    {
        var list = (await Page(input)).Items?.Adapt<List<ExportXzRegselectnewOutput>>() ?? new();
        if (input.SelectKeyList?.Count > 0) list = list.Where(x => input.SelectKeyList.Contains(x.Id)).ToList();
        return ExcelHelper.ExportTemplate(list, "注册首页选择导出记录");
    }
    
    /// <summary>
    /// 下载注册首页选择数据导入模板 ⬇️
    /// </summary>
    /// <returns></returns>
    [DisplayName("下载注册首页选择数据导入模板")]
    [ApiDescriptionSettings(Name = "Import"), HttpGet, NonUnify]
    public IActionResult DownloadTemplate()
    {
        return ExcelHelper.ExportTemplate(new List<ExportXzRegselectnewOutput>(), "注册首页选择导入模板");
    }
    
    private static readonly object _xzRegselectnewImportLock = new object();
    /// <summary>
    /// 导入注册首页选择记录 💾
    /// </summary>
    /// <returns></returns>
    [DisplayName("导入注册首页选择记录")]
    [ApiDescriptionSettings(Name = "Import"), HttpPost, NonUnify, UnitOfWork]
    public IActionResult ImportData([Required] IFormFile file)
    {
        lock (_xzRegselectnewImportLock)
        {
            var stream = ExcelHelper.ImportData<ImportXzRegselectnewInput, XzRegselectnew>(file, (list, markerErrorAction) =>
            {
                _sqlSugarClient.Utilities.PageEach(list, 2048, pageItems =>
                {
                    
                    // 校验并过滤必填基本类型为null的字段
                    var rows = pageItems.Where(x => {
                        if (!string.IsNullOrWhiteSpace(x.Error)) return false;
                        return true;
                    }).Adapt<List<XzRegselectnew>>();
                    
                    var storageable = _xzRegselectnewRep.Context.Storageable(rows)
                        .SplitError(it => it.Item.title?.Length > 200, "长度不能超过200个字符")
                        .SplitError(it => it.Item.selectitem?.Length > 500, "长度不能超过500个字符")
                        .SplitInsert(_=> true) // 没有设置唯一键代表插入所有数据
                        .ToStorage();
                    
                    storageable.AsInsertable.ExecuteCommand();// 不存在插入
                    storageable.AsUpdateable.UpdateColumns(it => new
                    {
                        it.uid,
                        it.title,
                        it.selectitem,
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
