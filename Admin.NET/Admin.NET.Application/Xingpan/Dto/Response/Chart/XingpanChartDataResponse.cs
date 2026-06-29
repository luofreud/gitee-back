// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Newtonsoft.Json;

namespace Admin.NET.Application;

/// <summary>
/// 星盘通用响应数据，所有 chart / compare 响应的 data 字段都会反序列化为本类。
/// <para>包含 user / house / planet 三大核心节点；扩展字段（如 planet_second / svg / aspect_list / phase_list）由 <see cref="Extra"/> 兜底。</para>
/// </summary>
public class XingpanChartDataResponse
{
    /// <summary>
    /// 用户节点
    /// <para>回显请求参数、access_token、宫位系统、相位配置等上下文。详见 <see cref="XingpanChartUser"/>。</para>
    /// </summary>
    [JsonProperty("user")]
    public XingpanChartUser User { get; set; }

    /// <summary>
    /// 12 宫位列表
    /// <para>数组下标与宫位 ID 不一定一致，请使用 <see cref="XingpanChartHouse.HouseId"/> 字段判断。</para>
    /// </summary>
    [JsonProperty("house")]
    public List<XingpanChartHouse> House { get; set; }

    /// <summary>
    /// 行星列表
    /// <para>包含请求 planets 列表中所有星体在星座 / 宫位 / 速度等数据。详见 <see cref="XingpanPlanet"/>。</para>
    /// </summary>
    [JsonProperty("planet")]
    public List<XingpanPlanet> Planet { get; set; }

    /// <summary>
    /// 扩展字段
    /// <para>常见键：</para>
    /// <list type="bullet">
    ///   <item>planet_second：双人盘第二组行星（如比较盘 / 组合盘）</item>
    ///   <item>aspect_list / aspect：相位列表（行星-行星 容许度 / 角度）</item>
    ///   <item>phase_list：相位摘要</item>
    ///   <item>svg：盘面 SVG 字符串（若请求时 svg_type=1）</item>
    ///   <item>midpoint：中点列表（部分盘型）</item>
    ///   <item>fortune / arabic / hermes：希腊点 / 阿拉伯点 等扩展</item>
    /// </list>
    /// </summary>
    [JsonExtensionData]
    public Dictionary<string, object> Extra { get; set; }
}
