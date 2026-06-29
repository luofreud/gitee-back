// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Admin.NET.Core;
using SqlSugar;
namespace Admin.NET.Application.Entity;

/// <summary>
/// 星币兑换商城
/// </summary>
[Tenant("1300000000001")]
[SugarTable("xz_exchangeshop", "星币兑换商城")]
public partial class XzExchangeshop : EntityBaseId
{
    /// <summary>
    /// 商品名称
    /// </summary>
    [SugarColumn(ColumnName = "goodname", ColumnDescription = "商品名称", Length = 200)]
    public virtual string? goodname { get; set; }
    
    /// <summary>
    /// 商品图片
    /// </summary>
    [SugarColumn(ColumnName = "goodimg", ColumnDescription = "商品图片", Length = 200)]
    public virtual string? goodimg { get; set; }
    
    /// <summary>
    /// 兑换星币数量
    /// </summary>
    [SugarColumn(ColumnName = "xbmoney", ColumnDescription = "兑换星币数量")]
    public virtual int? xbmoney { get; set; }
    
    /// <summary>
    /// 可兑换的商品数量
    /// </summary>
    [SugarColumn(ColumnName = "count", ColumnDescription = "商品数量")]
    public virtual int? count { get; set; }

    /// <summary>
    /// 兑换星钻数量
    /// </summary>
    [SugarColumn(ColumnName = "xzmoney", ColumnDescription = "")]
    public virtual int? xzmoney { get; set; }
    
    /// <summary>
    /// 类型id
    /// </summary>
    [SugarColumn(ColumnName = "goodtypeid", ColumnDescription = "类型id")]
    public virtual long? goodtypeid { get; set; }
    
    /// <summary>
    /// 0：正常，1：下架
    /// </summary>
    [SugarColumn(ColumnName = "state", ColumnDescription = "0：正常，1：下架")]
    public virtual int? state { get; set; }
    
    /// <summary>
    /// createtime
    /// </summary>
    [SugarColumn(ColumnName = "createtime", ColumnDescription = "createtime")]
    public virtual DateTime? createtime { get; set; }

    /// <summary>
    /// 用户等级加载兑换商品
    /// </summary>
    [SugarColumn(ColumnName = "level", ColumnDescription = "level")]
    public virtual int? level { get; set; }

    /// <summary>
    /// 排序
    /// </summary>
    [SugarColumn(ColumnName = "sortcode", ColumnDescription = "sortcode")]

    public virtual int? sortcode { get; set; }

    /// <summary>
    /// 0：每月兑换，1：只能兑换
    /// </summary>
    [SugarColumn(ColumnName = "limittype", ColumnDescription = "limittype")]

    public virtual int? limittype { get; set; }

    /// <summary>
    /// 兑换次数
    /// </summary>
    [SugarColumn(ColumnName = "limitcount", ColumnDescription = "limitcount")]

    public virtual int? limitcount { get; set; }

    /// <summary>
    /// 0:实物，1：虚拟商品
    /// </summary>
    [SugarColumn(ColumnName = "virtualgood", ColumnDescription = "virtualgood")]

    public virtual int? virtualgood { get; set; }

    /// <summary>
    /// 关联优惠劵
    /// </summary>
    [SugarColumn(ColumnName = "cid", ColumnDescription = "cid")]   
    public virtual long? cid { get; set; }
    

}
