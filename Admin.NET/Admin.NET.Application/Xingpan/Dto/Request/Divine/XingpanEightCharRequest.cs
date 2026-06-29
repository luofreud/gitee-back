// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Newtonsoft.Json;

namespace Admin.NET.Application;

/// <summary>
/// 八字排盘（Four Pillars / Bazi）
/// <para>接口：<c>eightchar/get</c>，依据公历出生时间（可校真太阳时）排出四柱八字。</para>
/// </summary>
public class XingpanEightCharRequest : XingpanBaseRequest
{
    /// <summary>出生年</summary>
    /// <example>1999</example>
    [JsonProperty("year")]
    public int Year { get; set; }

    /// <summary>出生月（接口字段名沿用上游 moth）</summary>
    /// <example>10</example>
    [JsonProperty("moth")]
    public int Moth { get; set; }

    /// <summary>出生日</summary>
    /// <example>17</example>
    [JsonProperty("day")]
    public int Day { get; set; }

    /// <summary>出生时（24h）</summary>
    /// <example>21</example>
    [JsonProperty("hour")]
    public int Hour { get; set; }

    /// <summary>出生分</summary>
    /// <example>0</example>
    [JsonProperty("minute")]
    public int Minute { get; set; }

    /// <summary>出生秒</summary>
    /// <example>0</example>
    [JsonProperty("second")]
    public int Second { get; set; }

    /// <summary>性别（0 女 / 1 男）</summary>
    /// <example>1</example>
    [JsonProperty("gender")]
    public int Gender { get; set; }

    /// <summary>是否使用真太阳时（0 否 / 1 是）</summary>
    /// <example>1</example>
    [JsonProperty("suntime")]
    public int Suntime { get; set; }

    /// <summary>出生地经度（suntime=1 时必填）</summary>
    /// <example>121.47</example>
    [JsonProperty("longitude")]
    public string Longitude { get; set; }

    /// <summary>出生地纬度（suntime=1 时必填）</summary>
    /// <example>31.23</example>
    [JsonProperty("latitude")]
    public string Latitude { get; set; }
}
