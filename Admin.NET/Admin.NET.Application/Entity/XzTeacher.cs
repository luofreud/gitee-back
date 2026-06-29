// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Admin.NET.Core;
using SqlSugar;
namespace Admin.NET.Application.Entity;

/// <summary>
/// 星座咨询师
/// </summary>
[Tenant("1300000000001")]
[SugarTable("xz_teacher", "星座咨询师")]
public partial class XzTeacher : EntityBaseId
{
    /// <summary>
    /// uid
    /// </summary>
    [SugarColumn(ColumnName = "uid", ColumnDescription = "uid")]
    public virtual long? uid { get; set; }
    /// <summary>
    /// 姓名
    /// </summary>
    [SugarColumn(ColumnName = "name", ColumnDescription = "姓名", Length = 20)]
    public virtual string? name { get; set; }
    
    /// <summary>
    /// 头像
    /// </summary>
    [SugarColumn(ColumnName = "headimg", ColumnDescription = "头像", Length = 100)]
    public virtual string? headimg { get; set; }
    
    /// <summary>
    /// 等级
    /// </summary>
    [SugarColumn(ColumnName = "level", ColumnDescription = "等级")]
    public virtual int? level { get; set; }
    
    /// <summary>
    /// 推广code
    /// </summary>
    [SugarColumn(ColumnName = "tgcode", ColumnDescription = "推广code", Length = 100)]
    public virtual string? tgcode { get; set; }
    
    /// <summary>
    /// 介绍
    /// </summary>
    [SugarColumn(ColumnName = "introduction", ColumnDescription = "介绍", Length = 500)]
    public virtual string? introduction { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [SugarColumn(ColumnName = "score", ColumnDescription = "")]
    public virtual double? score { get; set; }
    
    /// <summary>
    /// 星钻
    /// </summary>
    [SugarColumn(ColumnName = "xzmoney", ColumnDescription = "星钻")]
    public virtual double? xzmoney { get; set; }
    
    /// <summary>
    /// 从业年限
    /// </summary>
    [SugarColumn(ColumnName = "year", ColumnDescription = "从业年限")]
    public virtual int? year { get; set; }
    
    /// <summary>
    /// 标签
    /// </summary>
    [SugarColumn(ColumnName = "tags", ColumnDescription = "标签", Length = 200)]
    public virtual string? tags { get; set; }
    
    /// <summary>
    /// 0：在线，1：离线，2：禁用
    /// </summary>
    [SugarColumn(ColumnName = "livestate", ColumnDescription = "0：在线，1：离线，2：禁用")]
    public virtual int? livestate { get; set; }
    
    /// <summary>
    /// 0：正常，1：审核中
    /// </summary>
    [SugarColumn(ColumnName = "state", ColumnDescription = "0：正常，1：审核中")]
    public virtual int? state { get; set; }
    
    /// <summary>
    /// 电话
    /// </summary>
    [SugarColumn(ColumnName = "phone", ColumnDescription = "电话", Length = 50)]
    public virtual string? phone { get; set; }
    
    /// <summary>
    /// 身份证照片
    /// </summary>
    [SugarColumn(ColumnName = "card", ColumnDescription = "身份证照片", Length = 150)]
    public virtual string? card { get; set; }
    
    /// <summary>
    /// 银行卡照片
    /// </summary>
    [SugarColumn(ColumnName = "bankcard", ColumnDescription = "银行卡照片", Length = 50)]
    public virtual string? bankcard { get; set; }
    
    /// <summary>
    /// 银行卡编号
    /// </summary>
    [SugarColumn(ColumnName = "banknum", ColumnDescription = "银行卡编号", Length = 20)]
    public virtual string? banknum { get; set; }
    
    /// <summary>
    /// 开户行
    /// </summary>
    [SugarColumn(ColumnName = "bankname", ColumnDescription = "开户行", Length = 50)]
    public virtual string? bankname { get; set; }
    
    /// <summary>
    /// 开户行名称
    /// </summary>
    [SugarColumn(ColumnName = "bankaddress", ColumnDescription = "开户行名称", Length = 150)]
    public virtual string? bankaddress { get; set; }
    
    /// <summary>
    /// 越大越靠前
    /// </summary>
    [SugarColumn(ColumnName = "sortcode", ColumnDescription = "越大越靠前")]
    public virtual int? sortcode { get; set; }
    
    /// <summary>
    /// 0：不推荐，1：推荐
    /// </summary>
    [SugarColumn(ColumnName = "istop", ColumnDescription = "0：不推荐，1：推荐")]
    public virtual int? istop { get; set; }
    
    /// <summary>
    /// 入住时间，审核成功修改时间
    /// </summary>
    [SugarColumn(ColumnName = "checktime", ColumnDescription = "入住时间，审核成功修改时间")]
    public virtual DateTime? checktime { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [SugarColumn(ColumnName = "createtime", ColumnDescription = "")]
    public virtual DateTime? createtime { get; set; }
    
    /// <summary>
    /// 连麦单价
    /// </summary>
    [SugarColumn(ColumnName = "liveprice", ColumnDescription = "连麦单价")]
    public virtual double? liveprice { get; set; }
    
    /// <summary>
    /// 1对1单价
    /// </summary>
    [SugarColumn(ColumnName = "oliveprice", ColumnDescription = "1对1单价")]
    public virtual double? oliveprice { get; set; }


    /// <summary>
    /// 连麦次数
    /// </summary>
    [SugarColumn(ColumnName = "livenum", ColumnDescription = "连麦次数")]
    public virtual int? livenum { get; set; }


    /// <summary>
    /// 解惑次数
    /// </summary>
    [SugarColumn(ColumnName = "doubtnum", ColumnDescription = "解惑次数")]
    public virtual int? doubtnum { get; set; }

}
