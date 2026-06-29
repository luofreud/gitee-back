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
/// 用户签到服务 🧩
/// </summary>
[ApiDescriptionSettings(ApplicationConst.GroupName, Order = 100)]
public partial class XzCheckService : IDynamicApiController, ITransient
{
    private readonly SqlSugarRepository<XzCheck> _xzCheckRep;
    private readonly ISqlSugarClient _sqlSugarClient;

    public XzCheckService(SqlSugarRepository<XzCheck> xzCheckRep, ISqlSugarClient sqlSugarClient, AppUserManager userManager, SqlSugarRepository<XzUser> xzUserRep)
    {
        _xzCheckRep = xzCheckRep;
        _sqlSugarClient = sqlSugarClient;
    }

    /// <summary>
    /// 分页查询用户签到 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("分页查询用户签到")]
    [ApiDescriptionSettings(Name = "Page"), HttpPost]
    public async Task<SqlSugarPagedList<XzCheckOutput>> Page(PageXzCheckInput input)
    {
        input.Keyword = input.Keyword?.Trim();
        var query = _xzCheckRep.AsQueryable()
            .WhereIF(input.uid != null, u => u.uid == input.uid)
            .WhereIF(input.qdtimeRange?.Length == 2, u => u.qdtime >= input.qdtimeRange[0] && u.qdtime <= input.qdtimeRange[1])
            .WhereIF(input.createtimeRange?.Length == 2, u => u.createtime >= input.createtimeRange[0] && u.createtime <= input.createtimeRange[1])
            .Select<XzCheckOutput>();
		return await query.OrderBuilder(input).ToPagedListAsync(input.Page, input.PageSize);
    }

    /// <summary>
    /// 获取用户签到详情 ℹ️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("获取用户签到详情")]
    [ApiDescriptionSettings(Name = "Detail"), HttpGet]
    public async Task<XzCheck> Detail([FromQuery] QueryByIdXzCheckInput input)
    {
        return await _xzCheckRep.GetFirstAsync(u => u.Id == input.Id);
    }

    /// <summary>
    /// 增加用户签到 ➕
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("增加用户签到")]
    [ApiDescriptionSettings(Name = "Add"), HttpPost]
    public async Task<long> Add(AddXzCheckInput input)
    {
        var entity = input.Adapt<XzCheck>();
        return await _xzCheckRep.InsertAsync(entity) ? entity.Id : 0;
    }

    /// <summary>
    /// 更新用户签到 ✏️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("更新用户签到")]
    [ApiDescriptionSettings(Name = "Update"), HttpPost]
    public async Task Update(UpdateXzCheckInput input)
    {
        var entity = input.Adapt<XzCheck>();
        await _xzCheckRep.AsUpdateable(entity)
        .ExecuteCommandAsync();
    }

    /// <summary>
    /// 删除用户签到 ❌
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("删除用户签到")]
    [ApiDescriptionSettings(Name = "Delete"), HttpPost]
    public async Task Delete(DeleteXzCheckInput input)
    {
        var entity = await _xzCheckRep.GetFirstAsync(u => u.Id == input.Id) ?? throw Oops.Oh(ErrorCodeEnum.D1002);
       // await _xzCheckRep.FakeDeleteAsync(entity);   //假删除
        await _xzCheckRep.DeleteAsync(entity);   //真删除
    }

    /// <summary>
    /// 批量删除用户签到 ❌
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("批量删除用户签到")]
    [ApiDescriptionSettings(Name = "BatchDelete"), HttpPost]
    public async Task<bool> BatchDelete([Required(ErrorMessage = "主键列表不能为空")]List<DeleteXzCheckInput> input)
    {
        var exp = Expressionable.Create<XzCheck>();
        foreach (var row in input) exp = exp.Or(it => it.Id == row.Id);
        var list = await _xzCheckRep.AsQueryable().Where(exp.ToExpression()).ToListAsync();
   
        //return await _xzCheckRep.FakeDeleteAsync(list);   //假删除
        return await _xzCheckRep.DeleteAsync(list);   //真删除
    }
    
    /// <summary>
    /// 导出用户签到记录 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("导出用户签到记录")]
    [ApiDescriptionSettings(Name = "Export"), HttpPost, NonUnify]
    public async Task<IActionResult> Export(PageXzCheckInput input)
    {
        var list = (await Page(input)).Items?.Adapt<List<ExportXzCheckOutput>>() ?? new();
        if (input.SelectKeyList?.Count > 0) list = list.Where(x => input.SelectKeyList.Contains(x.Id)).ToList();
        return ExcelHelper.ExportTemplate(list, "用户签到导出记录");
    }
    
    /// <summary>
    /// 下载用户签到数据导入模板 ⬇️
    /// </summary>
    /// <returns></returns>
    [DisplayName("下载用户签到数据导入模板")]
    [ApiDescriptionSettings(Name = "Import"), HttpGet, NonUnify]
    public IActionResult DownloadTemplate()
    {
        return ExcelHelper.ExportTemplate(new List<ExportXzCheckOutput>(), "用户签到导入模板");
    }
    
    private static readonly object _xzCheckImportLock = new object();
    /// <summary>
    /// 导入用户签到记录 💾
    /// </summary>
    /// <returns></returns>
    [DisplayName("导入用户签到记录")]
    [ApiDescriptionSettings(Name = "Import"), HttpPost, NonUnify, UnitOfWork]
    public IActionResult ImportData([Required] IFormFile file)
    {
        lock (_xzCheckImportLock)
        {
            var stream = ExcelHelper.ImportData<ImportXzCheckInput, XzCheck>(file, (list, markerErrorAction) =>
            {
                _sqlSugarClient.Utilities.PageEach(list, 2048, pageItems =>
                {
                    
                    // 校验并过滤必填基本类型为null的字段
                    var rows = pageItems.Where(x => {
                        if (!string.IsNullOrWhiteSpace(x.Error)) return false;
                        return true;
                    }).Adapt<List<XzCheck>>();
                    
                    var storageable = _xzCheckRep.Context.Storageable(rows)
                        .SplitInsert(_=> true) // 没有设置唯一键代表插入所有数据
                        .ToStorage();
                    
                    storageable.AsInsertable.ExecuteCommand();// 不存在插入
                    storageable.AsUpdateable.UpdateColumns(it => new
                    {
                        it.uid,
                        it.qdtime,
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
