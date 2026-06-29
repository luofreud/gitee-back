// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Admin.NET.Core;
using SqlSugar;
namespace Admin.NET.Application.Entity;

/// <summary>
/// 用户星币兑换记录
/// </summary>
[Tenant("1300000000001")]
[SugarTable("xz_uexchagelog", "用户星币兑换记录")]
public partial class XzUexchagelog : EntityBaseId
{
    /// <summary>
    /// uid
    /// </summary>
    [SugarColumn(ColumnName = "uid", ColumnDescription = "uid")]
    public virtual long? uid { get; set; }
    
    /// <summary>
    /// 收货地址id
    /// </summary>
    [SugarColumn(ColumnName = "takeid", ColumnDescription = "收货地址id")]
    public virtual long? takeid { get; set; }
    
    /// <summary>
    /// 收货姓名
    /// </summary>
    [SugarColumn(ColumnName = "name", ColumnDescription = "收货姓名", Length = 50)]
    public virtual string? name { get; set; }
    
    /// <summary>
    /// 联系电话
    /// </summary>
    [SugarColumn(ColumnName = "phone", ColumnDescription = "联系电话", Length = 50)]
    public virtual string? phone { get; set; }
    
    /// <summary>
    /// 区域
    /// </summary>
    [SugarColumn(ColumnName = "area", ColumnDescription = "区域", Length = 200)]
    public virtual string? area { get; set; }
    
    /// <summary>
    /// 详细地址
    /// </summary>
    [SugarColumn(ColumnName = "address", ColumnDescription = "详细地址", Length = 200)]
    public virtual string? address { get; set; }
    
    /// <summary>
    /// 商品id
    /// </summary>
    [SugarColumn(ColumnName = "gid", ColumnDescription = "商品id")]
    public virtual long? gid { get; set; }
    
    /// <summary>
    /// 商品名称
    /// </summary>
    [SugarColumn(ColumnName = "gname", ColumnDescription = "商品名称", Length = 200)]
    public virtual string? gname { get; set; }
    /// <summary>
    /// 商品图片
    /// </summary>
    [SugarColumn(ColumnName = "gimg", ColumnDescription = "商品图片", Length = 2000)]
    public virtual string? gimg { get; set; }

    /// <summary>
    /// 兑换数量
    /// </summary>
    [SugarColumn(ColumnName = "expressnum", ColumnDescription = "", Length = 200)]
    public virtual int? expressnum { get; set; }
    
    /// <summary>
    /// 状态 1:待发货，2：已发货，3：已完成
    /// </summary>
    [SugarColumn(ColumnName = "orderstate", ColumnDescription = "状态 1:待发货，2：已发货，3：已完成")]
    public virtual int? orderstate { get; set; }
    
    /// <summary>
    /// 评价状态 0：未评价，1：已评价
    /// </summary>
    [SugarColumn(ColumnName = "evaluatestate", ColumnDescription = "评价状态 0：未评价，1：已评价")]
    public virtual int? evaluatestate { get; set; }
    
    /// <summary>
    /// 备注
    /// </summary>
    [SugarColumn(ColumnName = "mark", ColumnDescription = "备注", Length = 200)]
    public virtual string? mark { get; set; }

    /// <summary>
    /// 快单类型
    /// </summary>
    [SugarColumn(ColumnName = "ordertype", ColumnDescription = "快单类型", Length = 200)]
    public virtual string? ordertype { get; set; }


    /// <summary>
    /// 单号
    /// </summary>
    [SugarColumn(ColumnName = "orderno", ColumnDescription = "单号", Length = 200)]
    public virtual string? orderno { get; set; }


    /// <summary>
    /// 兑换需要的星币
    /// </summary>
    [SugarColumn(ColumnName = "xbmoney", ColumnDescription = "兑换需要的星币")]
    public virtual int? xbmoney { get; set; }

    /// <summary>
    /// 0:实物，1：虚拟商品
    /// </summary>
    [SugarColumn(ColumnName = "virtualgood", ColumnDescription = "虚拟商品")]
    public virtual int? virtualgood { get; set; }

    /// <summary>
    /// 优惠券id
    /// </summary>
    [SugarColumn(ColumnName = "cid", ColumnDescription = "优惠券id")]
    public virtual long? cid { get; set; }
    

    /// <summary>
    /// 
    /// </summary>
    [SugarColumn(ColumnName = "createtime", ColumnDescription = "")]
    public virtual DateTime? createtime { get; set; }
    
}
