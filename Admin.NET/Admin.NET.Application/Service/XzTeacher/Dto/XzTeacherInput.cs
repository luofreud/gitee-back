// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Admin.NET.Core;
using System.ComponentModel.DataAnnotations;
using Magicodes.ExporterAndImporter.Core;
using Magicodes.ExporterAndImporter.Excel;

namespace Admin.NET.Application;

/// <summary>
/// 星座咨询师基础输入参数
/// </summary>
public class XzTeacherBaseInput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    public virtual long? Id { get; set; }
    
    /// <summary>
    /// 姓名
    /// </summary>
    public virtual string? name { get; set; }
    
    /// <summary>
    /// 头像
    /// </summary>
    public virtual string? headimg { get; set; }
    
    /// <summary>
    /// 等级
    /// </summary>
    public virtual int? level { get; set; }
    
    /// <summary>
    /// 推广code
    /// </summary>
    public virtual string? tgcode { get; set; }
    
    /// <summary>
    /// 介绍
    /// </summary>
    public virtual string? introduction { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public virtual double? score { get; set; }
    
    /// <summary>
    /// 星钻
    /// </summary>
    public virtual double? xzmoney { get; set; }
    
    /// <summary>
    /// 从业年限
    /// </summary>
    public virtual int? year { get; set; }
    
    /// <summary>
    /// 标签
    /// </summary>
    public virtual string? tags { get; set; }
    
    /// <summary>
    /// 0：在线，1：离线
    /// </summary>
    public virtual int? livestate { get; set; }
    
    /// <summary>
    /// 0：正常，1：审核中
    /// </summary>
    public virtual int? state { get; set; }
    
    /// <summary>
    /// 电话
    /// </summary>
    public virtual string? phone { get; set; }
    
    /// <summary>
    /// 身份证照片
    /// </summary>
    public virtual string? card { get; set; }
    
    /// <summary>
    /// 银行卡照片
    /// </summary>
    public virtual string? bankcard { get; set; }
    
    /// <summary>
    /// 银行卡编号
    /// </summary>
    public virtual string? banknum { get; set; }
    
    /// <summary>
    /// 开户行
    /// </summary>
    public virtual string? bankname { get; set; }
    
    /// <summary>
    /// 开户行名称
    /// </summary>
    public virtual string? bankaddress { get; set; }
    
    /// <summary>
    /// 越大越靠前
    /// </summary>
    public virtual int? sortcode { get; set; }
    
    /// <summary>
    /// 0：不推荐，1：推荐
    /// </summary>
    public virtual int? istop { get; set; }
    
    /// <summary>
    /// 入住时间，审核成功修改时间
    /// </summary>
    public virtual DateTime? checktime { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public virtual DateTime? createtime { get; set; }
    
}

/// <summary>
/// 星座咨询师分页查询输入参数
/// </summary>
public class PageXzTeacherInput : BasePageInput
{
    /// <summary>
    /// 姓名
    /// </summary>
    public string? name { get; set; }
    
    /// <summary>
    /// 头像
    /// </summary>
    public string? headimg { get; set; }
    
    /// <summary>
    /// 等级
    /// </summary>
    public int? level { get; set; }
    
    /// <summary>
    /// 推广code
    /// </summary>
    public string? tgcode { get; set; }
    
    /// <summary>
    /// 介绍
    /// </summary>
    public string? introduction { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public double? score { get; set; }
    
    /// <summary>
    /// 星钻
    /// </summary>
    public double? xzmoney { get; set; }
    
    /// <summary>
    /// 从业年限
    /// </summary>
    public int? year { get; set; }
    
    /// <summary>
    /// 标签
    /// </summary>
    public string? tags { get; set; }
    
    /// <summary>
    /// 0：在线，1：离线
    /// </summary>
    public int? livestate { get; set; }
    
    /// <summary>
    /// 0：正常，1：审核中
    /// </summary>
    public int? state { get; set; }
    
    /// <summary>
    /// 电话
    /// </summary>
    public string? phone { get; set; }
    
    /// <summary>
    /// 身份证照片
    /// </summary>
    public string? card { get; set; }
    
    /// <summary>
    /// 银行卡照片
    /// </summary>
    public string? bankcard { get; set; }
    
    /// <summary>
    /// 银行卡编号
    /// </summary>
    public string? banknum { get; set; }
    
    /// <summary>
    /// 开户行
    /// </summary>
    public string? bankname { get; set; }
    
    /// <summary>
    /// 开户行名称
    /// </summary>
    public string? bankaddress { get; set; }
    
    /// <summary>
    /// 越大越靠前
    /// </summary>
    public int? sortcode { get; set; }
    
    /// <summary>
    /// 0：不推荐，1：推荐
    /// </summary>
    public int? istop { get; set; }
    
    /// <summary>
    /// 入住时间，审核成功修改时间范围
    /// </summary>
     public DateTime?[] checktimeRange { get; set; }
    
    /// <summary>
    /// 范围
    /// </summary>
     public DateTime?[] createtimeRange { get; set; }
    
    /// <summary>
    /// 选中主键列表
    /// </summary>
     public List<long> SelectKeyList { get; set; }
}

/// <summary>
/// 星座咨询师增加输入参数
/// </summary>
public class AddXzTeacherInput
{
    /// <summary>
    /// 姓名
    /// </summary>
    [MaxLength(20, ErrorMessage = "姓名字符长度不能超过20")]
    public string? name { get; set; }
    
    /// <summary>
    /// 头像
    /// </summary>
    [MaxLength(100, ErrorMessage = "头像字符长度不能超过100")]
    public string? headimg { get; set; }
    
    /// <summary>
    /// 等级
    /// </summary>
    public int? level { get; set; }
    
    /// <summary>
    /// 推广code
    /// </summary>
    [MaxLength(100, ErrorMessage = "推广code字符长度不能超过100")]
    public string? tgcode { get; set; }
    
    /// <summary>
    /// 介绍
    /// </summary>
    [MaxLength(500, ErrorMessage = "介绍字符长度不能超过500")]
    public string? introduction { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public double? score { get; set; }
    
    /// <summary>
    /// 星钻
    /// </summary>
    public double? xzmoney { get; set; }
    
    /// <summary>
    /// 从业年限
    /// </summary>
    public int? year { get; set; }
    
    /// <summary>
    /// 标签
    /// </summary>
    [MaxLength(200, ErrorMessage = "标签字符长度不能超过200")]
    public string? tags { get; set; }
    
    /// <summary>
    /// 0：在线，1：离线
    /// </summary>
    public int? livestate { get; set; }
    
    /// <summary>
    /// 0：正常，1：审核中
    /// </summary>
    public int? state { get; set; }
    
    /// <summary>
    /// 电话
    /// </summary>
    [MaxLength(50, ErrorMessage = "电话字符长度不能超过50")]
    public string? phone { get; set; }
    
    /// <summary>
    /// 身份证照片
    /// </summary>
    [MaxLength(150, ErrorMessage = "身份证照片字符长度不能超过150")]
    public string? card { get; set; }
    
    /// <summary>
    /// 银行卡照片
    /// </summary>
    [MaxLength(50, ErrorMessage = "银行卡照片字符长度不能超过50")]
    public string? bankcard { get; set; }
    
    /// <summary>
    /// 银行卡编号
    /// </summary>
    [MaxLength(20, ErrorMessage = "银行卡编号字符长度不能超过20")]
    public string? banknum { get; set; }
    
    /// <summary>
    /// 开户行
    /// </summary>
    [MaxLength(50, ErrorMessage = "开户行字符长度不能超过50")]
    public string? bankname { get; set; }
    
    /// <summary>
    /// 开户行名称
    /// </summary>
    [MaxLength(150, ErrorMessage = "开户行名称字符长度不能超过150")]
    public string? bankaddress { get; set; }
    
    /// <summary>
    /// 越大越靠前
    /// </summary>
    public int? sortcode { get; set; }
    
    /// <summary>
    /// 0：不推荐，1：推荐
    /// </summary>
    public int? istop { get; set; }
    
    /// <summary>
    /// 入住时间，审核成功修改时间
    /// </summary>
    public DateTime? checktime { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public DateTime? createtime { get; set; }
    
}

/// <summary>
/// 星座咨询师删除输入参数
/// </summary>
public class DeleteXzTeacherInput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    [Required(ErrorMessage = "主键Id不能为空")]
    public int? Id { get; set; }
    
}

/// <summary>
/// 星座咨询师更新输入参数
/// </summary>
public class UpdateXzTeacherInput
{
    /// <summary>
    /// 主键Id
    /// </summary>    
    [Required(ErrorMessage = "主键Id不能为空")]
    public int? Id { get; set; }
    
    /// <summary>
    /// 姓名
    /// </summary>    
    [MaxLength(20, ErrorMessage = "姓名字符长度不能超过20")]
    public string? name { get; set; }
    
    /// <summary>
    /// 头像
    /// </summary>    
    [MaxLength(100, ErrorMessage = "头像字符长度不能超过100")]
    public string? headimg { get; set; }
    
    /// <summary>
    /// 等级
    /// </summary>    
    public int? level { get; set; }
    
    /// <summary>
    /// 推广code
    /// </summary>    
    [MaxLength(100, ErrorMessage = "推广code字符长度不能超过100")]
    public string? tgcode { get; set; }
    
    /// <summary>
    /// 介绍
    /// </summary>    
    [MaxLength(500, ErrorMessage = "介绍字符长度不能超过500")]
    public string? introduction { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    public double? score { get; set; }
    
    /// <summary>
    /// 星钻
    /// </summary>    
    public double? xzmoney { get; set; }
    
    /// <summary>
    /// 从业年限
    /// </summary>    
    public int? year { get; set; }
    
    /// <summary>
    /// 标签
    /// </summary>    
    [MaxLength(200, ErrorMessage = "标签字符长度不能超过200")]
    public string? tags { get; set; }
    
    /// <summary>
    /// 0：在线，1：离线
    /// </summary>    
    public int? livestate { get; set; }
    
    /// <summary>
    /// 0：正常，1：审核中
    /// </summary>    
    public int? state { get; set; }
    
    /// <summary>
    /// 电话
    /// </summary>    
    [MaxLength(50, ErrorMessage = "电话字符长度不能超过50")]
    public string? phone { get; set; }
    
    /// <summary>
    /// 身份证照片
    /// </summary>    
    [MaxLength(150, ErrorMessage = "身份证照片字符长度不能超过150")]
    public string? card { get; set; }
    
    /// <summary>
    /// 银行卡照片
    /// </summary>    
    [MaxLength(50, ErrorMessage = "银行卡照片字符长度不能超过50")]
    public string? bankcard { get; set; }
    
    /// <summary>
    /// 银行卡编号
    /// </summary>    
    [MaxLength(20, ErrorMessage = "银行卡编号字符长度不能超过20")]
    public string? banknum { get; set; }
    
    /// <summary>
    /// 开户行
    /// </summary>    
    [MaxLength(50, ErrorMessage = "开户行字符长度不能超过50")]
    public string? bankname { get; set; }
    
    /// <summary>
    /// 开户行名称
    /// </summary>    
    [MaxLength(150, ErrorMessage = "开户行名称字符长度不能超过150")]
    public string? bankaddress { get; set; }
    
    /// <summary>
    /// 越大越靠前
    /// </summary>    
    public int? sortcode { get; set; }
    
    /// <summary>
    /// 0：不推荐，1：推荐
    /// </summary>    
    public int? istop { get; set; }
    
    /// <summary>
    /// 入住时间，审核成功修改时间
    /// </summary>    
    public DateTime? checktime { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    public DateTime? createtime { get; set; }
    
}

/// <summary>
/// 星座咨询师主键查询输入参数
/// </summary>
public class QueryByIdXzTeacherInput : DeleteXzTeacherInput
{
}

/// <summary>
/// 星座咨询师数据导入实体
/// </summary>
[ExcelImporter(SheetIndex = 1, IsOnlyErrorRows = true)]
public class ImportXzTeacherInput : BaseImportInput
{
    /// <summary>
    /// 姓名
    /// </summary>
    [ImporterHeader(Name = "姓名")]
    [ExporterHeader("姓名", Format = "", Width = 25, IsBold = true)]
    public string? name { get; set; }
    
    /// <summary>
    /// 头像
    /// </summary>
    [ImporterHeader(Name = "头像")]
    [ExporterHeader("头像", Format = "", Width = 25, IsBold = true)]
    public string? headimg { get; set; }
    
    /// <summary>
    /// 等级
    /// </summary>
    [ImporterHeader(Name = "等级")]
    [ExporterHeader("等级", Format = "", Width = 25, IsBold = true)]
    public int? level { get; set; }
    
    /// <summary>
    /// 推广code
    /// </summary>
    [ImporterHeader(Name = "推广code")]
    [ExporterHeader("推广code", Format = "", Width = 25, IsBold = true)]
    public string? tgcode { get; set; }
    
    /// <summary>
    /// 介绍
    /// </summary>
    [ImporterHeader(Name = "介绍")]
    [ExporterHeader("介绍", Format = "", Width = 25, IsBold = true)]
    public string? introduction { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public double? score { get; set; }
    
    /// <summary>
    /// 星钻
    /// </summary>
    [ImporterHeader(Name = "星钻")]
    [ExporterHeader("星钻", Format = "", Width = 25, IsBold = true)]
    public double? xzmoney { get; set; }
    
    /// <summary>
    /// 从业年限
    /// </summary>
    [ImporterHeader(Name = "从业年限")]
    [ExporterHeader("从业年限", Format = "", Width = 25, IsBold = true)]
    public int? year { get; set; }
    
    /// <summary>
    /// 标签
    /// </summary>
    [ImporterHeader(Name = "标签")]
    [ExporterHeader("标签", Format = "", Width = 25, IsBold = true)]
    public string? tags { get; set; }
    
    /// <summary>
    /// 0：在线，1：离线
    /// </summary>
    [ImporterHeader(Name = "0：在线，1：离线")]
    [ExporterHeader("0：在线，1：离线", Format = "", Width = 25, IsBold = true)]
    public int? livestate { get; set; }
    
    /// <summary>
    /// 0：正常，1：审核中
    /// </summary>
    [ImporterHeader(Name = "0：正常，1：审核中")]
    [ExporterHeader("0：正常，1：审核中", Format = "", Width = 25, IsBold = true)]
    public int? state { get; set; }
    
    /// <summary>
    /// 电话
    /// </summary>
    [ImporterHeader(Name = "电话")]
    [ExporterHeader("电话", Format = "", Width = 25, IsBold = true)]
    public string? phone { get; set; }
    
    /// <summary>
    /// 身份证照片
    /// </summary>
    [ImporterHeader(Name = "身份证照片")]
    [ExporterHeader("身份证照片", Format = "", Width = 25, IsBold = true)]
    public string? card { get; set; }
    
    /// <summary>
    /// 银行卡照片
    /// </summary>
    [ImporterHeader(Name = "银行卡照片")]
    [ExporterHeader("银行卡照片", Format = "", Width = 25, IsBold = true)]
    public string? bankcard { get; set; }
    
    /// <summary>
    /// 银行卡编号
    /// </summary>
    [ImporterHeader(Name = "银行卡编号")]
    [ExporterHeader("银行卡编号", Format = "", Width = 25, IsBold = true)]
    public string? banknum { get; set; }
    
    /// <summary>
    /// 开户行
    /// </summary>
    [ImporterHeader(Name = "开户行")]
    [ExporterHeader("开户行", Format = "", Width = 25, IsBold = true)]
    public string? bankname { get; set; }
    
    /// <summary>
    /// 开户行名称
    /// </summary>
    [ImporterHeader(Name = "开户行名称")]
    [ExporterHeader("开户行名称", Format = "", Width = 25, IsBold = true)]
    public string? bankaddress { get; set; }
    
    /// <summary>
    /// 越大越靠前
    /// </summary>
    [ImporterHeader(Name = "越大越靠前")]
    [ExporterHeader("越大越靠前", Format = "", Width = 25, IsBold = true)]
    public int? sortcode { get; set; }
    
    /// <summary>
    /// 0：不推荐，1：推荐
    /// </summary>
    [ImporterHeader(Name = "0：不推荐，1：推荐")]
    [ExporterHeader("0：不推荐，1：推荐", Format = "", Width = 25, IsBold = true)]
    public int? istop { get; set; }
    
    /// <summary>
    /// 入住时间，审核成功修改时间
    /// </summary>
    [ImporterHeader(Name = "入住时间，审核成功修改时间")]
    [ExporterHeader("入住时间，审核成功修改时间", Format = "", Width = 25, IsBold = true)]
    public DateTime? checktime { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public DateTime? createtime { get; set; }
    
}
