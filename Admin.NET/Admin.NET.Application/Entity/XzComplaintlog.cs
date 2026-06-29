// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Admin.NET.Core;
using SqlSugar;
namespace Admin.NET.Application.Entity;

/// <summary>
/// 用户投诉记录表
/// </summary>
[Tenant("1300000000001")]
[SugarTable("xz_complaintlog", "用户投诉记录表")]
public partial class XzComplaintlog : EntityBaseId
{
    /// <summary>
    /// 
    /// </summary>
    [SugarColumn(ColumnName = "uid", ColumnDescription = "")]
    public virtual long? uid { get; set; }
    
    /// <summary>
    /// 投诉单号
    /// </summary>
    [SugarColumn(ColumnName = "cnum", ColumnDescription = "", Length = 20)]
    public virtual string? cnum { get; set; }
    /// <summary>
    /// 投诉内容
    /// </summary>
    [SugarColumn(ColumnName = "orderquestion", ColumnDescription = "", Length = 100)]
    public virtual string? orderquestion { get; set; }

    /// <summary>
    /// 投诉标题
    /// </summary>
    [SugarColumn(ColumnName = "title", ColumnDescription = "投诉标题", Length = 20)]
    public virtual string? title { get; set; }

    /// <summary>
    /// 0：订单-问答，1：订单-直播连麦，2：订单-语音，3：订单-测评，4：老师，5：其他
    /// </summary>
    [SugarColumn(ColumnName = "ctype", ColumnDescription = " 0：订单-问答，1：订单-直播连麦，2：订单-语音，3：订单-测评，4：老师，5：其他")]
    public virtual int? ctype { get; set; }
    
    /// <summary>
    /// 关联id，后期可以单独拆成单独投诉表
    /// </summary>
    [SugarColumn(ColumnName = "relevanceid", ColumnDescription = "关联id，后期可以单独拆成单独投诉表")]
    public virtual int? relevanceid { get; set; }
    
    /// <summary>
    /// 结束时间
    /// </summary>
    [SugarColumn(ColumnName = "overtime", ColumnDescription = "结束时间")]
    public virtual DateTime? overtime { get; set; }
    
    /// <summary>
    /// 0：正在投诉中，1：完成
    /// </summary>
    [SugarColumn(ColumnName = "cstate", ColumnDescription = "0：正在投诉中，1：完成")]
    public virtual int? cstate { get; set; }
    
    /// <summary>
    /// 投诉内容描述
    /// </summary>
    [SugarColumn(ColumnName = "content", ColumnDescription = "投诉内容描述", Length = 0)]
    public virtual string? content { get; set; }
    
    /// <summary>
    /// 投诉截图
    /// </summary>
    [SugarColumn(ColumnName = "imgs", ColumnDescription = "投诉截图", Length = 0)]
    public virtual string? imgs { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [SugarColumn(ColumnName = "createtime", ColumnDescription = "")]
    public virtual DateTime? createtime { get; set; }
    
}
