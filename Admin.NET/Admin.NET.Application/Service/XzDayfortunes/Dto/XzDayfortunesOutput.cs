// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！
using Magicodes.ExporterAndImporter.Core;
namespace Admin.NET.Application;

/// <summary>
/// 星座日运势输出参数
/// </summary>
public class XzDayfortunesOutput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    public int Id { get; set; }    
    
    /// <summary>
    /// 运势时间
    /// </summary>
    public DateTime? ftime { get; set; }    
    
    /// <summary>
    /// 星座类型
    /// </summary>
    public int? signtype { get; set; }    
    
    /// <summary>
    /// 综合分数
    /// </summary>
    public int? allscore { get; set; }    
    
    /// <summary>
    /// 爱情分数
    /// </summary>
    public int? lovescore { get; set; }    
    
    /// <summary>
    /// 健康分数
    /// </summary>
    public int? healthscore { get; set; }    
    
    /// <summary>
    /// 财富分数
    /// </summary>
    public int? wealthscore { get; set; }    
    
    /// <summary>
    /// 幸运数字
    /// </summary>
    public int? luckynum { get; set; }    
    
    /// <summary>
    /// 幸运颜色
    /// </summary>
    public string? luckycolor { get; set; }    
    
    /// <summary>
    /// 幸运花
    /// </summary>
    public string? luckyflower { get; set; }    
    
    /// <summary>
    /// 幸运石
    /// </summary>
    public string? luckystone { get; set; }    
    
    /// <summary>
    /// 解释
    /// </summary>
    public string? explaincontent { get; set; }    
    
}

/// <summary>
/// 星座日运势数据导入模板实体
/// </summary>
public class ExportXzDayfortunesOutput : ImportXzDayfortunesInput
{
    [ImporterHeader(IsIgnore = true)]
    [ExporterHeader(IsIgnore = true)]
    public override string Error { get; set; }
}
