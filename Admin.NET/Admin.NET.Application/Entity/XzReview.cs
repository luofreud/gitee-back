// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Admin.NET.Core;
using SqlSugar;
namespace Admin.NET.Application.Entity;

/// <summary>
/// 系统用户评测
/// </summary>
[Tenant("1300000000001")]
[SugarTable("xz_review", "系统用户评测")]
public partial class XzReview : EntityBaseId
{
    /// <summary>
    /// 
    /// </summary>
    [SugarColumn(ColumnName = "name", ColumnDescription = "", Length = 100)]
    public virtual string? name { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [SugarColumn(ColumnName = "tipname", ColumnDescription = "", Length = 100)]
    public virtual string? tipname { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [SugarColumn(ColumnName = "img", ColumnDescription = "", Length = 200)]
    public virtual string? img { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [SugarColumn(ColumnName = "url", ColumnDescription = "", Length = 300)]
    public virtual string? url { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [SugarColumn(ColumnName = "money", ColumnDescription = "")]
    public virtual int? money { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [SugarColumn(ColumnName = "count", ColumnDescription = "")]
    public virtual int? count { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [SugarColumn(ColumnName = "sortcode", ColumnDescription = "")]
    public virtual int? sortcode { get; set; }
    
    /// <summary>
    /// 0：不置顶，1：置顶
    /// </summary>
    [SugarColumn(ColumnName = "istop", ColumnDescription = "0：不置顶，1：置顶")]
    public virtual int? istop { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [SugarColumn(ColumnName = "rtype", ColumnDescription = "")]
    public virtual long? rtype { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [SugarColumn(ColumnName = "click", ColumnDescription = "")]
    public virtual int? click { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [SugarColumn(ColumnName = "createtime", ColumnDescription = "")]
    public virtual DateTime? createtime { get; set; }
    
}
