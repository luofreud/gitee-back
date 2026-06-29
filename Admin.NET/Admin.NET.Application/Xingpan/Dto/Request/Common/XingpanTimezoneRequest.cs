// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Newtonsoft.Json;

namespace Admin.NET.Application;

/// <summary>
/// 计算指定位置 / 时间的真太阳时与夏令时
/// <para>接口：<c>chart/timezone</c>，常用于本地出生时间换算。</para>
/// </summary>
public class XingpanTimezoneRequest : XingpanBaseRequest
{
    /// <summary>
    /// 纬度（十进制）
    /// <para>必填，北纬为正，南纬为负。</para>
    /// </summary>
    /// <example>31.23</example>
    [JsonProperty("latitude")]
    public string Latitude { get; set; }

    /// <summary>
    /// 经度（十进制）
    /// <para>必填，东经为正，西经为负。</para>
    /// </summary>
    /// <example>121.47</example>
    [JsonProperty("longitude")]
    public string Longitude { get; set; }

    /// <summary>
    /// 当地时间
    /// <para>必填，格式 yyyy-MM-dd HH:mm。</para>
    /// </summary>
    /// <example>2025-12-12 12:12</example>
    [JsonProperty("datetime")]
    public string Datetime { get; set; }
}
