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
/// 系统用户评测基础输入参数
/// </summary>
public class XzReviewBaseInput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    public virtual long? Id { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public virtual string? name { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public virtual string? tipname { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public virtual string? img { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public virtual string? url { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public virtual double? money { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public virtual int? count { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public virtual int? sortcode { get; set; }
    
    /// <summary>
    /// 0：不置顶，1：置顶
    /// </summary>
    public virtual int? istop { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public virtual int? rtype { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public virtual int? click { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public virtual DateTime? createtime { get; set; }
    
}

/// <summary>
/// 系统用户评测分页查询输入参数
/// </summary>
public class PageXzReviewInput : BasePageInput
{
    /// <summary>
    /// 
    /// </summary>
    public string? name { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public string? tipname { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public string? img { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public string? url { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public double? money { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public int? count { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public int? sortcode { get; set; }
    
    /// <summary>
    /// 0：不置顶，1：置顶
    /// </summary>
    public int? istop { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public int? rtype { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public int? click { get; set; }
    
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
/// 系统用户评测增加输入参数
/// </summary>
public class AddXzReviewInput
{
    /// <summary>
    /// 
    /// </summary>
    [MaxLength(100, ErrorMessage = "字符长度不能超过100")]
    public string? name { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [MaxLength(100, ErrorMessage = "字符长度不能超过100")]
    public string? tipname { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [MaxLength(200, ErrorMessage = "字符长度不能超过200")]
    public string? img { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [MaxLength(300, ErrorMessage = "字符长度不能超过300")]
    public string? url { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public double? money { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public int? count { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public int? sortcode { get; set; }
    
    /// <summary>
    /// 0：不置顶，1：置顶
    /// </summary>
    public int? istop { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public int? rtype { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public int? click { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public DateTime? createtime { get; set; }
    
}

/// <summary>
/// 系统用户评测删除输入参数
/// </summary>
public class DeleteXzReviewInput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    [Required(ErrorMessage = "主键Id不能为空")]
    public long? Id { get; set; }
    
}

/// <summary>
/// 系统用户评测更新输入参数
/// </summary>
public class UpdateXzReviewInput
{
    /// <summary>
    /// 主键Id
    /// </summary>    
    [Required(ErrorMessage = "主键Id不能为空")]
    public long? Id { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    [MaxLength(100, ErrorMessage = "字符长度不能超过100")]
    public string? name { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    [MaxLength(100, ErrorMessage = "字符长度不能超过100")]
    public string? tipname { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    [MaxLength(200, ErrorMessage = "字符长度不能超过200")]
    public string? img { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    [MaxLength(300, ErrorMessage = "字符长度不能超过300")]
    public string? url { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    public double? money { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    public int? count { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    public int? sortcode { get; set; }
    
    /// <summary>
    /// 0：不置顶，1：置顶
    /// </summary>    
    public int? istop { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    public int? rtype { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    public int? click { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    public DateTime? createtime { get; set; }
    
}

/// <summary>
/// 系统用户评测主键查询输入参数
/// </summary>
public class QueryByIdXzReviewInput : DeleteXzReviewInput
{
}

/// <summary>
/// 系统用户评测数据导入实体
/// </summary>
[ExcelImporter(SheetIndex = 1, IsOnlyErrorRows = true)]
public class ImportXzReviewInput : BaseImportInput
{
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public string? name { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public string? tipname { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public string? img { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public string? url { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public double? money { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public int? count { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public int? sortcode { get; set; }
    
    /// <summary>
    /// 0：不置顶，1：置顶
    /// </summary>
    [ImporterHeader(Name = "0：不置顶，1：置顶")]
    [ExporterHeader("0：不置顶，1：置顶", Format = "", Width = 25, IsBold = true)]
    public int? istop { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public int? rtype { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public int? click { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public DateTime? createtime { get; set; }
    
}
