// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Newtonsoft.Json;

namespace Admin.NET.Application;

/// <summary>
/// 行星信息节点。常见于 <c>planet</c>（主盘行星）与 <c>planet_second</c>（次盘，比较盘 / 组合盘等）数组中。
/// <para>每颗行星除了基础位置外，可能携带独有的扩展字段，统一通过 <see cref="Extra"/> 兜底。</para>
/// </summary>
public class XingpanPlanet
{
    /// <summary>
    /// 行星所在星座
    /// <para>详见 <see cref="XingpanSign"/>。</para>
    /// </summary>
    [JsonProperty("sign")]
    public XingpanSign Sign { get; set; }

    /// <summary>
    /// 黄经度数
    /// <para>0-360，单位度。例：220.50 表示落在天蝎座 10.50°。</para>
    /// </summary>
    /// <example>220.5017119</example>
    [JsonProperty("longitude")]
    public string Longitude { get; set; }

    /// <summary>
    /// 行星运行速度（度/天）
    /// <para>正数为顺行，负数为逆行，0 表示停滞（见月亮空亡等场景）。</para>
    /// </summary>
    /// <example>1.0008516</example>
    [JsonProperty("speed")]
    public string Speed { get; set; }

    /// <summary>
    /// 行星 ID
    /// <para>部分接口出现；0 太阳 / 1 月亮 / 2 水星 / 3 金星 / 4 火星 / 5 木星 / 6 土星 / 7 天王星 / 8 海王星 / 9 冥王星。</para>
    /// </summary>
    [JsonProperty("planet_id")]
    public string PlanetId { get; set; }

    /// <summary>
    /// 所在宫位 ID
    /// <para>1-12，部分接口（如比较盘）出现。</para>
    /// </summary>
    [JsonProperty("house_id")]
    public string HouseId { get; set; }

    /// <summary>
    /// 容许度（度）
    /// <para>仅相位类场景出现，描述该相位偏差多少度。</para>
    /// </summary>
    [JsonProperty("orb")]
    public string Orb { get; set; }

    /// <summary>
    /// 未识别字段
    /// <para>用于兜底上游可能新增的字段（逆行状态、守护星、庙旺陷落等），如需读取请走字典 Key。</para>
    /// </summary>
    [JsonExtensionData]
    public Dictionary<string, object> Extra { get; set; }
}
