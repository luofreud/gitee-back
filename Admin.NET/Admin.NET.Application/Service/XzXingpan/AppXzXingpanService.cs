
namespace Admin.NET.Application;

/// <summary>
/// 星盘服务
/// </summary>
[ApiDescriptionSettings(ApplicationConst.AppGroupName, Name = "AppXzXingpan", Order = 100)]
public class AppXzXingpanService : IDynamicApiController, ITransient
{
    private readonly ISqlSugarClient _sqlSugarClient;
    private readonly XingpanHttpClient _xingpanHttpClient;

    public AppXzXingpanService(ISqlSugarClient sqlSugarClient, XingpanHttpClient xingpanHttpClient)
    {
        _sqlSugarClient = sqlSugarClient;
        _xingpanHttpClient = xingpanHttpClient;
    }

    /// <summary>
    /// 获取本命盘
    /// </summary>
    [DisplayName("获取本命盘")]
    [ApiDescriptionSettings(Name = "Natal"), HttpPost]
    [AllowAnonymous]
    public async Task<XingpanNatalResponse> Natal([FromBody] XzXingpanChartInput input)
    {
        await FillArchiveAsync(input);
        return await _xingpanHttpClient.NatalAsync(input.Adapt<XingpanNatalRequest>());
    }

    /// <summary>
    /// 获取天象盘
    /// </summary>
    [DisplayName("获取天象盘")]
    [ApiDescriptionSettings(Name = "Current"), HttpPost]
    [AllowAnonymous]
    public async Task<XingpanCurrentResponse> Current([FromBody] XzXingpanChartInput input)
    {
        await FillArchiveAsync(input);
        return await _xingpanHttpClient.CurrentAsync(input.Adapt<XingpanCurrentRequest>());
    }

    /// <summary>
    /// 获取行运盘
    /// </summary>
    [DisplayName("获取行运盘")]
    [ApiDescriptionSettings(Name = "Transit"), HttpPost]
    [AllowAnonymous]
    public async Task<XingpanTransitResponse> Transit([FromBody] XzXingpanChartInput input)
    {
        await FillArchiveAsync(input);
        return await _xingpanHttpClient.TransitAsync(input.Adapt<XingpanTransitRequest>());
    }

    /// <summary>
    /// 获取三限盘
    /// </summary>
    [DisplayName("获取三限盘")]
    [ApiDescriptionSettings(Name = "ThirdProgressed"), HttpPost]
    [AllowAnonymous]
    public async Task<XingpanThirdProgressedResponse> ThirdProgressed([FromBody] XzXingpanChartInput input)
    {
        await FillArchiveAsync(input);
        return await _xingpanHttpClient.ThirdProgressedAsync(input.Adapt<XingpanThirdProgressedRequest>());
    }

    /// <summary>
    /// 获取法达盘
    /// </summary>
    [DisplayName("获取法达盘")]
    [ApiDescriptionSettings(Name = "Developed"), HttpPost]
    [AllowAnonymous]
    public async Task<XingpanDevelopedResponse> Developed([FromBody] XzXingpanChartInput input)
    {
        await FillArchiveAsync(input);
        return await _xingpanHttpClient.DevelopedAsync(input.Adapt<XingpanDevelopedRequest>());
    }

    /// <summary>
    /// 获取次限盘
    /// </summary>
    [DisplayName("获取次限盘")]
    [ApiDescriptionSettings(Name = "SecondaryLimit"), HttpPost]
    [AllowAnonymous]
    public async Task<XingpanSecondaryLimitResponse> SecondaryLimit([FromBody] XzXingpanChartInput input)
    {
        await FillArchiveAsync(input);
        return await _xingpanHttpClient.SecondaryLimitAsync(input.Adapt<XingpanSecondaryLimitRequest>());
    }

    /// <summary>
    /// 获取三限比
    /// </summary>
    [DisplayName("获取三限比")]
    [ApiDescriptionSettings(Name = "ThirdProgressedDouble"), HttpPost]
    [AllowAnonymous]
    public async Task<XingpanThirdProgressedDoubleResponse> ThirdProgressedDouble([FromBody] XzXingpanChartInput input)
    {
        await FillArchiveAsync(input);
        return await _xingpanHttpClient.ThirdProgressedDoubleAsync(input.Adapt<XingpanThirdProgressedDoubleRequest>());
    }

    /// <summary>
    /// 获取星座语料列表
    /// </summary>
    [DisplayName("获取星座语料列表")]
    [ApiDescriptionSettings(Name = "CorpusGetList"), HttpPost]
    [AllowAnonymous]
    public async Task<XingpanCorpusGetListResponse> CorpusGetList([FromBody] XzXingpanCorpusInput input)
    {
        return await _xingpanHttpClient.CorpusGetListAsync(input);
    }

    /// <summary>
    /// 韦特塔罗占卜
    /// </summary>
    [DisplayName("韦特塔罗占卜")]
    [ApiDescriptionSettings(Name = "TarotGenerate"), HttpPost]
    [AllowAnonymous]
    public async Task<XingpanTarotGenerateResponse> TarotGenerate([FromBody] XzXingpanTarotGenerateInput input)
    {
        return await _xingpanHttpClient.TarotGenerateAsync(input);
    }

    /// <summary>
    /// 骰子占卜
    /// </summary>
    [DisplayName("骰子占卜")]
    [ApiDescriptionSettings(Name = "DiceGenerate"), HttpPost]
    [AllowAnonymous]
    public async Task<XingpanDiceGenerateResponse> DiceGenerate()
    {
        return await _xingpanHttpClient.DiceGenerateAsync(new XingpanDiceGenerateRequest());
    }

    /// <summary>
    /// 获取组合盘
    /// </summary>
    [DisplayName("获取组合盘")]
    [ApiDescriptionSettings(Name = "Composite"), HttpPost]
    [AllowAnonymous]
    public async Task<XingpanCompositeResponse> Composite([FromBody] XzXingpanCompositeInput input)
    {
        var archives = await _sqlSugarClient.Queryable<XzArchive>()
            .Where(a => a.Id == input.ArchiveId1 || a.Id == input.ArchiveId2)
            .ToListAsync();

        var a1 = archives.FirstOrDefault(a => a.Id == input.ArchiveId1)
                 ?? throw Oops.Oh(ErrorCodeEnum.D1002);
        var a2 = archives.FirstOrDefault(a => a.Id == input.ArchiveId2)
                 ?? throw Oops.Oh(ErrorCodeEnum.D1002);

        var request = input.Adapt<XingpanCompositeRequest>();

        var userList = new Dictionary<string, XingpanUserListItem>
        {
            ["0"] = new() { Longitude = a1.addresslong, Latitude = a1.addresslat, Tz = a1.timezone, Birthday = a1.birthday },
            ["1"] = new() { Longitude = a2.addresslong, Latitude = a2.addresslat, Tz = a2.timezone, Birthday = a2.birthday }
        };

        request.UserList = userList;
        return await _xingpanHttpClient.CompositeAsync(request);
    }

    /// <summary>
    /// 获取日返照盘
    /// </summary>
    [DisplayName("获取日返照盘")]
    [ApiDescriptionSettings(Name = "SolarReturn"), HttpPost]
    [AllowAnonymous]
    public async Task<XingpanSolarReturnResponse> SolarReturn([FromBody] XzXingpanCompositeInput input)
    {
        var archives = await _sqlSugarClient.Queryable<XzArchive>()
            .Where(a => a.Id == input.ArchiveId1 || a.Id == input.ArchiveId2)
            .ToListAsync();

        var a1 = archives.FirstOrDefault(a => a.Id == input.ArchiveId1)
                 ?? throw Oops.Oh(ErrorCodeEnum.D1002);
        var a2 = archives.FirstOrDefault(a => a.Id == input.ArchiveId2)
                 ?? throw Oops.Oh(ErrorCodeEnum.D1002);

        var request = input.Adapt<XingpanSolarReturnRequest>();
        request.UserList = new Dictionary<string, XingpanUserListItem>
        {
            ["0"] = new() { Longitude = a1.addresslong, Latitude = a1.addresslat, Tz = a1.timezone, Birthday = a1.birthday },
            ["1"] = new() { Longitude = a2.addresslong, Latitude = a2.addresslat, Tz = a2.timezone, Birthday = a2.birthday }
        };

        return await _xingpanHttpClient.SolarReturnAsync(request);
    }

    /// <summary>
    /// 获取月返照盘
    /// </summary>
    [DisplayName("获取月返照盘")]
    [ApiDescriptionSettings(Name = "LunarReturn"), HttpPost]
    [AllowAnonymous]
    public async Task<XingpanLunarReturnResponse> LunarReturn([FromBody] XzXingpanCompositeInput input)
    {
        var archives = await _sqlSugarClient.Queryable<XzArchive>()
            .Where(a => a.Id == input.ArchiveId1 || a.Id == input.ArchiveId2)
            .ToListAsync();

        var a1 = archives.FirstOrDefault(a => a.Id == input.ArchiveId1)
                 ?? throw Oops.Oh(ErrorCodeEnum.D1002);
        var a2 = archives.FirstOrDefault(a => a.Id == input.ArchiveId2)
                 ?? throw Oops.Oh(ErrorCodeEnum.D1002);

        var request = input.Adapt<XingpanLunarReturnRequest>();
        request.UserList = new Dictionary<string, XingpanUserListItem>
        {
            ["0"] = new() { Longitude = a1.addresslong, Latitude = a1.addresslat, Tz = a1.timezone, Birthday = a1.birthday },
            ["1"] = new() { Longitude = a2.addresslong, Latitude = a2.addresslat, Tz = a2.timezone, Birthday = a2.birthday }
        };

        return await _xingpanHttpClient.LunarReturnAsync(request);
    }

    /// <summary>
    /// 获取日运（今日运势）
    /// <para>转发到上游 <c>https://go.xingpan.vip/astrology/luck/day</c>。</para>
    /// </summary>
    [DisplayName("获取日运")]
    [ApiDescriptionSettings(Name = "LuckDay"), HttpPost]
    [AllowAnonymous]
    public async Task<XingpanLuckDayResponse> LuckDay([FromBody] XzXingpanLuckInput input)
    {
        await FillArchiveAsync(input);
        return await _xingpanHttpClient.LuckDayAsync(input.Adapt<XingpanLuckDayRequest>());
    }

    /// <summary>
    /// 获取周运（本周运势）
    /// <para>转发到上游 <c>https://go.xingpan.vip/astrology/luck/weeks</c>。</para>
    /// </summary>
    [DisplayName("获取周运")]
    [ApiDescriptionSettings(Name = "LuckWeeks"), HttpPost]
    [AllowAnonymous]
    public async Task<XingpanLuckWeeksResponse> LuckWeeks([FromBody] XzXingpanLuckInput input)
    {
        await FillArchiveAsync(input);
        return await _xingpanHttpClient.LuckWeeksAsync(input.Adapt<XingpanLuckWeeksRequest>());
    }

    /// <summary>
    /// 获取月运（本月运势）
    /// <para>转发到上游 <c>https://go.xingpan.vip/astrology/luck/moon</c>。</para>
    /// </summary>
    [DisplayName("获取月运")]
    [ApiDescriptionSettings(Name = "LuckMoon"), HttpPost]
    [AllowAnonymous]
    public async Task<XingpanLuckMoonResponse> LuckMoon([FromBody] XzXingpanLuckInput input)
    {
        await FillArchiveAsync(input);
        return await _xingpanHttpClient.LuckMoonAsync(input.Adapt<XingpanLuckMoonRequest>());
    }

    /// <summary>
    /// 获取年运（本年运势）
    /// <para>转发到上游 <c>https://go.xingpan.vip/astrology/luck/year</c>。</para>
    /// </summary>
    [DisplayName("获取年运")]
    [ApiDescriptionSettings(Name = "LuckYear"), HttpPost]
    [AllowAnonymous]
    public async Task<XingpanLuckYearResponse> LuckYear([FromBody] XzXingpanLuckInput input)
    {
        await FillArchiveAsync(input);
        return await _xingpanHttpClient.LuckYearAsync(input.Adapt<XingpanLuckYearRequest>());
    }

    private async Task FillArchiveAsync(XzXingpanChartInput input)
    {
        if (input.ArchiveId is not > 0) return;

        var archive = await _sqlSugarClient.Queryable<XzArchive>()
            .FirstAsync(a => a.Id == input.ArchiveId.Value);
        if (archive == null)
            throw Oops.Oh(ErrorCodeEnum.D1002);

        input.Longitude = archive.addresslong;
        input.Latitude = archive.addresslat;
        input.Tz = archive.timezone;
        input.Birthday = archive.birthday;
    }

    private async Task FillArchiveAsync(XzXingpanLuckInput input)
    {
        if (input.ArchiveId is not > 0) return;

        var archive = await _sqlSugarClient.Queryable<XzArchive>()
            .FirstAsync(a => a.Id == input.ArchiveId.Value);
        if (archive == null)
            throw Oops.Oh(ErrorCodeEnum.D1002);

        input.Longitude = archive.addresslong;
        input.Latitude = archive.addresslat;
        input.Tz = archive.timezone;
        input.Birthday = archive.birthday;
    }
}
