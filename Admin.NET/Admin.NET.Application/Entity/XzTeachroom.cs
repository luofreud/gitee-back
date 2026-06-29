// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Admin.NET.Core;
using SqlSugar;
namespace Admin.NET.Application.Entity;

/// <summary>
/// 导师直播间
/// </summary>
[Tenant("1300000000001")]
[SugarTable("xz_teachroom", "导师直播间")]
public partial class XzTeachroom : EntityBaseId
{
    /// <summary>
    /// 
    /// </summary>
    [SugarColumn(ColumnName = "tid", ColumnDescription = "")]
    public virtual long? tid { get; set; }

    /// <summary>
    /// 用户id
    /// </summary>
    [SugarColumn(ColumnName = "uid", ColumnDescription = "用户id")]
    public virtual long? uid { get; set; }

    /// <summary>
    /// 直播间id
    /// </summary>
    [SugarColumn(ColumnName = "roomid", ColumnDescription = "直播间id")]
    public virtual long? roomid { get; set; }


    /// <summary>
    /// 导师进入直播间使用的uid
    /// </summary>
    [SugarColumn(ColumnName = "uroomid", ColumnDescription = "导师进入直播间使用的uid")]
    public virtual long? uroomid { get; set; }

    /// <summary>
    /// 直播间封面图片
    /// </summary>
    [SugarColumn(ColumnName = "img", ColumnDescription = "直播间封面图片", Length = 200)]
    public virtual string? img { get; set; }


    /// <summary>
    /// 直播间背景图片
    /// </summary>
    [SugarColumn(ColumnName = "bgimg", ColumnDescription = "直播间背景图片", Length = 200)]
    public virtual string? bgimg { get; set; }

    /// <summary>
    /// 1：置顶
    /// </summary>
    [SugarColumn(ColumnName = "istop", ColumnDescription = "1：置顶")]
    public virtual int? istop { get; set; }

    /// <summary>
    /// 1：火热
    /// </summary>
    [SugarColumn(ColumnName = "ishot", ColumnDescription = "1：火热")]
    public virtual int? ishot { get; set; }

    /// <summary>
    /// 0普通、1中级，2高级，3资深
    /// </summary>
    [SugarColumn(ColumnName = "level", ColumnDescription = "普通、中级，高级，资深")]
    public virtual int? level { get; set; }

    /// <summary>
    ///星盘、合盘、塔罗
    /// </summary>
    [SugarColumn(ColumnName = "major", ColumnDescription = "星盘、合盘、塔罗")]
    public virtual string? major { get; set; }

    /// <summary>
    /// 0：1v1,1:问答
    /// </summary>
    [SugarColumn(ColumnName = "rtype", ColumnDescription = "0：1v1,1:问答")]
    public virtual int? rtype { get; set; }

    /// <summary>
    /// 标题
    /// </summary>
    [SugarColumn(ColumnName = "title", ColumnDescription = "标题", Length = 100)]
    public virtual string? title { get; set; }

    /// <summary>
    /// 介绍
    /// </summary>
    [SugarColumn(ColumnName = "content", ColumnDescription = "介绍", Length = 200)]
    public virtual string? content { get; set; }

    /// <summary>
    /// 房间人数
    /// </summary>
    [SugarColumn(ColumnName = "rnum", ColumnDescription = "房间人数")]
    public virtual int? rnum { get; set; }

    /// <summary>
    /// 观看人数
    /// </summary>
    [SugarColumn(ColumnName = "lookrum", ColumnDescription = "观看人数")]
    public virtual int? lookrum { get; set; }

    /// <summary>
    /// 点赞数
    /// </summary>
    [SugarColumn(ColumnName = "likerum", ColumnDescription = "点赞数")]
    public virtual int? likerum { get; set; }

    /// <summary>
    /// 0：在线，1：连麦中，2：结束
    /// </summary>
    [SugarColumn(ColumnName = "state", ColumnDescription = "0：在线，1：连麦中，2：结束")]
    public virtual int? state { get; set; }

    /// <summary>
    /// 时间
    /// </summary>
    [SugarColumn(ColumnName = "createtime", ColumnDescription = "时间")]
    public virtual DateTime? createtime { get; set; }

    /// <summary>
    /// 标签
    /// </summary>
    [SugarColumn(ColumnName = "tags", ColumnDescription = "标签", Length = 100)]
    public virtual string? tags { get; set; }


    /// <summary>
    /// 结束时间
    /// </summary>
    [SugarColumn(ColumnName = "overtime", ColumnDescription = "结束时间")]
    public virtual DateTime? overtime { get; set; }

    /// <summary>
    /// 直播时长
    /// </summary>
    [SugarColumn(ColumnName = "livetime", ColumnDescription = "直播时长")]
    public virtual int? livetime { get; set; }

    /// <summary>
    /// 导师teacher
    /// </summary>
    [Navigate(NavigateType.OneToOne, nameof(tid), nameof(XzTeacher.Id))]
    public XzTeacher teacher { get; set; }

}
