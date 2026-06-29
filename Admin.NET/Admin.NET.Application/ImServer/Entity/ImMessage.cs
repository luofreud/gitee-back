// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Admin.NET.Core;
using SqlSugar;
namespace Admin.NET.Application;

/// <summary>
/// IM 消息
/// </summary>
[SugarTable("im_message", "IM消息")]
public class ImMessage : EntityBaseId
{
    /// <summary>
    /// 消息ID
    /// </summary>
    [SugarColumn(ColumnName = "msg_id", ColumnDescription = "消息ID", Length = 64)]
    public virtual string? MsgId { get; set; }

    /// <summary>
    /// 发送方UID
    /// </summary>
    [SugarColumn(ColumnName = "from_uid", ColumnDescription = "发送方UID", Length = 64)]
    public virtual string? FromUid { get; set; }

    /// <summary>
    /// 接收方UID
    /// </summary>
    [SugarColumn(ColumnName = "to_uid", ColumnDescription = "接收方UID", Length = 64)]
    public virtual string? ToUid { get; set; }

    /// <summary>
    /// 消息类型
    /// </summary>
    [SugarColumn(ColumnName = "type", ColumnDescription = "消息类型", Length = 20)]
    public virtual string? Type { get; set; }

    /// <summary>
    /// 消息内容
    /// </summary>
    [SugarColumn(ColumnName = "content", ColumnDescription = "消息内容", ColumnDataType = "text")]
    public virtual string? Content { get; set; }

    /// <summary>
    /// 类型
    /// </summary>
    [SugarColumn(ColumnName = "typeu", ColumnDescription = "类型", DefaultValue = "0")]
    public virtual int? Typeu { get; set; }

    /// <summary>
    /// 状态
    /// </summary>
    [SugarColumn(ColumnName = "status", ColumnDescription = "状态", DefaultValue = "0")]
    public virtual int? Status { get; set; }

    /// <summary>
    /// 创建时间
    /// </summary>
    [SugarColumn(ColumnName = "created_at", ColumnDescription = "创建时间")]
    public virtual DateTime? CreatedAt { get; set; }
}
