// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Newtonsoft.Json;

namespace Admin.NET.Application;

/// <summary>
/// 组合评测（Evaluation Combination）
/// <para>接口：<c>evaluationcombination/add</c>，按双人关系给出运势组合评测。</para>
/// </summary>
public class XingpanEvaluationCombinationRequest : XingpanBaseRequest
{
    /// <summary>
    /// 双人结构
    /// <para>键 "0" 第一人 / "1" 第二人，每项含 longitude / latitude / tz / birthday。</para>
    /// </summary>
    [JsonProperty("user_list")]
    public Dictionary<string, XingpanUserListItem> UserList { get; set; }

    /// <summary>
    /// 评测时间粒度
    /// <para>1 今日 / 2 本周 / 3 本月 / 4 本年。</para>
    /// </summary>
    [JsonProperty("type")]
    public int Type { get; set; }
}
