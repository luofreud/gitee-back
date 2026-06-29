// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Newtonsoft.Json;

namespace Admin.NET.Application;

/// <summary>
/// 语料星座列表
/// <para>接口：<c>corpusconstellation/getlist</c>，按盘型 + 命中规则返回星座语料分组。</para>
/// </summary>
public class XingpanCorpusGetListRequest : XingpanBaseRequest
{
    /// <summary>
    /// 命中规则
    /// <para>0 / 1（具体语义参见上游文档；一般 0 全部、1 命中）。</para>
    /// </summary>
    [JsonProperty("fallInto")]
    public int FallInto { get; set; }

    /// <summary>
    /// 盘型 ID
    /// <para>1-25；对应 chart/natal(1) / chart/transit(2) / chart/composite(3) ... 等盘型。</para>
    /// </summary>
    [JsonProperty("chartType")]
    public int ChartType { get; set; }
}
