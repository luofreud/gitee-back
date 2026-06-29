// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Newtonsoft.Json;

namespace Admin.NET.Application;

/// <summary>
/// 双人盘请求基类（时空盘 / 比较盘 / 配对盘 / 组合盘 / 返照盘 ...）。
/// <para>两个用户的所有信息合并在 <see cref="UserList"/> 字典中，键 "0" 为第一人，"1" 为第二人。</para>
/// </summary>
public abstract class XingpanChartDoubleRequest : XingpanChartBaseRequest
{
    /// <summary>
    /// 双人用户数据
    /// <para>必填，键 "0" / "1"，值含 longitude/latitude/tz/birthday 四要素。</para>
    /// </summary>
    [JsonProperty("user_list")]
    public Dictionary<string, XingpanUserListItem> UserList { get; set; }

    /// <summary>
    /// 盘面 SVG 输出类型
    /// <para>1 普通盘（默认高级盘）。</para>
    /// </summary>
    [JsonProperty("svg_type")]
    public string SvgType { get; set; }
}
