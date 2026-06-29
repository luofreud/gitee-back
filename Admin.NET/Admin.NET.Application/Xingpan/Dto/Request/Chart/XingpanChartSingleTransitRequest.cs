// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Newtonsoft.Json;

namespace Admin.NET.Application;

/// <summary>
/// 单人盘 + 推运时间 请求基类（次限 / 三限 / 推进 / 行运 / 太阳弧 / 法达 / 小限 / 天象 ...）。
/// <para>在 <see cref="XingpanChartSingleRequest"/> 基础上叠加推运时间，用于"何时发生"类推运场景。</para>
/// </summary>
public abstract class XingpanChartSingleTransitRequest : XingpanChartSingleRequest
{
    /// <summary>
    /// 推运时间
    /// <para>必填，格式 yyyy-MM-dd HH:mm:ss；行运类接口必须晚于 <c>birthday</c>。</para>
    /// </summary>
    /// <example>2025-12-12 12:00:00</example>
    [JsonProperty("transitday")]
    public string Transitday { get; set; }
}
