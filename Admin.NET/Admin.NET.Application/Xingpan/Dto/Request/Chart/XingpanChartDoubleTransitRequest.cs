// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Newtonsoft.Json;

namespace Admin.NET.Application;

/// <summary>
/// 双人盘 + 推运时间 请求基类（组合次限 / 组合三限 / 时空次限 / 时空三限 / 马盘次限 / 马盘三限 ...）。
/// <para>在 <see cref="XingpanChartDoubleRequest"/> 基础上叠加推运时间，用于关系中"某时点的相位变化"。</para>
/// </summary>
public abstract class XingpanChartDoubleTransitRequest : XingpanChartDoubleRequest
{
    /// <summary>
    /// 推运时间
    /// <para>必填，格式 yyyy-MM-dd HH:mm:ss。</para>
    /// </summary>
    /// <example>2025-12-12 12:00:00</example>
    [JsonProperty("transitday")]
    public string Transitday { get; set; }
}
