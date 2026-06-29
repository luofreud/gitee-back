// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Newtonsoft.Json;

namespace Admin.NET.Application;

/// <summary>
/// 小限相位（Aphesis）
/// <para>接口：<c>astro/aphesis</c>，按指定星体（小限主星）逐年推运并计算相位。</para>
/// </summary>
public class XingpanAphesisRequest : XingpanBaseRequest
{
    /// <summary>
    /// 出生地经度（十进制）
    /// </summary>
    /// <example>121.47</example>
    [JsonProperty("longitude")]
    public string Longitude { get; set; }

    /// <summary>
    /// 出生地纬度（十进制）
    /// </summary>
    /// <example>31.23</example>
    [JsonProperty("latitude")]
    public string Latitude { get; set; }

    /// <summary>
    /// 时区
    /// </summary>
    /// <example>8</example>
    [JsonProperty("tz")]
    public string Tz { get; set; }

    /// <summary>
    /// 出生时间
    /// <para>格式 yyyy-MM-dd HH:mm:ss。</para>
    /// </summary>
    /// <example>1999-10-17 21:00:00</example>
    [JsonProperty("birthday")]
    public string Birthday { get; set; }

    /// <summary>
    /// 推运单位
    /// <para>year 按年 / month 按月。</para>
    /// </summary>
    /// <example>year</example>
    [JsonProperty("unit")]
    public string Unit { get; set; }

    /// <summary>
    /// 推运步数
    /// <para>unit=year 时表示年数；unit=month 时表示月数。</para>
    /// </summary>
    [JsonProperty("years")]
    public int Years { get; set; }

    /// <summary>
    /// 推运主星 ID
    /// <para>0 太阳 / 1 月亮 / 2 水星 ... 9 冥王星，默认 0。</para>
    /// </summary>
    [JsonProperty("spirit")]
    public int Spirit { get; set; }
}
