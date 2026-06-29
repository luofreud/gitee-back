// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Newtonsoft.Json;

namespace Admin.NET.Application;

/// <summary>
/// 单人盘请求基类（natal / progressed / transit / current ...）。
/// <para>包含人物出生信息与可选盘面 / 语料参数，叠加在 <see cref="XingpanChartBaseRequest"/> 之上。</para>
/// </summary>
public abstract class XingpanChartSingleRequest : XingpanChartBaseRequest
{
    /// <summary>
    /// 出生地经度（十进制）
    /// <para>必填，东经为正，西经为负。</para>
    /// </summary>
    /// <example>121.47</example>
    [JsonProperty("longitude")]
    public string Longitude { get; set; }

    /// <summary>
    /// 出生地纬度（十进制）
    /// <para>必填，北纬为正，南纬为负。</para>
    /// </summary>
    /// <example>31.23</example>
    [JsonProperty("latitude")]
    public string Latitude { get; set; }

    /// <summary>
    /// 出生地时区
    /// <para>UTC 偏移小时数；东八区为 8。</para>
    /// </summary>
    /// <example>8</example>
    [JsonProperty("tz")]
    public string Tz { get; set; }

    /// <summary>
    /// 出生时间
    /// <para>必填，格式 yyyy-MM-dd HH:mm:ss（24 小时制）。</para>
    /// </summary>
    /// <example>1999-10-17 21:00:00</example>
    [JsonProperty("birthday")]
    public string Birthday { get; set; }

    /// <summary>
    /// 盘面 SVG 输出类型
    /// <para>1 普通盘 / 0 或不传 高级盘 / -1 不显示盘（仅返回数据）。</para>
    /// </summary>
    [JsonProperty("svg_type")]
    public string SvgType { get; set; }

    /// <summary>
    /// 相位容许度（覆盖默认）
    /// <para>key=相位角度（0/30/45/60/90/120/180），value=允许度数。</para>
    /// </summary>
    /// <example>{ "90": 2, "180": 6 }</example>
    [JsonProperty("phase")]
    public Dictionary<string, string> Phase { get; set; }

    /// <summary>
    /// 是否返回语料
    /// <para>1 附带星盘语料；0 或不传 仅返回星盘数据。</para>
    /// </summary>
    [JsonProperty("is_corpus")]
    public string IsCorpus { get; set; }
}
