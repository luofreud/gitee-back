// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Admin.NET.Core.Service;
using Furion.FriendlyException;
using Furion.HttpRemote;
using Microsoft.Extensions.Options;
using Newtonsoft.Json;
using System.Reflection;
using System.Text;

namespace Admin.NET.Application;

/// <summary>
/// 星盘（xingpan.vip）接口 HTTP 客户端，封装 48 个老接口 + 4 个 luck 系列接口的请求 / 响应。
/// <para>采用 <see cref="ITransient"/> 注入到 DI 容器；<strong>不对外暴露为 API 接口</strong>，仅供业务 Service / Job 内部调用。</para>
/// <para>AccessToken 解析优先级（从高到低）— 通用链路：</para>
/// <list type="number">
///   <item>方法参数 <c>overrideAccessToken</c></item>
///   <item>SysConfig <c>Code = xingpan_access_token</c> 的 Value（<see cref="SysConfigService.GetConfigValue{T}"/>，带缓存）</item>
///   <item><see cref="XingpanOptions.AccessToken"/>（Configuration/Xingpan.json）</item>
/// </list>
/// <para>AccessToken 解析优先级（从高到低）— luck 链路（仅 luck/day | luck/weeks | luck/moon | luck/year 走此链路）：</para>
/// <list type="number">
///   <item>方法参数 <c>overrideAccessToken</c></item>
///   <item>SysConfig <c>Code = xingpan_luck_access_token</c> 的 Value</item>
///   <item><see cref="XingpanOptions.LuckAccessToken"/>（Configuration/Xingpan.json）</item>
/// </list>
/// <para>所有方法在 <c>code != 0</c> 时统一抛 <see cref="Oops"/> 异常，msg 直接来自上游。</para>
/// </summary>
public class XingpanHttpClient : ITransient
{
    private readonly IHttpRemoteService _httpRemoteService;
    private readonly XingpanOptions _options;
    private readonly SysConfigService _sysConfigService;

    private static readonly JsonSerializerSettings JsonSettings = new()
    {
        NullValueHandling = NullValueHandling.Ignore,
        DateFormatString = "yyyy-MM-dd HH:mm:ss",
    };

    public XingpanHttpClient(
        IHttpRemoteService httpRemoteService,
        IOptions<XingpanOptions> options,
        SysConfigService sysConfigService)
    {
        _httpRemoteService = httpRemoteService;
        _options = options.Value;
        _sysConfigService = sysConfigService;
    }

    #region 通用 Common（3）

    /// <summary>
    /// <c>common/planetconfig</c> 获取星盘全局配置
    /// <para>返回行星 / 星座字典、相位字典等，初始化客户端时常调用一次。</para>
    /// </summary>
    public Task<XingpanPlanetConfigResponse> PlanetConfigAsync(XingpanPlanetConfigRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanPlanetConfigRequest, XingpanPlanetConfigResponse>("common/planetconfig", request, overrideAccessToken, ct);

    /// <summary>
    /// <c>article/details</c> 获取文章详情
    /// <para>按标题模糊匹配，常用于"星座百科 / 运势科普"类文章查询。</para>
    /// </summary>
    public Task<XingpanArticleDetailsResponse> ArticleDetailsAsync(XingpanArticleDetailsRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanArticleDetailsRequest, XingpanArticleDetailsResponse>("article/details", request, overrideAccessToken, ct);

    /// <summary>
    /// <c>chart/timezone</c> 计算指定地点 / 时间的真太阳时与夏令时
    /// <para>常在生时校正步骤中调用，确定 tz 与真实出生时间。</para>
    /// </summary>
    public Task<XingpanTimezoneResponse> TimezoneAsync(XingpanTimezoneRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanTimezoneRequest, XingpanTimezoneResponse>("chart/timezone", request, overrideAccessToken, ct);

    #endregion 通用 Common

    #region 星盘 Chart（24）

    /// <summary>
    /// <c>chart/natal</c> 本命盘
    /// <para>单人出生星盘，星盘类接口的入口；返回行星落座、落宫、相位等核心数据。</para>
    /// </summary>
    public Task<XingpanNatalResponse> NatalAsync(XingpanNatalRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanNatalRequest, XingpanNatalResponse>("chart/natal", request, overrideAccessToken, ct);

    /// <summary>
    /// <c>chart/timesmidpoint</c> 时空盘
    /// <para>按两人出生时间 / 地点的中点构成的虚拟盘，分析关系的时间维度。</para>
    /// </summary>
    public Task<XingpanTimesmidpointResponse> TimesmidpointAsync(XingpanTimesmidpointRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanTimesmidpointRequest, XingpanTimesmidpointResponse>("chart/timesmidpoint", request, overrideAccessToken, ct);

    /// <summary>
    /// <c>chart/comparision</c> 比较盘
    /// <para>把 A 的行星叠加到 B 的盘上分析两人互动，data.extra 中会含 planet_second。</para>
    /// </summary>
    public Task<XingpanComparisionResponse> ComparisionAsync(XingpanComparisionRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanComparisionRequest, XingpanComparisionResponse>("chart/comparision", request, overrideAccessToken, ct);

    /// <summary>
    /// <c>chart/marks</c> 马克思盘
    /// <para>使用两人中点位置构盘，分析"关系本身"而非个人。</para>
    /// </summary>
    public Task<XingpanMarksResponse> MarksAsync(XingpanMarksRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanMarksRequest, XingpanMarksResponse>("chart/marks", request, overrideAccessToken, ct);

    /// <summary>
    /// <c>chart/thirdprogressed</c> 三限盘
    /// <para>把出生图按"1 天 = 1 月"推进到 transitday 时刻。</para>
    /// </summary>
    public Task<XingpanThirdProgressedResponse> ThirdProgressedAsync(XingpanThirdProgressedRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanThirdProgressedRequest, XingpanThirdProgressedResponse>("chart/thirdprogressed", request, overrideAccessToken, ct);

    /// <summary>
    /// <c>chart/solarreturn</c> 日返照
    /// <para>太阳回到出生时黄经的瞬间所生成的星盘，每年一张；user_list["1"] 为返照所在地。</para>
    /// </summary>
    public Task<XingpanSolarReturnResponse> SolarReturnAsync(XingpanSolarReturnRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanSolarReturnRequest, XingpanSolarReturnResponse>("chart/solarreturn", request, overrideAccessToken, ct);

    /// <summary>
    /// <c>chart/lunarreturn</c> 月返照
    /// <para>月亮回到出生时黄经的瞬间所生成的星盘，每月一张。</para>
    /// </summary>
    public Task<XingpanLunarReturnResponse> LunarReturnAsync(XingpanLunarReturnRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanLunarReturnRequest, XingpanLunarReturnResponse>("chart/lunarreturn", request, overrideAccessToken, ct);

    /// <summary>
    /// <c>chart/synastry</c> 配对盘
    /// <para>将两人本命盘叠加分析行星间的相位互动，data.extra 中包含 planet_second。</para>
    /// </summary>
    public Task<XingpanSynastryResponse> SynastryAsync(XingpanSynastryRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanSynastryRequest, XingpanSynastryResponse>("chart/synastry", request, overrideAccessToken, ct);

    /// <summary>
    /// <c>chart/progressed</c> 推进盘
    /// <para>符号推进：1 天 = 1 年，每年推 1 天。</para>
    /// </summary>
    public Task<XingpanProgressedResponse> ProgressedAsync(XingpanProgressedRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanProgressedRequest, XingpanProgressedResponse>("chart/progressed", request, overrideAccessToken, ct);

    /// <summary>
    /// <c>chart/secondarylimit</c> 次限盘
    /// <para>最常用的"推运"方法：1 天 = 1 年。</para>
    /// </summary>
    public Task<XingpanSecondaryLimitResponse> SecondaryLimitAsync(XingpanSecondaryLimitRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanSecondaryLimitRequest, XingpanSecondaryLimitResponse>("chart/secondarylimit", request, overrideAccessToken, ct);

    /// <summary>
    /// <c>chart/transit</c> 行运盘
    /// <para>把 transitday 时刻的天空叠加到本命盘上，看当下星象对命主的影响；transitday 必须晚于 birthday。</para>
    /// </summary>
    public Task<XingpanTransitResponse> TransitAsync(XingpanTransitRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanTransitRequest, XingpanTransitResponse>("chart/transit", request, overrideAccessToken, ct);

    /// <summary>
    /// <c>chart/composite</c> 组合盘
    /// <para>按两人本命中点构盘，常用于关系分析。</para>
    /// </summary>
    public Task<XingpanCompositeResponse> CompositeAsync(XingpanCompositeRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanCompositeRequest, XingpanCompositeResponse>("chart/composite", request, overrideAccessToken, ct);

    /// <summary>
    /// <c>chart/solararc</c> 太阳弧推运
    /// <para>将所有行星按太阳推进的弧度（通常 1 年 ≈ 1°）旋转。</para>
    /// </summary>
    public Task<XingpanSolarArcResponse> SolarArcAsync(XingpanSolarArcRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanSolarArcRequest, XingpanSolarArcResponse>("chart/solararc", request, overrideAccessToken, ct);

    /// <summary>
    /// <c>chart/compositeSecondary</c> 组合次限
    /// <para>对组合盘再叠加次限推运，看"某时点"的关系状态。</para>
    /// </summary>
    public Task<XingpanCompositeSecondaryResponse> CompositeSecondaryAsync(XingpanCompositeSecondaryRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanCompositeSecondaryRequest, XingpanCompositeSecondaryResponse>("chart/compositeSecondary", request, overrideAccessToken, ct);

    /// <summary>
    /// <c>chart/compositeThirprogr</c> 组合三限
    /// <para>对组合盘再叠加三限推运。</para>
    /// </summary>
    public Task<XingpanCompositeThirprogrResponse> CompositeThirprogrAsync(XingpanCompositeThirprogrRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanCompositeThirprogrRequest, XingpanCompositeThirprogrResponse>("chart/compositeThirprogr", request, overrideAccessToken, ct);

    /// <summary>
    /// <c>chart/timesmidpointSecprogr</c> 时空次限
    /// <para>对时空盘叠加次限推运。</para>
    /// </summary>
    public Task<XingpanTimesmidpointSecprogrResponse> TimesmidpointSecprogrAsync(XingpanTimesmidpointSecprogrRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanTimesmidpointSecprogrRequest, XingpanTimesmidpointSecprogrResponse>("chart/timesmidpointSecprogr", request, overrideAccessToken, ct);

    /// <summary>
    /// <c>chart/timesmidpointThirprogr</c> 时空三限
    /// <para>对时空盘叠加三限推运。</para>
    /// </summary>
    public Task<XingpanTimesmidpointThirprogrResponse> TimesmidpointThirprogrAsync(XingpanTimesmidpointThirprogrRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanTimesmidpointThirprogrRequest, XingpanTimesmidpointThirprogrResponse>("chart/timesmidpointThirprogr", request, overrideAccessToken, ct);

    /// <summary>
    /// <c>chart/marksSecprogr</c> 马盘次限
    /// <para>对马盘（马克思盘）叠加次限推运。</para>
    /// </summary>
    public Task<XingpanMarksSecprogrResponse> MarksSecprogrAsync(XingpanMarksSecprogrRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanMarksSecprogrRequest, XingpanMarksSecprogrResponse>("chart/marksSecprogr", request, overrideAccessToken, ct);

    /// <summary>
    /// <c>chart/marksThirprogr</c> 马盘三限
    /// <para>对马盘叠加三限推运。</para>
    /// </summary>
    public Task<XingpanMarksThirprogrResponse> MarksThirprogrAsync(XingpanMarksThirprogrRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanMarksThirprogrRequest, XingpanMarksThirprogrResponse>("chart/marksThirprogr", request, overrideAccessToken, ct);

    /// <summary>
    /// <c>chart/developed</c> 法达盘
    /// <para>按本命行星主限 / 子限划分人生大运周期。</para>
    /// </summary>
    public Task<XingpanDevelopedResponse> DevelopedAsync(XingpanDevelopedRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanDevelopedRequest, XingpanDevelopedResponse>("chart/developed", request, overrideAccessToken, ct);

    /// <summary>
    /// <c>chart/smalllimit</c> 小限盘
    /// <para>每年使用对应星座作为 1 宫起点，每年 1 宫。</para>
    /// </summary>
    public Task<XingpanSmallLimitResponse> SmallLimitAsync(XingpanSmallLimitRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanSmallLimitRequest, XingpanSmallLimitResponse>("chart/smalllimit", request, overrideAccessToken, ct);

    /// <summary>
    /// <c>chart/nataltwelvepointer</c> 十二分盘
    /// <para>在原盘基础上旋转 30°（1/12 圈）形成新盘。</para>
    /// </summary>
    public Task<XingpanNatalTwelvePointerResponse> NatalTwelvePointerAsync(XingpanNatalTwelvePointerRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanNatalTwelvePointerRequest, XingpanNatalTwelvePointerResponse>("chart/nataltwelvepointer", request, overrideAccessToken, ct);

    /// <summary>
    /// <c>chart/natalthirteenpointer</c> 十三分盘
    /// <para>在原盘基础上旋转约 27.69°（1/13 圈）形成新盘。</para>
    /// </summary>
    public Task<XingpanNatalThirteenPointerResponse> NatalThirteenPointerAsync(XingpanNatalThirteenPointerRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanNatalThirteenPointerRequest, XingpanNatalThirteenPointerResponse>("chart/natalthirteenpointer", request, overrideAccessToken, ct);

    /// <summary>
    /// <c>chart/current</c> 天象盘
    /// <para>当前天空叠加到本命盘上查看实时星象对命主的影响；is_corpus=1 时附带语料。</para>
    /// </summary>
    public Task<XingpanCurrentResponse> CurrentAsync(XingpanCurrentRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanCurrentRequest, XingpanCurrentResponse>("chart/current", request, overrideAccessToken, ct);

    #endregion 星盘 Chart

    #region 比较 Compare（4）

    /// <summary>
    /// <c>chart/secondarylimitdouble</c> 次限比
    /// <para>在次限推运盘上叠加另一时点，对比同一命主不同次限版本。</para>
    /// </summary>
    public Task<XingpanSecondaryLimitDoubleResponse> SecondaryLimitDoubleAsync(XingpanSecondaryLimitDoubleRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanSecondaryLimitDoubleRequest, XingpanSecondaryLimitDoubleResponse>("chart/secondarylimitdouble", request, overrideAccessToken, ct);

    /// <summary>
    /// <c>chart/thirdprogresseddouble</c> 三限比
    /// <para>对三限推运盘叠加另一时点。</para>
    /// </summary>
    public Task<XingpanThirdProgressedDoubleResponse> ThirdProgressedDoubleAsync(XingpanThirdProgressedDoubleRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanThirdProgressedDoubleRequest, XingpanThirdProgressedDoubleResponse>("chart/thirdprogresseddouble", request, overrideAccessToken, ct);

    /// <summary>
    /// <c>chart/solarreturndouble</c> 日返比
    /// <para>对比两张不同的日返照盘（同命主不同年份）。</para>
    /// </summary>
    public Task<XingpanSolarReturnDoubleResponse> SolarReturnDoubleAsync(XingpanSolarReturnDoubleRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanSolarReturnDoubleRequest, XingpanSolarReturnDoubleResponse>("chart/solarreturndouble", request, overrideAccessToken, ct);

    /// <summary>
    /// <c>chart/lunarreturndouble</c> 月返比
    /// <para>对比两张不同的月返照盘。</para>
    /// </summary>
    public Task<XingpanLunarReturnDoubleResponse> LunarReturnDoubleAsync(XingpanLunarReturnDoubleRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanLunarReturnDoubleRequest, XingpanLunarReturnDoubleResponse>("chart/lunarreturndouble", request, overrideAccessToken, ct);

    #endregion 比较 Compare

    #region 天文工具 Astro（7）

    /// <summary>
    /// <c>chart/aphesis</c> 小限相位
    /// <para>按指定星体（小限主星）逐年推运并计算与本命行星的相位。</para>
    /// </summary>
    public Task<XingpanAphesisResponse> AphesisAsync(XingpanAphesisRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanAphesisRequest, XingpanAphesisResponse>("chart/aphesis", request, overrideAccessToken, ct);

    /// <summary>
    /// <c>chart/rise</c> 日出日落
    /// <para>查询指定地点未来 n 天的日出日落与天文晨昏时间。</para>
    /// </summary>
    public Task<XingpanRiseResponse> RiseAsync(XingpanRiseRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanRiseRequest, XingpanRiseResponse>("chart/rise", request, overrideAccessToken, ct);

    /// <summary>
    /// <c>sign/ephemeris</c> 星历表
    /// <para>返回指定时间区间内每天 10 颗主行星的黄经位置，建议跨度不超过 31 天。</para>
    /// </summary>
    public Task<XingpanEphemerisResponse> EphemerisAsync(XingpanEphemerisRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanEphemerisRequest, XingpanEphemerisResponse>("sign/ephemeris", request, overrideAccessToken, ct);

    /// <summary>
    /// <c>sign/astrocalendar</c> 天文日历
    /// <para>返回指定年月的日月食、合月、季节等关键天文事件。</para>
    /// </summary>
    public Task<XingpanAstroCalendarResponse> AstroCalendarAsync(XingpanAstroCalendarRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanAstroCalendarRequest, XingpanAstroCalendarResponse>("sign/astrocalendar", request, overrideAccessToken, ct);

    /// <summary>
    /// <c>chart/signpush</c> 星座推运
    /// <para>从指定星座出发按 unit（year/month）逐年推运的行星位置。</para>
    /// </summary>
    public Task<XingpanSignPushResponse> SignPushAsync(XingpanSignPushRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanSignPushRequest, XingpanSignPushResponse>("chart/signpush", request, overrideAccessToken, ct);

    /// <summary>
    /// <c>sign/moonphase</c> 月相
    /// <para>返回指定年月的所有月相时间（新月 / 上弦 / 满月 / 下弦）。</para>
    /// </summary>
    public Task<XingpanMoonPhaseResponse> MoonPhaseAsync(XingpanMoonPhaseRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanMoonPhaseRequest, XingpanMoonPhaseResponse>("sign/moonphase", request, overrideAccessToken, ct);

    /// <summary>
    /// <c>chart/westernHost</c> 西方宫主星（28 星宿）
    /// <para>按本命盘查询每宫宫主星及其落座宫位（上游文档标题写为 28 星宿，实际返回西方宫主星数据）。</para>
    /// </summary>
    public Task<XingpanWesternHostResponse> WesternHostAsync(XingpanWesternHostRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanWesternHostRequest, XingpanWesternHostResponse>("chart/westernHost", request, overrideAccessToken, ct);

    #endregion 天文工具 Astro

    #region 占卜 Divine（3）

    /// <summary>
    /// <c>Waite/generate</c> 韦特塔罗占卜
    /// <para>随机抽取 N 张韦特牌并返回完整解读（id / title / explain / negative / work / love / friend / affection）。</para>
    /// </summary>
    public Task<XingpanTarotGenerateResponse> TarotGenerateAsync(XingpanTarotGenerateRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanTarotGenerateRequest, XingpanTarotGenerateResponse>("Waite/generate", request, overrideAccessToken, ct);

    /// <summary>
    /// <c>dice/generate</c> 骰子占卜
    /// <para>无需参数；返回三颗骰子点数及吉凶解读。</para>
    /// </summary>
    public Task<XingpanDiceGenerateResponse> DiceGenerateAsync(XingpanDiceGenerateRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanDiceGenerateRequest, XingpanDiceGenerateResponse>("dice/generate", request, overrideAccessToken, ct);

    /// <summary>
    /// <c>eightchar/get</c> 八字排盘
    /// <para>依据公历出生时间（可校真太阳时）排出四柱八字 + 大运 / 流年。</para>
    /// </summary>
    public Task<XingpanEightCharResponse> EightCharAsync(XingpanEightCharRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanEightCharRequest, XingpanEightCharResponse>("eightchar/get", request, overrideAccessToken, ct);

    #endregion 占卜 Divine

    #region 运势语料 Luck（6）

    /// <summary>
    /// <c>luck/day</c> 今日运势
    /// <para>按命主本日星象给出综合运势评分与解读。</para>
    /// <para>base URL 走 <see cref="XingpanOptions.LuckApiUrl"/>（<c>https://go.xingpan.vip/astrology/</c>），与老 48 个接口的 <c>www.xingpan.vip</c> 域名/协议不同。</para>
    /// <para>token 走 luck 链路：method override &gt; SysConfig(<c>xingpan_luck_access_token</c>) &gt; <see cref="XingpanOptions.LuckAccessToken"/>。</para>
    /// </summary>
    public Task<XingpanLuckDayResponse> LuckDayAsync(XingpanLuckDayRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanLuckDayRequest, XingpanLuckDayResponse>("luck/day", request, overrideAccessToken, ct, _options.LuckApiUrl, useLuckToken: true);

    /// <summary>
    /// <c>luck/moon</c> 本月运势
    /// <para>按命主本月星象给出综合运势。</para>
    /// <para>base URL 走 <see cref="XingpanOptions.LuckApiUrl"/>（<c>https://go.xingpan.vip/astrology/</c>），与老 48 个接口的 <c>www.xingpan.vip</c> 域名/协议不同。</para>
    /// <para>token 走 luck 链路：method override &gt; SysConfig(<c>xingpan_luck_access_token</c>) &gt; <see cref="XingpanOptions.LuckAccessToken"/>。</para>
    /// </summary>
    public Task<XingpanLuckMoonResponse> LuckMoonAsync(XingpanLuckMoonRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanLuckMoonRequest, XingpanLuckMoonResponse>("luck/moon", request, overrideAccessToken, ct, _options.LuckApiUrl, useLuckToken: true);

    /// <summary>
    /// <c>luck/weeks</c> 本年逐周运势
    /// <para>按命主本年星象给出 52 周运势曲线。</para>
    /// <para>base URL 走 <see cref="XingpanOptions.LuckApiUrl"/>（<c>https://go.xingpan.vip/astrology/</c>），与老 48 个接口的 <c>www.xingpan.vip</c> 域名/协议不同。</para>
    /// <para>token 走 luck 链路：method override &gt; SysConfig(<c>xingpan_luck_access_token</c>) &gt; <see cref="XingpanOptions.LuckAccessToken"/>。</para>
    /// </summary>
    public Task<XingpanLuckWeeksResponse> LuckWeeksAsync(XingpanLuckWeeksRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanLuckWeeksRequest, XingpanLuckWeeksResponse>("luck/weeks", request, overrideAccessToken, ct, _options.LuckApiUrl, useLuckToken: true);

    /// <summary>
    /// <c>luck/year</c> 本年运势
    /// <para>按命主本年星象给出年度运势综述。</para>
    /// <para>base URL 走 <see cref="XingpanOptions.LuckApiUrl"/>（<c>https://go.xingpan.vip/astrology/</c>），与老 48 个接口的 <c>www.xingpan.vip</c> 域名/协议不同。</para>
    /// <para>token 走 luck 链路：method override &gt; SysConfig(<c>xingpan_luck_access_token</c>) &gt; <see cref="XingpanOptions.LuckAccessToken"/>。</para>
    /// </summary>
    public Task<XingpanLuckYearResponse> LuckYearAsync(XingpanLuckYearRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanLuckYearRequest, XingpanLuckYearResponse>("luck/year", request, overrideAccessToken, ct, _options.LuckApiUrl, useLuckToken: true);

    /// <summary>
    /// <c>evaluationcombination/add</c> 组合评测
    /// <para>按双人关系 + type（1今日/2本周/3本月/4本年）给出组合评测。</para>
    /// </summary>
    public Task<XingpanEvaluationCombinationResponse> EvaluationCombinationAsync(XingpanEvaluationCombinationRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanEvaluationCombinationRequest, XingpanEvaluationCombinationResponse>("evaluationcombination/add", request, overrideAccessToken, ct);

    /// <summary>
    /// <c>sign/corpus</c> 星座语料
    /// <para>按指定日期返回 12 星座语料（如每日一句话 / 短文）。</para>
    /// </summary>
    public Task<XingpanSignCorpusResponse> SignCorpusAsync(XingpanSignCorpusRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanSignCorpusRequest, XingpanSignCorpusResponse>("sign/corpus", request, overrideAccessToken, ct);

    #endregion 运势语料 Luck

    #region 语料 Corpus（1）

    /// <summary>
    /// <c>corpusconstellation/getlist</c> 语料星座列表
    /// <para>按 chartType（1-25） + fallInto（0/1）返回星座语料分组。</para>
    /// </summary>
    public Task<XingpanCorpusGetListResponse> CorpusGetListAsync(XingpanCorpusGetListRequest request, string overrideAccessToken = null, CancellationToken ct = default)
        => SendAsync<XingpanCorpusGetListRequest, XingpanCorpusGetListResponse>("corpusconstellation/getlist", request, overrideAccessToken, ct);

    #endregion 语料 Corpus

    #region 内部辅助

    /// <summary>
    /// 通用请求：反射序列化为 form-urlencoded → 注入 access_token → POST → 反序列化响应 → 错误码非 0 时抛 <see cref="Oops"/>。
    /// <para>所有公共方法都委托到此函数，避免重复样板代码。</para>
    /// <para><paramref name="baseUrl"/> 为可选 base URL 覆盖：默认 <c>null</c> 时回退到 <see cref="XingpanOptions.ApiUrl"/>，保持 48 个老接口零改动；
    /// luck 系列显式传入 <see cref="XingpanOptions.LuckApiUrl"/> 指向 <c>https://go.xingpan.vip/astrology/</c>。</para>
    /// <para><paramref name="useLuckToken"/> 为可选 token 链路切换：默认 <c>false</c> 时使用老 SysConfig/<see cref="XingpanOptions.AccessToken"/>；
    /// luck 系列显式传 <c>true</c> 使用 <c>xingpan_luck_access_token</c> SysConfig / <see cref="XingpanOptions.LuckAccessToken"/>。</para>
    /// </summary>
    private async Task<TResponseData> SendAsync<TRequest, TResponseData>(
        string endpoint,
        TRequest request,
        string overrideAccessToken,
        CancellationToken ct,
        string baseUrl = null,
        bool useLuckToken = false)
        where TRequest : XingpanBaseRequest
    {
        var token = await ResolveTokenAsync(overrideAccessToken, useLuckToken);
        var pairs = ToFormPairs(request);
        if (!string.IsNullOrWhiteSpace(token))
            pairs.Add(new KeyValuePair<string, string>("access_token", token));

        var url = (baseUrl ?? _options.ApiUrl) + endpoint;
        var formContent = new FormUrlEncodedContent(pairs);
        var raw = await _httpRemoteService.PostAsStringAsync(url, builder =>
        {
            builder.SetContent(formContent);
        }, ct);

        XingpanResponse<TResponseData> wrapped;
        try
        {
            wrapped = JsonConvert.DeserializeObject<XingpanResponse<TResponseData>>(raw, JsonSettings);
        }
        catch (JsonException)
        {
            throw Oops.Bah($"星盘接口 {endpoint} 响应格式异常，请检查请求参数：{raw}");
        }

        if (wrapped == null || wrapped.Code != 0)
        {
            var code = wrapped?.Code ?? -1;
            var msg = wrapped?.Msg ?? "上游响应为空";
            throw Oops.Bah($"星盘接口 {endpoint} 调用失败：code={code}, msg={msg}");
        }

        return wrapped.Data;
    }

    /// <summary>
    /// 反射读取请求 DTO 的所有属性，展平为 form-urlencoded 键值对列表。
    /// <para>字段名优先取 <see cref="JsonPropertyAttribute.PropertyName"/>，否则用 PascalCase 原名。</para>
    /// <para>数组/集合类型以重复键（name[]=val1&name[]=val2）发送；空字符串跳过。</para>
    /// </summary>
    private static List<KeyValuePair<string, string>> ToFormPairs<T>(T request)
        where T : XingpanBaseRequest
    {
        var pairs = new List<KeyValuePair<string, string>>();
        foreach (var prop in typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance))
        {
            if (prop.GetIndexParameters().Length > 0 || !prop.CanRead) continue;
            var value = prop.GetValue(request);
            if (value == null) continue;
            var name = prop.GetCustomAttribute<JsonPropertyAttribute>()?.PropertyName ?? prop.Name;
            switch (value)
            {
                case string s:
                    if (!string.IsNullOrEmpty(s))
                        pairs.Add(new KeyValuePair<string, string>(name, s));
                    break;
                case bool b:
                    pairs.Add(new KeyValuePair<string, string>(name, b ? "1" : "0"));
                    break;
                case DateTime dt:
                    pairs.Add(new KeyValuePair<string, string>(name, dt.ToString("yyyy-MM-dd HH:mm:ss")));
                    break;
                case System.Collections.IDictionary dict:
                    foreach (System.Collections.DictionaryEntry entry in dict)
                    {
                        if (entry.Value == null) continue;
                        var prefix = $"{name}[{entry.Key}]";
                        FlattenObject(entry.Value, prefix, pairs);
                    }
                    break;
                case System.Collections.IEnumerable en:
                    var arrKey = name + "[]";
                    foreach (var item in en)
                    {
                        if (item == null) continue;
                        pairs.Add(new KeyValuePair<string, string>(arrKey, item.ToString()));
                    }
                    break;
                default:
                    pairs.Add(new KeyValuePair<string, string>(name, value.ToString()));
                    break;
            }
        }
        return pairs;
    }

    /// <summary>
    /// 递归展平对象属性到 form-urlencoded 键值对。
    /// <para>string/值类型直接输出；复杂对象按属性递归，键路径为 <c>prefix[propName]</c>。</para>
    /// </summary>
    private static void FlattenObject(object value, string prefix, List<KeyValuePair<string, string>> pairs)
    {
        var type = value.GetType();
        if (type == typeof(string) || type.IsValueType)
        {
            pairs.Add(new KeyValuePair<string, string>(prefix, value.ToString()));
            return;
        }

        foreach (var prop in type.GetProperties(BindingFlags.Public | BindingFlags.Instance))
        {
            if (prop.GetIndexParameters().Length > 0 || !prop.CanRead) continue;
            var val = prop.GetValue(value);
            if (val == null) continue;
            var propName = prop.GetCustomAttribute<JsonPropertyAttribute>()?.PropertyName ?? prop.Name;
            FlattenObject(val, $"{prefix}[{propName}]", pairs);
        }
    }

    /// <summary>
    /// 解析 AccessToken：
    /// 通用链路 P1 <paramref name="overrideAccessToken"/> &gt; P2 SysConfig &gt; P3 <see cref="XingpanOptions.AccessToken"/>；
    /// 当 <paramref name="useLuckToken"/> = true 时切换为 luck 链路：P1 &gt; P2 SysConfig(<c>xingpan_luck_access_token</c>) &gt; P3 <see cref="XingpanOptions.LuckAccessToken"/>。
    /// </summary>
    private async Task<string> ResolveTokenAsync(string overrideAccessToken, bool useLuckToken = false)
    {
        if (!string.IsNullOrWhiteSpace(overrideAccessToken)) return overrideAccessToken;

        var sysCode = useLuckToken ? ConfigConst.XingpanLuckAccessToken : ConfigConst.XingpanAccessToken;
        var sysToken = await _sysConfigService.GetConfigValue<string>(sysCode);
        if (!string.IsNullOrWhiteSpace(sysToken)) return sysToken;

        return useLuckToken ? _options.LuckAccessToken : _options.AccessToken;
    }

    #endregion 内部辅助
}
