// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Admin.NET.Core;
using SqlSugar;
namespace Admin.NET.Application.Entity;

/// <summary>
/// 咨询师提现记录
/// </summary>
[Tenant("1300000000001")]
[SugarTable("zx_teachcasglog", "咨询师提现记录")]
public partial class ZxTeachcasglog : EntityBaseId
{
    /// <summary>
    /// tid
    /// </summary>
    [SugarColumn(ColumnName = "tid", ColumnDescription = "tid")]
    public virtual int? tid { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [SugarColumn(ColumnName = "oldzxmoney", ColumnDescription = "")]
    public virtual double? oldzxmoney { get; set; }
    
    /// <summary>
    /// 加密key
    /// </summary>
    [SugarColumn(ColumnName = "encode", ColumnDescription = "加密key", Length = 200)]
    public virtual string? encode { get; set; }
    
    /// <summary>
    /// 星币
    /// </summary>
    [SugarColumn(ColumnName = "txzxmoney", ColumnDescription = "星币")]
    public virtual double? txzxmoney { get; set; }
    
    /// <summary>
    /// 体现金额
    /// </summary>
    [SugarColumn(ColumnName = "cashmoney", ColumnDescription = "体现金额")]
    public virtual double? cashmoney { get; set; }
    
    /// <summary>
    /// 0：完成，1：等待审核，2：等待打款，3：驳回
    /// </summary>
    [SugarColumn(ColumnName = "state", ColumnDescription = "0：完成，1：等待审核，2：等待打款，3：驳回")]
    public virtual int? state { get; set; }
    
    /// <summary>
    /// 备注
    /// </summary>
    [SugarColumn(ColumnName = "mark", ColumnDescription = "备注", Length = 200)]
    public virtual string? mark { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [SugarColumn(ColumnName = "receipt", ColumnDescription = "", Length = 100)]
    public virtual string? receipt { get; set; }
    
    /// <summary>
    /// 时间
    /// </summary>
    [SugarColumn(ColumnName = "createtime", ColumnDescription = "时间")]
    public virtual DateTime? createtime { get; set; }
    
}
