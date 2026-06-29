// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Admin.NET.Core;
using SqlSugar;
namespace Admin.NET.Application.Entity;

/// <summary>
/// 板块
/// </summary>
[Tenant("1300000000001")]
[SugarTable("xz_articleplate", "板块")]
public partial class XzArticleplate : EntityBaseId
{


    /// <summary>
    /// 标题
    /// </summary>
    [SugarColumn(ColumnName = "title", ColumnDescription = "标题")]
    public virtual string? title { get; set; }

    /// <summary>
    /// 内容
    /// </summary>
    [SugarColumn(ColumnName = "content", ColumnDescription = "内容", Length = 0)]
    public virtual string? content { get; set; }


    /// <summary>
    /// 图片
    /// </summary>
    [SugarColumn(ColumnName = "image", ColumnDescription = "图片")]
    public virtual string? image { get; set; }

    /// <summary>
    /// 热度
    /// </summary>
    [SugarColumn(ColumnName = "ishot", ColumnDescription = "热度")]
    public virtual int? ishot { get; set; }
    
    /// <summary>
    /// 新
    /// </summary>
    [SugarColumn(ColumnName = "isnew", ColumnDescription = "新")]
    public virtual int? isnew { get; set; }
    
    /// <summary>
    /// 关联数量
    /// </summary>
    [SugarColumn(ColumnName = "count", ColumnDescription = "关联数量")]
    public virtual int? count { get; set; }
    
    /// <summary>
    /// 0：不置顶，1：置顶
    /// </summary>
    [SugarColumn(ColumnName = "istop", ColumnDescription = "0：不置顶，1：置顶")]
    public virtual int? istop { get; set; }


    /// <summary>
    /// 类型 0:板块，1：话题
    /// </summary>
    [SugarColumn(ColumnName = "ltype", ColumnDescription = "类型 0:板块，1：话题")]
    public virtual int? ltype { get; set; }

    /// <summary>
    /// createtime
    /// </summary>
    [SugarColumn(ColumnName = "createtime", ColumnDescription = "createtime")]
    public virtual DateTime? createtime { get; set; }
    
}
