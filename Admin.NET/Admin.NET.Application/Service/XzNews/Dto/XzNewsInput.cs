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
/// 新闻内容基础输入参数
/// </summary>
public class XzNewsBaseInput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    public virtual long? Id { get; set; }
    
    /// <summary>
    /// 标题
    /// </summary>
    public virtual string? title { get; set; }
    
    /// <summary>
    /// 标题key
    /// </summary>
    public virtual string? titlecode { get; set; }
    
    /// <summary>
    /// 图标
    /// </summary>
    public virtual string? img { get; set; }
    
    /// <summary>
    /// 内容
    /// </summary>
    public virtual string? newcontent { get; set; }
    
    /// <summary>
    /// 点击次数
    /// </summary>
    public virtual int? click { get; set; }
    
    /// <summary>
    /// 排序
    /// </summary>
    public virtual int? sortcode { get; set; }
    
    /// <summary>
    /// 创建时间
    /// </summary>
    public virtual DateTime? createtime { get; set; }
    
}

/// <summary>
/// 新闻内容分页查询输入参数
/// </summary>
public class PageXzNewsInput : BasePageInput
{
    /// <summary>
    /// 标题
    /// </summary>
    public string? title { get; set; }
    
    /// <summary>
    /// 标题key 通过编号获取数据
    /// </summary>
    public string? titlecode { get; set; }
    
    /// <summary>
    /// 图标
    /// </summary>
    public string? img { get; set; }
    
    /// <summary>
    /// 内容
    /// </summary>
    public string? newcontent { get; set; }
    
    /// <summary>
    /// 点击次数
    /// </summary>
    public int? click { get; set; }
    
    /// <summary>
    /// 排序
    /// </summary>
    public int? sortcode { get; set; }
    
    /// <summary>
    /// 创建时间范围
    /// </summary>
     public DateTime?[] createtimeRange { get; set; }
    
    /// <summary>
    /// 选中主键列表
    /// </summary>
     public List<long> SelectKeyList { get; set; }
}

/// <summary>
/// 新闻内容增加输入参数
/// </summary>
public class AddXzNewsInput
{
    /// <summary>
    /// 标题
    /// </summary>
    [MaxLength(200, ErrorMessage = "标题字符长度不能超过200")]
    public string? title { get; set; }
    
    /// <summary>
    /// 标题key
    /// </summary>
    [MaxLength(50, ErrorMessage = "标题key字符长度不能超过50")]
    public string? titlecode { get; set; }
    
    /// <summary>
    /// 图标
    /// </summary>
    [MaxLength(500, ErrorMessage = "图标字符长度不能超过500")]
    public string? img { get; set; }
    
    /// <summary>
    /// 内容
    /// </summary>
    public string? newcontent { get; set; }
    
    /// <summary>
    /// 点击次数
    /// </summary>
    public int? click { get; set; }
    
    /// <summary>
    /// 排序
    /// </summary>
    public int? sortcode { get; set; }
    
    /// <summary>
    /// 创建时间
    /// </summary>
    public DateTime? createtime { get; set; }
    
}

/// <summary>
/// 新闻内容删除输入参数
/// </summary>
public class DeleteXzNewsInput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    [Required(ErrorMessage = "主键Id不能为空")]
    public long? Id { get; set; }
    
}

/// <summary>
/// 新闻内容更新输入参数
/// </summary>
public class UpdateXzNewsInput
{
    /// <summary>
    /// 主键Id
    /// </summary>    
    [Required(ErrorMessage = "主键Id不能为空")]
    public long? Id { get; set; }
    
    /// <summary>
    /// 标题
    /// </summary>    
    [MaxLength(200, ErrorMessage = "标题字符长度不能超过200")]
    public string? title { get; set; }
    
    /// <summary>
    /// 标题key
    /// </summary>    
    [MaxLength(50, ErrorMessage = "标题key字符长度不能超过50")]
    public string? titlecode { get; set; }
    
    /// <summary>
    /// 图标
    /// </summary>    
    [MaxLength(500, ErrorMessage = "图标字符长度不能超过500")]
    public string? img { get; set; }
    
    /// <summary>
    /// 内容
    /// </summary>    
    public string? newcontent { get; set; }
    
    /// <summary>
    /// 点击次数
    /// </summary>    
    public int? click { get; set; }
    
    /// <summary>
    /// 排序
    /// </summary>    
    public int? sortcode { get; set; }
    
    /// <summary>
    /// 创建时间
    /// </summary>    
    public DateTime? createtime { get; set; }
    
}

/// <summary>
/// 新闻内容主键查询输入参数
/// </summary>
public class QueryByIdXzNewsInput : DeleteXzNewsInput
{
}

/// <summary>
/// 新闻内容数据导入实体
/// </summary>
[ExcelImporter(SheetIndex = 1, IsOnlyErrorRows = true)]
public class ImportXzNewsInput : BaseImportInput
{
    /// <summary>
    /// 标题
    /// </summary>
    [ImporterHeader(Name = "标题")]
    [ExporterHeader("标题", Format = "", Width = 25, IsBold = true)]
    public string? title { get; set; }
    
    /// <summary>
    /// 标题key
    /// </summary>
    [ImporterHeader(Name = "标题key")]
    [ExporterHeader("标题key", Format = "", Width = 25, IsBold = true)]
    public string? titlecode { get; set; }
    
    /// <summary>
    /// 图标
    /// </summary>
    [ImporterHeader(Name = "图标")]
    [ExporterHeader("图标", Format = "", Width = 25, IsBold = true)]
    public string? img { get; set; }
    
    /// <summary>
    /// 内容
    /// </summary>
    [ImporterHeader(Name = "内容")]
    [ExporterHeader("内容", Format = "", Width = 25, IsBold = true)]
    public string? newcontent { get; set; }
    
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
    /// 创建时间
    /// </summary>
    [ImporterHeader(Name = "创建时间")]
    [ExporterHeader("创建时间", Format = "", Width = 25, IsBold = true)]
    public DateTime? createtime { get; set; }
    
}
