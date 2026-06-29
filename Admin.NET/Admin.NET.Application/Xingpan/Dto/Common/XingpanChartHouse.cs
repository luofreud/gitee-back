// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Newtonsoft.Json;

namespace Admin.NET.Application;

/// <summary>
/// 星盘响应中的 <c>house</c> 节点。数组共 12 项，第 i 项代表第 i 宫。
/// <para>包含宫头落入星座与宫位 ID；其他扩展（如宫主星）走 <see cref="Extra"/>。</para>
/// </summary>
public class XingpanChartHouse
{
    /// <summary>
    /// 宫头落入星座
    /// <para>详见 <see cref="XingpanSign"/>。</para>
    /// </summary>
    [JsonProperty("sign")]
    public XingpanSign Sign { get; set; }

    /// <summary>
    /// 宫位 ID
    /// <para>1-12，分别对应第 1 宫到第 12 宫。</para>
    /// </summary>
    /// <example>1</example>
    [JsonProperty("house_id")]
    public string HouseId { get; set; }

    /// <summary>
    /// 未识别字段
    /// <para>兜底上游可能新增字段（如宫位大小、intercept 标志等）。</para>
    /// </summary>
    [JsonExtensionData]
    public Dictionary<string, object> Extra { get; set; }
}
