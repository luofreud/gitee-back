// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Newtonsoft.Json;

namespace Admin.NET.Application;

/// <summary>
/// 星座推运（Sign Push）
/// <para>接口：<c>astro/signpush</c>，从指定星座出发逐年推运的行星位置。</para>
/// </summary>
public class XingpanSignPushRequest : XingpanBaseRequest
{
    /// <summary>
    /// 起始星座 ID
    /// <para>0 白羊 / 1 金牛 / 2 双子 / 3 巨蟹 / 4 狮子 / 5 处女 / 6 天秤 / 7 天蝎 / 8 射手 / 9 摩羯 / 10 水瓶 / 11 双鱼。</para>
    /// </summary>
    [JsonProperty("sign")]
    public int Sign { get; set; }

    /// <summary>
    /// 出生时间
    /// <para>格式 yyyy-MM-dd HH:mm:ss。</para>
    /// </summary>
    [JsonProperty("birthday")]
    public string Birthday { get; set; }

    /// <summary>
    /// 推运步数
    /// </summary>
    [JsonProperty("years")]
    public int Years { get; set; }

    /// <summary>
    /// 推运单位
    /// <para>year 按年 / month 按月。</para>
    /// </summary>
    [JsonProperty("unit")]
    public string Unit { get; set; }
}
