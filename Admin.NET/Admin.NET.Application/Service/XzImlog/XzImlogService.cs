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
/// 咨询连麦记录服务 🧩
/// </summary>
[ApiDescriptionSettings(ApplicationConst.GroupName, Order = 100)]
public partial class XzImlogService : IDynamicApiController, ITransient
{
    private readonly SqlSugarRepository<XzImlog> _xzImlogRep;
    private readonly ISqlSugarClient _sqlSugarClient;

    public XzImlogService(SqlSugarRepository<XzImlog> xzImlogRep, ISqlSugarClient sqlSugarClient)
    {
        _xzImlogRep = xzImlogRep;
        _sqlSugarClient = sqlSugarClient;
    }

    /// <summary>
    /// 分页查询咨询连麦记录 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("分页查询咨询连麦记录")]
    [ApiDescriptionSettings(Name = "Page"), HttpPost]
    public async Task<SqlSugarPagedList<XzImlogOutput>> Page(PageXzImlogInput input)
    {
        input.Keyword = input.Keyword?.Trim();
        var query = _xzImlogRep.AsQueryable()
            .WhereIF(!string.IsNullOrWhiteSpace(input.Keyword), u => u.orderno.Contains(input.Keyword))
            .WhereIF(!string.IsNullOrWhiteSpace(input.orderno), u => u.orderno.Contains(input.orderno.Trim()))
            .WhereIF(input.uid != null, u => u.uid == input.uid)
            .WhereIF(input.tid != null, u => u.tid == input.tid)
            .WhereIF(input.itype != null, u => u.itype == input.itype)
            .WhereIF(input.isdel != null, u => u.isdel == input.isdel)
            .WhereIF(input.state != null, u => u.state == input.state)
            .WhereIF(input.imtime != null, u => u.imtime == input.imtime)
            .WhereIF(input.overtimeRange?.Length == 2, u => u.overtime >= input.overtimeRange[0] && u.overtime <= input.overtimeRange[1])
            .WhereIF(input.createtimeRange?.Length == 2, u => u.createtime >= input.createtimeRange[0] && u.createtime <= input.createtimeRange[1])
            .Select<XzImlogOutput>();
		return await query.OrderBuilder(input).ToPagedListAsync(input.Page, input.PageSize);
    }

    /// <summary>
    /// 获取咨询连麦记录详情 ℹ️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("获取咨询连麦记录详情")]
    [ApiDescriptionSettings(Name = "Detail"), HttpGet]
    public async Task<XzImlog> Detail([FromQuery] QueryByIdXzImlogInput input)
    {
        return await _xzImlogRep.GetFirstAsync(u => u.Id == input.Id);
    }

    /// <summary>
    /// 增加咨询连麦记录 ➕
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("增加咨询连麦记录")]
    [ApiDescriptionSettings(Name = "Add"), HttpPost]
    public async Task<long> Add(AddXzImlogInput input)
    {
        var entity = input.Adapt<XzImlog>();
        return await _xzImlogRep.InsertAsync(entity) ? entity.Id : 0;
    }

    /// <summary>
    /// 更新咨询连麦记录 ✏️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("更新咨询连麦记录")]
    [ApiDescriptionSettings(Name = "Update"), HttpPost]
    public async Task Update(UpdateXzImlogInput input)
    {
        var entity = input.Adapt<XzImlog>();
        await _xzImlogRep.AsUpdateable(entity)
        .ExecuteCommandAsync();
    }

    /// <summary>
    /// 删除咨询连麦记录 ❌
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("删除咨询连麦记录")]
    [ApiDescriptionSettings(Name = "Delete"), HttpPost]
    public async Task Delete(DeleteXzImlogInput input)
    {
        var entity = await _xzImlogRep.GetFirstAsync(u => u.Id == input.Id) ?? throw Oops.Oh(ErrorCodeEnum.D1002);
        //await _xzImlogRep.FakeDeleteAsync(entity);   //假删除
        await _xzImlogRep.DeleteAsync(entity);   //真删除
    }

    /// <summary>
    /// 批量删除咨询连麦记录 ❌
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("批量删除咨询连麦记录")]
    [ApiDescriptionSettings(Name = "BatchDelete"), HttpPost]
    public async Task<bool> BatchDelete([Required(ErrorMessage = "主键列表不能为空")]List<DeleteXzImlogInput> input)
    {
        var exp = Expressionable.Create<XzImlog>();
        foreach (var row in input) exp = exp.Or(it => it.Id == row.Id);
        var list = await _xzImlogRep.AsQueryable().Where(exp.ToExpression()).ToListAsync();
   
        //return await _xzImlogRep.FakeDeleteAsync(list);   //假删除
        return await _xzImlogRep.DeleteAsync(list);   //真删除
    }
    
    /// <summary>
    /// 导出咨询连麦记录记录 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("导出咨询连麦记录记录")]
    [ApiDescriptionSettings(Name = "Export"), HttpPost, NonUnify]
    public async Task<IActionResult> Export(PageXzImlogInput input)
    {
        var list = (await Page(input)).Items?.Adapt<List<ExportXzImlogOutput>>() ?? new();
        if (input.SelectKeyList?.Count > 0) list = list.Where(x => input.SelectKeyList.Contains(x.Id)).ToList();
        return ExcelHelper.ExportTemplate(list, "咨询连麦记录导出记录");
    }
    
    /// <summary>
    /// 下载咨询连麦记录数据导入模板 ⬇️
    /// </summary>
    /// <returns></returns>
    [DisplayName("下载咨询连麦记录数据导入模板")]
    [ApiDescriptionSettings(Name = "Import"), HttpGet, NonUnify]
    public IActionResult DownloadTemplate()
    {
        return ExcelHelper.ExportTemplate(new List<ExportXzImlogOutput>(), "咨询连麦记录导入模板");
    }
    
    private static readonly object _xzImlogImportLock = new object();
    /// <summary>
    /// 导入咨询连麦记录记录 💾
    /// </summary>
    /// <returns></returns>
    [DisplayName("导入咨询连麦记录记录")]
    [ApiDescriptionSettings(Name = "Import"), HttpPost, NonUnify, UnitOfWork]
    public IActionResult ImportData([Required] IFormFile file)
    {
        lock (_xzImlogImportLock)
        {
            var stream = ExcelHelper.ImportData<ImportXzImlogInput, XzImlog>(file, (list, markerErrorAction) =>
            {
                _sqlSugarClient.Utilities.PageEach(list, 2048, pageItems =>
                {
                    
                    // 校验并过滤必填基本类型为null的字段
                    var rows = pageItems.Where(x => {
                        if (!string.IsNullOrWhiteSpace(x.Error)) return false;
                        return true;
                    }).Adapt<List<XzImlog>>();
                    
                    var storageable = _xzImlogRep.Context.Storageable(rows)
                        .SplitError(it => it.Item.orderno?.Length > 20, "订单号长度不能超过20个字符")
                        .SplitInsert(_=> true) // 没有设置唯一键代表插入所有数据
                        .ToStorage();
                    
                    storageable.AsInsertable.ExecuteCommand();// 不存在插入
                    storageable.AsUpdateable.UpdateColumns(it => new
                    {
                        it.uid,
                        it.tid,
                        it.itype,
                        it.xzmoney,
                        it.orderno,
                        it.isdel,
                        it.price,
                        it.state,
                        it.imtime,
                        it.overtime,
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
