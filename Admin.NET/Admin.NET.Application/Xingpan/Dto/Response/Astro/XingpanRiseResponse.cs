// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

namespace Admin.NET.Application;

/// <summary>
/// 日出日落 响应
/// <para>对应接口：<c>astro/rise</c>。</para>
/// <para>上游 data 字段为不固定结构，常见键：</para>
/// <list type="bullet">
///   <item>sunrise / sunset：日出日落时间</item>
///   <item>civil_twilight_begin / civil_twilight_end：民用晨昏</item>
///   <item>nautical_twilight_begin / nautical_twilight_end：航海晨昏</item>
///   <item>astronomical_twilight_begin / astronomical_twilight_end：天文晨昏</item>
///   <item>date：对应日期</item>
/// </list>
/// </summary>
public class XingpanRiseResponse : Dictionary<string, object>
{
}
