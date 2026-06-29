// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Admin.NET.Core;
using SqlSugar;
namespace Admin.NET.Application.Entity;

/// <summary>
/// 系统广告
/// </summary>
[Tenant("1300000000001")]
[SugarTable("xz_adv", "系统广告")]
public partial class XzAdv : EntityBaseId
{
    /// <summary>
    /// 广告名称
    /// </summary>
    [SugarColumn(ColumnName = "name", ColumnDescription = "广告名称", Length = 100)]
    public virtual string? name { get; set; }
    
    /// <summary>
    /// 广告图片
    /// </summary>
    [SugarColumn(ColumnName = "img", ColumnDescription = "广告图片", Length = 300)]
    public virtual string? img { get; set; }
    
    /// <summary>
    /// 广告位置
    /// </summary>
    [SugarColumn(ColumnName = "postion", ColumnDescription = "广告位置")]
    public virtual int? postion { get; set; }
    
    /// <summary>
    /// 开始时间
    /// </summary>
    [SugarColumn(ColumnName = "stime", ColumnDescription = "开始时间")]
    public virtual DateTime? stime { get; set; }
    
    /// <summary>
    /// 结束时间
    /// </summary>
    [SugarColumn(ColumnName = "etime", ColumnDescription = "结束时间")]
    public virtual DateTime? etime { get; set; }
    
    /// <summary>
    /// 排序
    /// </summary>
    [SugarColumn(ColumnName = "sortcode", ColumnDescription = "排序")]
    public virtual int? sortcode { get; set; }
    
    /// <summary>
    /// 跳转地址
    /// </summary>
    [SugarColumn(ColumnName = "url", ColumnDescription = "跳转地址", Length = 300)]
    public virtual string? url { get; set; }
    
    /// <summary>
    /// 0：启用，1：不显示
    /// </summary>
    [SugarColumn(ColumnName = "isenable", ColumnDescription = "0：启用，1：不显示")]
    public virtual int? isenable { get; set; }
    
    /// <summary>
    /// 点击次数
    /// </summary>
    [SugarColumn(ColumnName = "click", ColumnDescription = "点击次数")]
    public virtual int? click { get; set; }
    
    /// <summary>
    /// 时间
    /// </summary>
    [SugarColumn(ColumnName = "createtime", ColumnDescription = "时间")]
    public virtual DateTime? createtime { get; set; }
    
}
