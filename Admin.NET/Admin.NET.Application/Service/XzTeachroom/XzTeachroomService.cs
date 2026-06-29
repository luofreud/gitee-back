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
/// 导师直播间服务 🧩
/// </summary>
[ApiDescriptionSettings(ApplicationConst.GroupName, Order = 100)]
public partial class XzTeachroomService : IDynamicApiController, ITransient
{
    private readonly SqlSugarRepository<XzTeachroom> _xzTeachroomRep;
    private readonly ISqlSugarClient _sqlSugarClient;

    public XzTeachroomService(SqlSugarRepository<XzTeachroom> xzTeachroomRep, ISqlSugarClient sqlSugarClient)
    {
        _xzTeachroomRep = xzTeachroomRep;
        _sqlSugarClient = sqlSugarClient;
    }

    /// <summary>
    /// 分页查询导师直播间 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("分页查询导师直播间")]
    [ApiDescriptionSettings(Name = "Page"), HttpPost]
    public async Task<SqlSugarPagedList<XzTeachroomOutput>> Page(PageXzTeachroomInput input)
    {
        input.Keyword = input.Keyword?.Trim();
        var query = _xzTeachroomRep.AsQueryable()
            .WhereIF(!string.IsNullOrWhiteSpace(input.Keyword), u => u.img.Contains(input.Keyword) || u.title.Contains(input.Keyword) || u.tags.Contains(input.Keyword))
            .WhereIF(!string.IsNullOrWhiteSpace(input.img), u => u.img.Contains(input.img.Trim()))
            .WhereIF(!string.IsNullOrWhiteSpace(input.title), u => u.title.Contains(input.title.Trim()))
            .WhereIF(!string.IsNullOrWhiteSpace(input.tags), u => u.tags.Contains(input.tags.Trim()))
            .WhereIF(input.tid != null, u => u.tid == input.tid)
            .WhereIF(input.roomid != null, u => u.roomid == input.roomid)
            .WhereIF(input.istop != null, u => u.istop == input.istop)
            .WhereIF(input.ishot != null, u => u.ishot == input.ishot)
            .WhereIF(input.rtype != null, u => u.rtype == input.rtype)
            .WhereIF(input.rnum != null, u => u.rnum == input.rnum)
            .WhereIF(input.state != null, u => u.state == input.state)
            .WhereIF(input.overtimeRange?.Length == 2, u => u.overtime >= input.overtimeRange[0] && u.overtime <= input.overtimeRange[1])
            .WhereIF(input.livetime != null, u => u.livetime == input.livetime)
            .Select<XzTeachroomOutput>();
		return await query.OrderBuilder(input).ToPagedListAsync(input.Page, input.PageSize);
    }

    /// <summary>
    /// 获取导师直播间详情 ℹ️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("获取导师直播间详情")]
    [ApiDescriptionSettings(Name = "Detail"), HttpGet]
    public async Task<XzTeachroom> Detail([FromQuery] QueryByIdXzTeachroomInput input)
    {
        return await _xzTeachroomRep.GetFirstAsync(u => u.Id == input.Id);
    }

    /// <summary>
    /// 增加导师直播间 ➕
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("增加导师直播间")]
    [ApiDescriptionSettings(Name = "Add"), HttpPost]
    public async Task<long> Add(AddXzTeachroomInput input)
    {
        var entity = input.Adapt<XzTeachroom>();
        return await _xzTeachroomRep.InsertAsync(entity) ? entity.Id : 0;
    }

    /// <summary>
    /// 更新导师直播间 ✏️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("更新导师直播间")]
    [ApiDescriptionSettings(Name = "Update"), HttpPost]
    public async Task Update(UpdateXzTeachroomInput input)
    {
        var entity = input.Adapt<XzTeachroom>();
        await _xzTeachroomRep.AsUpdateable(entity)
        .ExecuteCommandAsync();
    }

    /// <summary>
    /// 删除导师直播间 ❌
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("删除导师直播间")]
    [ApiDescriptionSettings(Name = "Delete"), HttpPost]
    public async Task Delete(DeleteXzTeachroomInput input)
    {
        var entity = await _xzTeachroomRep.GetFirstAsync(u => u.Id == input.Id) ?? throw Oops.Oh(ErrorCodeEnum.D1002);
        //await _xzTeachroomRep.FakeDeleteAsync(entity);   //假删除
        await _xzTeachroomRep.DeleteAsync(entity);   //真删除
    }

    /// <summary>
    /// 批量删除导师直播间 ❌
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("批量删除导师直播间")]
    [ApiDescriptionSettings(Name = "BatchDelete"), HttpPost]
    public async Task<bool> BatchDelete([Required(ErrorMessage = "主键列表不能为空")]List<DeleteXzTeachroomInput> input)
    {
        var exp = Expressionable.Create<XzTeachroom>();
        foreach (var row in input) exp = exp.Or(it => it.Id == row.Id);
        var list = await _xzTeachroomRep.AsQueryable().Where(exp.ToExpression()).ToListAsync();
   
        //return await _xzTeachroomRep.FakeDeleteAsync(list);   //假删除
        return await _xzTeachroomRep.DeleteAsync(list);   //真删除
    }
    
    /// <summary>
    /// 导出导师直播间记录 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("导出导师直播间记录")]
    [ApiDescriptionSettings(Name = "Export"), HttpPost, NonUnify]
    public async Task<IActionResult> Export(PageXzTeachroomInput input)
    {
        var list = (await Page(input)).Items?.Adapt<List<ExportXzTeachroomOutput>>() ?? new();
        if (input.SelectKeyList?.Count > 0) list = list.Where(x => input.SelectKeyList.Contains(x.Id)).ToList();
        return ExcelHelper.ExportTemplate(list, "导师直播间导出记录");
    }
    
    /// <summary>
    /// 下载导师直播间数据导入模板 ⬇️
    /// </summary>
    /// <returns></returns>
    [DisplayName("下载导师直播间数据导入模板")]
    [ApiDescriptionSettings(Name = "Import"), HttpGet, NonUnify]
    public IActionResult DownloadTemplate()
    {
        return ExcelHelper.ExportTemplate(new List<ExportXzTeachroomOutput>(), "导师直播间导入模板");
    }
    
    private static readonly object _xzTeachroomImportLock = new object();
    /// <summary>
    /// 导入导师直播间记录 💾
    /// </summary>
    /// <returns></returns>
    [DisplayName("导入导师直播间记录")]
    [ApiDescriptionSettings(Name = "Import"), HttpPost, NonUnify, UnitOfWork]
    public IActionResult ImportData([Required] IFormFile file)
    {
        lock (_xzTeachroomImportLock)
        {
            var stream = ExcelHelper.ImportData<ImportXzTeachroomInput, XzTeachroom>(file, (list, markerErrorAction) =>
            {
                _sqlSugarClient.Utilities.PageEach(list, 2048, pageItems =>
                {
                    
                    // 校验并过滤必填基本类型为null的字段
                    var rows = pageItems.Where(x => {
                        if (!string.IsNullOrWhiteSpace(x.Error)) return false;
                        return true;
                    }).Adapt<List<XzTeachroom>>();
                    
                    var storageable = _xzTeachroomRep.Context.Storageable(rows)
                        .SplitError(it => it.Item.img?.Length > 200, "直播间图片长度不能超过200个字符")
                        .SplitError(it => it.Item.title?.Length > 100, "标题长度不能超过100个字符")
                        .SplitError(it => it.Item.tags?.Length > 100, "标签长度不能超过100个字符")
                        .SplitInsert(_=> true) // 没有设置唯一键代表插入所有数据
                        .ToStorage();
                    
                    storageable.AsInsertable.ExecuteCommand();// 不存在插入
                    storageable.AsUpdateable.UpdateColumns(it => new
                    {
                        it.tid,
                        it.roomid,
                        it.img,
                        it.istop,
                        it.ishot,
                        it.rtype,
                        it.title,
                        it.rnum,
                        it.state,
                        it.tags,
                        it.overtime,
                        it.livetime,
                    }).ExecuteCommand();// 存在更新
                    
                    // 标记错误信息
                    markerErrorAction.Invoke(storageable, pageItems, rows);
                });
            });
            
            return stream;
        }
    }
}
