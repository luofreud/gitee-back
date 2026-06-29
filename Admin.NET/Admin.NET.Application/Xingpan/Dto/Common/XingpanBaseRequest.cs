// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

namespace Admin.NET.Application;

/// <summary>
/// 星盘接口请求基类，所有 48 个接口的 Request DTO 均派生自本类。
/// <para>注意：<c>access_token</c> 字段不在此处声明，<see cref="XingpanHttpClient"/> 会在发送请求前按以下优先级自动注入：</para>
/// <list type="number">
///   <item>方法参数 <c>overrideAccessToken</c>（最高优先级）</item>
///   <item>系统参数表 sys_config 中 <c>Code = "xingpan_access_token"</c> 的 Value</item>
///   <item><c>XingpanOptions.AccessToken</c>（最低优先级，来源于 Configuration/Xingpan.json）</item>
/// </list>
/// <para>luck 系列（luck/day | luck/weeks | luck/moon | luck/year）走独立 token 链路：</para>
/// <list type="number">
///   <item>方法参数 <c>overrideAccessToken</c>（最高优先级）</item>
///   <item>系统参数表 sys_config 中 <c>Code = "xingpan_luck_access_token"</c> 的 Value</item>
///   <item><c>XingpanOptions.LuckAccessToken</c>（最低优先级，来源于 Configuration/Xingpan.json）</item>
/// </list>
/// </summary>
public abstract class XingpanBaseRequest
{
}
