// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Admin.NET.Core;
using SqlSugar;
namespace Admin.NET.Application.Entity;

/// <summary>
/// 系统优惠券
/// </summary>
[Tenant("1300000000001")]
[SugarTable("xz_coupon", "系统优惠券")]
public partial class XzCoupon : EntityBaseId
{
    /// <summary>
    /// 0：商品优惠券，1：星币优惠券，2：商品兑换券，3：充值折扣券
    /// </summary>
    [SugarColumn(ColumnName = "ctype", ColumnDescription = "0：商品优惠券，1：星币优惠券，2：商品兑换券，3：充值折扣券")]
    public virtual int? ctype { get; set; }
    
    /// <summary>
    /// 开始时间
    /// </summary>
    [SugarColumn(ColumnName = "stime", ColumnDescription = "")]
    public virtual DateTime? stime { get; set; }
    
    /// <summary>
    /// 结束时间
    /// </summary>
    [SugarColumn(ColumnName = "etime", ColumnDescription = "")]
    public virtual DateTime? etime { get; set; }
    
    /// <summary>
    /// 优惠券名称
    /// </summary>
    [SugarColumn(ColumnName = "name", ColumnDescription = "", Length = 50)]
    public virtual string? name { get; set; }
    /// <summary>
    /// 优惠券图片
    /// </summary>
    [SugarColumn(ColumnName = "img", ColumnDescription = "", Length = 500)]
    public virtual string? img { get; set; }

    /// <summary>
    /// 0：正常，1：删除
    /// </summary>
    [SugarColumn(ColumnName = "isdel", ColumnDescription = "0：正常，1：删除")]
    public virtual int? isdel { get; set; }
    
    /// <summary>
    /// -1：无限制
    /// </summary>
    [SugarColumn(ColumnName = "count", ColumnDescription = "-1：无限制")]
    public virtual int? count { get; set; }
    
    /// <summary>
    /// 领取总数
    /// </summary>
    [SugarColumn(ColumnName = "lqcount", ColumnDescription = "")]
    public virtual int? lqcount { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [SugarColumn(ColumnName = "createtime", ColumnDescription = "")]
    public virtual DateTime? createtime { get; set; }
    
}
