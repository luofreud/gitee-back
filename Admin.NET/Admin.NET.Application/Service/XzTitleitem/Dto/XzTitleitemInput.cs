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
/// 系统标题栏目基础输入参数
/// </summary>
public class XzTitleitemBaseInput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    public virtual long? Id { get; set; }
    
    /// <summary>
    /// 标题名称
    /// </summary>
    public virtual string? name { get; set; }
    
    /// <summary>
    /// 逗号分隔
    /// </summary>
    public virtual string? img { get; set; }
    
    /// <summary>
    /// 跳转地址
    /// </summary>
    public virtual string? url { get; set; }
    
    /// <summary>
    /// 点击次数
    /// </summary>
    public virtual int? click { get; set; }
    
    /// <summary>
    /// 排序
    /// </summary>
    public virtual int? sortcode { get; set; }
    
    /// <summary>
    /// 时间
    /// </summary>
    public virtual DateTime? createtime { get; set; }
    
}

/// <summary>
/// 系统标题栏目分页查询输入参数
/// </summary>
public class PageXzTitleitemInput : BasePageInput
{
    /// <summary>
    /// 标题名称
    /// </summary>
    public string? name { get; set; }
    
    /// <summary>
    /// 逗号分隔
    /// </summary>
    public string? img { get; set; }
    
    /// <summary>
    /// 跳转地址
    /// </summary>
    public string? url { get; set; }
    
    /// <summary>
    /// 点击次数
    /// </summary>
    public int? click { get; set; }
    
    /// <summary>
    /// 排序
    /// </summary>
    public int? sortcode { get; set; }
    
    /// <summary>
    /// 时间范围
    /// </summary>
     public DateTime?[] createtimeRange { get; set; }
    
    /// <summary>
    /// 选中主键列表
    /// </summary>
     public List<long> SelectKeyList { get; set; }
}

/// <summary>
/// 系统标题栏目增加输入参数
/// </summary>
public class AddXzTitleitemInput
{
    /// <summary>
    /// 标题名称
    /// </summary>
    [MaxLength(50, ErrorMessage = "标题名称字符长度不能超过50")]
    public string? name { get; set; }
    
    /// <summary>
    /// 逗号分隔
    /// </summary>
    [MaxLength(300, ErrorMessage = "逗号分隔字符长度不能超过300")]
    public string? img { get; set; }
    
    /// <summary>
    /// 跳转地址
    /// </summary>
    [MaxLength(300, ErrorMessage = "跳转地址字符长度不能超过300")]
    public string? url { get; set; }
    
    /// <summary>
    /// 点击次数
    /// </summary>
    public int? click { get; set; }
    
    /// <summary>
    /// 排序
    /// </summary>
    public int? sortcode { get; set; }
    
    /// <summary>
    /// 时间
    /// </summary>
    public DateTime? createtime { get; set; }
    
}

/// <summary>
/// 系统标题栏目删除输入参数
/// </summary>
public class DeleteXzTitleitemInput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    [Required(ErrorMessage = "主键Id不能为空")]
    public long? Id { get; set; }
    
}

/// <summary>
/// 系统标题栏目更新输入参数
/// </summary>
public class UpdateXzTitleitemInput
{
    /// <summary>
    /// 主键Id
    /// </summary>    
    [Required(ErrorMessage = "主键Id不能为空")]
    public long? Id { get; set; }
    
    /// <summary>
    /// 标题名称
    /// </summary>    
    [MaxLength(50, ErrorMessage = "标题名称字符长度不能超过50")]
    public string? name { get; set; }
    
    /// <summary>
    /// 逗号分隔
    /// </summary>    
    [MaxLength(300, ErrorMessage = "逗号分隔字符长度不能超过300")]
    public string? img { get; set; }
    
    /// <summary>
    /// 跳转地址
    /// </summary>    
    [MaxLength(300, ErrorMessage = "跳转地址字符长度不能超过300")]
    public string? url { get; set; }
    
    /// <summary>
    /// 点击次数
    /// </summary>    
    public int? click { get; set; }
    
    /// <summary>
    /// 排序
    /// </summary>    
    public int? sortcode { get; set; }
    
    /// <summary>
    /// 时间
    /// </summary>    
    public DateTime? createtime { get; set; }
    
}

/// <summary>
/// 系统标题栏目主键查询输入参数
/// </summary>
public class QueryByIdXzTitleitemInput : DeleteXzTitleitemInput
{
}

/// <summary>
/// 系统标题栏目数据导入实体
/// </summary>
[ExcelImporter(SheetIndex = 1, IsOnlyErrorRows = true)]
public class ImportXzTitleitemInput : BaseImportInput
{
    /// <summary>
    /// 标题名称
    /// </summary>
    [ImporterHeader(Name = "标题名称")]
    [ExporterHeader("标题名称", Format = "", Width = 25, IsBold = true)]
    public string? name { get; set; }
    
    /// <summary>
    /// 逗号分隔
    /// </summary>
    [ImporterHeader(Name = "逗号分隔")]
    [ExporterHeader("逗号分隔", Format = "", Width = 25, IsBold = true)]
    public string? img { get; set; }
    
    /// <summary>
    /// 跳转地址
    /// </summary>
    [ImporterHeader(Name = "跳转地址")]
    [ExporterHeader("跳转地址", Format = "", Width = 25, IsBold = true)]
    public string? url { get; set; }
    
    /// <summary>
    /// 点击次数
    /// </summary>
    [ImporterHeader(Name = "点击次数")]
    [ExporterHeader("点击次数", Format = "", Width = 25, IsBold = true)]
    public int? click { get; set; }
    
    /// <summary>
    /// 排序
    /// </summary>
    [ImporterHeader(Name = "排序")]
    [ExporterHeader("排序", Format = "", Width = 25, IsBold = true)]
    public int? sortcode { get; set; }
    
    /// <summary>
    /// 时间
    /// </summary>
    [ImporterHeader(Name = "时间")]
    [ExporterHeader("时间", Format = "", Width = 25, IsBold = true)]
    public DateTime? createtime { get; set; }
    
}
