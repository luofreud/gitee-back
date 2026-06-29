// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

namespace Admin.NET.Application;

/// <summary>
/// 星盘接口业务错误码常量（与上游文档 1:1 对应），仅用于在 <c>code</c> 字段中比对。
/// <para>典型错误码段位：</para>
/// <list type="bullet">
///   <item>10xxxxx：access_token / 通用参数错误</item>
///   <item>101xxxx：账号 / 验证码</item>
///   <item>106xxxx：日期 / 地区 / 宫位 / 行星 / 计数 等业务校验</item>
/// </list>
/// </summary>
public static class XingpanApiError
{
    /// <summary>成功</summary>
    public const int Success = 0;

    /// <summary>access_token 无效或未提供</summary>
    public const int AccessTokenInvalid = 1000001;

    /// <summary>调用过于频繁</summary>
    public const int AccessTokenFrequent = 1000002;

    /// <summary>access_token 调用次数受限</summary>
    public const int AccessTokenLimited = 1000003;

    /// <summary>请求路径不存在</summary>
    public const int PathInvalid = 1000006;

    /// <summary>关键字段为空</summary>
    public const int FieldEmpty = 1000007;

    /// <summary>用户 token 为空</summary>
    public const int UserTokenEmpty = 1000008;

    /// <summary>星座 ID 非法</summary>
    public const int SignInvalid = 1000009;

    /// <summary>用户未登录</summary>
    public const int NotLoggedIn = 1000010;

    /// <summary>账号被拉黑</summary>
    public const int Blacklisted = 1000011;

    /// <summary>密码错误</summary>
    public const int PasswordWrong = 1010001;

    /// <summary>用户或验证码为空</summary>
    public const int UserOrCodeEmpty = 1010002;

    /// <summary>注册失败</summary>
    public const int RegisterFailed = 1010003;

    /// <summary>旧/新密码为空</summary>
    public const int OldOrNewPasswordEmpty = 1010004;

    /// <summary>密码更新失败</summary>
    public const int PasswordUpdateFailed = 1010005;

    /// <summary>短信验证码错误</summary>
    public const int SmsCodeWrong = 1010007;

    /// <summary>日期为空</summary>
    public const int DateEmpty = 1060001;

    /// <summary>地区（经纬度）为空</summary>
    public const int RegionEmpty = 1060002;

    /// <summary>宫位为空</summary>
    public const int HouseEmpty = 1060003;

    /// <summary>行星为空</summary>
    public const int PlanetEmpty = 1060004;

    /// <summary>计数非法</summary>
    public const int CountInvalid = 1060005;

    /// <summary>太阳数据缺失</summary>
    public const int SunEmpty = 1060006;

    /// <summary>月亮数据缺失</summary>
    public const int MoonEmpty = 1060007;

    /// <summary>行运时间过小（早于出生时间）</summary>
    public const int TransitTimeTooSmall = 1060008;
}
