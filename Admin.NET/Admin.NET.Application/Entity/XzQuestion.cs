// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Admin.NET.Core;
using SqlSugar;
namespace Admin.NET.Application.Entity;

/// <summary>
/// 用户问答
/// </summary>
[Tenant("1300000000001")]
[SugarTable("xz_question", "用户问答")]
public partial class XzQuestion : EntityBaseId
{
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
    /// 名称
    /// </summary>
    [SugarColumn(ColumnName = "name", ColumnDescription = "", Length = 100)]
    public virtual string? name { get; set; }
    
    /// <summary>
    /// 解读内容
    /// </summary>
    [SugarColumn(ColumnName = "content", ColumnDescription = "", Length = 0)]
    public virtual string? content { get; set; }


    /// <summary>
    /// 档案1
    /// </summary>
    [SugarColumn(ColumnName = "aid1", ColumnDescription = "档案1")]
    public virtual long? aid1 { get; set; }


    /// <summary>
    /// 档案2
    /// </summary>
    [SugarColumn(ColumnName = "aid2", ColumnDescription = "档案2")]
    public virtual long? aid2 { get; set; }

    /// <summary>
    /// 0:骰子,1:星盘,2:智慧牌,3:合盘
    /// </summary>
    [SugarColumn(ColumnName = "ordertype", ColumnDescription = "0:骰子,1:星盘,2:智慧牌,3:合盘")]
    public virtual int? ordertype { get; set; }

    /// <summary>
    /// 0：待完成，1：已完成，2：投诉
    /// </summary>
    [SugarColumn(ColumnName = "orderstate", ColumnDescription = "0：待完成，1：已完成，2：投诉")]
    public virtual int? orderstate { get; set; }

    /// <summary>
    /// 完成时间
    /// </summary>
    [SugarColumn(ColumnName = "ftime", ColumnDescription = "")]
    public virtual DateTime? ftime { get; set; }
    
    /// <summary>
    /// 星钻
    /// </summary>
    [SugarColumn(ColumnName = "money", ColumnDescription = "")]
    public virtual double? money { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [SugarColumn(ColumnName = "createtime", ColumnDescription = "")]
    public virtual DateTime? createtime { get; set; }
    
    /// <summary>
    /// 图片
    /// </summary>
    [SugarColumn(ColumnName = "img", ColumnDescription = "", Length = 300)]
    public virtual string? img { get; set; }

    /// <summary>
    /// 订单编号
    /// </summary>
    [SugarColumn(ColumnName = "orderno", ColumnDescription = "", Length = 300)]
    public string? orderno { get; set; }

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
    /// 付费时间
    /// </summary>
    [SugarColumn(ColumnName = "paytime", ColumnDescription = "付费时间")]
    public virtual int? paytime { get; set; }

    /// <summary>
    /// 免费时间
    /// </summary>
    [SugarColumn(ColumnName = "freetime", ColumnDescription = "免费时间")]
    public virtual int? freetime { get; set; }

    /// <summary>
    /// 单价
    /// </summary>
    [SugarColumn(ColumnName = "price", ColumnDescription = "单价")]
    public virtual double? price { get; set; }

    /// <summary>
    /// 删除 0：正常，1：删除
    /// </summary>
    [SugarColumn(ColumnName = "isdel", ColumnDescription = "删除")]
    public virtual int? isdel { get; set; }


    /// <summary>
    /// 星盘解析
    /// </summary>
    [Navigate(NavigateType.OneToOne, nameof(Id), nameof(XzQuestionAstrology.qid))]
    public XzQuestionAstrology astrology { get; set; }
}
