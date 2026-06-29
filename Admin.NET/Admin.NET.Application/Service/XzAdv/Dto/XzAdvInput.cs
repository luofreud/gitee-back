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
/// 系统广告基础输入参数
/// </summary>
public class XzAdvBaseInput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    public virtual int? Id { get; set; }
    
    /// <summary>
    /// 广告名称
    /// </summary>
    public virtual string? name { get; set; }
    
    /// <summary>
    /// 广告图片
    /// </summary>
    public virtual string? img { get; set; }
    
    /// <summary>
    /// 广告位置
    /// </summary>
    public virtual int? postion { get; set; }
    
    /// <summary>
    /// 开始时间
    /// </summary>
    public virtual DateTime? stime { get; set; }
    
    /// <summary>
    /// 结束时间
    /// </summary>
    public virtual DateTime? etime { get; set; }
    
    /// <summary>
    /// 排序
    /// </summary>
    public virtual int? sortcode { get; set; }
    
    /// <summary>
    /// 跳转地址
    /// </summary>
    public virtual string? url { get; set; }
    
    /// <summary>
    /// 0：启用，1：不显示
    /// </summary>
    public virtual int? isenable { get; set; }
    
    /// <summary>
    /// 点击次数
    /// </summary>
    public virtual int? click { get; set; }
    
    /// <summary>
    /// 时间
    /// </summary>
    public virtual DateTime? createtime { get; set; }
    
}

/// <summary>
/// 系统广告分页查询输入参数
/// </summary>
public class PageXzAdvInput : BasePageInput
{
    /// <summary>
    /// 广告名称
    /// </summary>
    public string? name { get; set; }
    
    /// <summary>
    /// 广告图片
    /// </summary>
    public string? img { get; set; }
    
    /// <summary>
    /// 广告位置
    /// </summary>
    public int? postion { get; set; }
    
    /// <summary>
    /// 开始时间范围
    /// </summary>
     public DateTime?[] stimeRange { get; set; }
    
    /// <summary>
    /// 结束时间范围
    /// </summary>
     public DateTime?[] etimeRange { get; set; }
    
    /// <summary>
    /// 排序
    /// </summary>
    public int? sortcode { get; set; }
    
    /// <summary>
    /// 跳转地址
    /// </summary>
    public string? url { get; set; }
    
    /// <summary>
    /// 0：启用，1：不显示
    /// </summary>
    public int? isenable { get; set; }
    
    /// <summary>
    /// 点击次数
    /// </summary>
    public int? click { get; set; }
    
    /// <summary>
    /// 时间范围
    /// </summary>
     public DateTime?[] createtimeRange { get; set; }
    
    /// <summary>
    /// 选中主键列表
    /// </summary>
     public List<int> SelectKeyList { get; set; }
}

/// <summary>
/// 系统广告增加输入参数
/// </summary>
public class AddXzAdvInput
{
    /// <summary>
    /// 广告名称
    /// </summary>
    [MaxLength(100, ErrorMessage = "广告名称字符长度不能超过100")]
    public string? name { get; set; }
    
    /// <summary>
    /// 广告图片
    /// </summary>
    [MaxLength(300, ErrorMessage = "广告图片字符长度不能超过300")]
    public string? img { get; set; }
    
    /// <summary>
    /// 广告位置
    /// </summary>
    public int? postion { get; set; }
    
    /// <summary>
    /// 开始时间
    /// </summary>
    public DateTime? stime { get; set; }
    
    /// <summary>
    /// 结束时间
    /// </summary>
    public DateTime? etime { get; set; }
    
    /// <summary>
    /// 排序
    /// </summary>
    public int? sortcode { get; set; }
    
    /// <summary>
    /// 跳转地址
    /// </summary>
    [MaxLength(300, ErrorMessage = "跳转地址字符长度不能超过300")]
    public string? url { get; set; }
    
    /// <summary>
    /// 0：启用，1：不显示
    /// </summary>
    public int? isenable { get; set; }
    
    /// <summary>
    /// 点击次数
    /// </summary>
    public int? click { get; set; }
    
    /// <summary>
    /// 时间
    /// </summary>
    public DateTime? createtime { get; set; }
    
}

/// <summary>
/// 系统广告删除输入参数
/// </summary>
public class DeleteXzAdvInput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    [Required(ErrorMessage = "主键Id不能为空")]
    public int? Id { get; set; }
    
}

/// <summary>
/// 系统广告更新输入参数
/// </summary>
public class UpdateXzAdvInput
{
    /// <summary>
    /// 主键Id
    /// </summary>    
    [Required(ErrorMessage = "主键Id不能为空")]
    public int? Id { get; set; }
    
    /// <summary>
    /// 广告名称
    /// </summary>    
    [MaxLength(100, ErrorMessage = "广告名称字符长度不能超过100")]
    public string? name { get; set; }
    
    /// <summary>
    /// 广告图片
    /// </summary>    
    [MaxLength(300, ErrorMessage = "广告图片字符长度不能超过300")]
    public string? img { get; set; }
    
    /// <summary>
    /// 广告位置
    /// </summary>    
    public int? postion { get; set; }
    
    /// <summary>
    /// 开始时间
    /// </summary>    
    public DateTime? stime { get; set; }
    
    /// <summary>
    /// 结束时间
    /// </summary>    
    public DateTime? etime { get; set; }
    
    /// <summary>
    /// 排序
    /// </summary>    
    public int? sortcode { get; set; }
    
    /// <summary>
    /// 跳转地址
    /// </summary>    
    [MaxLength(300, ErrorMessage = "跳转地址字符长度不能超过300")]
    public string? url { get; set; }
    
    /// <summary>
    /// 0：启用，1：不显示
    /// </summary>    
    public int? isenable { get; set; }
    
    /// <summary>
    /// 点击次数
    /// </summary>    
    public int? click { get; set; }
    
    /// <summary>
    /// 时间
    /// </summary>    
    public DateTime? createtime { get; set; }
    
}

/// <summary>
/// 系统广告主键查询输入参数
/// </summary>
public class QueryByIdXzAdvInput : DeleteXzAdvInput
{
}

/// <summary>
/// 系统广告数据导入实体
/// </summary>
[ExcelImporter(SheetIndex = 1, IsOnlyErrorRows = true)]
public class ImportXzAdvInput : BaseImportInput
{
    /// <summary>
    /// 广告名称
    /// </summary>
    [ImporterHeader(Name = "广告名称")]
    [ExporterHeader("广告名称", Format = "", Width = 25, IsBold = true)]
    public string? name { get; set; }
    
    /// <summary>
    /// 广告图片
    /// </summary>
    [ImporterHeader(Name = "广告图片")]
    [ExporterHeader("广告图片", Format = "", Width = 25, IsBold = true)]
    public string? img { get; set; }
    
    /// <summary>
    /// 广告位置
    /// </summary>
    [ImporterHeader(Name = "广告位置")]
    [ExporterHeader("广告位置", Format = "", Width = 25, IsBold = true)]
    public int? postion { get; set; }
    
    /// <summary>
    /// 开始时间
    /// </summary>
    [ImporterHeader(Name = "开始时间")]
    [ExporterHeader("开始时间", Format = "", Width = 25, IsBold = true)]
    public DateTime? stime { get; set; }
    
    /// <summary>
    /// 结束时间
    /// </summary>
    [ImporterHeader(Name = "结束时间")]
    [ExporterHeader("结束时间", Format = "", Width = 25, IsBold = true)]
    public DateTime? etime { get; set; }
    
    /// <summary>
    /// 排序
    /// </summary>
    [ImporterHeader(Name = "排序")]
    [ExporterHeader("排序", Format = "", Width = 25, IsBold = true)]
    public int? sortcode { get; set; }
    
    /// <summary>
    /// 跳转地址
    /// </summary>
    [ImporterHeader(Name = "跳转地址")]
    [ExporterHeader("跳转地址", Format = "", Width = 25, IsBold = true)]
    public string? url { get; set; }
    
    /// <summary>
    /// 0：启用，1：不显示
    /// </summary>
    [ImporterHeader(Name = "0：启用，1：不显示")]
    [ExporterHeader("0：启用，1：不显示", Format = "", Width = 25, IsBold = true)]
    public int? isenable { get; set; }
    
    /// <summary>
    /// 点击次数
    /// </summary>
    [ImporterHeader(Name = "点击次数")]
    [ExporterHeader("点击次数", Format = "", Width = 25, IsBold = true)]
    public int? click { get; set; }
    
    /// <summary>
    /// 时间
    /// </summary>
    [ImporterHeader(Name = "时间")]
    [ExporterHeader("时间", Format = "", Width = 25, IsBold = true)]
    public DateTime? createtime { get; set; }
    
}
