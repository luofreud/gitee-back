// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Newtonsoft.Json;

namespace Admin.NET.Application;

/// <summary>
/// 韦特塔罗占卜 - 单张牌数据
/// <para>对应接口：<c>Waite/generate</c>，每张牌包含标题、解读、四维运势。</para>
/// </summary>
public class XingpanTarotCard
{
    /// <summary>
    /// 卡牌 ID
    /// <para>0-21 大阿卡那；22-77 小阿卡那（含宫廷牌 56-77）。</para>
    /// </summary>
    [JsonProperty("id")]
    public int Id { get; set; }

    /// <summary>
    /// 卡牌标题
    /// <para>例：愚者 / 魔术师 / 战车 / 死神 / 圣杯三 等。</para>
    /// </summary>
    [JsonProperty("title")]
    public string Title { get; set; }

    /// <summary>
    /// 综合解读
    /// <para>对该牌正位 / 逆位的整体说明。</para>
    /// </summary>
    [JsonProperty("explain")]
    public string Explain { get; set; }

    /// <summary>
    /// 逆位 / 负向含义
    /// <para>当抽到逆位时重点阅读。</para>
    /// </summary>
    [JsonProperty("negative")]
    public string Negative { get; set; }

    /// <summary>
    /// 事业运
    /// <para>对工作 / 学业的影响。</para>
    /// </summary>
    [JsonProperty("work")]
    public string Work { get; set; }

    /// <summary>
    /// 爱情运
    /// <para>对亲密关系 / 恋爱的影响。</para>
    /// </summary>
    [JsonProperty("love")]
    public string Love { get; set; }

    /// <summary>
    /// 友情 / 人际运
    /// <para>对朋友 / 同事关系的影响。</para>
    /// </summary>
    [JsonProperty("friend")]
    public string Friend { get; set; }

    /// <summary>
    /// 情感 / 情绪
    /// <para>对当下心境 / 情绪状态的描述。</para>
    /// </summary>
    [JsonProperty("affection")]
    public string Affection { get; set; }

    /// <summary>
    /// 未识别字段
    /// <para>兜底上游可能新增字段（如 image、keyword 等）。</para>
    /// </summary>
    [JsonExtensionData]
    public Dictionary<string, object> Extra { get; set; }
}
