// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Newtonsoft.Json;

namespace Admin.NET.Application;

/// <summary>
/// 星盘接口通用响应壳，统一包含 <c>code</c>、<c>msg</c>、<c>data</c> 三个字段。
/// <para>code 为 0 表示成功；非 0 时 <c>XingpanHttpClient</c> 会直接抛 <see cref="Furion.FriendlyException.Oops"/>。</para>
/// </summary>
/// <typeparam name="TData">data 字段业务类型，可以是 chart、字典、列表等</typeparam>
public class XingpanResponse<TData>
{
    /// <summary>
    /// 业务错误码
    /// <para>0：成功；非 0：失败，详见 <see cref="XingpanApiError"/> 常量定义。</para>
    /// </summary>
    [JsonProperty("code")]
    public int Code { get; set; }

    /// <summary>
    /// 提示信息
    /// <para>成功时为"操作成功"；失败时为错误说明，可直接用于 Toast 提示。</para>
    /// </summary>
    [JsonProperty("msg")]
    public string Msg { get; set; }

    /// <summary>
    /// 业务数据
    /// <para>失败时为 null；成功时为接口对应业务对象。</para>
    /// </summary>
    [JsonProperty("data")]
    public TData Data { get; set; }
}
