// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Admin.NET.Core;
using SqlSugar;
namespace Admin.NET.Application.Entity;

/// <summary>
/// 咨询师评价
/// </summary>
[Tenant("1300000000001")]
[SugarTable("xz_techerevaluate", "咨询师评价")]
public partial class XzTecherevaluate : EntityBaseId
{
    /// <summary>
    /// 
    /// </summary>
    [SugarColumn(ColumnName = "tid", ColumnDescription = "")]
    public virtual int? tid { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [SugarColumn(ColumnName = "uid", ColumnDescription = "")]
    public virtual int? uid { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [SugarColumn(ColumnName = "content", ColumnDescription = "", Length = 100)]
    public virtual string? content { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [SugarColumn(ColumnName = "likecount", ColumnDescription = "")]
    public virtual int? likecount { get; set; }
    
    /// <summary>
    /// 0：正常，1：投诉中，2：不显示
    /// </summary>
    [SugarColumn(ColumnName = "state", ColumnDescription = "0：正常，1：投诉中，2：不显示")]
    public virtual int? state { get; set; }
    
    /// <summary>
    /// 0：正常，1：删除
    /// </summary>
    [SugarColumn(ColumnName = "isdel", ColumnDescription = "0：正常，1：删除")]
    public virtual int? isdel { get; set; }
    
    /// <summary>
    /// 0：不置顶，1：置顶
    /// </summary>
    [SugarColumn(ColumnName = "istop", ColumnDescription = "0：不置顶，1：置顶")]
    public virtual int? istop { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [SugarColumn(ColumnName = "createtime", ColumnDescription = "")]
    public virtual DateTime? createtime { get; set; }
    
}
