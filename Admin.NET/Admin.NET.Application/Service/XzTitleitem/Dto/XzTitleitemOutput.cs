// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！
using Magicodes.ExporterAndImporter.Core;
namespace Admin.NET.Application;

/// <summary>
/// 系统标题栏目输出参数
/// </summary>
public class XzTitleitemOutput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    public int Id { get; set; }    
    
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
    /// 时间
    /// </summary>
    public DateTime? createtime { get; set; }    
    
}

/// <summary>
/// 系统标题栏目数据导入模板实体
/// </summary>
public class ExportXzTitleitemOutput : ImportXzTitleitemInput
{
    [ImporterHeader(IsIgnore = true)]
    [ExporterHeader(IsIgnore = true)]
    public override string Error { get; set; }
}
