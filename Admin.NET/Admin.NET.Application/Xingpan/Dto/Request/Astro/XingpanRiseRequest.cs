// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Newtonsoft.Json;

namespace Admin.NET.Application;

/// <summary>
/// 日出日落（Sunrise / Sunset）
/// <para>接口：<c>astro/rise</c>，查询指定地点未来若干天的日出日落及天文晨昏时间。</para>
/// </summary>
public class XingpanRiseRequest : XingpanBaseRequest
{
    /// <summary>
    /// 出生地经度
    /// </summary>
    [JsonProperty("longitude")]
    public string Longitude { get; set; }

    /// <summary>
    /// 出生地纬度
    /// </summary>
    [JsonProperty("latitude")]
    public string Latitude { get; set; }

    /// <summary>
    /// 时区
    /// </summary>
    [JsonProperty("tz")]
    public string Tz { get; set; }

    /// <summary>
    /// 起始日期
    /// <para>格式 yyyy-MM-dd HH:mm:ss。</para>
    /// </summary>
    [JsonProperty("birthday")]
    public string Birthday { get; set; }

    /// <summary>
    /// 海拔（米）
    /// <para>0 或不传为普通算法；非 0 时按高海拔校正。</para>
    /// </summary>
    [JsonProperty("altitude")]
    public string Altitude { get; set; }

    /// <summary>
    /// 查询天数
    /// <para>1-7；包含起始日。</para>
    /// </summary>
    [JsonProperty("n")]
    public int N { get; set; }
}
