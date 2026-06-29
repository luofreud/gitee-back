// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Newtonsoft.Json;

namespace Admin.NET.Application;

/// <summary>
/// 双人盘（时空盘 / 比较盘 / 配对盘 / 组合盘 / 返照盘 / 推运盘组合 等）的单人数据项。
/// <para>上游 <c>user_list</c> JSON 形如 <c>{ "0": {...}, "1": {...} }</c>，请求侧使用 <see cref="Dictionary{TKey,TValue}"/> 承载以保留索引；响应侧数组下标 0 / 1 对应两人。</para>
/// </summary>
public class XingpanUserListItem
{
    /// <summary>
    /// 经度
    /// <para>十进制，东经为正，西经为负。</para>
    /// </summary>
    /// <example>121.47</example>
    [JsonProperty("longitude")]
    public string Longitude { get; set; }

    /// <summary>
    /// 纬度
    /// <para>十进制，北纬为正，南纬为负。</para>
    /// </summary>
    /// <example>31.23</example>
    [JsonProperty("latitude")]
    public string Latitude { get; set; }

    /// <summary>
    /// 时区
    /// <para>UTC 偏移小时数；东八区为 8，西五区为 -5。</para>
    /// </summary>
    /// <example>8</example>
    [JsonProperty("tz")]
    public string Tz { get; set; }

    /// <summary>
    /// 出生时间
    /// <para>格式 yyyy-MM-dd HH:mm:ss，部分接口允许 12 小时制（不推荐）。</para>
    /// </summary>
    /// <example>1999-10-17 21:00:00</example>
    [JsonProperty("birthday")]
    public string Birthday { get; set; }

    /// <summary>
    /// 未识别字段
    /// <para>兜底上游可能新增字段（如 solar_time、sex 等）。</para>
    /// </summary>
    [JsonExtensionData]
    public Dictionary<string, object> Extra { get; set; }
}
