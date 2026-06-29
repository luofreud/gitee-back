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
/// 星座月运势服务 🧩
/// </summary>
[ApiDescriptionSettings(ApplicationConst.GroupName, Order = 100)]
public partial class XzMonthfortunesService : IDynamicApiController, ITransient
{
    private readonly SqlSugarRepository<XzMonthfortunes> _xzMonthfortunesRep;
    private readonly ISqlSugarClient _sqlSugarClient;

    public XzMonthfortunesService(SqlSugarRepository<XzMonthfortunes> xzMonthfortunesRep, ISqlSugarClient sqlSugarClient)
    {
        _xzMonthfortunesRep = xzMonthfortunesRep;
        _sqlSugarClient = sqlSugarClient;
    }

    /// <summary>
    /// 分页查询星座月运势 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("分页查询星座月运势")]
    [ApiDescriptionSettings(Name = "Page"), HttpPost]
    public async Task<SqlSugarPagedList<XzMonthfortunesOutput>> Page(PageXzMonthfortunesInput input)
    {
        input.Keyword = input.Keyword?.Trim();
        var query = _xzMonthfortunesRep.AsQueryable()
            .WhereIF(!string.IsNullOrWhiteSpace(input.Keyword), u => u.luckycolor.Contains(input.Keyword) || u.luckyflower.Contains(input.Keyword) || u.luckystone.Contains(input.Keyword) || u.explaincontent.Contains(input.Keyword))
            .WhereIF(!string.IsNullOrWhiteSpace(input.luckycolor), u => u.luckycolor.Contains(input.luckycolor.Trim()))
            .WhereIF(!string.IsNullOrWhiteSpace(input.luckyflower), u => u.luckyflower.Contains(input.luckyflower.Trim()))
            .WhereIF(!string.IsNullOrWhiteSpace(input.luckystone), u => u.luckystone.Contains(input.luckystone.Trim()))
            .WhereIF(!string.IsNullOrWhiteSpace(input.explaincontent), u => u.explaincontent.Contains(input.explaincontent.Trim()))
            .WhereIF(input.ftimeRange?.Length == 2, u => u.ftime >= input.ftimeRange[0] && u.ftime <= input.ftimeRange[1])
            .WhereIF(input.signtype != null, u => u.signtype == input.signtype)
            .WhereIF(input.allscore != null, u => u.allscore == input.allscore)
            .WhereIF(input.lovescore != null, u => u.lovescore == input.lovescore)
            .WhereIF(input.healthscore != null, u => u.healthscore == input.healthscore)
            .WhereIF(input.wealthscore != null, u => u.wealthscore == input.wealthscore)
            .WhereIF(input.luckynum != null, u => u.luckynum == input.luckynum)
            .Select<XzMonthfortunesOutput>();
		return await query.OrderBuilder(input).ToPagedListAsync(input.Page, input.PageSize);
    }

    /// <summary>
    /// 获取星座月运势详情 ℹ️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("获取星座月运势详情")]
    [ApiDescriptionSettings(Name = "Detail"), HttpGet]
    public async Task<XzMonthfortunes> Detail([FromQuery] QueryByIdXzMonthfortunesInput input)
    {
        return await _xzMonthfortunesRep.GetFirstAsync(u => u.Id == input.Id);
    }

    /// <summary>
    /// 增加星座月运势 ➕
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("增加星座月运势")]
    [ApiDescriptionSettings(Name = "Add"), HttpPost]
    public async Task<long> Add(AddXzMonthfortunesInput input)
    {
        var entity = input.Adapt<XzMonthfortunes>();
        return await _xzMonthfortunesRep.InsertAsync(entity) ? entity.Id : 0;
    }

    /// <summary>
    /// 更新星座月运势 ✏️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("更新星座月运势")]
    [ApiDescriptionSettings(Name = "Update"), HttpPost]
    public async Task Update(UpdateXzMonthfortunesInput input)
    {
        var entity = input.Adapt<XzMonthfortunes>();
        await _xzMonthfortunesRep.AsUpdateable(entity)
        .ExecuteCommandAsync();
    }

    /// <summary>
    /// 删除星座月运势 ❌
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("删除星座月运势")]
    [ApiDescriptionSettings(Name = "Delete"), HttpPost]
    public async Task Delete(DeleteXzMonthfortunesInput input)
    {
        var entity = await _xzMonthfortunesRep.GetFirstAsync(u => u.Id == input.Id) ?? throw Oops.Oh(ErrorCodeEnum.D1002);
        //await _xzMonthfortunesRep.FakeDeleteAsync(entity);   //假删除
        await _xzMonthfortunesRep.DeleteAsync(entity);   //真删除
    }

    /// <summary>
    /// 批量删除星座月运势 ❌
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("批量删除星座月运势")]
    [ApiDescriptionSettings(Name = "BatchDelete"), HttpPost]
    public async Task<bool> BatchDelete([Required(ErrorMessage = "主键列表不能为空")]List<DeleteXzMonthfortunesInput> input)
    {
        var exp = Expressionable.Create<XzMonthfortunes>();
        foreach (var row in input) exp = exp.Or(it => it.Id == row.Id);
        var list = await _xzMonthfortunesRep.AsQueryable().Where(exp.ToExpression()).ToListAsync();
   
        //return await _xzMonthfortunesRep.FakeDeleteAsync(list);   //假删除
        return await _xzMonthfortunesRep.DeleteAsync(list);   //真删除
    }
    
    /// <summary>
    /// 导出星座月运势记录 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("导出星座月运势记录")]
    [ApiDescriptionSettings(Name = "Export"), HttpPost, NonUnify]
    public async Task<IActionResult> Export(PageXzMonthfortunesInput input)
    {
        var list = (await Page(input)).Items?.Adapt<List<ExportXzMonthfortunesOutput>>() ?? new();
        if (input.SelectKeyList?.Count > 0) list = list.Where(x => input.SelectKeyList.Contains(x.Id)).ToList();
        return ExcelHelper.ExportTemplate(list, "星座月运势导出记录");
    }
    
    /// <summary>
    /// 下载星座月运势数据导入模板 ⬇️
    /// </summary>
    /// <returns></returns>
    [DisplayName("下载星座月运势数据导入模板")]
    [ApiDescriptionSettings(Name = "Import"), HttpGet, NonUnify]
    public IActionResult DownloadTemplate()
    {
        return ExcelHelper.ExportTemplate(new List<ExportXzMonthfortunesOutput>(), "星座月运势导入模板");
    }
    
    private static readonly object _xzMonthfortunesImportLock = new object();
    /// <summary>
    /// 导入星座月运势记录 💾
    /// </summary>
    /// <returns></returns>
    [DisplayName("导入星座月运势记录")]
    [ApiDescriptionSettings(Name = "Import"), HttpPost, NonUnify, UnitOfWork]
    public IActionResult ImportData([Required] IFormFile file)
    {
        lock (_xzMonthfortunesImportLock)
        {
            var stream = ExcelHelper.ImportData<ImportXzMonthfortunesInput, XzMonthfortunes>(file, (list, markerErrorAction) =>
            {
                _sqlSugarClient.Utilities.PageEach(list, 2048, pageItems =>
                {
                    
                    // 校验并过滤必填基本类型为null的字段
                    var rows = pageItems.Where(x => {
                        if (!string.IsNullOrWhiteSpace(x.Error)) return false;
                        return true;
                    }).Adapt<List<XzMonthfortunes>>();
                    
                    var storageable = _xzMonthfortunesRep.Context.Storageable(rows)
                        .SplitError(it => it.Item.luckycolor?.Length > 20, "幸运颜色长度不能超过20个字符")
                        .SplitError(it => it.Item.luckyflower?.Length > 20, "幸运花长度不能超过20个字符")
                        .SplitError(it => it.Item.luckystone?.Length > 20, "幸运石长度不能超过20个字符")
                        .SplitError(it => it.Item.explaincontent?.Length > 2000, "解释长度不能超过2000个字符")
                        .SplitInsert(_=> true) // 没有设置唯一键代表插入所有数据
                        .ToStorage();
                    
                    storageable.AsInsertable.ExecuteCommand();// 不存在插入
                    storageable.AsUpdateable.UpdateColumns(it => new
                    {
                        it.ftime,
                        it.signtype,
                        it.allscore,
                        it.lovescore,
                        it.healthscore,
                        it.wealthscore,
                        it.luckynum,
                        it.luckycolor,
                        it.luckyflower,
                        it.luckystone,
                        it.explaincontent,
                    }).ExecuteCommand();// 存在更新
                    
                    // 标记错误信息
                    markerErrorAction.Invoke(storageable, pageItems, rows);
                });
            });
            
            return stream;
        }
    }
}
