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
/// 星座咨询师服务 🧩
/// </summary>
[ApiDescriptionSettings(ApplicationConst.GroupName, Order = 100)]
public partial class XzTeacherService : IDynamicApiController, ITransient
{
    private readonly SqlSugarRepository<XzTeacher> _xzTeacherRep;
    private readonly ISqlSugarClient _sqlSugarClient;

    public XzTeacherService(SqlSugarRepository<XzTeacher> xzTeacherRep, ISqlSugarClient sqlSugarClient)
    {
        _xzTeacherRep = xzTeacherRep;
        _sqlSugarClient = sqlSugarClient;
    }

    /// <summary>
    /// 分页查询星座咨询师 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("分页查询星座咨询师")]
    [ApiDescriptionSettings(Name = "Page"), HttpPost]
    public async Task<SqlSugarPagedList<XzTeacherOutput>> Page(PageXzTeacherInput input)
    {
        input.Keyword = input.Keyword?.Trim();
        var query = _xzTeacherRep.AsQueryable()
            .WhereIF(!string.IsNullOrWhiteSpace(input.Keyword), u => u.name.Contains(input.Keyword) || u.headimg.Contains(input.Keyword) || u.tgcode.Contains(input.Keyword) || u.introduction.Contains(input.Keyword) || u.tags.Contains(input.Keyword) || u.phone.Contains(input.Keyword) || u.card.Contains(input.Keyword) || u.bankcard.Contains(input.Keyword) || u.banknum.Contains(input.Keyword) || u.bankname.Contains(input.Keyword) || u.bankaddress.Contains(input.Keyword))
            .WhereIF(!string.IsNullOrWhiteSpace(input.name), u => u.name.Contains(input.name.Trim()))
            .WhereIF(!string.IsNullOrWhiteSpace(input.headimg), u => u.headimg.Contains(input.headimg.Trim()))
            .WhereIF(!string.IsNullOrWhiteSpace(input.tgcode), u => u.tgcode.Contains(input.tgcode.Trim()))
            .WhereIF(!string.IsNullOrWhiteSpace(input.introduction), u => u.introduction.Contains(input.introduction.Trim()))
            .WhereIF(!string.IsNullOrWhiteSpace(input.tags), u => u.tags.Contains(input.tags.Trim()))
            .WhereIF(!string.IsNullOrWhiteSpace(input.phone), u => u.phone.Contains(input.phone.Trim()))
            .WhereIF(!string.IsNullOrWhiteSpace(input.card), u => u.card.Contains(input.card.Trim()))
            .WhereIF(!string.IsNullOrWhiteSpace(input.bankcard), u => u.bankcard.Contains(input.bankcard.Trim()))
            .WhereIF(!string.IsNullOrWhiteSpace(input.banknum), u => u.banknum.Contains(input.banknum.Trim()))
            .WhereIF(!string.IsNullOrWhiteSpace(input.bankname), u => u.bankname.Contains(input.bankname.Trim()))
            .WhereIF(!string.IsNullOrWhiteSpace(input.bankaddress), u => u.bankaddress.Contains(input.bankaddress.Trim()))
            .WhereIF(input.level != null, u => u.level == input.level)
            .WhereIF(input.year != null, u => u.year == input.year)
            .WhereIF(input.livestate != null, u => u.livestate == input.livestate)
            .WhereIF(input.state != null, u => u.state == input.state)
            .WhereIF(input.sortcode != null, u => u.sortcode == input.sortcode)
            .WhereIF(input.istop != null, u => u.istop == input.istop)
            .WhereIF(input.checktimeRange?.Length == 2, u => u.checktime >= input.checktimeRange[0] && u.checktime <= input.checktimeRange[1])
            .WhereIF(input.createtimeRange?.Length == 2, u => u.createtime >= input.createtimeRange[0] && u.createtime <= input.createtimeRange[1])
            .Select<XzTeacherOutput>();
		return await query.OrderBuilder(input).ToPagedListAsync(input.Page, input.PageSize);
    }

    /// <summary>
    /// 获取星座咨询师详情 ℹ️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("获取星座咨询师详情")]
    [ApiDescriptionSettings(Name = "Detail"), HttpGet]
    public async Task<XzTeacher> Detail([FromQuery] QueryByIdXzTeacherInput input)
    {
        return await _xzTeacherRep.GetFirstAsync(u => u.Id == input.Id);
    }

    /// <summary>
    /// 增加星座咨询师 ➕
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("增加星座咨询师")]
    [ApiDescriptionSettings(Name = "Add"), HttpPost]
    public async Task<long> Add(AddXzTeacherInput input)
    {
        var entity = input.Adapt<XzTeacher>();
        return await _xzTeacherRep.InsertAsync(entity) ? entity.Id : 0;
    }

    /// <summary>
    /// 更新星座咨询师 ✏️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("更新星座咨询师")]
    [ApiDescriptionSettings(Name = "Update"), HttpPost]
    public async Task Update(UpdateXzTeacherInput input)
    {
        var entity = input.Adapt<XzTeacher>();
        await _xzTeacherRep.AsUpdateable(entity)
        .ExecuteCommandAsync();
    }

    /// <summary>
    /// 删除星座咨询师 ❌
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("删除星座咨询师")]
    [ApiDescriptionSettings(Name = "Delete"), HttpPost]
    public async Task Delete(DeleteXzTeacherInput input)
    {
        var entity = await _xzTeacherRep.GetFirstAsync(u => u.Id == input.Id) ?? throw Oops.Oh(ErrorCodeEnum.D1002);
        //await _xzTeacherRep.FakeDeleteAsync(entity);   //假删除
        await _xzTeacherRep.DeleteAsync(entity);   //真删除
    }

    /// <summary>
    /// 批量删除星座咨询师 ❌
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("批量删除星座咨询师")]
    [ApiDescriptionSettings(Name = "BatchDelete"), HttpPost]
    public async Task<bool> BatchDelete([Required(ErrorMessage = "主键列表不能为空")]List<DeleteXzTeacherInput> input)
    {
        var exp = Expressionable.Create<XzTeacher>();
        foreach (var row in input) exp = exp.Or(it => it.Id == row.Id);
        var list = await _xzTeacherRep.AsQueryable().Where(exp.ToExpression()).ToListAsync();
   
        //return await _xzTeacherRep.FakeDeleteAsync(list);   //假删除
        return await _xzTeacherRep.DeleteAsync(list);   //真删除
    }
    
    /// <summary>
    /// 导出星座咨询师记录 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("导出星座咨询师记录")]
    [ApiDescriptionSettings(Name = "Export"), HttpPost, NonUnify]
    public async Task<IActionResult> Export(PageXzTeacherInput input)
    {
        var list = (await Page(input)).Items?.Adapt<List<ExportXzTeacherOutput>>() ?? new();
        if (input.SelectKeyList?.Count > 0) list = list.Where(x => input.SelectKeyList.Contains(x.Id)).ToList();
        return ExcelHelper.ExportTemplate(list, "星座咨询师导出记录");
    }
    
    /// <summary>
    /// 下载星座咨询师数据导入模板 ⬇️
    /// </summary>
    /// <returns></returns>
    [DisplayName("下载星座咨询师数据导入模板")]
    [ApiDescriptionSettings(Name = "Import"), HttpGet, NonUnify]
    public IActionResult DownloadTemplate()
    {
        return ExcelHelper.ExportTemplate(new List<ExportXzTeacherOutput>(), "星座咨询师导入模板");
    }
    
    private static readonly object _xzTeacherImportLock = new object();
    /// <summary>
    /// 导入星座咨询师记录 💾
    /// </summary>
    /// <returns></returns>
    [DisplayName("导入星座咨询师记录")]
    [ApiDescriptionSettings(Name = "Import"), HttpPost, NonUnify, UnitOfWork]
    public IActionResult ImportData([Required] IFormFile file)
    {
        lock (_xzTeacherImportLock)
        {
            var stream = ExcelHelper.ImportData<ImportXzTeacherInput, XzTeacher>(file, (list, markerErrorAction) =>
            {
                _sqlSugarClient.Utilities.PageEach(list, 2048, pageItems =>
                {
                    
                    // 校验并过滤必填基本类型为null的字段
                    var rows = pageItems.Where(x => {
                        if (!string.IsNullOrWhiteSpace(x.Error)) return false;
                        return true;
                    }).Adapt<List<XzTeacher>>();
                    
                    var storageable = _xzTeacherRep.Context.Storageable(rows)
                        .SplitError(it => it.Item.name?.Length > 20, "姓名长度不能超过20个字符")
                        .SplitError(it => it.Item.headimg?.Length > 100, "头像长度不能超过100个字符")
                        .SplitError(it => it.Item.tgcode?.Length > 100, "推广code长度不能超过100个字符")
                        .SplitError(it => it.Item.introduction?.Length > 500, "介绍长度不能超过500个字符")
                        .SplitError(it => it.Item.tags?.Length > 200, "标签长度不能超过200个字符")
                        .SplitError(it => it.Item.phone?.Length > 50, "电话长度不能超过50个字符")
                        .SplitError(it => it.Item.card?.Length > 150, "身份证照片长度不能超过150个字符")
                        .SplitError(it => it.Item.bankcard?.Length > 50, "银行卡照片长度不能超过50个字符")
                        .SplitError(it => it.Item.banknum?.Length > 20, "银行卡编号长度不能超过20个字符")
                        .SplitError(it => it.Item.bankname?.Length > 50, "开户行长度不能超过50个字符")
                        .SplitError(it => it.Item.bankaddress?.Length > 150, "开户行名称长度不能超过150个字符")
                        .SplitInsert(_=> true) // 没有设置唯一键代表插入所有数据
                        .ToStorage();
                    
                    storageable.AsInsertable.ExecuteCommand();// 不存在插入
                    storageable.AsUpdateable.UpdateColumns(it => new
                    {
                        it.name,
                        it.headimg,
                        it.level,
                        it.tgcode,
                        it.introduction,
                        it.score,
                        it.xzmoney,
                        it.year,
                        it.tags,
                        it.livestate,
                        it.state,
                        it.phone,
                        it.card,
                        it.bankcard,
                        it.banknum,
                        it.bankname,
                        it.bankaddress,
                        it.sortcode,
                        it.istop,
                        it.checktime,
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
