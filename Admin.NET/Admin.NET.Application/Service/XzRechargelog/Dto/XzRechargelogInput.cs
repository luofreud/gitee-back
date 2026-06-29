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
/// 充值记录基础输入参数
/// </summary>
public class XzRechargelogBaseInput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    public virtual long? Id { get; set; }
    
    /// <summary>
    /// 用户id
    /// </summary>
    public virtual long? uid { get; set; }
    
    /// <summary>
    /// 充值金额
    /// </summary>
    public virtual double? money { get; set; }
    
    /// <summary>
    /// 充值类型：1：微信，2：支付宝，3：系统赠送
    /// </summary>
    public virtual int? rechargetype { get; set; }
    
    /// <summary>
    /// 备注
    /// </summary>
    public virtual string? mark { get; set; }
    
    /// <summary>
    /// 充值时间
    /// </summary>
    public virtual DateTime? createtime { get; set; }
    
}

/// <summary>
/// 充值记录分页查询输入参数
/// </summary>
public class PageXzRechargelogInput : BasePageInput
{
    /// <summary>
    /// 用户id
    /// </summary>
    public long? uid { get; set; }
    
    /// <summary>
    /// 充值金额
    /// </summary>
    public double? money { get; set; }
    
    /// <summary>
    /// 充值类型：1：微信，2：支付宝，3：系统赠送
    /// </summary>
    public int? rechargetype { get; set; }
    
    /// <summary>
    /// 备注
    /// </summary>
    public string? mark { get; set; }
    
    /// <summary>
    /// 充值时间范围
    /// </summary>
     public DateTime?[] createtimeRange { get; set; }
    
    /// <summary>
    /// 选中主键列表
    /// </summary>
     public List<long> SelectKeyList { get; set; }
}

/// <summary>
/// 充值记录增加输入参数
/// </summary>
public class AddXzRechargelogInput
{
    /// <summary>
    /// 用户id
    /// </summary>
    public int? uid { get; set; }
    
    /// <summary>
    /// 充值金额
    /// </summary>
    public double? money { get; set; }
    
    /// <summary>
    /// 充值类型：1：微信，2：支付宝，3：系统赠送
    /// </summary>
    public int? rechargetype { get; set; }
    
    /// <summary>
    /// 备注
    /// </summary>
    [MaxLength(100, ErrorMessage = "备注字符长度不能超过100")]
    public string? mark { get; set; }
    
    /// <summary>
    /// 充值时间
    /// </summary>
    public DateTime? createtime { get; set; }
    
}

/// <summary>
/// 充值记录删除输入参数
/// </summary>
public class DeleteXzRechargelogInput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    [Required(ErrorMessage = "主键Id不能为空")]
    public int? Id { get; set; }
    
}

/// <summary>
/// 充值记录更新输入参数
/// </summary>
public class UpdateXzRechargelogInput
{
    /// <summary>
    /// 主键Id
    /// </summary>    
    [Required(ErrorMessage = "主键Id不能为空")]
    public int? Id { get; set; }
    
    /// <summary>
    /// 用户id
    /// </summary>    
    public int? uid { get; set; }
    
    /// <summary>
    /// 充值金额
    /// </summary>    
    public double? money { get; set; }
    
    /// <summary>
    /// 充值类型：1：微信，2：支付宝，3：系统赠送
    /// </summary>    
    public int? rechargetype { get; set; }
    
    /// <summary>
    /// 备注
    /// </summary>    
    [MaxLength(100, ErrorMessage = "备注字符长度不能超过100")]
    public string? mark { get; set; }
    
    /// <summary>
    /// 充值时间
    /// </summary>    
    public DateTime? createtime { get; set; }
    
}

/// <summary>
/// 充值记录主键查询输入参数
/// </summary>
public class QueryByIdXzRechargelogInput : DeleteXzRechargelogInput
{
}

/// <summary>
/// 充值记录数据导入实体
/// </summary>
[ExcelImporter(SheetIndex = 1, IsOnlyErrorRows = true)]
public class ImportXzRechargelogInput : BaseImportInput
{
    /// <summary>
    /// 用户id
    /// </summary>
    [ImporterHeader(Name = "用户id")]
    [ExporterHeader("用户id", Format = "", Width = 25, IsBold = true)]
    public long? uid { get; set; }
    
    /// <summary>
    /// 充值金额
    /// </summary>
    [ImporterHeader(Name = "充值金额")]
    [ExporterHeader("充值金额", Format = "", Width = 25, IsBold = true)]
    public double? money { get; set; }
    
    /// <summary>
    /// 充值类型：1：微信，2：支付宝，3：系统赠送
    /// </summary>
    [ImporterHeader(Name = "充值类型：1：微信，2：支付宝，3：系统赠送")]
    [ExporterHeader("充值类型：1：微信，2：支付宝，3：系统赠送", Format = "", Width = 25, IsBold = true)]
    public int? rechargetype { get; set; }
    
    /// <summary>
    /// 备注
    /// </summary>
    [ImporterHeader(Name = "备注")]
    [ExporterHeader("备注", Format = "", Width = 25, IsBold = true)]
    public string? mark { get; set; }
    
    /// <summary>
    /// 充值时间
    /// </summary>
    [ImporterHeader(Name = "充值时间")]
    [ExporterHeader("充值时间", Format = "", Width = 25, IsBold = true)]
    public DateTime? createtime { get; set; }
    
}
