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
/// 用户信息基础输入参数
/// </summary>
public class XzUserBaseInput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    public virtual long? Id { get; set; }
    
    /// <summary>
    /// 昵称
    /// </summary>
    public virtual string? nickname { get; set; }
    
    /// <summary>
    /// 电话
    /// </summary>
    public virtual string? phone { get; set; }
    
    /// <summary>
    /// openid
    /// </summary>
    public virtual string? openid { get; set; }
    
    /// <summary>
    /// 0:男，1:女
    /// </summary>
    public virtual int? sex { get; set; }
    
    /// <summary>
    /// 等级1-5
    /// </summary>
    public virtual int? level { get; set; }
    
    /// <summary>
    /// 出生地址
    /// </summary>
    public virtual string? address { get; set; }
    
    /// <summary>
    /// 头像
    /// </summary>
    public virtual string? headimg { get; set; }
    
    /// <summary>
    /// 现居地址
    /// </summary>
    public virtual string? nowaddress { get; set; }
    
    /// <summary>
    /// 星币
    /// </summary>
    public virtual int? xbmoney { get; set; }
    
    /// <summary>
    /// 星钻 1-1
    /// </summary>
    public virtual double? xzmoney { get; set; }
    
    /// <summary>
    /// 连麦时长（剩余）
    /// </summary>
    public virtual int? lmtime { get; set; }
    
    /// <summary>
    /// 是否首充
    /// </summary>
    public virtual int? iscz { get; set; }
    
    /// <summary>
    /// 签名限定20个字
    /// </summary>
    public virtual string? sign { get; set; }
    
    /// <summary>
    /// 0：正常，1：异常
    /// </summary>
    public virtual int? state { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public virtual string? tgcode { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public virtual DateTime? createtime { get; set; }
    /// <summary>
    /// 出生日期
    /// </summary>
    public virtual DateTime? birthday { get; set; }

}

/// <summary>
/// 用户信息分页查询输入参数
/// </summary>
public class PageXzUserInput : BasePageInput
{
    /// <summary>
    /// 昵称
    /// </summary>
    public string? nickname { get; set; }
    
    /// <summary>
    /// 电话
    /// </summary>
    public string? phone { get; set; }
    
    /// <summary>
    /// openid
    /// </summary>
    public string? openid { get; set; }
    
    /// <summary>
    /// 0:男，1:女
    /// </summary>
    public int? sex { get; set; }
    
    /// <summary>
    /// 等级1-5
    /// </summary>
    public int? level { get; set; }
    
    /// <summary>
    /// 出生地址
    /// </summary>
    public string? address { get; set; }
    
    /// <summary>
    /// 头像
    /// </summary>
    public string? headimg { get; set; }
    
    /// <summary>
    /// 现居地址
    /// </summary>
    public string? nowaddress { get; set; }
    
    /// <summary>
    /// 星币
    /// </summary>
    public int? xbmoney { get; set; }
    
    /// <summary>
    /// 星钻 1-1
    /// </summary>
    public double? xzmoney { get; set; }
    
    /// <summary>
    /// 连麦时长（剩余）
    /// </summary>
    public int? lmtime { get; set; }
    
    /// <summary>
    /// 是否首充
    /// </summary>
    public int? iscz { get; set; }
    
    /// <summary>
    /// 签名限定20个字
    /// </summary>
    public string? sign { get; set; }
    
    /// <summary>
    /// 0：正常，1：异常
    /// </summary>
    public int? state { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public string? tgcode { get; set; }
    
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
/// 用户信息增加输入参数
/// </summary>
public class AddXzUserInput
{
    /// <summary>
    /// 昵称
    /// </summary>
    [MaxLength(50, ErrorMessage = "昵称字符长度不能超过50")]
    public string? nickname { get; set; }
    
    /// <summary>
    /// 电话
    /// </summary>
    [MaxLength(20, ErrorMessage = "电话字符长度不能超过20")]
    public string? phone { get; set; }
    
    /// <summary>
    /// openid
    /// </summary>
    [MaxLength(40, ErrorMessage = "openid字符长度不能超过40")]
    public string? openid { get; set; }
    
    /// <summary>
    /// 0:男，1:女
    /// </summary>
    public int? sex { get; set; }
    
    /// <summary>
    /// 等级1-5
    /// </summary>
    public int? level { get; set; }
    
    /// <summary>
    /// 出生地址
    /// </summary>
    [MaxLength(100, ErrorMessage = "出生地址字符长度不能超过100")]
    public string? address { get; set; }
    
    /// <summary>
    /// 头像
    /// </summary>
    [MaxLength(100, ErrorMessage = "头像字符长度不能超过100")]
    public string? headimg { get; set; }
    
    /// <summary>
    /// 现居地址
    /// </summary>
    [MaxLength(100, ErrorMessage = "现居地址字符长度不能超过100")]
    public string? nowaddress { get; set; }
    
    /// <summary>
    /// 星币
    /// </summary>
    public int? xbmoney { get; set; }
    
    /// <summary>
    /// 星钻 1-1
    /// </summary>
    public double? xzmoney { get; set; }
    
    /// <summary>
    /// 连麦时长（剩余）
    /// </summary>
    public int? lmtime { get; set; }
    
    /// <summary>
    /// 是否首充
    /// </summary>
    public int? iscz { get; set; }
    
    /// <summary>
    /// 签名限定20个字
    /// </summary>
    [MaxLength(100, ErrorMessage = "签名限定20个字字符长度不能超过100")]
    public string? sign { get; set; }
    
    /// <summary>
    /// 0：正常，1：异常
    /// </summary>
    public int? state { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [MaxLength(50, ErrorMessage = "字符长度不能超过50")]
    public string? tgcode { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public DateTime? createtime { get; set; }
    
}

/// <summary>
/// 用户信息删除输入参数
/// </summary>
public class DeleteXzUserInput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    [Required(ErrorMessage = "主键Id不能为空")]
    public long? Id { get; set; }
    
}

/// <summary>
/// 用户信息更新输入参数
/// </summary>
public class UpdateXzUserInput
{
    /// <summary>
    /// 主键Id
    /// </summary>    
    [Required(ErrorMessage = "主键Id不能为空")]
    public long? Id { get; set; }
    
    /// <summary>
    /// 昵称
    /// </summary>    
    [MaxLength(50, ErrorMessage = "昵称字符长度不能超过50")]
    public string? nickname { get; set; }
    
    /// <summary>
    /// 电话
    /// </summary>    
    [MaxLength(20, ErrorMessage = "电话字符长度不能超过20")]
    public string? phone { get; set; }
    
    /// <summary>
    /// openid
    /// </summary>    
    [MaxLength(40, ErrorMessage = "openid字符长度不能超过40")]
    public string? openid { get; set; }
    
    /// <summary>
    /// 0:男，1:女
    /// </summary>    
    public int? sex { get; set; }
    
    /// <summary>
    /// 等级1-5
    /// </summary>    
    public int? level { get; set; }
    
    /// <summary>
    /// 出生地址
    /// </summary>    
    [MaxLength(100, ErrorMessage = "出生地址字符长度不能超过100")]
    public string? address { get; set; }
    
    /// <summary>
    /// 头像
    /// </summary>    
    [MaxLength(100, ErrorMessage = "头像字符长度不能超过100")]
    public string? headimg { get; set; }
    
    /// <summary>
    /// 现居地址
    /// </summary>    
    [MaxLength(100, ErrorMessage = "现居地址字符长度不能超过100")]
    public string? nowaddress { get; set; }
    
    /// <summary>
    /// 星币
    /// </summary>    
    public int? xbmoney { get; set; }
    
    /// <summary>
    /// 星钻 1-1
    /// </summary>    
    public double? xzmoney { get; set; }
    
    /// <summary>
    /// 连麦时长（剩余）
    /// </summary>    
    public int? lmtime { get; set; }
    
    /// <summary>
    /// 是否首充
    /// </summary>    
    public int? iscz { get; set; }
    
    /// <summary>
    /// 签名限定20个字
    /// </summary>    
    [MaxLength(100, ErrorMessage = "签名限定20个字字符长度不能超过100")]
    public string? sign { get; set; }
    
    /// <summary>
    /// 0：正常，1：异常
    /// </summary>    
    public int? state { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    [MaxLength(50, ErrorMessage = "字符长度不能超过50")]
    public string? tgcode { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    public DateTime? createtime { get; set; }
    
}

/// <summary>
/// 用户信息主键查询输入参数
/// </summary>
public class QueryByIdXzUserInput : DeleteXzUserInput
{
}

/// <summary>
/// 用户信息数据导入实体
/// </summary>
[ExcelImporter(SheetIndex = 1, IsOnlyErrorRows = true)]
public class ImportXzUserInput : BaseImportInput
{
    /// <summary>
    /// 昵称
    /// </summary>
    [ImporterHeader(Name = "昵称")]
    [ExporterHeader("昵称", Format = "", Width = 25, IsBold = true)]
    public string? nickname { get; set; }
    
    /// <summary>
    /// 电话
    /// </summary>
    [ImporterHeader(Name = "电话")]
    [ExporterHeader("电话", Format = "", Width = 25, IsBold = true)]
    public string? phone { get; set; }
    
    /// <summary>
    /// openid
    /// </summary>
    [ImporterHeader(Name = "openid")]
    [ExporterHeader("openid", Format = "", Width = 25, IsBold = true)]
    public string? openid { get; set; }
    
    /// <summary>
    /// 0:男，1:女
    /// </summary>
    [ImporterHeader(Name = "0:男，1:女")]
    [ExporterHeader("0:男，1:女", Format = "", Width = 25, IsBold = true)]
    public int? sex { get; set; }
    
    /// <summary>
    /// 等级1-5
    /// </summary>
    [ImporterHeader(Name = "等级1-5")]
    [ExporterHeader("等级1-5", Format = "", Width = 25, IsBold = true)]
    public int? level { get; set; }
    
    /// <summary>
    /// 出生地址
    /// </summary>
    [ImporterHeader(Name = "出生地址")]
    [ExporterHeader("出生地址", Format = "", Width = 25, IsBold = true)]
    public string? address { get; set; }
    
    /// <summary>
    /// 头像
    /// </summary>
    [ImporterHeader(Name = "头像")]
    [ExporterHeader("头像", Format = "", Width = 25, IsBold = true)]
    public string? headimg { get; set; }
    
    /// <summary>
    /// 现居地址
    /// </summary>
    [ImporterHeader(Name = "现居地址")]
    [ExporterHeader("现居地址", Format = "", Width = 25, IsBold = true)]
    public string? nowaddress { get; set; }
    
    /// <summary>
    /// 星币
    /// </summary>
    [ImporterHeader(Name = "星币")]
    [ExporterHeader("星币", Format = "", Width = 25, IsBold = true)]
    public int? xbmoney { get; set; }
    
    /// <summary>
    /// 星钻 1-1
    /// </summary>
    [ImporterHeader(Name = "星钻 1-1")]
    [ExporterHeader("星钻 1-1", Format = "", Width = 25, IsBold = true)]
    public double? xzmoney { get; set; }
    
    /// <summary>
    /// 连麦时长（剩余）
    /// </summary>
    [ImporterHeader(Name = "连麦时长（剩余）")]
    [ExporterHeader("连麦时长（剩余）", Format = "", Width = 25, IsBold = true)]
    public int? lmtime { get; set; }
    
    /// <summary>
    /// 是否首充
    /// </summary>
    [ImporterHeader(Name = "是否首充")]
    [ExporterHeader("是否首充", Format = "", Width = 25, IsBold = true)]
    public int? iscz { get; set; }
    
    /// <summary>
    /// 签名限定20个字
    /// </summary>
    [ImporterHeader(Name = "签名限定20个字")]
    [ExporterHeader("签名限定20个字", Format = "", Width = 25, IsBold = true)]
    public string? sign { get; set; }
    
    /// <summary>
    /// 0：正常，1：异常
    /// </summary>
    [ImporterHeader(Name = "0：正常，1：异常")]
    [ExporterHeader("0：正常，1：异常", Format = "", Width = 25, IsBold = true)]
    public int? state { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public string? tgcode { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public DateTime? createtime { get; set; }
    
}
