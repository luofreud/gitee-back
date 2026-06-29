// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Admin.NET.Core;
using SqlSugar;
namespace Admin.NET.Application.Entity;

/// <summary>
/// 星座月运势
/// </summary>
[Tenant("1300000000001")]
[SugarTable("xz_monthfortunes", "星座月运势")]
public partial class XzMonthfortunes : EntityBaseId
{
    /// <summary>
    /// 运势时间
    /// </summary>
    [SugarColumn(ColumnName = "ftime", ColumnDescription = "运势时间")]
    public virtual DateTime? ftime { get; set; }
    
    /// <summary>
    /// 星座类型
    /// </summary>
    [SugarColumn(ColumnName = "signtype", ColumnDescription = "星座类型")]
    public virtual int? signtype { get; set; }
    
    /// <summary>
    /// 综合分数
    /// </summary>
    [SugarColumn(ColumnName = "allscore", ColumnDescription = "综合分数")]
    public virtual int? allscore { get; set; }
    
    /// <summary>
    /// 爱情分数
    /// </summary>
    [SugarColumn(ColumnName = "lovescore", ColumnDescription = "爱情分数")]
    public virtual int? lovescore { get; set; }
    
    /// <summary>
    /// 健康分数
    /// </summary>
    [SugarColumn(ColumnName = "healthscore", ColumnDescription = "健康分数")]
    public virtual int? healthscore { get; set; }
    
    /// <summary>
    /// 财富分数
    /// </summary>
    [SugarColumn(ColumnName = "wealthscore", ColumnDescription = "财富分数")]
    public virtual int? wealthscore { get; set; }
    
    /// <summary>
    /// 幸运数字
    /// </summary>
    [SugarColumn(ColumnName = "luckynum", ColumnDescription = "幸运数字")]
    public virtual int? luckynum { get; set; }
    
    /// <summary>
    /// 幸运颜色
    /// </summary>
    [SugarColumn(ColumnName = "luckycolor", ColumnDescription = "幸运颜色", Length = 20)]
    public virtual string? luckycolor { get; set; }
    
    /// <summary>
    /// 幸运花
    /// </summary>
    [SugarColumn(ColumnName = "luckyflower", ColumnDescription = "幸运花", Length = 20)]
    public virtual string? luckyflower { get; set; }
    
    /// <summary>
    /// 幸运石
    /// </summary>
    [SugarColumn(ColumnName = "luckystone", ColumnDescription = "幸运石", Length = 20)]
    public virtual string? luckystone { get; set; }
    
    /// <summary>
    /// 解释
    /// </summary>
    [SugarColumn(ColumnName = "explaincontent", ColumnDescription = "解释", Length = 2000)]
    public virtual string? explaincontent { get; set; }
    
}
