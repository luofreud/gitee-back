// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Newtonsoft.Json;

namespace Admin.NET.Application;

/// <summary>
/// 星座信息节点。常见于 <c>sign</c>、<c>planet.sign</c>、<c>house.sign</c> 等位置。
/// <para>同时描述"某颗行星落在哪个星座的几度几分几秒"，与 12 星座一一对应。</para>
/// </summary>
public class XingpanSign
{
    /// <summary>
    /// 度数
    /// <para>取值范围 0-29，表示所在星座的第几度。</para>
    /// </summary>
    /// <example>15</example>
    [JsonProperty("deg")]
    public string Deg { get; set; }

    /// <summary>
    /// 分数
    /// <para>取值范围 0-59，度的余下分数。</para>
    /// </summary>
    /// <example>23</example>
    [JsonProperty("min")]
    public string Min { get; set; }

    /// <summary>
    /// 秒数
    /// <para>取值范围 0-59，精确到秒的星盘数据。</para>
    /// </summary>
    /// <example>45</example>
    [JsonProperty("sec")]
    public string Sec { get; set; }

    /// <summary>
    /// 星座 ID
    /// <para>0 白羊 / 1 金牛 / 2 双子 / 3 巨蟹 / 4 狮子 / 5 处女 / 6 天秤 / 7 天蝎 / 8 射手 / 9 摩羯 / 10 水瓶 / 11 双鱼。</para>
    /// </summary>
    [JsonProperty("sign_id")]
    public int SignId { get; set; }

    /// <summary>
    /// 星座英文名
    /// <para>例如：Aries / Taurus / Gemini ... Pisces。</para>
    /// </summary>
    [JsonProperty("sign_english")]
    public string SignEnglish { get; set; }

    /// <summary>
    /// 星座中文名
    /// <para>例如：白羊座 / 金牛座 / 双子座 ... 双鱼座。</para>
    /// </summary>
    [JsonProperty("sign_chinese")]
    public string SignChinese { get; set; }

    /// <summary>
    /// 星座符号字体
    /// <para>Unicode 字符，需配合项目内置的符号字体库（如 "♈"）显示。</para>
    /// </summary>
    [JsonProperty("sign_font")]
    public string SignFont { get; set; }
}
