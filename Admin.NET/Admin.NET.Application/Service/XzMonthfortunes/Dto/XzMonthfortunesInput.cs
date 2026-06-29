// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Admin.NET.Core;
using System.ComponentModel.DataAnnotations;
using Magicodes.ExporterAndImporter.Core;
using Magicodes.ExporterAndImporter.Excel;

namespace Admin.NET.Application;

/// <summary>
/// 星座月运势基础输入参数
/// </summary>
public class XzMonthfortunesBaseInput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    public virtual long? Id { get; set; }
    
    /// <summary>
    /// 运势时间
    /// </summary>
    public virtual DateTime? ftime { get; set; }
    
    /// <summary>
    /// 星座类型
    /// </summary>
    public virtual int? signtype { get; set; }
    
    /// <summary>
    /// 综合分数
    /// </summary>
    public virtual int? allscore { get; set; }
    
    /// <summary>
    /// 爱情分数
    /// </summary>
    public virtual int? lovescore { get; set; }
    
    /// <summary>
    /// 健康分数
    /// </summary>
    public virtual int? healthscore { get; set; }
    
    /// <summary>
    /// 财富分数
    /// </summary>
    public virtual int? wealthscore { get; set; }
    
    /// <summary>
    /// 幸运数字
    /// </summary>
    public virtual int? luckynum { get; set; }
    
    /// <summary>
    /// 幸运颜色
    /// </summary>
    public virtual string? luckycolor { get; set; }
    
    /// <summary>
    /// 幸运花
    /// </summary>
    public virtual string? luckyflower { get; set; }
    
    /// <summary>
    /// 幸运石
    /// </summary>
    public virtual string? luckystone { get; set; }
    
    /// <summary>
    /// 解释
    /// </summary>
    public virtual string? explaincontent { get; set; }
    
}

/// <summary>
/// 星座月运势分页查询输入参数
/// </summary>
public class PageXzMonthfortunesInput : BasePageInput
{
    /// <summary>
    /// 运势时间范围
    /// </summary>
     public DateTime?[] ftimeRange { get; set; }
    
    /// <summary>
    /// 星座类型
    /// </summary>
    public int? signtype { get; set; }
    
    /// <summary>
    /// 综合分数
    /// </summary>
    public int? allscore { get; set; }
    
    /// <summary>
    /// 爱情分数
    /// </summary>
    public int? lovescore { get; set; }
    
    /// <summary>
    /// 健康分数
    /// </summary>
    public int? healthscore { get; set; }
    
    /// <summary>
    /// 财富分数
    /// </summary>
    public int? wealthscore { get; set; }
    
    /// <summary>
    /// 幸运数字
    /// </summary>
    public int? luckynum { get; set; }
    
    /// <summary>
    /// 幸运颜色
    /// </summary>
    public string? luckycolor { get; set; }
    
    /// <summary>
    /// 幸运花
    /// </summary>
    public string? luckyflower { get; set; }
    
    /// <summary>
    /// 幸运石
    /// </summary>
    public string? luckystone { get; set; }
    
    /// <summary>
    /// 解释
    /// </summary>
    public string? explaincontent { get; set; }
    
    /// <summary>
    /// 选中主键列表
    /// </summary>
     public List<long> SelectKeyList { get; set; }
}

/// <summary>
/// 星座月运势增加输入参数
/// </summary>
public class AddXzMonthfortunesInput
{
    /// <summary>
    /// 运势时间
    /// </summary>
    public DateTime? ftime { get; set; }
    
    /// <summary>
    /// 星座类型
    /// </summary>
    public int? signtype { get; set; }
    
    /// <summary>
    /// 综合分数
    /// </summary>
    public int? allscore { get; set; }
    
    /// <summary>
    /// 爱情分数
    /// </summary>
    public int? lovescore { get; set; }
    
    /// <summary>
    /// 健康分数
    /// </summary>
    public int? healthscore { get; set; }
    
    /// <summary>
    /// 财富分数
    /// </summary>
    public int? wealthscore { get; set; }
    
    /// <summary>
    /// 幸运数字
    /// </summary>
    public int? luckynum { get; set; }
    
    /// <summary>
    /// 幸运颜色
    /// </summary>
    [MaxLength(20, ErrorMessage = "幸运颜色字符长度不能超过20")]
    public string? luckycolor { get; set; }
    
    /// <summary>
    /// 幸运花
    /// </summary>
    [MaxLength(20, ErrorMessage = "幸运花字符长度不能超过20")]
    public string? luckyflower { get; set; }
    
    /// <summary>
    /// 幸运石
    /// </summary>
    [MaxLength(20, ErrorMessage = "幸运石字符长度不能超过20")]
    public string? luckystone { get; set; }
    
    /// <summary>
    /// 解释
    /// </summary>
    [MaxLength(2000, ErrorMessage = "解释字符长度不能超过2000")]
    public string? explaincontent { get; set; }
    
}

/// <summary>
/// 星座月运势删除输入参数
/// </summary>
public class DeleteXzMonthfortunesInput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    [Required(ErrorMessage = "主键Id不能为空")]
    public long? Id { get; set; }
    
}

/// <summary>
/// 星座月运势更新输入参数
/// </summary>
public class UpdateXzMonthfortunesInput
{
    /// <summary>
    /// 主键Id
    /// </summary>    
    [Required(ErrorMessage = "主键Id不能为空")]
    public long? Id { get; set; }
    
    /// <summary>
    /// 运势时间
    /// </summary>    
    public DateTime? ftime { get; set; }
    
    /// <summary>
    /// 星座类型
    /// </summary>    
    public int? signtype { get; set; }
    
    /// <summary>
    /// 综合分数
    /// </summary>    
    public int? allscore { get; set; }
    
    /// <summary>
    /// 爱情分数
    /// </summary>    
    public int? lovescore { get; set; }
    
    /// <summary>
    /// 健康分数
    /// </summary>    
    public int? healthscore { get; set; }
    
    /// <summary>
    /// 财富分数
    /// </summary>    
    public int? wealthscore { get; set; }
    
    /// <summary>
    /// 幸运数字
    /// </summary>    
    public int? luckynum { get; set; }
    
    /// <summary>
    /// 幸运颜色
    /// </summary>    
    [MaxLength(20, ErrorMessage = "幸运颜色字符长度不能超过20")]
    public string? luckycolor { get; set; }
    
    /// <summary>
    /// 幸运花
    /// </summary>    
    [MaxLength(20, ErrorMessage = "幸运花字符长度不能超过20")]
    public string? luckyflower { get; set; }
    
    /// <summary>
    /// 幸运石
    /// </summary>    
    [MaxLength(20, ErrorMessage = "幸运石字符长度不能超过20")]
    public string? luckystone { get; set; }
    
    /// <summary>
    /// 解释
    /// </summary>    
    [MaxLength(2000, ErrorMessage = "解释字符长度不能超过2000")]
    public string? explaincontent { get; set; }
    
}

/// <summary>
/// 星座月运势主键查询输入参数
/// </summary>
public class QueryByIdXzMonthfortunesInput : DeleteXzMonthfortunesInput
{
}

/// <summary>
/// 星座月运势数据导入实体
/// </summary>
[ExcelImporter(SheetIndex = 1, IsOnlyErrorRows = true)]
public class ImportXzMonthfortunesInput : BaseImportInput
{
    /// <summary>
    /// 运势时间
    /// </summary>
    [ImporterHeader(Name = "运势时间")]
    [ExporterHeader("运势时间", Format = "", Width = 25, IsBold = true)]
    public DateTime? ftime { get; set; }
    
    /// <summary>
    /// 星座类型
    /// </summary>
    [ImporterHeader(Name = "星座类型")]
    [ExporterHeader("星座类型", Format = "", Width = 25, IsBold = true)]
    public int? signtype { get; set; }
    
    /// <summary>
    /// 综合分数
    /// </summary>
    [ImporterHeader(Name = "综合分数")]
    [ExporterHeader("综合分数", Format = "", Width = 25, IsBold = true)]
    public int? allscore { get; set; }
    
    /// <summary>
    /// 爱情分数
    /// </summary>
    [ImporterHeader(Name = "爱情分数")]
    [ExporterHeader("爱情分数", Format = "", Width = 25, IsBold = true)]
    public int? lovescore { get; set; }
    
    /// <summary>
    /// 健康分数
    /// </summary>
    [ImporterHeader(Name = "健康分数")]
    [ExporterHeader("健康分数", Format = "", Width = 25, IsBold = true)]
    public int? healthscore { get; set; }
    
    /// <summary>
    /// 财富分数
    /// </summary>
    [ImporterHeader(Name = "财富分数")]
    [ExporterHeader("财富分数", Format = "", Width = 25, IsBold = true)]
    public int? wealthscore { get; set; }
    
    /// <summary>
    /// 幸运数字
    /// </summary>
    [ImporterHeader(Name = "幸运数字")]
    [ExporterHeader("幸运数字", Format = "", Width = 25, IsBold = true)]
    public int? luckynum { get; set; }
    
    /// <summary>
    /// 幸运颜色
    /// </summary>
    [ImporterHeader(Name = "幸运颜色")]
    [ExporterHeader("幸运颜色", Format = "", Width = 25, IsBold = true)]
    public string? luckycolor { get; set; }
    
    /// <summary>
    /// 幸运花
    /// </summary>
    [ImporterHeader(Name = "幸运花")]
    [ExporterHeader("幸运花", Format = "", Width = 25, IsBold = true)]
    public string? luckyflower { get; set; }
    
    /// <summary>
    /// 幸运石
    /// </summary>
    [ImporterHeader(Name = "幸运石")]
    [ExporterHeader("幸运石", Format = "", Width = 25, IsBold = true)]
    public string? luckystone { get; set; }
    
    /// <summary>
    /// 解释
    /// </summary>
    [ImporterHeader(Name = "解释")]
    [ExporterHeader("解释", Format = "", Width = 25, IsBold = true)]
    public string? explaincontent { get; set; }
    
}
