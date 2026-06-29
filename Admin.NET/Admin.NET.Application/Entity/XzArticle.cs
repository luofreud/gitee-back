// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Admin.NET.Core;
using SqlSugar;
namespace Admin.NET.Application.Entity;

/// <summary>
/// 用户发布文章
/// </summary>
[Tenant("1300000000001")]
[SugarTable("xz_article", "用户发布文章")]
public partial class XzArticle : EntityBaseId
{
    /// <summary>
    /// 板块id
    /// </summary>
    [SugarColumn(ColumnName = "plateid", ColumnDescription = "板块id")]
    public virtual long? plateid { get; set; }

    /// <summary>
    /// 
    /// </summary>
    [SugarColumn(ColumnName = "uid", ColumnDescription = "")]
    public virtual long? uid { get; set; }

    /// <summary>
    /// 标题
    /// </summary>
    [SugarColumn(ColumnName = "title", ColumnDescription = "标题", Length = 30)]
    public virtual string? title { get; set; }

    /// <summary>
    /// 内容
    /// </summary>
    [SugarColumn(ColumnName = "content", ColumnDescription = "内容", Length = 0)]
    public virtual string? content { get; set; }

    /// <summary>
    /// 图片
    /// </summary>
    [SugarColumn(ColumnName = "imgs", ColumnDescription = "图片", Length = 500)]
    public virtual string? imgs { get; set; }

    /// <summary>
    /// 视频
    /// </summary>
    [SugarColumn(ColumnName = "videos", ColumnDescription = "视频", Length = 500)]
    public virtual string? videos { get; set; }

    /// <summary>
    /// 话题标签
    /// </summary>
    [SugarColumn(ColumnName = "tags", ColumnDescription = "话题标签", Length = 100)]
    public virtual string? tags { get; set; }


    /// <summary>
    /// 话题关联ID
    /// </summary>
    [SugarColumn(ColumnName = "topicid", ColumnDescription = "话题关联ID")]
    public virtual long? topicid { get; set; }

    /// <summary>
    /// 发布板块
    /// </summary>
    [SugarColumn(ColumnName = "atype", ColumnDescription = "发布板块")]
    public virtual long? atype { get; set; }

    /// <summary>
    /// 0:正常，1：待审核，2：禁用
    /// </summary>
    [SugarColumn(ColumnName = "state", ColumnDescription = "0:正常，1：待审核，2：禁用")]
    public virtual int? state { get; set; }

    /// <summary>
    /// 0:否，1：匿名
    /// </summary>
    [SugarColumn(ColumnName = "isanonymous", ColumnDescription = "0:否，1：匿名")]
    public virtual int? isanonymous { get; set; }

    /// <summary>
    /// 点赞
    /// </summary>
    [SugarColumn(ColumnName = "likecount", ColumnDescription = "点赞")]
    public virtual int? likecount { get; set; }

    /// <summary>
    /// 评论
    /// </summary>
    [SugarColumn(ColumnName = "commentcount", ColumnDescription = "评论")]
    public virtual int? commentcount { get; set; }

    /// <summary>
    /// 收藏
    /// </summary>
    [SugarColumn(ColumnName = "collectioncount", ColumnDescription = "收藏")]
    public virtual int? collectioncount { get; set; }

    /// <summary>
    /// 0：不置顶，1：置顶
    /// </summary>
    [SugarColumn(ColumnName = "istop", ColumnDescription = "0：不置顶，1：置顶")]
    public virtual int? istop { get; set; }

    /// <summary>
    /// createtime
    /// </summary>
    [SugarColumn(ColumnName = "createtime", ColumnDescription = "createtime")]
    public virtual DateTime? createtime { get; set; }

    [Navigate(NavigateType.OneToMany, nameof(XzArticlelike.aid), nameof(Id))]
    public List<XzArticlelike> xzArticlelike { get; set; }  //注意禁止给Books手动赋值

    /// <summary>
    /// 发帖用户
    /// </summary>
    [Navigate(NavigateType.OneToOne, nameof(uid), nameof(XzUser.Id))]
    public XzUser user { get; set; }

    /// <summary>
    /// 如果是导师则显示导师信息
    /// </summary>
    [Navigate(NavigateType.OneToOne, nameof(uid), nameof(XzTeacher.uid))]
    public XzTeacher teacher { get; set; }


}
