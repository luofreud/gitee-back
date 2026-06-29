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
/// 星币记录基础输入参数
/// </summary>
public class XzXblogBaseInput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    public virtual long? Id { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public virtual long? uid { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public virtual int? xb { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public virtual string? mark { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public virtual int? xbye { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public virtual DateTime? createtime { get; set; }
    
}

/// <summary>
/// 星币记录分页查询输入参数
/// </summary>
public class PageXzXblogInput : BasePageInput
{
    /// <summary>
    /// 
    /// </summary>
    public long? uid { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public int? xb { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public string? mark { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public int? xbye { get; set; }
    
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
/// 星币记录增加输入参数
/// </summary>
public class AddXzXblogInput
{
    /// <summary>
    /// 
    /// </summary>
    public long? uid { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public int? xb { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [MaxLength(50, ErrorMessage = "字符长度不能超过50")]
    public string? mark { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public int? xbye { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public DateTime? createtime { get; set; }
    
}

/// <summary>
/// 星币记录删除输入参数
/// </summary>
public class DeleteXzXblogInput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    [Required(ErrorMessage = "主键Id不能为空")]
    public long? Id { get; set; }
    
}

/// <summary>
/// 星币记录更新输入参数
/// </summary>
public class UpdateXzXblogInput
{
    /// <summary>
    /// 主键Id
    /// </summary>    
    [Required(ErrorMessage = "主键Id不能为空")]
    public long? Id { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    public long? uid { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    public int? xb { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    [MaxLength(50, ErrorMessage = "字符长度不能超过50")]
    public string? mark { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    public int? xbye { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    public DateTime? createtime { get; set; }
    
}

/// <summary>
/// 星币记录主键查询输入参数
/// </summary>
public class QueryByIdXzXblogInput : DeleteXzXblogInput
{
}

/// <summary>
/// 星币记录数据导入实体
/// </summary>
[ExcelImporter(SheetIndex = 1, IsOnlyErrorRows = true)]
public class ImportXzXblogInput : BaseImportInput
{
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public long? uid { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public int? xb { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public string? mark { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public int? xbye { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public DateTime? createtime { get; set; }
    
}
