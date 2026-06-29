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
/// 用户评论列表服务 🧩
/// </summary>
[ApiDescriptionSettings(ApplicationConst.GroupName, Order = 100)]
public partial class XzArticlecommentsService : IDynamicApiController, ITransient
{
    private readonly SqlSugarRepository<XzArticlecomments> _xzArticlecommentsRep;
    private readonly ISqlSugarClient _sqlSugarClient;

    public XzArticlecommentsService(SqlSugarRepository<XzArticlecomments> xzArticlecommentsRep, ISqlSugarClient sqlSugarClient)
    {
        _xzArticlecommentsRep = xzArticlecommentsRep;
        _sqlSugarClient = sqlSugarClient;
    }

    /// <summary>
    /// 分页查询用户评论列表 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("分页查询用户评论列表")]
    [ApiDescriptionSettings(Name = "Page"), HttpPost]
    public async Task<SqlSugarPagedList<XzArticlecommentsOutput>> Page(PageXzArticlecommentsInput input)
    {
        input.Keyword = input.Keyword?.Trim();
        var query = _xzArticlecommentsRep.AsQueryable()
            .WhereIF(!string.IsNullOrWhiteSpace(input.Keyword), u => u.content.Contains(input.Keyword))
            .WhereIF(!string.IsNullOrWhiteSpace(input.content), u => u.content.Contains(input.content.Trim()))
            .WhereIF(input.uid != null, u => u.uid == input.uid)
            .WhereIF(input.aid != null, u => u.aid == input.aid)
            .WhereIF(input.likecount != null, u => u.likecount == input.likecount)
            .WhereIF(input.parentid != null, u => u.parentid == input.parentid)
            .WhereIF(input.replycount != null, u => u.replycount == input.replycount)
            .WhereIF(input.state != null, u => u.state == input.state)
            .WhereIF(input.createtimeRange?.Length == 2, u => u.createtime >= input.createtimeRange[0] && u.createtime <= input.createtimeRange[1])
            .Select<XzArticlecommentsOutput>();
		return await query.OrderBuilder(input).ToPagedListAsync(input.Page, input.PageSize);
    }

    /// <summary>
    /// 获取用户评论列表详情 ℹ️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("获取用户评论列表详情")]
    [ApiDescriptionSettings(Name = "Detail"), HttpGet]
    public async Task<XzArticlecomments> Detail([FromQuery] QueryByIdXzArticlecommentsInput input)
    {
        return await _xzArticlecommentsRep.GetFirstAsync(u => u.Id == input.Id);
    }

    /// <summary>
    /// 增加用户评论列表 ➕
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("增加用户评论列表")]
    [ApiDescriptionSettings(Name = "Add"), HttpPost]
    public async Task<long> Add(AddXzArticlecommentsInput input)
    {
        var entity = input.Adapt<XzArticlecomments>();
        return await _xzArticlecommentsRep.InsertAsync(entity) ? entity.Id : 0;
    }

    /// <summary>
    /// 更新用户评论列表 ✏️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("更新用户评论列表")]
    [ApiDescriptionSettings(Name = "Update"), HttpPost]
    public async Task Update(UpdateXzArticlecommentsInput input)
    {
        var entity = input.Adapt<XzArticlecomments>();
        await _xzArticlecommentsRep.AsUpdateable(entity)
        .ExecuteCommandAsync();
    }

    /// <summary>
    /// 删除用户评论列表 ❌
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("删除用户评论列表")]
    [ApiDescriptionSettings(Name = "Delete"), HttpPost]
    public async Task Delete(DeleteXzArticlecommentsInput input)
    {
        var entity = await _xzArticlecommentsRep.GetFirstAsync(u => u.Id == input.Id) ?? throw Oops.Oh(ErrorCodeEnum.D1002);
        //await _xzArticlecommentsRep.FakeDeleteAsync(entity);   //假删除
        await _xzArticlecommentsRep.DeleteAsync(entity);   //真删除
    }

    /// <summary>
    /// 批量删除用户评论列表 ❌
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("批量删除用户评论列表")]
    [ApiDescriptionSettings(Name = "BatchDelete"), HttpPost]
    public async Task<bool> BatchDelete([Required(ErrorMessage = "主键列表不能为空")]List<DeleteXzArticlecommentsInput> input)
    {
        var exp = Expressionable.Create<XzArticlecomments>();
        foreach (var row in input) exp = exp.Or(it => it.Id == row.Id);
        var list = await _xzArticlecommentsRep.AsQueryable().Where(exp.ToExpression()).ToListAsync();
   
        //return await _xzArticlecommentsRep.FakeDeleteAsync(list);   //假删除
        return await _xzArticlecommentsRep.DeleteAsync(list);   //真删除
    }
    
    /// <summary>
    /// 导出用户评论列表记录 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("导出用户评论列表记录")]
    [ApiDescriptionSettings(Name = "Export"), HttpPost, NonUnify]
    public async Task<IActionResult> Export(PageXzArticlecommentsInput input)
    {
        var list = (await Page(input)).Items?.Adapt<List<ExportXzArticlecommentsOutput>>() ?? new();
        if (input.SelectKeyList?.Count > 0) list = list.Where(x => input.SelectKeyList.Contains(x.Id)).ToList();
        return ExcelHelper.ExportTemplate(list, "用户评论列表导出记录");
    }
    
    /// <summary>
    /// 下载用户评论列表数据导入模板 ⬇️
    /// </summary>
    /// <returns></returns>
    [DisplayName("下载用户评论列表数据导入模板")]
    [ApiDescriptionSettings(Name = "Import"), HttpGet, NonUnify]
    public IActionResult DownloadTemplate()
    {
        return ExcelHelper.ExportTemplate(new List<ExportXzArticlecommentsOutput>(), "用户评论列表导入模板");
    }
    
    private static readonly object _xzArticlecommentsImportLock = new object();
    /// <summary>
    /// 导入用户评论列表记录 💾
    /// </summary>
    /// <returns></returns>
    [DisplayName("导入用户评论列表记录")]
    [ApiDescriptionSettings(Name = "Import"), HttpPost, NonUnify, UnitOfWork]
    public IActionResult ImportData([Required] IFormFile file)
    {
        lock (_xzArticlecommentsImportLock)
        {
            var stream = ExcelHelper.ImportData<ImportXzArticlecommentsInput, XzArticlecomments>(file, (list, markerErrorAction) =>
            {
                _sqlSugarClient.Utilities.PageEach(list, 2048, pageItems =>
                {
                    
                    // 校验并过滤必填基本类型为null的字段
                    var rows = pageItems.Where(x => {
                        if (!string.IsNullOrWhiteSpace(x.Error)) return false;
                        return true;
                    }).Adapt<List<XzArticlecomments>>();
                    
                    var storageable = _xzArticlecommentsRep.Context.Storageable(rows)
                        .SplitError(it => it.Item.content?.Length > 500, "内容长度不能超过500个字符")
                        .SplitInsert(_=> true) // 没有设置唯一键代表插入所有数据
                        .ToStorage();
                    
                    storageable.AsInsertable.ExecuteCommand();// 不存在插入
                    storageable.AsUpdateable.UpdateColumns(it => new
                    {
                        it.uid,
                        it.aid,
                        it.content,
                        it.likecount,
                        it.parentid,
                        it.replycount,
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
