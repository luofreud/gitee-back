// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Furion.ConfigurableOptions;

namespace Admin.NET.Application;

/// <summary>
/// 星盘（xingpan.vip）接口配置项
/// </summary>
public sealed class XingpanOptions : IConfigurableOptions
{
    /// <summary>
    /// 接口基础地址，例如 http://www.xingpan.vip/astrology/
    /// </summary>
    public string ApiUrl { get; set; }

    /// <summary>
    /// 默认 AccessToken（最低优先级 P3）
    /// </summary>
    public string AccessToken { get; set; }

    /// <summary>
    /// 运势（luck/day | luck/weeks | luck/moon | luck/year）专用接口基础地址
    /// <para>与 <see cref="ApiUrl"/>（老 48 个接口）分开配置，因上游域名/协议不同。</para>
    /// <para>典型值：<c>https://go.xingpan.vip/astrology/</c>。</para>
    /// </summary>
    public string LuckApiUrl { get; set; }

    /// <summary>
    /// 运势（luck/day | luck/weeks | luck/moon | luck/year）专用默认 AccessToken（最低优先级 P3）
    /// <para>与 <see cref="AccessToken"/>（老 48 个接口）分开；典型值由 <c>doc/xingpan_api_docs.md</c> 中的测试 token 决定。</para>
    /// </summary>
    public string LuckAccessToken { get; set; }
}
