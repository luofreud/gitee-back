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
/// 星币兑换商城服务 🧩
/// </summary>
[ApiDescriptionSettings(ApplicationConst.GroupName, Order = 100)]
public partial class XzExchangeshopService : IDynamicApiController, ITransient
{
    private readonly SqlSugarRepository<XzExchangeshop> _xzExchangeshopRep;
    private readonly ISqlSugarClient _sqlSugarClient;

    public XzExchangeshopService(SqlSugarRepository<XzExchangeshop> xzExchangeshopRep, ISqlSugarClient sqlSugarClient)
    {
        _xzExchangeshopRep = xzExchangeshopRep;
        _sqlSugarClient = sqlSugarClient;
    }

    /// <summary>
    /// 分页查询星币兑换商城 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("分页查询星币兑换商城")]
    [ApiDescriptionSettings(Name = "Page"), HttpPost]
    public async Task<SqlSugarPagedList<XzExchangeshopOutput>> Page(PageXzExchangeshopInput input)
    {
        input.Keyword = input.Keyword?.Trim();
        var query = _xzExchangeshopRep.AsQueryable()
            .WhereIF(!string.IsNullOrWhiteSpace(input.Keyword), u => u.goodname.Contains(input.Keyword) || u.goodimg.Contains(input.Keyword))
            .WhereIF(!string.IsNullOrWhiteSpace(input.goodname), u => u.goodname.Contains(input.goodname.Trim()))
            .WhereIF(!string.IsNullOrWhiteSpace(input.goodimg), u => u.goodimg.Contains(input.goodimg.Trim()))
            .WhereIF(input.xbmoney != null, u => u.xbmoney == input.xbmoney)
            .WhereIF(input.count != null, u => u.count == input.count)
            .WhereIF(input.xzmoney != null, u => u.xzmoney == input.xzmoney)
            .WhereIF(input.goodtypeid != null, u => u.goodtypeid == input.goodtypeid)
            .WhereIF(input.state != null, u => u.state == input.state)
            .WhereIF(input.createtimeRange?.Length == 2, u => u.createtime >= input.createtimeRange[0] && u.createtime <= input.createtimeRange[1])
            .Select<XzExchangeshopOutput>();
		return await query.OrderBuilder(input).ToPagedListAsync(input.Page, input.PageSize);
    }

    /// <summary>
    /// 获取星币兑换商城详情 ℹ️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("获取星币兑换商城详情")]
    [ApiDescriptionSettings(Name = "Detail"), HttpGet]
    public async Task<XzExchangeshop> Detail([FromQuery] QueryByIdXzExchangeshopInput input)
    {
        return await _xzExchangeshopRep.GetFirstAsync(u => u.Id == input.Id);
    }

    /// <summary>
    /// 增加星币兑换商城 ➕
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("增加星币兑换商城")]
    [ApiDescriptionSettings(Name = "Add"), HttpPost]
    public async Task<long> Add(AddXzExchangeshopInput input)
    {
        var entity = input.Adapt<XzExchangeshop>();
        return await _xzExchangeshopRep.InsertAsync(entity) ? entity.Id : 0;
    }

    /// <summary>
    /// 更新星币兑换商城 ✏️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("更新星币兑换商城")]
    [ApiDescriptionSettings(Name = "Update"), HttpPost]
    public async Task Update(UpdateXzExchangeshopInput input)
    {
        var entity = input.Adapt<XzExchangeshop>();
        await _xzExchangeshopRep.AsUpdateable(entity)
        .ExecuteCommandAsync();
    }

    /// <summary>
    /// 删除星币兑换商城 ❌
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("删除星币兑换商城")]
    [ApiDescriptionSettings(Name = "Delete"), HttpPost]
    public async Task Delete(DeleteXzExchangeshopInput input)
    {
        var entity = await _xzExchangeshopRep.GetFirstAsync(u => u.Id == input.Id) ?? throw Oops.Oh(ErrorCodeEnum.D1002);
        //await _xzExchangeshopRep.FakeDeleteAsync(entity);   //假删除
        await _xzExchangeshopRep.DeleteAsync(entity);   //真删除
    }

    /// <summary>
    /// 批量删除星币兑换商城 ❌
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("批量删除星币兑换商城")]
    [ApiDescriptionSettings(Name = "BatchDelete"), HttpPost]
    public async Task<bool> BatchDelete([Required(ErrorMessage = "主键列表不能为空")]List<DeleteXzExchangeshopInput> input)
    {
        var exp = Expressionable.Create<XzExchangeshop>();
        foreach (var row in input) exp = exp.Or(it => it.Id == row.Id);
        var list = await _xzExchangeshopRep.AsQueryable().Where(exp.ToExpression()).ToListAsync();
   
        //return await _xzExchangeshopRep.FakeDeleteAsync(list);   //假删除
        return await _xzExchangeshopRep.DeleteAsync(list);   //真删除
    }
    
    /// <summary>
    /// 导出星币兑换商城记录 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("导出星币兑换商城记录")]
    [ApiDescriptionSettings(Name = "Export"), HttpPost, NonUnify]
    public async Task<IActionResult> Export(PageXzExchangeshopInput input)
    {
        var list = (await Page(input)).Items?.Adapt<List<ExportXzExchangeshopOutput>>() ?? new();
        if (input.SelectKeyList?.Count > 0) list = list.Where(x => input.SelectKeyList.Contains(x.Id)).ToList();
        return ExcelHelper.ExportTemplate(list, "星币兑换商城导出记录");
    }
    
    /// <summary>
    /// 下载星币兑换商城数据导入模板 ⬇️
    /// </summary>
    /// <returns></returns>
    [DisplayName("下载星币兑换商城数据导入模板")]
    [ApiDescriptionSettings(Name = "Import"), HttpGet, NonUnify]
    public IActionResult DownloadTemplate()
    {
        return ExcelHelper.ExportTemplate(new List<ExportXzExchangeshopOutput>(), "星币兑换商城导入模板");
    }
    
    private static readonly object _xzExchangeshopImportLock = new object();
    /// <summary>
    /// 导入星币兑换商城记录 💾
    /// </summary>
    /// <returns></returns>
    [DisplayName("导入星币兑换商城记录")]
    [ApiDescriptionSettings(Name = "Import"), HttpPost, NonUnify, UnitOfWork]
    public IActionResult ImportData([Required] IFormFile file)
    {
        lock (_xzExchangeshopImportLock)
        {
            var stream = ExcelHelper.ImportData<ImportXzExchangeshopInput, XzExchangeshop>(file, (list, markerErrorAction) =>
            {
                _sqlSugarClient.Utilities.PageEach(list, 2048, pageItems =>
                {
                    
                    // 校验并过滤必填基本类型为null的字段
                    var rows = pageItems.Where(x => {
                        if (!string.IsNullOrWhiteSpace(x.Error)) return false;
                        return true;
                    }).Adapt<List<XzExchangeshop>>();
                    
                    var storageable = _xzExchangeshopRep.Context.Storageable(rows)
                        .SplitError(it => it.Item.goodname?.Length > 200, "商品名称长度不能超过200个字符")
                        .SplitError(it => it.Item.goodimg?.Length > 200, "商品图片长度不能超过200个字符")
                        .SplitInsert(_=> true) // 没有设置唯一键代表插入所有数据
                        .ToStorage();
                    
                    storageable.AsInsertable.ExecuteCommand();// 不存在插入
                    storageable.AsUpdateable.UpdateColumns(it => new
                    {
                        it.goodname,
                        it.goodimg,
                        it.xbmoney,
                        it.count,
                        it.xzmoney,
                        it.goodtypeid,
                        it.state,
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
