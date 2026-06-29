// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Admin.NET.Core;
using SqlSugar;
namespace Admin.NET.Application.Entity;

/// <summary>
/// 
/// </summary>
[Tenant("1300000000001")]
[SugarTable("xz_news", "")]
public partial class XzNews : EntityBaseId
{
    /// <summary>
    /// 标题
    /// </summary>
    [SugarColumn(ColumnName = "title", ColumnDescription = "标题", Length = 200)]
    public virtual string? title { get; set; }

    /// <summary>
    /// 标题key
    /// </summary>
    [SugarColumn(ColumnName = "titlecode", ColumnDescription = "标题key", Length = 50)]
    public virtual string? titlecode { get; set; }

    /// <summary>
    /// 图标
    /// </summary>
    [SugarColumn(ColumnName = "img", ColumnDescription = "图标", Length = 500)]
    public virtual string? img { get; set; }

    /// <summary>
    /// 内容
    /// </summary>
    [SugarColumn(ColumnName = "newcontent", ColumnDescription = "内容", Length = 0)]
    public virtual string? newcontent { get; set; }

    /// <summary>
    /// 点击次数
    /// </summary>
    [SugarColumn(ColumnName = "click", ColumnDescription = "点击次数")]
    public virtual int? click { get; set; }

    /// <summary>
    /// 排序
    /// </summary>
    [SugarColumn(ColumnName = "sortcode", ColumnDescription = "排序")]
    public virtual int? sortcode { get; set; }

    /// <summary>
    /// 创建时间
    /// </summary>
    [SugarColumn(ColumnName = "createtime", ColumnDescription = "创建时间")]
    public virtual DateTime? createtime { get; set; }

    [Navigate(NavigateType.OneToMany, nameof(XzNewitem.newid))]
    public virtual List<XzNewitem> XzNewitems { get; set; }

}
