// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Admin.NET.Core;
using SqlSugar;
namespace Admin.NET.Application.Entity;

/// <summary>
/// 咨询连麦记录
/// </summary>
[Tenant("1300000000001")]
[SugarTable("xz_imlog", "咨询连麦记录")]
public partial class XzImlog : EntityBaseId
{

    /// <summary>
    /// 0：正常，1：投诉状态
    /// </summary>
    [SugarColumn(ColumnName = "ostate", ColumnDescription = "0：正常，1：投诉状态")]
    public virtual int? ostate { get; set; }


    /// <summary>
    /// 
    /// </summary>
    [SugarColumn(ColumnName = "uid", ColumnDescription = "")]
    public virtual long? uid { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [SugarColumn(ColumnName = "tid", ColumnDescription = "")]
    public virtual long? tid { get; set; }

    /// <summary>
    /// 房间id
    /// </summary>
    [SugarColumn(ColumnName = "roomid", ColumnDescription = "")]
    public virtual long? roomid { get; set; }


    /// <summary>
    /// 0：普通连麦，1：1v1连麦，2：及时通话
    /// </summary>
    [SugarColumn(ColumnName = "itype", ColumnDescription = "0：普通连麦，1：1v1连麦，2：及时通话")]
    public virtual int? itype { get; set; }
    
    /// <summary>
    /// 消费星钻
    /// </summary>
    [SugarColumn(ColumnName = "xzmoney", ColumnDescription = "消费星钻")]
    public virtual double? xzmoney { get; set; }
    
    /// <summary>
    /// 订单号
    /// </summary>
    [SugarColumn(ColumnName = "orderno", ColumnDescription = "订单号", Length = 20)]
    public virtual string? orderno { get; set; }
    
    /// <summary>
    /// 0：不删除，1：删除
    /// </summary>
    [SugarColumn(ColumnName = "isdel", ColumnDescription = "0：不删除，1：删除")]
    public virtual int? isdel { get; set; }
    
    /// <summary>
    /// 单价
    /// </summary>
    [SugarColumn(ColumnName = "price", ColumnDescription = "单价")]
    public virtual double? price { get; set; }

    /// <summary>
    /// 0：未连麦，1：正在连麦，2：已完成连麦,3:投诉状态,4:导师拒绝连麦
    /// </summary>
    [SugarColumn(ColumnName = "state", ColumnDescription = "0：未连麦，1：正在连麦，2：已完成连麦,3:投诉状态,4:导师拒绝连麦")]
    public virtual int? state { get; set; }
    
    /// <summary>
    /// 连麦时长
    /// </summary>
    [SugarColumn(ColumnName = "imtime", ColumnDescription = "连麦时长")]
    public virtual int? imtime { get; set; }

    /// <summary>
    /// 开始时间
    /// </summary>
    [SugarColumn(ColumnName = "starttime", ColumnDescription = "开始时间")]
    public virtual DateTime? starttime { get; set; }

    /// <summary>
    /// 结束时间
    /// </summary>
    [SugarColumn(ColumnName = "overtime", ColumnDescription = "结束时间")]
    public virtual DateTime? overtime { get; set; }   
    
    /// <summary>
    /// createtime
    /// </summary>
    [SugarColumn(ColumnName = "createtime", ColumnDescription = "createtime")]
    public virtual DateTime? createtime { get; set; }

    /// <summary>
    /// 付费时常
    /// </summary>
    [SugarColumn(ColumnName = "paytime", ColumnDescription = "付费时常")]
    public virtual int? paytime { get; set; }

    /// <summary>
    /// 免费时常
    /// </summary>
    [SugarColumn(ColumnName = "freetime", ColumnDescription = "免费时常")]
    public virtual int? freetime { get; set; }


    /// <summary>
    /// 用户信息
    /// </summary>
    [Navigate(NavigateType.OneToOne, nameof(uid), nameof(XzUser.Id))]
    public XzUser user { get; set; }


    /// <summary>
    /// 用户信息
    /// </summary>
    [Navigate(NavigateType.OneToOne, nameof(tid), nameof(XzTeacher.Id))]
    public XzTeacher teacher { get; set; }
}
