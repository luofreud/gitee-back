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
/// 系统优惠券服务 🧩
/// </summary>
[ApiDescriptionSettings(ApplicationConst.GroupName, Order = 100)]
public partial class XzCouponService : IDynamicApiController, ITransient
{
    private readonly SqlSugarRepository<XzCoupon> _xzCouponRep;
    private readonly ISqlSugarClient _sqlSugarClient;

    public XzCouponService(SqlSugarRepository<XzCoupon> xzCouponRep, ISqlSugarClient sqlSugarClient)
    {
        _xzCouponRep = xzCouponRep;
        _sqlSugarClient = sqlSugarClient;
    }

    /// <summary>
    /// 分页查询系统优惠券 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("分页查询系统优惠券")]
    [ApiDescriptionSettings(Name = "Page"), HttpPost]
    public async Task<SqlSugarPagedList<XzCouponOutput>> Page(PageXzCouponInput input)
    {
        input.Keyword = input.Keyword?.Trim();
        var query = _xzCouponRep.AsQueryable()
            .WhereIF(!string.IsNullOrWhiteSpace(input.Keyword), u => u.name.Contains(input.Keyword))
            .WhereIF(!string.IsNullOrWhiteSpace(input.name), u => u.name.Contains(input.name.Trim()))
            .WhereIF(input.ctype != null, u => u.ctype == input.ctype)
            .WhereIF(input.stimeRange?.Length == 2, u => u.stime >= input.stimeRange[0] && u.stime <= input.stimeRange[1])
            .WhereIF(input.etimeRange?.Length == 2, u => u.etime >= input.etimeRange[0] && u.etime <= input.etimeRange[1])
            .WhereIF(input.isdel != null, u => u.isdel == input.isdel)
            .WhereIF(input.count != null, u => u.count == input.count)
            .WhereIF(input.lqcount != null, u => u.lqcount == input.lqcount)
            .WhereIF(input.createtimeRange?.Length == 2, u => u.createtime >= input.createtimeRange[0] && u.createtime <= input.createtimeRange[1])
            .Select<XzCouponOutput>();
		return await query.OrderBuilder(input).ToPagedListAsync(input.Page, input.PageSize);
    }

    /// <summary>
    /// 获取系统优惠券详情 ℹ️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("获取系统优惠券详情")]
    [ApiDescriptionSettings(Name = "Detail"), HttpGet]
    public async Task<XzCoupon> Detail([FromQuery] QueryByIdXzCouponInput input)
    {
        return await _xzCouponRep.GetFirstAsync(u => u.Id == input.Id);
    }

    /// <summary>
    /// 增加系统优惠券 ➕
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("增加系统优惠券")]
    [ApiDescriptionSettings(Name = "Add"), HttpPost]
    public async Task<long> Add(AddXzCouponInput input)
    {
        var entity = input.Adapt<XzCoupon>();
        return await _xzCouponRep.InsertAsync(entity) ? entity.Id : 0;
    }

    /// <summary>
    /// 更新系统优惠券 ✏️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("更新系统优惠券")]
    [ApiDescriptionSettings(Name = "Update"), HttpPost]
    public async Task Update(UpdateXzCouponInput input)
    {
        var entity = input.Adapt<XzCoupon>();
        await _xzCouponRep.AsUpdateable(entity)
        .ExecuteCommandAsync();
    }

    /// <summary>
    /// 删除系统优惠券 ❌
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("删除系统优惠券")]
    [ApiDescriptionSettings(Name = "Delete"), HttpPost]
    public async Task Delete(DeleteXzCouponInput input)
    {
        var entity = await _xzCouponRep.GetFirstAsync(u => u.Id == input.Id) ?? throw Oops.Oh(ErrorCodeEnum.D1002);
        //await _xzCouponRep.FakeDeleteAsync(entity);   //假删除
        await _xzCouponRep.DeleteAsync(entity);   //真删除
    }

    /// <summary>
    /// 批量删除系统优惠券 ❌
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("批量删除系统优惠券")]
    [ApiDescriptionSettings(Name = "BatchDelete"), HttpPost]
    public async Task<bool> BatchDelete([Required(ErrorMessage = "主键列表不能为空")]List<DeleteXzCouponInput> input)
    {
        var exp = Expressionable.Create<XzCoupon>();
        foreach (var row in input) exp = exp.Or(it => it.Id == row.Id);
        var list = await _xzCouponRep.AsQueryable().Where(exp.ToExpression()).ToListAsync();
   
        //return await _xzCouponRep.FakeDeleteAsync(list);   //假删除
        return await _xzCouponRep.DeleteAsync(list);   //真删除
    }
    
    /// <summary>
    /// 导出系统优惠券记录 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("导出系统优惠券记录")]
    [ApiDescriptionSettings(Name = "Export"), HttpPost, NonUnify]
    public async Task<IActionResult> Export(PageXzCouponInput input)
    {
        var list = (await Page(input)).Items?.Adapt<List<ExportXzCouponOutput>>() ?? new();
        if (input.SelectKeyList?.Count > 0) list = list.Where(x => input.SelectKeyList.Contains(x.Id)).ToList();
        return ExcelHelper.ExportTemplate(list, "系统优惠券导出记录");
    }
    
    /// <summary>
    /// 下载系统优惠券数据导入模板 ⬇️
    /// </summary>
    /// <returns></returns>
    [DisplayName("下载系统优惠券数据导入模板")]
    [ApiDescriptionSettings(Name = "Import"), HttpGet, NonUnify]
    public IActionResult DownloadTemplate()
    {
        return ExcelHelper.ExportTemplate(new List<ExportXzCouponOutput>(), "系统优惠券导入模板");
    }
    
    private static readonly object _xzCouponImportLock = new object();
    /// <summary>
    /// 导入系统优惠券记录 💾
    /// </summary>
    /// <returns></returns>
    [DisplayName("导入系统优惠券记录")]
    [ApiDescriptionSettings(Name = "Import"), HttpPost, NonUnify, UnitOfWork]
    public IActionResult ImportData([Required] IFormFile file)
    {
        lock (_xzCouponImportLock)
        {
            var stream = ExcelHelper.ImportData<ImportXzCouponInput, XzCoupon>(file, (list, markerErrorAction) =>
            {
                _sqlSugarClient.Utilities.PageEach(list, 2048, pageItems =>
                {
                    
                    // 校验并过滤必填基本类型为null的字段
                    var rows = pageItems.Where(x => {
                        if (!string.IsNullOrWhiteSpace(x.Error)) return false;
                        return true;
                    }).Adapt<List<XzCoupon>>();
                    
                    var storageable = _xzCouponRep.Context.Storageable(rows)
                        .SplitError(it => it.Item.name?.Length > 50, "长度不能超过50个字符")
                        .SplitInsert(_=> true) // 没有设置唯一键代表插入所有数据
                        .ToStorage();
                    
                    storageable.AsInsertable.ExecuteCommand();// 不存在插入
                    storageable.AsUpdateable.UpdateColumns(it => new
                    {
                        it.ctype,
                        it.stime,
                        it.etime,
                        it.name,
                        it.isdel,
                        it.count,
                        it.lqcount,
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
