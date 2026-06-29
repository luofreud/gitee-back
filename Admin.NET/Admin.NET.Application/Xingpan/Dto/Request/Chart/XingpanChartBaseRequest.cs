// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Newtonsoft.Json;

namespace Admin.NET.Application;

/// <summary>
/// 星盘请求通用基类（planets / h_sys 等），所有 chart 类接口的请求都会继承本类或子类。
/// <para>本基类只描述"看哪几颗星 + 用什么宫位系统"，不涉及人物信息；具体见 <see cref="XingpanChartSingleRequest"/> / <see cref="XingpanChartDoubleRequest"/>。</para>
/// </summary>
public abstract class XingpanChartBaseRequest : XingpanBaseRequest
{
    /// <summary>
    /// 主星体 ID 列表
    /// <para>0 太阳 / 1 月亮 / 2 水星 / 3 金星 / 4 火星 / 5 木星 / 6 土星 / 7 天王星 / 8 海王星 / 9 冥王星。</para>
    /// </summary>
    /// <example>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]</example>
    [JsonProperty("planets")]
    public List<string> Planets { get; set; }

    /// <summary>
    /// 小行星 ID 列表（可选）
    /// <para>如凯龙（10）、谷神（11）、智神（12）、婚神（13）等，可按需附加。</para>
    /// </summary>
    [JsonProperty("planet_xs")]
    public List<string> PlanetXs { get; set; }

    /// <summary>
    /// 虚星 ID 列表（可选）
    /// <para>如莉莉丝、南交、福点等西方虚点。</para>
    /// </summary>
    [JsonProperty("virtual")]
    public List<string> Virtual { get; set; }

    /// <summary>
    /// 宫位系统
    /// <para>k 柯本（默认）/ p 普拉西度 / r 赤道 / w 全星座 / e 相等宫位。</para>
    /// </summary>
    /// <example>k</example>
    [JsonProperty("h_sys")]
    public string HSys { get; set; } = "k";
}
