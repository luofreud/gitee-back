// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Newtonsoft.Json;

namespace Admin.NET.Application;

/// <summary>
/// 星盘响应中的 <c>user</c> 节点。回显请求时提交的上下文信息。
/// <para>对于单人盘：包含 access_token、h_sys、planets、phase；</para>
/// <para>对于双人盘：额外包含 user_list 数组（按 "0"/"1" 索引）。</para>
/// </summary>
public class XingpanChartUser
{
    /// <summary>
    /// 访问 token
    /// <para>上游回传的 token，业务侧无需关心，用于核对调用身份。</para>
    /// </summary>
    [JsonProperty("access_token")]
    public string AccessToken { get; set; }

    /// <summary>
    /// 宫位系统
    /// <para>k 柯本 / p 普拉西度 / r 赤道 / w 全星座 / e 相等宫位。</para>
    /// </summary>
    /// <example>k</example>
    [JsonProperty("h_sys")]
    public string HSys { get; set; }

    /// <summary>
    /// 用户列表（仅双人盘回传）
    /// <para>数组下标 0 表示第一个人，1 表示第二个人。详见 <see cref="XingpanUserListItem"/>。</para>
    /// </summary>
    [JsonProperty("user_list")]
    public List<XingpanUserListItem> UserList { get; set; }

    /// <summary>
    /// 星体 ID 列表
    /// <para>原样回显请求时传入的 planets 字段，0-9 为 10 颗主行星。</para>
    /// </summary>
    [JsonProperty("planets")]
    public List<object> Planets { get; set; }

    /// <summary>
    /// 相位容许度配置
    /// <para>key 为相位角度（0 合 / 30 六合 / 45 六合半 / 60 三分 / 90 四分 / 120 六分 / 180 冲），value 为允许度数。</para>
    /// </summary>
    /// <example>{ "0": 8, "90": 6, "120": 5, "180": 6 }</example>
    [JsonProperty("phase")]
    public Dictionary<string, object> Phase { get; set; }

    /// <summary>
    /// 未识别字段
    /// <para>兜底上游可能新增字段（如行星_2nd、守护星等）。</para>
    /// </summary>
    [JsonExtensionData]
    public Dictionary<string, object> Extra { get; set; }
}
