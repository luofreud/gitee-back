// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！



namespace Admin.NET.Application;

/// <summary>
/// app 星象日历服务 🧩
/// </summary>
[ApiDescriptionSettings(ApplicationConst.AppGroupName, Name = "AppXzAstrocalendar", Order = 100)]
public partial class AppXzAstrocalendarService : IDynamicApiController, ITransient
{
    private readonly SqlSugarRepository<XzAstrocalendar> _xzAstrocalendarRep;
    private readonly XingpanHttpClient _xingpan;

    public AppXzAstrocalendarService(SqlSugarRepository<XzAstrocalendar> xzAstrocalendarRep, XingpanHttpClient xingpan)
    {
        _xzAstrocalendarRep = xzAstrocalendarRep;
        _xingpan = xingpan;
    }

    /// <summary>
    /// 获取星象日历（按日）。优先从本地缓存读取；缺失时调星盘远端拉取整月数据并填充到数据库。
    /// </summary>
    /// <param name="year">年份，如 2026</param>
    /// <param name="month">月份 1-12</param>
    /// <param name="day">日 1-31</param>
    /// <returns>指定日期的星象事件列表（按 timestamp 升序）</returns>
    [DisplayName("获取星象日历")]
    [ApiDescriptionSettings(Name = "GetCalendarByDay"), HttpGet]
    [AllowAnonymous]
    [UnitOfWork]
    public async Task<List<XzAstrocalendar>> GetCalendarByDay(
        [FromQuery] int year, [FromQuery] int month, [FromQuery] int day)
    {
        if (year < 1900 || month < 1 || month > 12 || day < 1 || day > 31)
            throw Oops.Oh(ErrorCodeEnum.D1001);

        var cached = await _xzAstrocalendarRep.AsQueryable()
            .Where(u => u.Year == year && u.Month == month && u.Day == day)
            .OrderBy(u => u.Timestamp, OrderByType.Asc)
            .ToListAsync();
        if (cached.Count > 0) return cached;

        var monthCount = await _xzAstrocalendarRep.AsQueryable()
            .Where(u => u.Year == year && u.Month == month)
            .OrderBy(u => u.Timestamp, OrderByType.Asc).CountAsync();
        if (monthCount > 0)
        {
            return [];
        }
        var resp = await _xingpan.AstroCalendarAsync(
            new XingpanAstroCalendarRequest { Year = year, Month = month });
        if (resp == null || resp.Count == 0) return new List<XzAstrocalendar>();

        var rows = resp.Adapt<List<XzAstrocalendar>>();
        foreach (var r in rows)
        {
            r.Year = year;
            r.Month = month;
        }

        var storage = _xzAstrocalendarRep.Context.Storageable(rows).ToStorage();
        await storage.AsInsertable.ExecuteCommandAsync();

        return await _xzAstrocalendarRep.AsQueryable()
            .Where(u => u.Year == year && u.Month == month && u.Day == day)
            .OrderBy(u => u.Timestamp, OrderByType.Asc)
            .ToListAsync();
    }

    /// <summary>
    /// 按月获取星象日历（每天取第一条）。优先从本地缓存读取；缺失时调星盘远端拉取整月数据并填充到数据库。
    /// </summary>
    /// <param name="year">年份，如 2026</param>
    /// <param name="month">月份 1-12</param>
    /// <returns>每天最早的一条星象事件（按 day 升序）</returns>
    [DisplayName("按月获取星象日历")]
    [ApiDescriptionSettings(Name = "GetCalendarByMonth"), HttpGet]
    [AllowAnonymous]
    [UnitOfWork]
    public async Task<List<XzAstrocalendar>> GetCalendarByMonth(
        [FromQuery] int year, [FromQuery] int month)
    {
        if (year < 1900 || month < 1 || month > 12)
            throw Oops.Oh(ErrorCodeEnum.D1001);

        var monthCount = await _xzAstrocalendarRep.AsQueryable()
            .Where(u => u.Year == year && u.Month == month).CountAsync();

        if (monthCount == 0)
        {
            var resp = await _xingpan.AstroCalendarAsync(
                new XingpanAstroCalendarRequest { Year = year, Month = month });
            if (resp != null && resp.Count > 0)
            {
                var rows = resp.Adapt<List<XzAstrocalendar>>();
                foreach (var r in rows) { r.Year = year; r.Month = month; }
                var storage = _xzAstrocalendarRep.Context.Storageable(rows).ToStorage();
                await storage.AsInsertable.ExecuteCommandAsync();
            }
        }

        var allRecords = await _xzAstrocalendarRep.AsQueryable()
            .Where(u => u.Year == year && u.Month == month)
            .OrderBy(u => u.Timestamp, OrderByType.Asc)
            .ToListAsync();

        return allRecords
            .GroupBy(u => u.Day)
            .Select(g => g.First())
            .OrderBy(u => u.Day)
            .ToList();
    }
}
