// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Admin.NET.Core;
using SqlSugar;
namespace Admin.NET.Application.Entity;

/// <summary>
/// 星象日历
/// <para>数据来源：星盘（xingpan.vip）<c>astro/astrocalendar</c> 远端接口 + 本地缓存。</para>
/// <para>同一天可能存在多个相位事件（合/冲/六合/入星座/月空结束…），由 <see cref="Type"/> 区分语义。</para>
/// </summary>
[Tenant("1300000000001")]
[SugarTable("xz_astrocalendar", "星象日历")]
[SugarIndex("uniq_xz_astrocalendar",
    nameof(Year), OrderByType.Asc,
    nameof(Month), OrderByType.Asc,
    nameof(Day), OrderByType.Asc,
    nameof(Type), OrderByType.Asc,
    nameof(Timestamp), OrderByType.Asc,
    nameof(PlanetCode1), OrderByType.Asc,
    nameof(PlanetCode2), OrderByType.Asc,
    nameof(PlanetCode), OrderByType.Asc,
    nameof(Sign), OrderByType.Asc,
    IsUnique = true)]
public partial class XzAstrocalendar : EntityBaseId
{
    /// <summary>
    /// 年份
    /// </summary>
    [SugarColumn(ColumnName = "year", ColumnDescription = "年份")]
    public virtual int Year { get; set; }

    /// <summary>
    /// 月份 1-12
    /// </summary>
    [SugarColumn(ColumnName = "month", ColumnDescription = "月份 1-12")]
    public virtual int Month { get; set; }

    /// <summary>
    /// 日 1-31
    /// </summary>
    [SugarColumn(ColumnName = "day", ColumnDescription = "日 1-31")]
    public virtual int Day { get; set; }

    /// <summary>
    /// 事件类型：1=行星相位 / 2=行星入星座 / 14=月亮空亡结束
    /// </summary>
    [SugarColumn(ColumnName = "type", ColumnDescription = "事件类型 1相位/2入星座/14月空结束")]
    public virtual int? Type { get; set; }

    /// <summary>
    /// Unix 时间戳（秒）
    /// </summary>
    [SugarColumn(ColumnName = "timestamp", ColumnDescription = "Unix 时间戳")]
    public virtual long? Timestamp { get; set; }

    /// <summary>
    /// 黄经度数 0-360
    /// </summary>
    [SugarColumn(ColumnName = "longitude", ColumnDescription = "黄经度数")]
    public virtual double? Longitude { get; set; }

    /// <summary>
    /// 时刻 HH:mm
    /// </summary>
    [SugarColumn(ColumnName = "time", ColumnDescription = "时刻 HH:mm", Length = 20)]
    public virtual string? Time { get; set; }

    /// <summary>
    /// 完整日期时间 yyyy-MM-dd HH:mm
    /// </summary>
    [SugarColumn(ColumnName = "date", ColumnDescription = "完整日期时间", Length = 30)]
    public virtual string? Date { get; set; }

    /// <summary>
    /// 事件结束时间（上游当前恒空，保留字段）
    /// </summary>
    [SugarColumn(ColumnName = "end_date", ColumnDescription = "事件结束时间", Length = 30)]
    public virtual string? EndDate { get; set; }

    /// <summary>
    /// 标题简写，如"日六合土"
    /// </summary>
    [SugarColumn(ColumnName = "title_short", ColumnDescription = "标题简写", Length = 100)]
    public virtual string? TitleShort { get; set; }

    /// <summary>
    /// 事件标题，如"太阳六合土星"
    /// </summary>
    [SugarColumn(ColumnName = "title", ColumnDescription = "事件标题", Length = 200)]
    public virtual string? Title { get; set; }

    /// <summary>
    /// 主星体代码（type=1 相位）
    /// </summary>
    [SugarColumn(ColumnName = "planet_code1", ColumnDescription = "主星体代码 type=1", Length = 20)]
    public virtual string? PlanetCode1 { get; set; }

    /// <summary>
    /// 客体星体代码（type=1 相位）
    /// </summary>
    [SugarColumn(ColumnName = "planet_code2", ColumnDescription = "客体星体代码 type=1", Length = 20)]
    public virtual string? PlanetCode2 { get; set; }

    /// <summary>
    /// 容许度（type=1 相位），单位角度，如 60/90/120/180
    /// </summary>
    [SugarColumn(ColumnName = "allow", ColumnDescription = "容许度 type=1")]
    public virtual int? Allow { get; set; }

    /// <summary>
    /// 实际偏差角度（type=1 相位），越接近 0 越精准
    /// </summary>
    [SugarColumn(ColumnName = "allow_cha", ColumnDescription = "实际偏差角度 type=1")]
    public virtual double? AllowCha { get; set; }

    /// <summary>
    /// 主星体中文名（type=1）
    /// </summary>
    [SugarColumn(ColumnName = "planet_chinese1", ColumnDescription = "主星体中文名 type=1", Length = 20)]
    public virtual string? PlanetChinese1 { get; set; }

    /// <summary>
    /// 主星体英文名（type=1）
    /// </summary>
    [SugarColumn(ColumnName = "planet_english1", ColumnDescription = "主星体英文名 type=1", Length = 20)]
    public virtual string? PlanetEnglish1 { get; set; }

    /// <summary>
    /// 主星体字体符号（type=1）
    /// </summary>
    [SugarColumn(ColumnName = "planet_font1", ColumnDescription = "主星体字体符号 type=1", Length = 10)]
    public virtual string? PlanetFont1 { get; set; }

    /// <summary>
    /// 客体星体中文名（type=1）
    /// </summary>
    [SugarColumn(ColumnName = "planet_chinese2", ColumnDescription = "客体星体中文名 type=1", Length = 20)]
    public virtual string? PlanetChinese2 { get; set; }

    /// <summary>
    /// 客体星体英文名（type=1）
    /// </summary>
    [SugarColumn(ColumnName = "planet_english2", ColumnDescription = "客体星体英文名 type=1", Length = 20)]
    public virtual string? PlanetEnglish2 { get; set; }

    /// <summary>
    /// 客体星体字体符号（type=1）
    /// </summary>
    [SugarColumn(ColumnName = "planet_font2", ColumnDescription = "客体星体字体符号 type=1", Length = 10)]
    public virtual string? PlanetFont2 { get; set; }

    /// <summary>
    /// 入星座的星体代码（type=2/14）
    /// </summary>
    [SugarColumn(ColumnName = "planet_code", ColumnDescription = "入星座的星体代码 type=2/14", Length = 20)]
    public virtual string? PlanetCode { get; set; }

    /// <summary>
    /// 进入的星座代码（type=2/14）
    /// </summary>
    [SugarColumn(ColumnName = "sign", ColumnDescription = "进入的星座代码 type=2/14", Length = 20)]
    public virtual string? Sign { get; set; }

    /// <summary>
    /// 星座中文名（type=2/14）
    /// </summary>
    [SugarColumn(ColumnName = "sign_chinese", ColumnDescription = "星座中文名 type=2/14", Length = 20)]
    public virtual string? SignChinese { get; set; }

    /// <summary>
    /// 星座英文名（type=2/14）
    /// </summary>
    [SugarColumn(ColumnName = "sign_english", ColumnDescription = "星座英文名 type=2/14", Length = 20)]
    public virtual string? SignEnglish { get; set; }

    /// <summary>
    /// 星座字体符号（type=2/14）
    /// </summary>
    [SugarColumn(ColumnName = "sign_font", ColumnDescription = "星座字体符号 type=2/14", Length = 10)]
    public virtual string? SignFont { get; set; }
}
