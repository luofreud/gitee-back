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
/// 用户投诉记录表服务 🧩
/// </summary>
[ApiDescriptionSettings(ApplicationConst.GroupName, Order = 100)]
public partial class XzComplaintlogService : IDynamicApiController, ITransient
{
    private readonly SqlSugarRepository<XzComplaintlog> _xzComplaintlogRep;
    private readonly ISqlSugarClient _sqlSugarClient;

    public XzComplaintlogService(SqlSugarRepository<XzComplaintlog> xzComplaintlogRep, ISqlSugarClient sqlSugarClient)
    {
        _xzComplaintlogRep = xzComplaintlogRep;
        _sqlSugarClient = sqlSugarClient;
    }

    /// <summary>
    /// 分页查询用户投诉记录表 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("分页查询用户投诉记录表")]
    [ApiDescriptionSettings(Name = "Page"), HttpPost]
    public async Task<SqlSugarPagedList<XzComplaintlogOutput>> Page(PageXzComplaintlogInput input)
    {
        input.Keyword = input.Keyword?.Trim();
        var query = _xzComplaintlogRep.AsQueryable()
            .WhereIF(!string.IsNullOrWhiteSpace(input.Keyword), u => u.cnum.Contains(input.Keyword) || u.content.Contains(input.Keyword) || u.imgs.Contains(input.Keyword))
            .WhereIF(!string.IsNullOrWhiteSpace(input.cnum), u => u.cnum.Contains(input.cnum.Trim()))
            .WhereIF(!string.IsNullOrWhiteSpace(input.content), u => u.content.Contains(input.content.Trim()))
            .WhereIF(!string.IsNullOrWhiteSpace(input.imgs), u => u.imgs.Contains(input.imgs.Trim()))
            .WhereIF(input.uid != null, u => u.uid == input.uid)
            .WhereIF(input.ctype != null, u => u.ctype == input.ctype)
            .WhereIF(input.relevanceid != null, u => u.relevanceid == input.relevanceid)
            .WhereIF(input.overtimeRange?.Length == 2, u => u.overtime >= input.overtimeRange[0] && u.overtime <= input.overtimeRange[1])
            .WhereIF(input.cstate != null, u => u.cstate == input.cstate)
            .WhereIF(input.createtimeRange?.Length == 2, u => u.createtime >= input.createtimeRange[0] && u.createtime <= input.createtimeRange[1])
            .Select<XzComplaintlogOutput>();
		return await query.OrderBuilder(input).ToPagedListAsync(input.Page, input.PageSize);
    }

    /// <summary>
    /// 获取用户投诉记录表详情 ℹ️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("获取用户投诉记录表详情")]
    [ApiDescriptionSettings(Name = "Detail"), HttpGet]
    public async Task<XzComplaintlog> Detail([FromQuery] QueryByIdXzComplaintlogInput input)
    {
        return await _xzComplaintlogRep.GetFirstAsync(u => u.Id == input.Id);
    }

    /// <summary>
    /// 增加用户投诉记录表 ➕
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("增加用户投诉记录表")]
    [ApiDescriptionSettings(Name = "Add"), HttpPost]
    public async Task<long> Add(AddXzComplaintlogInput input)
    {
        var entity = input.Adapt<XzComplaintlog>();
        return await _xzComplaintlogRep.InsertAsync(entity) ? entity.Id : 0;
    }

    /// <summary>
    /// 更新用户投诉记录表 ✏️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("更新用户投诉记录表")]
    [ApiDescriptionSettings(Name = "Update"), HttpPost]
    public async Task Update(UpdateXzComplaintlogInput input)
    {
        var entity = input.Adapt<XzComplaintlog>();
        await _xzComplaintlogRep.AsUpdateable(entity)
        .ExecuteCommandAsync();
    }

    /// <summary>
    /// 删除用户投诉记录表 ❌
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("删除用户投诉记录表")]
    [ApiDescriptionSettings(Name = "Delete"), HttpPost]
    public async Task Delete(DeleteXzComplaintlogInput input)
    {
        var entity = await _xzComplaintlogRep.GetFirstAsync(u => u.Id == input.Id) ?? throw Oops.Oh(ErrorCodeEnum.D1002);
        //await _xzComplaintlogRep.FakeDeleteAsync(entity);   //假删除
        await _xzComplaintlogRep.DeleteAsync(entity);   //真删除
    }

    /// <summary>
    /// 批量删除用户投诉记录表 ❌
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("批量删除用户投诉记录表")]
    [ApiDescriptionSettings(Name = "BatchDelete"), HttpPost]
    public async Task<bool> BatchDelete([Required(ErrorMessage = "主键列表不能为空")]List<DeleteXzComplaintlogInput> input)
    {
        var exp = Expressionable.Create<XzComplaintlog>();
        foreach (var row in input) exp = exp.Or(it => it.Id == row.Id);
        var list = await _xzComplaintlogRep.AsQueryable().Where(exp.ToExpression()).ToListAsync();
   
        //return await _xzComplaintlogRep.FakeDeleteAsync(list);   //假删除
        return await _xzComplaintlogRep.DeleteAsync(list);   //真删除
    }
    
    /// <summary>
    /// 导出用户投诉记录表记录 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("导出用户投诉记录表记录")]
    [ApiDescriptionSettings(Name = "Export"), HttpPost, NonUnify]
    public async Task<IActionResult> Export(PageXzComplaintlogInput input)
    {
        var list = (await Page(input)).Items?.Adapt<List<ExportXzComplaintlogOutput>>() ?? new();
        if (input.SelectKeyList?.Count > 0) list = list.Where(x => input.SelectKeyList.Contains(x.Id)).ToList();
        return ExcelHelper.ExportTemplate(list, "用户投诉记录表导出记录");
    }
    
    /// <summary>
    /// 下载用户投诉记录表数据导入模板 ⬇️
    /// </summary>
    /// <returns></returns>
    [DisplayName("下载用户投诉记录表数据导入模板")]
    [ApiDescriptionSettings(Name = "Import"), HttpGet, NonUnify]
    public IActionResult DownloadTemplate()
    {
        return ExcelHelper.ExportTemplate(new List<ExportXzComplaintlogOutput>(), "用户投诉记录表导入模板");
    }
    
    private static readonly object _xzComplaintlogImportLock = new object();
    /// <summary>
    /// 导入用户投诉记录表记录 💾
    /// </summary>
    /// <returns></returns>
    [DisplayName("导入用户投诉记录表记录")]
    [ApiDescriptionSettings(Name = "Import"), HttpPost, NonUnify, UnitOfWork]
    public IActionResult ImportData([Required] IFormFile file)
    {
        lock (_xzComplaintlogImportLock)
        {
            var stream = ExcelHelper.ImportData<ImportXzComplaintlogInput, XzComplaintlog>(file, (list, markerErrorAction) =>
            {
                _sqlSugarClient.Utilities.PageEach(list, 2048, pageItems =>
                {
                    
                    // 校验并过滤必填基本类型为null的字段
                    var rows = pageItems.Where(x => {
                        if (!string.IsNullOrWhiteSpace(x.Error)) return false;
                        return true;
                    }).Adapt<List<XzComplaintlog>>();
                    
                    var storageable = _xzComplaintlogRep.Context.Storageable(rows)
                        .SplitError(it => it.Item.cnum?.Length > 20, "长度不能超过20个字符")
                        .SplitInsert(_=> true) // 没有设置唯一键代表插入所有数据
                        .ToStorage();
                    
                    storageable.AsInsertable.ExecuteCommand();// 不存在插入
                    storageable.AsUpdateable.UpdateColumns(it => new
                    {
                        it.uid,
                        it.cnum,
                        it.ctype,
                        it.relevanceid,
                        it.overtime,
                        it.cstate,
                        it.content,
                        it.imgs,
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
