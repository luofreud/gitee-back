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
/// 系统优惠券基础输入参数
/// </summary>
public class XzCouponBaseInput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    public virtual long? Id { get; set; }
    
    /// <summary>
    /// 0：商品优惠券，1：星币优惠券，2：商品兑换券，3：充值折扣券
    /// </summary>
    public virtual int? ctype { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public virtual DateTime? stime { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public virtual DateTime? etime { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public virtual string? name { get; set; }
    
    /// <summary>
    /// 0：正常，1：删除
    /// </summary>
    public virtual int? isdel { get; set; }
    
    /// <summary>
    /// -1：无限制
    /// </summary>
    public virtual int? count { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public virtual int? lqcount { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public virtual DateTime? createtime { get; set; }
    
}

/// <summary>
/// 系统优惠券分页查询输入参数
/// </summary>
public class PageXzCouponInput : BasePageInput
{
    /// <summary>
    /// 0：商品优惠券，1：星币优惠券，2：商品兑换券，3：充值折扣券
    /// </summary>
    public int? ctype { get; set; }
    
    /// <summary>
    /// 范围
    /// </summary>
     public DateTime?[] stimeRange { get; set; }
    
    /// <summary>
    /// 范围
    /// </summary>
     public DateTime?[] etimeRange { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public string? name { get; set; }
    
    /// <summary>
    /// 0：正常，1：删除
    /// </summary>
    public int? isdel { get; set; }
    
    /// <summary>
    /// -1：无限制
    /// </summary>
    public int? count { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public int? lqcount { get; set; }
    
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
/// 系统优惠券增加输入参数
/// </summary>
public class AddXzCouponInput
{
    /// <summary>
    /// 0：商品优惠券，1：星币优惠券，2：商品兑换券，3：充值折扣券
    /// </summary>
    public int? ctype { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public DateTime? stime { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public DateTime? etime { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [MaxLength(50, ErrorMessage = "字符长度不能超过50")]
    public string? name { get; set; }
    
    /// <summary>
    /// 0：正常，1：删除
    /// </summary>
    public int? isdel { get; set; }
    
    /// <summary>
    /// -1：无限制
    /// </summary>
    public int? count { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public int? lqcount { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public DateTime? createtime { get; set; }
    
}

/// <summary>
/// 系统优惠券删除输入参数
/// </summary>
public class DeleteXzCouponInput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    [Required(ErrorMessage = "主键Id不能为空")]
    public long? Id { get; set; }
    
}

/// <summary>
/// 系统优惠券更新输入参数
/// </summary>
public class UpdateXzCouponInput
{
    /// <summary>
    /// 主键Id
    /// </summary>    
    [Required(ErrorMessage = "主键Id不能为空")]
    public long? Id { get; set; }
    
    /// <summary>
    /// 0：商品优惠券，1：星币优惠券，2：商品兑换券，3：充值折扣券
    /// </summary>    
    public int? ctype { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    public DateTime? stime { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    public DateTime? etime { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    [MaxLength(50, ErrorMessage = "字符长度不能超过50")]
    public string? name { get; set; }
    
    /// <summary>
    /// 0：正常，1：删除
    /// </summary>    
    public int? isdel { get; set; }
    
    /// <summary>
    /// -1：无限制
    /// </summary>    
    public int? count { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    public int? lqcount { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    public DateTime? createtime { get; set; }
    
}

/// <summary>
/// 系统优惠券主键查询输入参数
/// </summary>
public class QueryByIdXzCouponInput : DeleteXzCouponInput
{
}

/// <summary>
/// 系统优惠券数据导入实体
/// </summary>
[ExcelImporter(SheetIndex = 1, IsOnlyErrorRows = true)]
public class ImportXzCouponInput : BaseImportInput
{
    /// <summary>
    /// 0：商品优惠券，1：星币优惠券，2：商品兑换券，3：充值折扣券
    /// </summary>
    [ImporterHeader(Name = "0：商品优惠券，1：星币优惠券，2：商品兑换券，3：充值折扣券")]
    [ExporterHeader("0：商品优惠券，1：星币优惠券，2：商品兑换券，3：充值折扣券", Format = "", Width = 25, IsBold = true)]
    public int? ctype { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public DateTime? stime { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public DateTime? etime { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public string? name { get; set; }
    
    /// <summary>
    /// 0：正常，1：删除
    /// </summary>
    [ImporterHeader(Name = "0：正常，1：删除")]
    [ExporterHeader("0：正常，1：删除", Format = "", Width = 25, IsBold = true)]
    public int? isdel { get; set; }
    
    /// <summary>
    /// -1：无限制
    /// </summary>
    [ImporterHeader(Name = "-1：无限制")]
    [ExporterHeader("-1：无限制", Format = "", Width = 25, IsBold = true)]
    public int? count { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public int? lqcount { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public DateTime? createtime { get; set; }
    
}
