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
/// 用户信息服务 🧩
/// </summary>
[ApiDescriptionSettings(ApplicationConst.GroupName, Order = 100)]
public partial class XzUserService : IDynamicApiController, ITransient
{
    private readonly SqlSugarRepository<XzUser> _xzUserRep;
    private readonly ISqlSugarClient _sqlSugarClient;

    public XzUserService(SqlSugarRepository<XzUser> xzUserRep, ISqlSugarClient sqlSugarClient )
    {
        _xzUserRep = xzUserRep;
        _sqlSugarClient = sqlSugarClient;

    }

    /// <summary>
    /// 分页查询用户信息 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("分页查询用户信息")]
    [ApiDescriptionSettings(Name = "Page"), HttpPost]
    public async Task<SqlSugarPagedList<XzUserOutput>> Page(PageXzUserInput input)
    {
        input.Keyword = input.Keyword?.Trim();
        var query = _xzUserRep.AsQueryable()
            .WhereIF(!string.IsNullOrWhiteSpace(input.Keyword), u => u.nickname.Contains(input.Keyword) || u.phone.Contains(input.Keyword) || u.openid.Contains(input.Keyword) || u.address.Contains(input.Keyword) || u.headimg.Contains(input.Keyword) || u.nowaddress.Contains(input.Keyword) || u.sign.Contains(input.Keyword) || u.tgcode.Contains(input.Keyword))
            .WhereIF(!string.IsNullOrWhiteSpace(input.nickname), u => u.nickname.Contains(input.nickname.Trim()))
            .WhereIF(!string.IsNullOrWhiteSpace(input.phone), u => u.phone.Contains(input.phone.Trim()))
            .WhereIF(!string.IsNullOrWhiteSpace(input.openid), u => u.openid.Contains(input.openid.Trim()))
            .WhereIF(!string.IsNullOrWhiteSpace(input.address), u => u.address.Contains(input.address.Trim()))
            .WhereIF(!string.IsNullOrWhiteSpace(input.headimg), u => u.headimg.Contains(input.headimg.Trim()))
            .WhereIF(!string.IsNullOrWhiteSpace(input.nowaddress), u => u.nowaddress.Contains(input.nowaddress.Trim()))
            .WhereIF(!string.IsNullOrWhiteSpace(input.sign), u => u.sign.Contains(input.sign.Trim()))
            .WhereIF(!string.IsNullOrWhiteSpace(input.tgcode), u => u.tgcode.Contains(input.tgcode.Trim()))
            .WhereIF(input.sex != null, u => u.sex == input.sex)
            .WhereIF(input.level != null, u => u.level == input.level)
            .WhereIF(input.xbmoney != null, u => u.xbmoney == input.xbmoney)
            .WhereIF(input.xzmoney != null, u => u.xzmoney == input.xzmoney)
            .WhereIF(input.lmtime != null, u => u.lmtime == input.lmtime)
            .WhereIF(input.iscz != null, u => u.iscz == input.iscz)
            .WhereIF(input.state != null, u => u.state == input.state)
            .WhereIF(input.createtimeRange?.Length == 2, u => u.createtime >= input.createtimeRange[0] && u.createtime <= input.createtimeRange[1])
            .Select<XzUserOutput>();
		return await query.OrderBuilder(input).ToPagedListAsync(input.Page, input.PageSize);
    }

    /// <summary>
    /// 获取用户信息详情 ℹ️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("获取用户信息详情")]
    [ApiDescriptionSettings(Name = "Detail"), HttpGet]
    public async Task<XzUser> Detail([FromQuery] QueryByIdXzUserInput input)
    {
        return await _xzUserRep.GetFirstAsync(u => u.Id == input.Id);
    }

    /// <summary>
    /// 增加用户信息 ➕
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("增加用户信息")]
    [ApiDescriptionSettings(Name = "Add"), HttpPost]
    public async Task<long> Add(AddXzUserInput input)
    {
        var entity = input.Adapt<XzUser>();
        return await _xzUserRep.InsertAsync(entity) ? entity.Id : 0;
    }

    /// <summary>
    /// 更新用户信息 ✏️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("更新用户信息")]
    [ApiDescriptionSettings(Name = "Update"), HttpPost]
    public async Task Update(UpdateXzUserInput input)
    {
        var entity = input.Adapt<XzUser>();
        await _xzUserRep.AsUpdateable(entity)
        .ExecuteCommandAsync();
    }

    /// <summary>
    /// 删除用户信息 ❌
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("删除用户信息")]
    [ApiDescriptionSettings(Name = "Delete"), HttpPost]
    public async Task Delete(DeleteXzUserInput input)
    {
        var entity = await _xzUserRep.GetFirstAsync(u => u.Id == input.Id) ?? throw Oops.Oh(ErrorCodeEnum.D1002);
       // await _xzUserRep.FakeDeleteAsync(entity);   //假删除
        await _xzUserRep.DeleteAsync(entity);   //真删除
    }

    ///// <summary>
    ///// 批量删除用户信息 ❌
    ///// </summary>
    ///// <param name="input"></param>
    ///// <returns></returns>
    //[DisplayName("批量删除用户信息")]
    //[ApiDescriptionSettings(Name = "BatchDelete"), HttpPost]
    //public async Task<int> BatchDelete([Required(ErrorMessage = "主键列表不能为空")]List<DeleteXzUserInput> input)
    //{
    //    var exp = Expressionable.Create<XzUser>();
    //    foreach (var row in input) exp = exp.Or(it => it.Id == row.Id);
    //    var list = await _xzUserRep.AsQueryable().Where(exp.ToExpression()).ToListAsync();
   
    //    //return await _xzUserRep.FakeDeleteAsync(list);   //假删除
    //    return await _xzUserRep.DeleteAsync(list);   //真删除
    //}
    
    /// <summary>
    /// 导出用户信息记录 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("导出用户信息记录")]
    [ApiDescriptionSettings(Name = "Export"), HttpPost, NonUnify]
    public async Task<IActionResult> Export(PageXzUserInput input)
    {
        var list = (await Page(input)).Items?.Adapt<List<ExportXzUserOutput>>() ?? new();
        if (input.SelectKeyList?.Count > 0) list = list.Where(x => input.SelectKeyList.Contains(x.Id)).ToList();
        return ExcelHelper.ExportTemplate(list, "用户信息导出记录");
    }
    
    /// <summary>
    /// 下载用户信息数据导入模板 ⬇️
    /// </summary>
    /// <returns></returns>
    [DisplayName("下载用户信息数据导入模板")]
    [ApiDescriptionSettings(Name = "Import"), HttpGet, NonUnify]
    public IActionResult DownloadTemplate()
    {
        return ExcelHelper.ExportTemplate(new List<ExportXzUserOutput>(), "用户信息导入模板");
    }
    
    private static readonly object _xzUserImportLock = new object();
    /// <summary>
    /// 导入用户信息记录 💾
    /// </summary>
    /// <returns></returns>
    [DisplayName("导入用户信息记录")]
    [ApiDescriptionSettings(Name = "Import"), HttpPost, NonUnify, UnitOfWork]
    public IActionResult ImportData([Required] IFormFile file)
    {
        lock (_xzUserImportLock)
        {
            var stream = ExcelHelper.ImportData<ImportXzUserInput, XzUser>(file, (list, markerErrorAction) =>
            {
                _sqlSugarClient.Utilities.PageEach(list, 2048, pageItems =>
                {
                    
                    // 校验并过滤必填基本类型为null的字段
                    var rows = pageItems.Where(x => {
                        if (!string.IsNullOrWhiteSpace(x.Error)) return false;
                        return true;
                    }).Adapt<List<XzUser>>();
                    
                    var storageable = _xzUserRep.Context.Storageable(rows)
                        .SplitError(it => it.Item.nickname?.Length > 50, "昵称长度不能超过50个字符")
                        .SplitError(it => it.Item.phone?.Length > 20, "电话长度不能超过20个字符")
                        .SplitError(it => it.Item.openid?.Length > 40, "openid长度不能超过40个字符")
                        .SplitError(it => it.Item.address?.Length > 100, "出生地址长度不能超过100个字符")
                        .SplitError(it => it.Item.headimg?.Length > 100, "头像长度不能超过100个字符")
                        .SplitError(it => it.Item.nowaddress?.Length > 100, "现居地址长度不能超过100个字符")
                        .SplitError(it => it.Item.sign?.Length > 100, "签名限定20个字长度不能超过100个字符")
                        .SplitError(it => it.Item.tgcode?.Length > 50, "长度不能超过50个字符")
                        .SplitInsert(_=> true) // 没有设置唯一键代表插入所有数据
                        .ToStorage();
                    
                    storageable.AsInsertable.ExecuteCommand();// 不存在插入
                    storageable.AsUpdateable.UpdateColumns(it => new
                    {
                        it.nickname,
                        it.phone,
                        it.openid,
                        it.sex,
                        it.level,
                        it.address,
                        it.headimg,
                        it.nowaddress,
                        it.xbmoney,
                        it.xzmoney,
                        it.lmtime,
                        it.iscz,
                        it.sign,
                        it.state,
                        it.tgcode,
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
