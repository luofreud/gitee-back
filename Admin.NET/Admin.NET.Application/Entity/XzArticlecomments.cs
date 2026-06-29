// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Admin.NET.Core;
using SqlSugar;
namespace Admin.NET.Application.Entity;

/// <summary>
/// 用户评论列表
/// </summary>
[Tenant("1300000000001")]
[SugarTable("xz_articlecomments", "用户评论列表")]
public partial class XzArticlecomments : EntityBaseId
{
    /// <summary>
    /// 
    /// </summary>
    [SugarColumn(ColumnName = "uid", ColumnDescription = "")]
    public virtual long? uid { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [SugarColumn(ColumnName = "aid", ColumnDescription = "")]
    public virtual long? aid { get; set; }
    
    /// <summary>
    /// 内容
    /// </summary>
    [SugarColumn(ColumnName = "content", ColumnDescription = "内容", Length = 500)]
    public virtual string? content { get; set; }
    
    /// <summary>
    /// 点赞数量
    /// </summary>
    [SugarColumn(ColumnName = "likecount", ColumnDescription = "点赞数量")]
    public virtual int? likecount { get; set; }
    
    /// <summary>
    /// 父级
    /// </summary>
    [SugarColumn(ColumnName = "parentid", ColumnDescription = "父级")]
    public virtual long? parentid { get; set; }
    
    /// <summary>
    /// 回复数量
    /// </summary>
    [SugarColumn(ColumnName = "replycount", ColumnDescription = "回复数量")]
    public virtual int? replycount { get; set; }
    
    /// <summary>
    /// 0：正常，1：待审核，2：禁用
    /// </summary>
    [SugarColumn(ColumnName = "state", ColumnDescription = "0：正常，1：待审核，2：禁用")]
    public virtual int? state { get; set; }
    
    /// <summary>
    /// createtime
    /// </summary>
    [SugarColumn(ColumnName = "createtime", ColumnDescription = "createtime")]
    public virtual DateTime? createtime { get; set; }

    // 导航属性（SqlSugar 支持）
    [Navigate(NavigateType.OneToOne, nameof(uid))]
    public XzUser xzuser { get; set; }

    [Navigate(NavigateType.OneToOne, nameof(parentid))]
    public XzArticlecomments ParentComment { get; set; }

    [Navigate(NavigateType.OneToMany, nameof(XzArticlecomments.parentid))]
    public List<XzArticlecomments> Replies { get; set; }


    // 导航属性（SqlSugar 支持）
    [Navigate(NavigateType.OneToMany, nameof(XzArticlelike.aid), nameof(Id))]
    public List<XzArticlelike> commentlike { get; set; }

}
