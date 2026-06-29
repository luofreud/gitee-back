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
/// 用户发布文章服务 🧩
/// </summary>
[ApiDescriptionSettings(ApplicationConst.GroupName, Order = 100)]
public partial class XzArticleService : IDynamicApiController, ITransient
{
    private readonly SqlSugarRepository<XzArticle> _xzArticleRep;
    private readonly ISqlSugarClient _sqlSugarClient;

    public XzArticleService(SqlSugarRepository<XzArticle> xzArticleRep, ISqlSugarClient sqlSugarClient)
    {
        _xzArticleRep = xzArticleRep;
        _sqlSugarClient = sqlSugarClient;
    }

    /// <summary>
    /// 分页查询用户发布文章 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("分页查询用户发布文章")]
    [ApiDescriptionSettings(Name = "Page"), HttpPost]
    public async Task<SqlSugarPagedList<XzArticleOutput>> Page(PageXzArticleInput input)
    {
        input.Keyword = input.Keyword?.Trim();
        var query = _xzArticleRep.AsQueryable()
            .WhereIF(!string.IsNullOrWhiteSpace(input.Keyword), u => u.content.Contains(input.Keyword) || u.imgs.Contains(input.Keyword) || u.videos.Contains(input.Keyword) || u.tags.Contains(input.Keyword))
            .WhereIF(!string.IsNullOrWhiteSpace(input.content), u => u.content.Contains(input.content.Trim()))
            .WhereIF(!string.IsNullOrWhiteSpace(input.imgs), u => u.imgs.Contains(input.imgs.Trim()))
            .WhereIF(!string.IsNullOrWhiteSpace(input.videos), u => u.videos.Contains(input.videos.Trim()))
            .WhereIF(!string.IsNullOrWhiteSpace(input.tags), u => u.tags.Contains(input.tags.Trim()))
            .WhereIF(input.plateid != null, u => u.plateid == input.plateid)
            .WhereIF(input.uid != null, u => u.uid == input.uid)
            .WhereIF(input.atype != null, u => u.atype == input.atype)
            .WhereIF(input.isanonymous != null, u => u.isanonymous == input.isanonymous)
            .WhereIF(input.likecount != null, u => u.likecount == input.likecount)
            .WhereIF(input.commentcount != null, u => u.commentcount == input.commentcount)
            .WhereIF(input.collectioncount != null, u => u.collectioncount == input.collectioncount)
            .WhereIF(input.istop != null, u => u.istop == input.istop)
            .WhereIF(input.createtimeRange?.Length == 2, u => u.createtime >= input.createtimeRange[0] && u.createtime <= input.createtimeRange[1])
            .Select<XzArticleOutput>();
		return await query.OrderBuilder(input).ToPagedListAsync(input.Page, input.PageSize);
    }

    /// <summary>
    /// 获取用户发布文章详情 ℹ️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("获取用户发布文章详情")]
    [ApiDescriptionSettings(Name = "Detail"), HttpGet]
    public async Task<XzArticle> Detail([FromQuery] QueryByIdXzArticleInput input)
    {
        return await _xzArticleRep.GetFirstAsync(u => u.Id == input.Id);
    }

    /// <summary>
    /// 增加用户发布文章 ➕
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("增加用户发布文章")]
    [ApiDescriptionSettings(Name = "Add"), HttpPost]
    public async Task<long> Add(AddXzArticleInput input)
    {
        var entity = input.Adapt<XzArticle>();
        return await _xzArticleRep.InsertAsync(entity) ? entity.Id : 0;
    }

    /// <summary>
    /// 更新用户发布文章 ✏️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("更新用户发布文章")]
    [ApiDescriptionSettings(Name = "Update"), HttpPost]
    public async Task Update(UpdateXzArticleInput input)
    {
        var entity = input.Adapt<XzArticle>();
        await _xzArticleRep.AsUpdateable(entity)
        .ExecuteCommandAsync();
    }

    /// <summary>
    /// 删除用户发布文章 ❌
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("删除用户发布文章")]
    [ApiDescriptionSettings(Name = "Delete"), HttpPost]
    public async Task Delete(DeleteXzArticleInput input)
    {
        var entity = await _xzArticleRep.GetFirstAsync(u => u.Id == input.Id) ?? throw Oops.Oh(ErrorCodeEnum.D1002);
        //await _xzArticleRep.FakeDeleteAsync(entity);   //假删除
        await _xzArticleRep.DeleteAsync(entity);   //真删除
    }

    /// <summary>
    /// 批量删除用户发布文章 ❌
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("批量删除用户发布文章")]
    [ApiDescriptionSettings(Name = "BatchDelete"), HttpPost]
    public async Task<bool> BatchDelete([Required(ErrorMessage = "主键列表不能为空")]List<DeleteXzArticleInput> input)
    {
        var exp = Expressionable.Create<XzArticle>();
        foreach (var row in input) exp = exp.Or(it => it.Id == row.Id);
        var list = await _xzArticleRep.AsQueryable().Where(exp.ToExpression()).ToListAsync();
   
        //return await _xzArticleRep.FakeDeleteAsync(list);   //假删除
        return await _xzArticleRep.DeleteAsync(list);   //真删除
    }
    
    /// <summary>
    /// 导出用户发布文章记录 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("导出用户发布文章记录")]
    [ApiDescriptionSettings(Name = "Export"), HttpPost, NonUnify]
    public async Task<IActionResult> Export(PageXzArticleInput input)
    {
        var list = (await Page(input)).Items?.Adapt<List<ExportXzArticleOutput>>() ?? new();
        if (input.SelectKeyList?.Count > 0) list = list.Where(x => input.SelectKeyList.Contains(x.Id)).ToList();
        return ExcelHelper.ExportTemplate(list, "用户发布文章导出记录");
    }
    
    /// <summary>
    /// 下载用户发布文章数据导入模板 ⬇️
    /// </summary>
    /// <returns></returns>
    [DisplayName("下载用户发布文章数据导入模板")]
    [ApiDescriptionSettings(Name = "Import"), HttpGet, NonUnify]
    public IActionResult DownloadTemplate()
    {
        return ExcelHelper.ExportTemplate(new List<ExportXzArticleOutput>(), "用户发布文章导入模板");
    }
    
    private static readonly object _xzArticleImportLock = new object();
    /// <summary>
    /// 导入用户发布文章记录 💾
    /// </summary>
    /// <returns></returns>
    [DisplayName("导入用户发布文章记录")]
    [ApiDescriptionSettings(Name = "Import"), HttpPost, NonUnify, UnitOfWork]
    public IActionResult ImportData([Required] IFormFile file)
    {
        lock (_xzArticleImportLock)
        {
            var stream = ExcelHelper.ImportData<ImportXzArticleInput, XzArticle>(file, (list, markerErrorAction) =>
            {
                _sqlSugarClient.Utilities.PageEach(list, 2048, pageItems =>
                {
                    
                    // 校验并过滤必填基本类型为null的字段
                    var rows = pageItems.Where(x => {
                        if (!string.IsNullOrWhiteSpace(x.Error)) return false;
                        return true;
                    }).Adapt<List<XzArticle>>();
                    
                    var storageable = _xzArticleRep.Context.Storageable(rows)
                        .SplitError(it => it.Item.imgs?.Length > 500, "图片长度不能超过500个字符")
                        .SplitError(it => it.Item.videos?.Length > 500, "视频长度不能超过500个字符")
                        .SplitError(it => it.Item.tags?.Length > 100, "话题长度不能超过100个字符")
                        .SplitInsert(_=> true) // 没有设置唯一键代表插入所有数据
                        .ToStorage();
                    
                    storageable.AsInsertable.ExecuteCommand();// 不存在插入
                    storageable.AsUpdateable.UpdateColumns(it => new
                    {
                        it.plateid,
                        it.uid,
                        it.content,
                        it.imgs,
                        it.videos,
                        it.tags,
                        it.atype,
                        it.isanonymous,
                        it.likecount,
                        it.commentcount,
                        it.collectioncount,
                        it.istop,
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
