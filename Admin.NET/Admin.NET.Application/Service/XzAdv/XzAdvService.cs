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
/// 系统广告服务 🧩
/// </summary>
[ApiDescriptionSettings(ApplicationConst.GroupName, Order = 100)]
public partial class XzAdvService : IDynamicApiController, ITransient
{
    private readonly SqlSugarRepository<XzAdv> _xzAdvRep;
    private readonly ISqlSugarClient _sqlSugarClient;

    public XzAdvService(SqlSugarRepository<XzAdv> xzAdvRep, ISqlSugarClient sqlSugarClient)
    {
        _xzAdvRep = xzAdvRep;
        _sqlSugarClient = sqlSugarClient;
    }

    /// <summary>
    /// 分页查询系统广告 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("分页查询系统广告")]
    [ApiDescriptionSettings(Name = "Page"), HttpPost]
    public async Task<SqlSugarPagedList<XzAdvOutput>> Page(PageXzAdvInput input)
    {
        input.Keyword = input.Keyword?.Trim();
        var query = _xzAdvRep.AsQueryable()
            .WhereIF(!string.IsNullOrWhiteSpace(input.Keyword), u => u.name.Contains(input.Keyword) || u.img.Contains(input.Keyword) || u.url.Contains(input.Keyword))
            .WhereIF(!string.IsNullOrWhiteSpace(input.name), u => u.name.Contains(input.name.Trim()))
            .WhereIF(!string.IsNullOrWhiteSpace(input.img), u => u.img.Contains(input.img.Trim()))
            .WhereIF(!string.IsNullOrWhiteSpace(input.url), u => u.url.Contains(input.url.Trim()))
            .WhereIF(input.postion != null, u => u.postion == input.postion)
            .WhereIF(input.stimeRange?.Length == 2, u => u.stime >= input.stimeRange[0] && u.stime <= input.stimeRange[1])
            .WhereIF(input.etimeRange?.Length == 2, u => u.etime >= input.etimeRange[0] && u.etime <= input.etimeRange[1])
            .WhereIF(input.sortcode != null, u => u.sortcode == input.sortcode)
            .WhereIF(input.isenable != null, u => u.isenable == input.isenable)
            .WhereIF(input.click != null, u => u.click == input.click)
            .WhereIF(input.createtimeRange?.Length == 2, u => u.createtime >= input.createtimeRange[0] && u.createtime <= input.createtimeRange[1])
            .Select<XzAdvOutput>();
        return await query.OrderBuilder(input).ToPagedListAsync(input.Page, input.PageSize);
    }

    /// <summary>
    /// 获取系统广告详情 ℹ️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("获取系统广告详情")]
    [ApiDescriptionSettings(Name = "Detail"), HttpGet]
    public async Task<XzAdv> Detail([FromQuery] QueryByIdXzAdvInput input)
    {
        return await _xzAdvRep.GetFirstAsync(u => u.Id == input.Id);
    }

    /// <summary>
    /// 增加系统广告 ➕
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("增加系统广告")]
    [ApiDescriptionSettings(Name = "Add"), HttpPost]
    public async Task<long> Add(AddXzAdvInput input)
    {
        var entity = input.Adapt<XzAdv>();
        return await _xzAdvRep.InsertAsync(entity) ? entity.Id : 0;
    }

    /// <summary>
    /// 更新系统广告 ✏️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("更新系统广告")]
    [ApiDescriptionSettings(Name = "Update"), HttpPost]
    public async Task Update(UpdateXzAdvInput input)
    {
        var entity = input.Adapt<XzAdv>();
        await _xzAdvRep.AsUpdateable(entity)
        .ExecuteCommandAsync();
    }

    /// <summary>
    /// 删除系统广告 ❌
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("删除系统广告")]
    [ApiDescriptionSettings(Name = "Delete"), HttpPost]
    public async Task Delete(DeleteXzAdvInput input)
    {
        var entity = await _xzAdvRep.GetFirstAsync(u => u.Id == input.Id) ?? throw Oops.Oh(ErrorCodeEnum.D1002);
        await _xzAdvRep.DeleteAsync(entity);   //假删除
        //await _xzAdvRep.DeleteAsync(entity);   //真删除
    }

    /// <summary>
    /// 批量删除系统广告 ❌
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("批量删除系统广告")]
    [ApiDescriptionSettings(Name = "BatchDelete"), HttpPost]
    public async Task<bool> BatchDelete([Required(ErrorMessage = "主键列表不能为空")] List<DeleteXzAdvInput> input)
    {
        var exp = Expressionable.Create<XzAdv>();
        foreach (var row in input) exp = exp.Or(it => it.Id == row.Id);
        var list = await _xzAdvRep.AsQueryable().Where(exp.ToExpression()).ToListAsync();

        //return await _xzAdvRep.FakeDeleteAsync(list);   //假删除
        return await _xzAdvRep.DeleteAsync(list);   //真删除
    }

    /// <summary>
    /// 导出系统广告记录 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("导出系统广告记录")]
    [ApiDescriptionSettings(Name = "Export"), HttpPost, NonUnify]
    public async Task<IActionResult> Export(PageXzAdvInput input)
    {
        var list = (await Page(input)).Items?.Adapt<List<ExportXzAdvOutput>>() ?? new();
        if (input.SelectKeyList?.Count > 0) list = list.Where(x => input.SelectKeyList.Contains(x.Id)).ToList();
        return ExcelHelper.ExportTemplate(list, "系统广告导出记录");
    }

    /// <summary>
    /// 下载系统广告数据导入模板 ⬇️
    /// </summary>
    /// <returns></returns>
    [DisplayName("下载系统广告数据导入模板")]
    [ApiDescriptionSettings(Name = "Import"), HttpGet, NonUnify]
    public IActionResult DownloadTemplate()
    {
        return ExcelHelper.ExportTemplate(new List<ExportXzAdvOutput>(), "系统广告导入模板");
    }

    private static readonly object _xzAdvImportLock = new object();
    /// <summary>
    /// 导入系统广告记录 💾
    /// </summary>
    /// <returns></returns>
    [DisplayName("导入系统广告记录")]
    [ApiDescriptionSettings(Name = "Import"), HttpPost, NonUnify, UnitOfWork]
    public IActionResult ImportData([Required] IFormFile file)
    {
        lock (_xzAdvImportLock)
        {
            var stream = ExcelHelper.ImportData<ImportXzAdvInput, XzAdv>(file, (list, markerErrorAction) =>
            {
                _sqlSugarClient.Utilities.PageEach(list, 2048, pageItems =>
                {

                    // 校验并过滤必填基本类型为null的字段
                    var rows = pageItems.Where(x =>
                    {
                        if (!string.IsNullOrWhiteSpace(x.Error)) return false;
                        return true;
                    }).Adapt<List<XzAdv>>();

                    var storageable = _xzAdvRep.Context.Storageable(rows)
                        .SplitError(it => it.Item.name?.Length > 100, "广告名称长度不能超过100个字符")
                        .SplitError(it => it.Item.img?.Length > 300, "广告图片长度不能超过300个字符")
                        .SplitError(it => it.Item.url?.Length > 300, "跳转地址长度不能超过300个字符")
                        .SplitInsert(_ => true) // 没有设置唯一键代表插入所有数据
                        .ToStorage();

                    storageable.AsInsertable.ExecuteCommand();// 不存在插入
                    storageable.AsUpdateable.UpdateColumns(it => new
                    {
                        it.name,
                        it.img,
                        it.postion,
                        it.stime,
                        it.etime,
                        it.sortcode,
                        it.url,
                        it.isenable,
                        it.click,
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
