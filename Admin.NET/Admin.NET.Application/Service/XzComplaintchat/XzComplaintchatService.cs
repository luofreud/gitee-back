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
/// 用户投诉聊天记录服务 🧩
/// </summary>
[ApiDescriptionSettings(ApplicationConst.GroupName, Order = 100)]
public partial class XzComplaintchatService : IDynamicApiController, ITransient
{
    private readonly SqlSugarRepository<XzComplaintchat> _xzComplaintchatRep;
    private readonly ISqlSugarClient _sqlSugarClient;

    public XzComplaintchatService(SqlSugarRepository<XzComplaintchat> xzComplaintchatRep, ISqlSugarClient sqlSugarClient)
    {
        _xzComplaintchatRep = xzComplaintchatRep;
        _sqlSugarClient = sqlSugarClient;
    }

    /// <summary>
    /// 分页查询用户投诉聊天记录 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("分页查询用户投诉聊天记录")]
    [ApiDescriptionSettings(Name = "Page"), HttpPost]
    public async Task<SqlSugarPagedList<XzComplaintchatOutput>> Page(PageXzComplaintchatInput input)
    {
        input.Keyword = input.Keyword?.Trim();
        var query = _xzComplaintchatRep.AsQueryable()
            .WhereIF(!string.IsNullOrWhiteSpace(input.Keyword), u => u.content.Contains(input.Keyword))
            .WhereIF(!string.IsNullOrWhiteSpace(input.content), u => u.content.Contains(input.content.Trim()))
            .WhereIF(input.cid != null, u => u.cid == input.cid)
            .WhereIF(input.uid != null, u => u.uid == input.uid)
            .WhereIF(input.direction != null, u => u.direction == input.direction)
            .WhereIF(input.createtimeRange?.Length == 2, u => u.createtime >= input.createtimeRange[0] && u.createtime <= input.createtimeRange[1])
            .Select<XzComplaintchatOutput>();
		return await query.OrderBuilder(input).ToPagedListAsync(input.Page, input.PageSize);
    }

    /// <summary>
    /// 获取用户投诉聊天记录详情 ℹ️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("获取用户投诉聊天记录详情")]
    [ApiDescriptionSettings(Name = "Detail"), HttpGet]
    public async Task<XzComplaintchat> Detail([FromQuery] QueryByIdXzComplaintchatInput input)
    {
        return await _xzComplaintchatRep.GetFirstAsync(u => u.Id == input.Id);
    }

    /// <summary>
    /// 增加用户投诉聊天记录 ➕
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("增加用户投诉聊天记录")]
    [ApiDescriptionSettings(Name = "Add"), HttpPost]
    public async Task<long> Add(AddXzComplaintchatInput input)
    {
        var entity = input.Adapt<XzComplaintchat>();
        return await _xzComplaintchatRep.InsertAsync(entity) ? entity.Id : 0;
    }

    /// <summary>
    /// 更新用户投诉聊天记录 ✏️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("更新用户投诉聊天记录")]
    [ApiDescriptionSettings(Name = "Update"), HttpPost]
    public async Task Update(UpdateXzComplaintchatInput input)
    {
        var entity = input.Adapt<XzComplaintchat>();
        await _xzComplaintchatRep.AsUpdateable(entity)
        .ExecuteCommandAsync();
    }

    /// <summary>
    /// 删除用户投诉聊天记录 ❌
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("删除用户投诉聊天记录")]
    [ApiDescriptionSettings(Name = "Delete"), HttpPost]
    public async Task Delete(DeleteXzComplaintchatInput input)
    {
        var entity = await _xzComplaintchatRep.GetFirstAsync(u => u.Id == input.Id) ?? throw Oops.Oh(ErrorCodeEnum.D1002);
        //await _xzComplaintchatRep.FakeDeleteAsync(entity);   //假删除
        await _xzComplaintchatRep.DeleteAsync(entity);   //真删除
    }

    /// <summary>
    /// 批量删除用户投诉聊天记录 ❌
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("批量删除用户投诉聊天记录")]
    [ApiDescriptionSettings(Name = "BatchDelete"), HttpPost]
    public async Task<bool> BatchDelete([Required(ErrorMessage = "主键列表不能为空")]List<DeleteXzComplaintchatInput> input)
    {
        var exp = Expressionable.Create<XzComplaintchat>();
        foreach (var row in input) exp = exp.Or(it => it.Id == row.Id);
        var list = await _xzComplaintchatRep.AsQueryable().Where(exp.ToExpression()).ToListAsync();
   
        //return await _xzComplaintchatRep.FakeDeleteAsync(list);   //假删除
        return await _xzComplaintchatRep.DeleteAsync(list);   //真删除
    }
    
    /// <summary>
    /// 导出用户投诉聊天记录记录 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("导出用户投诉聊天记录记录")]
    [ApiDescriptionSettings(Name = "Export"), HttpPost, NonUnify]
    public async Task<IActionResult> Export(PageXzComplaintchatInput input)
    {
        var list = (await Page(input)).Items?.Adapt<List<ExportXzComplaintchatOutput>>() ?? new();
        if (input.SelectKeyList?.Count > 0) list = list.Where(x => input.SelectKeyList.Contains(x.Id)).ToList();
        return ExcelHelper.ExportTemplate(list, "用户投诉聊天记录导出记录");
    }
    
    /// <summary>
    /// 下载用户投诉聊天记录数据导入模板 ⬇️
    /// </summary>
    /// <returns></returns>
    [DisplayName("下载用户投诉聊天记录数据导入模板")]
    [ApiDescriptionSettings(Name = "Import"), HttpGet, NonUnify]
    public IActionResult DownloadTemplate()
    {
        return ExcelHelper.ExportTemplate(new List<ExportXzComplaintchatOutput>(), "用户投诉聊天记录导入模板");
    }
    
    private static readonly object _xzComplaintchatImportLock = new object();
    /// <summary>
    /// 导入用户投诉聊天记录记录 💾
    /// </summary>
    /// <returns></returns>
    [DisplayName("导入用户投诉聊天记录记录")]
    [ApiDescriptionSettings(Name = "Import"), HttpPost, NonUnify, UnitOfWork]
    public IActionResult ImportData([Required] IFormFile file)
    {
        lock (_xzComplaintchatImportLock)
        {
            var stream = ExcelHelper.ImportData<ImportXzComplaintchatInput, XzComplaintchat>(file, (list, markerErrorAction) =>
            {
                _sqlSugarClient.Utilities.PageEach(list, 2048, pageItems =>
                {
                    
                    // 校验并过滤必填基本类型为null的字段
                    var rows = pageItems.Where(x => {
                        if (!string.IsNullOrWhiteSpace(x.Error)) return false;
                        return true;
                    }).Adapt<List<XzComplaintchat>>();
                    
                    var storageable = _xzComplaintchatRep.Context.Storageable(rows)
                        .SplitInsert(_=> true) // 没有设置唯一键代表插入所有数据
                        .ToStorage();
                    
                    storageable.AsInsertable.ExecuteCommand();// 不存在插入
                    storageable.AsUpdateable.UpdateColumns(it => new
                    {
                        it.cid,
                        it.uid,
                        it.direction,
                        it.content,
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
