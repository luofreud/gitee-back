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
/// 用户问答服务🧩
/// </summary>
[ApiDescriptionSettings(ApplicationConst.GroupName, Order = 100)]
public partial class XzQuestionService : IDynamicApiController, ITransient
{
    private readonly SqlSugarRepository<XzQuestion> _xzQuestionRep;
    private readonly ISqlSugarClient _sqlSugarClient;

    public XzQuestionService(SqlSugarRepository<XzQuestion> xzQuestionRep, ISqlSugarClient sqlSugarClient)
    {
        _xzQuestionRep = xzQuestionRep;
        _sqlSugarClient = sqlSugarClient;
    }

    /// <summary>
    /// 分页查询用户问答 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("分页查询用户问答")]
    [ApiDescriptionSettings(Name = "Page"), HttpPost]
    public async Task<SqlSugarPagedList<XzQuestionOutput>> Page(PageXzQuestionInput input)
    {
        input.Keyword = input.Keyword?.Trim();
        var query = _xzQuestionRep.AsQueryable()
            .WhereIF(!string.IsNullOrWhiteSpace(input.Keyword), u => u.name.Contains(input.Keyword) || u.content.Contains(input.Keyword) || u.img.Contains(input.Keyword))
            .WhereIF(!string.IsNullOrWhiteSpace(input.name), u => u.name.Contains(input.name.Trim()))
            .WhereIF(!string.IsNullOrWhiteSpace(input.content), u => u.content.Contains(input.content.Trim()))
            .WhereIF(!string.IsNullOrWhiteSpace(input.img), u => u.img.Contains(input.img.Trim()))
            .WhereIF(input.uid != null, u => u.uid == input.uid)
            .WhereIF(input.tid != null, u => u.tid == input.tid)
            .WhereIF(input.ordertype != null, u => u.ordertype == input.ordertype)
            .WhereIF(input.orderstate != null, u => u.orderstate == input.orderstate)
            .WhereIF(input.ftimeRange?.Length == 2, u => u.ftime >= input.ftimeRange[0] && u.ftime <= input.ftimeRange[1])
            .WhereIF(input.money != null, u => u.money == input.money)
            .WhereIF(input.createtimeRange?.Length == 2, u => u.createtime >= input.createtimeRange[0] && u.createtime <= input.createtimeRange[1])
            .Select<XzQuestionOutput>();
		return await query.OrderBuilder(input).ToPagedListAsync(input.Page, input.PageSize);
    }

    /// <summary>
    /// 获取用户问答详情 ℹ️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("获取用户问答详情")]
    [ApiDescriptionSettings(Name = "Detail"), HttpGet]
    public async Task<XzQuestion> Detail([FromQuery] QueryByIdXzQuestionInput input)
    {
        return await _xzQuestionRep.GetFirstAsync(u => u.Id == input.Id);
    }

    /// <summary>
    /// 增加用户问答 ➕
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("增加用户问答")]
    [ApiDescriptionSettings(Name = "Add"), HttpPost]
    public async Task<long> Add(AddXzQuestionInput input)
    {
        var entity = input.Adapt<XzQuestion>();
        return await _xzQuestionRep.InsertAsync(entity) ? entity.Id : 0;
    }

    /// <summary>
    /// 更新用户问答 ✏️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("更新用户问答")]
    [ApiDescriptionSettings(Name = "Update"), HttpPost]
    public async Task Update(UpdateXzQuestionInput input)
    {
        var entity = input.Adapt<XzQuestion>();
        await _xzQuestionRep.AsUpdateable(entity)
        .ExecuteCommandAsync();
    }

    /// <summary>
    /// 删除用户问答 ❌
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("删除用户问答")]
    [ApiDescriptionSettings(Name = "Delete"), HttpPost]
    public async Task Delete(DeleteXzQuestionInput input)
    {
        var entity = await _xzQuestionRep.GetFirstAsync(u => u.Id == input.Id) ?? throw Oops.Oh(ErrorCodeEnum.D1002);
        //await _xzQuestionRep.FakeDeleteAsync(entity);   //假删除
        await _xzQuestionRep.DeleteAsync(entity);   //真删除
    }

    /// <summary>
    /// 批量删除用户问答 ❌
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("批量删除用户问答")]
    [ApiDescriptionSettings(Name = "BatchDelete"), HttpPost]
    public async Task<bool> BatchDelete([Required(ErrorMessage = "主键列表不能为空")]List<DeleteXzQuestionInput> input)
    {
        var exp = Expressionable.Create<XzQuestion>();
        foreach (var row in input) exp = exp.Or(it => it.Id == row.Id);
        var list = await _xzQuestionRep.AsQueryable().Where(exp.ToExpression()).ToListAsync();
   
        //return await _xzQuestionRep.FakeDeleteAsync(list);   //假删除
        return await _xzQuestionRep.DeleteAsync(list);   //真删除
    }
    
    /// <summary>
    /// 导出用户问答记录 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("导出用户问答记录")]
    [ApiDescriptionSettings(Name = "Export"), HttpPost, NonUnify]
    public async Task<IActionResult> Export(PageXzQuestionInput input)
    {
        var list = (await Page(input)).Items?.Adapt<List<ExportXzQuestionOutput>>() ?? new();
        if (input.SelectKeyList?.Count > 0) list = list.Where(x => input.SelectKeyList.Contains(x.Id)).ToList();
        return ExcelHelper.ExportTemplate(list, "用户问答导出记录");
    }
    
    /// <summary>
    /// 下载用户问答数据导入模板 ⬇️
    /// </summary>
    /// <returns></returns>
    [DisplayName("下载用户问答数据导入模板")]
    [ApiDescriptionSettings(Name = "Import"), HttpGet, NonUnify]
    public IActionResult DownloadTemplate()
    {
        return ExcelHelper.ExportTemplate(new List<ExportXzQuestionOutput>(), "用户问答导入模板");
    }
    
    private static readonly object _xzQuestionImportLock = new object();
    /// <summary>
    /// 导入用户问答记录 💾
    /// </summary>
    /// <returns></returns>
    [DisplayName("导入用户问答记录")]
    [ApiDescriptionSettings(Name = "Import"), HttpPost, NonUnify, UnitOfWork]
    public IActionResult ImportData([Required] IFormFile file)
    {
        lock (_xzQuestionImportLock)
        {
            var stream = ExcelHelper.ImportData<ImportXzQuestionInput, XzQuestion>(file, (list, markerErrorAction) =>
            {
                _sqlSugarClient.Utilities.PageEach(list, 2048, pageItems =>
                {
                    
                    // 校验并过滤必填基本类型为null的字段
                    var rows = pageItems.Where(x => {
                        if (!string.IsNullOrWhiteSpace(x.Error)) return false;
                        return true;
                    }).Adapt<List<XzQuestion>>();
                    
                    var storageable = _xzQuestionRep.Context.Storageable(rows)
                        .SplitError(it => it.Item.name?.Length > 100, "长度不能超过100个字符")
                        .SplitError(it => it.Item.img?.Length > 300, "长度不能超过300个字符")
                        .SplitInsert(_=> true) // 没有设置唯一键代表插入所有数据
                        .ToStorage();
                    
                    storageable.AsInsertable.ExecuteCommand();// 不存在插入
                    storageable.AsUpdateable.UpdateColumns(it => new
                    {
                        it.uid,
                        it.tid,
                        it.name,
                        it.content,
                        it.ordertype,
                        it.orderstate,
                        it.ftime,
                        it.money,
                        it.createtime,
                        it.img,
                    }).ExecuteCommand();// 存在更新
                    
                    // 标记错误信息
                    markerErrorAction.Invoke(storageable, pageItems, rows);
                });
            });
            
            return stream;
        }
    }
}
