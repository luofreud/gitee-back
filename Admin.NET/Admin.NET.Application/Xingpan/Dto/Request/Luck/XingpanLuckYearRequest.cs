// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Newtonsoft.Json;

namespace Admin.NET.Application;

/// <summary>
/// 本年运势（Luck / Year）
/// <para>接口：<c>luck/year</c>，按命主本年星象给出年度运势综述。</para>
/// </summary>
public class XingpanLuckYearRequest : XingpanBaseRequest
{
    /// <summary>出生地经度</summary>
    [JsonProperty("longitude")]
    public string Longitude { get; set; }

    /// <summary>出生地纬度</summary>
    [JsonProperty("latitude")]
    public string Latitude { get; set; }

    /// <summary>时区</summary>
    [JsonProperty("tz")]
    public string Tz { get; set; }

    /// <summary>出生时间</summary>
    [JsonProperty("birthday")]
    public string Birthday { get; set; }
}
