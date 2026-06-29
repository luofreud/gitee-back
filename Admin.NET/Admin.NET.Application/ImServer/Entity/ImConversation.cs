// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Admin.NET.Core;
using SqlSugar;
namespace Admin.NET.Application;

/// <summary>
/// IM 会话
/// </summary>
[SugarTable("im_conversation", "IM会话")]
public class ImConversation : EntityBaseId
{
    /// <summary>
    /// 所属用户UID
    /// </summary>
    [SugarColumn(ColumnName = "owner_uid", ColumnDescription = "所属用户UID", Length = 64)]
    public virtual string? OwnerUid { get; set; }

    /// <summary>
    /// 对方ID（用户/群/系统等）
    /// </summary>
    [SugarColumn(ColumnName = "target_id", ColumnDescription = "对方ID", Length = 64)]
    public virtual string? TargetId { get; set; }

    /// <summary>
    /// 对方类型
    /// </summary>
    [SugarColumn(ColumnName = "target_type", ColumnDescription = "对方类型", Length = 10)]
    public virtual string? TargetType { get; set; }

    /// <summary>
    /// 最后一条消息
    /// </summary>
    [SugarColumn(ColumnName = "last_message", ColumnDescription = "最后一条消息", ColumnDataType = "text")]
    public virtual string? LastMessage { get; set; }

    /// <summary>
    /// 最后消息ID
    /// </summary>
    [SugarColumn(ColumnName = "last_msg_id", ColumnDescription = "最后消息ID", Length = 64)]
    public virtual string? LastMsgId { get; set; }

    /// <summary>
    /// 最后消息类型
    /// </summary>
    [SugarColumn(ColumnName = "last_msg_type", ColumnDescription = "最后消息类型", Length = 20)]
    public virtual string? LastMsgType { get; set; }

    /// <summary>
    /// 最后时间
    /// </summary>
    [SugarColumn(ColumnName = "last_time", ColumnDescription = "最后时间")]
    public virtual DateTime? LastTime { get; set; }

    /// <summary>
    /// 未读消息数
    /// </summary>
    [SugarColumn(ColumnName = "unread_count", ColumnDescription = "未读消息数", DefaultValue = "0")]
    public virtual int? UnreadCount { get; set; }

    /// <summary>
    /// 是否置顶
    /// </summary>
    [SugarColumn(ColumnName = "is_top", ColumnDescription = "是否置顶", DefaultValue = "0")]
    public virtual int? IsTop { get; set; }

    /// <summary>
    /// 创建时间
    /// </summary>
    [SugarColumn(ColumnName = "created_at", ColumnDescription = "创建时间")]
    public virtual DateTime? CreatedAt { get; set; }

    /// <summary>
    /// 更新时间
    /// </summary>
    [SugarColumn(ColumnName = "updated_at", ColumnDescription = "更新时间")]
    public virtual DateTime? UpdatedAt { get; set; }


    /// <summary>
    /// 用户信息
    /// </summary>
    [Navigate(NavigateType.OneToOne, nameof(TargetId), nameof(XzUser.Id))]
    public XzUser TargetUser { get; set; }
}
