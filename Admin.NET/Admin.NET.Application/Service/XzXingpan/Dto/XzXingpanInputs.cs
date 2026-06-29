namespace Admin.NET.Application;

/// <summary>
/// 星盘查询统一输入（Natal / Current / Transit / ThirdProgressed / Developed / SecondaryLimit / ThirdProgressedDouble）
/// <para>继承 <see cref="XingpanChartSingleTransitRequest"/> 包含所有出生/推运字段，可选绑定档案。</para>
/// </summary>
public class XzXingpanChartInput : XingpanChartSingleTransitRequest
{
    /// <summary>
    /// 用户档案 ID（可选）。传此值则自动从数据库填充出生信息，覆盖请求中的 Birthday/Longitude/Latitude/Tz。
    /// </summary>
    public long? ArchiveId { get; set; }
}

/// <summary>
/// 星座语料列表查询输入
/// </summary>
public class XzXingpanCorpusInput : XingpanCorpusGetListRequest
{
}

/// <summary>
/// 韦特塔罗占卜输入
/// </summary>
public class XzXingpanTarotGenerateInput : XingpanTarotGenerateRequest
{
}

/// <summary>
/// 组合盘输入（双档案 ID）
/// </summary>
public class XzXingpanCompositeInput: XingpanChartSingleTransitRequest
{
    /// <summary>
    /// 用户档案 ID（第一人）
    /// </summary>
    public long? ArchiveId1 { get; set; }

    /// <summary>
    /// 用户档案 ID（第二人）
    /// </summary>
    public long? ArchiveId2 { get; set; }
}

/// <summary>
/// 运势查询统一输入（Luck / Day / Weeks / Moon / Year）
/// <para>四类运势接口字段一致，服务端按接口路径区分时间范围。</para>
/// <para>base URL 走 <c>https://go.xingpan.vip/astrology/</c>，与老 48 个接口的 <c>www.xingpan.vip</c> 不同。</para>
/// </summary>
public class XzXingpanLuckInput : XingpanLuckDayRequest
{
    /// <summary>
    /// 用户档案 ID（可选）。传此值则自动从数据库填充出生信息，覆盖请求中的 Birthday/Longitude/Latitude/Tz。
    /// </summary>
    public long? ArchiveId { get; set; }
}

