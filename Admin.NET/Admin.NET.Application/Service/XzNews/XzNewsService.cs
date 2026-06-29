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
/// 新闻内容服务 🧩
/// </summary>
[ApiDescriptionSettings(ApplicationConst.GroupName, Order = 100)]
public partial class XzNewsService : IDynamicApiController, ITransient
{
    private readonly SqlSugarRepository<XzNews> _xzNewsRep;
    private readonly ISqlSugarClient _sqlSugarClient;

    public XzNewsService(SqlSugarRepository<XzNews> xzNewsRep, ISqlSugarClient sqlSugarClient)
    {
        _xzNewsRep = xzNewsRep;
        _sqlSugarClient = sqlSugarClient;
    }

    /// <summary>
    /// 分页查询新闻内容 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("分页查询新闻内容")]
    [ApiDescriptionSettings(Name = "Page"), HttpPost]
    public async Task<SqlSugarPagedList<XzNewsOutput>> Page(PageXzNewsInput input)
    {
        input.Keyword = input.Keyword?.Trim();
        var query = _xzNewsRep.AsQueryable()
            .WhereIF(!string.IsNullOrWhiteSpace(input.Keyword), u => u.title.Contains(input.Keyword) || u.titlecode.Contains(input.Keyword) || u.img.Contains(input.Keyword) || u.newcontent.Contains(input.Keyword))
            .WhereIF(!string.IsNullOrWhiteSpace(input.title), u => u.title.Contains(input.title.Trim()))
            .WhereIF(!string.IsNullOrWhiteSpace(input.titlecode), u => u.titlecode.Contains(input.titlecode.Trim()))
            .WhereIF(!string.IsNullOrWhiteSpace(input.img), u => u.img.Contains(input.img.Trim()))
            .WhereIF(!string.IsNullOrWhiteSpace(input.newcontent), u => u.newcontent.Contains(input.newcontent.Trim()))
            .WhereIF(input.click != null, u => u.click == input.click)
            .WhereIF(input.sortcode != null, u => u.sortcode == input.sortcode)
            .WhereIF(input.createtimeRange?.Length == 2, u => u.createtime >= input.createtimeRange[0] && u.createtime <= input.createtimeRange[1])
            .Select<XzNewsOutput>();
		return await query.OrderBuilder(input).ToPagedListAsync(input.Page, input.PageSize);
    }

    /// <summary>
    /// 获取新闻内容详情 ℹ️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("获取新闻内容详情")]
    [ApiDescriptionSettings(Name = "Detail"), HttpGet]
    public async Task<XzNews> Detail([FromQuery] QueryByIdXzNewsInput input)
    {
        return await _xzNewsRep.GetFirstAsync(u => u.Id == input.Id);
    }

    /// <summary>
    /// 增加新闻内容 ➕
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("增加新闻内容")]
    [ApiDescriptionSettings(Name = "Add"), HttpPost]
    public async Task<long> Add(AddXzNewsInput input)
    {
        var entity = input.Adapt<XzNews>();
        return await _xzNewsRep.InsertAsync(entity) ? entity.Id : 0;
    }

    /// <summary>
    /// 更新新闻内容 ✏️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("更新新闻内容")]
    [ApiDescriptionSettings(Name = "Update"), HttpPost]
    public async Task Update(UpdateXzNewsInput input)
    {
        var entity = input.Adapt<XzNews>();
        await _xzNewsRep.AsUpdateable(entity)
        .ExecuteCommandAsync();
    }

    /// <summary>
    /// 删除新闻内容 ❌
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("删除新闻内容")]
    [ApiDescriptionSettings(Name = "Delete"), HttpPost]
    public async Task Delete(DeleteXzNewsInput input)
    {
        var entity = await _xzNewsRep.GetFirstAsync(u => u.Id == input.Id) ?? throw Oops.Oh(ErrorCodeEnum.D1002);
       // await _xzNewsRep.FakeDeleteAsync(entity);   //假删除
        await _xzNewsRep.DeleteAsync(entity);   //真删除
    }

    /// <summary>
    /// 批量删除新闻内容 ❌
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("批量删除新闻内容")]
    [ApiDescriptionSettings(Name = "BatchDelete"), HttpPost]
    public async Task<bool> BatchDelete([Required(ErrorMessage = "主键列表不能为空")]List<DeleteXzNewsInput> input)
    {
        var exp = Expressionable.Create<XzNews>();
        foreach (var row in input) exp = exp.Or(it => it.Id == row.Id);
        var list = await _xzNewsRep.AsQueryable().Where(exp.ToExpression()).ToListAsync();
   
        //return await _xzNewsRep.FakeDeleteAsync(list);   //假删除
        return await _xzNewsRep.DeleteAsync(list);   //真删除
    }
    
    /// <summary>
    /// 导出新闻内容记录 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("导出新闻内容记录")]
    [ApiDescriptionSettings(Name = "Export"), HttpPost, NonUnify]
    public async Task<IActionResult> Export(PageXzNewsInput input)
    {
        var list = (await Page(input)).Items?.Adapt<List<ExportXzNewsOutput>>() ?? new();
        if (input.SelectKeyList?.Count > 0) list = list.Where(x => input.SelectKeyList.Contains(x.Id)).ToList();
        return ExcelHelper.ExportTemplate(list, "新闻内容导出记录");
    }
    
    /// <summary>
    /// 下载新闻内容数据导入模板 ⬇️
    /// </summary>
    /// <returns></returns>
    [DisplayName("下载新闻内容数据导入模板")]
    [ApiDescriptionSettings(Name = "Import"), HttpGet, NonUnify]
    public IActionResult DownloadTemplate()
    {
        return ExcelHelper.ExportTemplate(new List<ExportXzNewsOutput>(), "新闻内容导入模板");
    }
    
    private static readonly object _xzNewsImportLock = new object();
    /// <summary>
    /// 导入新闻内容记录 💾
    /// </summary>
    /// <returns></returns>
    [DisplayName("导入新闻内容记录")]
    [ApiDescriptionSettings(Name = "Import"), HttpPost, NonUnify, UnitOfWork]
    public IActionResult ImportData([Required] IFormFile file)
    {
        lock (_xzNewsImportLock)
        {
            var stream = ExcelHelper.ImportData<ImportXzNewsInput, XzNews>(file, (list, markerErrorAction) =>
            {
                _sqlSugarClient.Utilities.PageEach(list, 2048, pageItems =>
                {
                    
                    // 校验并过滤必填基本类型为null的字段
                    var rows = pageItems.Where(x => {
                        if (!string.IsNullOrWhiteSpace(x.Error)) return false;
                        return true;
                    }).Adapt<List<XzNews>>();
                    
                    var storageable = _xzNewsRep.Context.Storageable(rows)
                        .SplitError(it => it.Item.title?.Length > 200, "标题长度不能超过200个字符")
                        .SplitError(it => it.Item.titlecode?.Length > 50, "标题key长度不能超过50个字符")
                        .SplitError(it => it.Item.img?.Length > 500, "图标长度不能超过500个字符")
                        .SplitInsert(_=> true) // 没有设置唯一键代表插入所有数据
                        .ToStorage();
                    
                    storageable.AsInsertable.ExecuteCommand();// 不存在插入
                    storageable.AsUpdateable.UpdateColumns(it => new
                    {
                        it.title,
                        it.titlecode,
                        it.img,
                        it.newcontent,
                        it.click,
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
