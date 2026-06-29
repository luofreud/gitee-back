// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Newtonsoft.Json;

namespace Admin.NET.Application;

/// <summary>
/// 天文日历 事件项
/// <para>对应接口：<c>sign/astrocalendar</c> 响应中按天分组的每个事件。日期由 <see cref="XingpanAstroCalendarResponse"/> 的内嵌 Converter 从 JSON 字典 key 自动填入到 <see cref="Day"/>。</para>
/// <para><see cref="Type"/> 取值参考：</para>
/// <list type="bullet">
///   <item><c>1</c> 行星相位：访问 <see cref="PlanetCode1"/> / <see cref="PlanetCode2"/> / <see cref="Allow"/> / <see cref="AllowCha"/> 等</item>
///   <item><c>2</c> 行星入星座：访问 <see cref="PlanetCode"/> / <see cref="Sign"/> / <see cref="SignChinese"/> 等</item>
///   <item><c>14</c> 月亮空亡结束：与 type=2 同 shape，语义由 <see cref="Title"/> 区分</item>
/// </list>
/// <para>未知 type 或新字段会落入 <see cref="Extra"/>，调用方可按 <see cref="Type"/> 分支处理。</para>
/// </summary>
public class XingpanAstroCalendarEvent
{
    /// <summary>
    /// 月内日期 1-31
    /// <para>由 Converter 从上游 JSON 字典的 key（如 "1" / "2"）反序列化时填入，调用方无需手动设置。</para>
    /// </summary>
    /// <example>2</example>
    [JsonProperty("day")]
    public int Day { get; set; }

    /// <summary>
    /// 事件类型
    /// <para>1=行星相位（如六合 / 三分 / 对冲）/ 2=行星入星座 / 14=月亮空亡结束。</para>
    /// </summary>
    /// <example>1</example>
    [JsonProperty("type")]
    public int Type { get; set; }

    /// <summary>
    /// Unix 时间戳（秒）
    /// <para>事件发生的精确时刻，可用于排序 / 时区换算。</para>
    /// </summary>
    /// <example>1780342260</example>
    [JsonProperty("timestamp")]
    public long Timestamp { get; set; }

    /// <summary>
    /// 黄经度数 0-360
    /// <para>type=2 时表示行星进入星座的精确黄经；type=1 时表示两颗行星之间的精确角度。</para>
    /// </summary>
    /// <example>59.9996</example>
    [JsonProperty("longitude")]
    public double Longitude { get; set; }

    /// <summary>
    /// 时刻（HH:mm 格式）
    /// </summary>
    /// <example>22:48</example>
    [JsonProperty("time")]
    public string Time { get; set; }

    /// <summary>
    /// 完整日期时间
    /// <para>格式 <c>yyyy-MM-dd HH:mm:ss</c>，可直接用 <see cref="DateTime.Parse(string)"/> 解析。</para>
    /// </summary>
    /// <example>2026-06-02 22:48</example>
    [JsonProperty("date")]
    public string Date { get; set; }

    /// <summary>
    /// 事件结束时间
    /// <para>当前数据中始终为空字符串，保留字段供未来扩展。</para>
    /// </summary>
    [JsonProperty("end_date")]
    public string EndDate { get; set; }

    /// <summary>
    /// 标题简写
    /// <para>2-3 字简称，如"日六合土"/"月冲水"/"水蟹"。</para>
    /// </summary>
    /// <example>日六合土</example>
    [JsonProperty("title_short")]
    public string TitleShort { get; set; }

    /// <summary>
    /// 事件标题
    /// <para>如"太阳六合土星"/"月亮冲水星"/"水星进入巨蟹座"/"月亮空亡结束"。</para>
    /// </summary>
    /// <example>太阳六合土星</example>
    [JsonProperty("title")]
    public string Title { get; set; }

    #region type=1 行星相位

    /// <summary>
    /// 主星体代码（type=1）
    /// <para>0 太阳 / 1 月亮 / 2 水星 / 3 金星 / 4 火星 / 5 木星 / 6 土星 / 7 天王星 / 8 海王星 / 9 冥王星。</para>
    /// </summary>
    /// <example>0</example>
    [JsonProperty("planet_code1")]
    public string PlanetCode1 { get; set; }

    /// <summary>
    /// 客体星体代码（type=1）
    /// <para>取值同 <see cref="PlanetCode1"/>。</para>
    /// </summary>
    /// <example>6</example>
    [JsonProperty("planet_code2")]
    public string PlanetCode2 { get; set; }

    /// <summary>
    /// 容许度（type=1）
    /// <para>单位为角度；如 60 = 容许 ±0.5° 的六合相位，180 = 对冲相位。</para>
    /// </summary>
    /// <example>60</example>
    [JsonProperty("allow")]
    public double? Allow { get; set; }

    /// <summary>
    /// 实际偏差角度（type=1）
    /// <para>与精确相位的差值，越接近 0 表示越精准入相位。</para>
    /// </summary>
    /// <example>0.0004</example>
    [JsonProperty("allow_cha")]
    public double? AllowCha { get; set; }

    /// <summary>
    /// 主星体中文名（type=1）
    /// </summary>
    /// <example>太阳</example>
    [JsonProperty("planet_chinese1")]
    public string PlanetChinese1 { get; set; }

    /// <summary>
    /// 主星体英文名（type=1）
    /// </summary>
    /// <example>Sun</example>
    [JsonProperty("planet_english1")]
    public string PlanetEnglish1 { get; set; }

    /// <summary>
    /// 主星体字体符号（type=1）
    /// <para>对应星盘字体中的字符编码，需搭配专用字体库渲染。</para>
    /// </summary>
    [JsonProperty("planet_font1")]
    public string PlanetFont1 { get; set; }

    /// <summary>
    /// 客体星体中文名（type=1）
    /// </summary>
    [JsonProperty("planet_chinese2")]
    public string PlanetChinese2 { get; set; }

    /// <summary>
    /// 客体星体英文名（type=1）
    /// </summary>
    [JsonProperty("planet_english2")]
    public string PlanetEnglish2 { get; set; }

    /// <summary>
    /// 客体星体字体符号（type=1）
    /// </summary>
    [JsonProperty("planet_font2")]
    public string PlanetFont2 { get; set; }

    #endregion type=1 行星相位

    #region type=2 / 14 行星入星座 / 月空结束

    /// <summary>
    /// 入星座的星体代码（type=2 / 14）
    /// <para>0 太阳 / 1 月亮 / 2 水星 / 3 金星 / 4 火星 / 5 木星 / 6 土星 / 7 天王星 / 8 海王星 / 9 冥王星。</para>
    /// </summary>
    /// <example>2</example>
    [JsonProperty("planet_code")]
    public string PlanetCode { get; set; }

    /// <summary>
    /// 进入的星座代码（type=2 / 14）
    /// <para>0 白羊 / 1 金牛 / 2 双子 / 3 巨蟹 / 4 狮子 / 5 处女 / 6 天秤 / 7 天蝎 / 8 射手 / 9 摩羯 / 10 水瓶 / 11 双鱼。</para>
    /// </summary>
    /// <example>3</example>
    [JsonProperty("sign")]
    public string Sign { get; set; }

    /// <summary>
    /// 星座中文名（type=2 / 14）
    /// </summary>
    /// <example>巨蟹</example>
    [JsonProperty("sign_chinese")]
    public string SignChinese { get; set; }

    /// <summary>
    /// 星座英文名（type=2 / 14）
    /// </summary>
    /// <example>Cancer</example>
    [JsonProperty("sign_english")]
    public string SignEnglish { get; set; }

    /// <summary>
    /// 星座字体符号（type=2 / 14）
    /// </summary>
    [JsonProperty("sign_font")]
    public string SignFont { get; set; }

    #endregion type=2 / 14 行星入星座 / 月空结束

    /// <summary>
    /// 扩展字段
    /// <para>上游新增字段 / 未知 type 携带的额外键值会落在这里，确保前向兼容。</para>
    /// </summary>
    [JsonExtensionData]
    public Dictionary<string, object> Extra { get; set; }
}
