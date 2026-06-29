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
/// 用户签到基础输入参数
/// </summary>
public class XzCheckBaseInput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    public virtual long? Id { get; set; }
    
    /// <summary>
    /// uid
    /// </summary>
    public virtual long? uid { get; set; }
    
    /// <summary>
    /// 签到时间
    /// </summary>
    public virtual DateTime? qdtime { get; set; }
    
    /// <summary>
    /// 记录时间
    /// </summary>
    public virtual DateTime? createtime { get; set; }
    
}

/// <summary>
/// 用户签到分页查询输入参数
/// </summary>
public class PageXzCheckInput : BasePageInput
{
    /// <summary>
    /// uid
    /// </summary>
    public long? uid { get; set; }
    
    /// <summary>
    /// 签到时间范围
    /// </summary>
     public DateTime?[] qdtimeRange { get; set; }
    
    /// <summary>
    /// 记录时间范围
    /// </summary>
     public DateTime?[] createtimeRange { get; set; }
    
    /// <summary>
    /// 选中主键列表
    /// </summary>
     public List<long> SelectKeyList { get; set; }
}

/// <summary>
/// 用户签到增加输入参数
/// </summary>
public class AddXzCheckInput
{
    /// <summary>
    /// uid
    /// </summary>
    public long? uid { get; set; }
    
    /// <summary>
    /// 签到时间
    /// </summary>
    public DateTime? qdtime { get; set; }
    
    /// <summary>
    /// 记录时间
    /// </summary>
    public DateTime? createtime { get; set; }
    
}

/// <summary>
/// 用户签到删除输入参数
/// </summary>
public class DeleteXzCheckInput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    [Required(ErrorMessage = "主键Id不能为空")]
    public long? Id { get; set; }
    
}

/// <summary>
/// 用户签到更新输入参数
/// </summary>
public class UpdateXzCheckInput
{
    /// <summary>
    /// 主键Id
    /// </summary>    
    [Required(ErrorMessage = "主键Id不能为空")]
    public long? Id { get; set; }
    
    /// <summary>
    /// uid
    /// </summary>    
    public long? uid { get; set; }
    
    /// <summary>
    /// 签到时间
    /// </summary>    
    public DateTime? qdtime { get; set; }
    
    /// <summary>
    /// 记录时间
    /// </summary>    
    public DateTime? createtime { get; set; }
    
}

/// <summary>
/// 用户签到主键查询输入参数
/// </summary>
public class QueryByIdXzCheckInput : DeleteXzCheckInput
{
}

/// <summary>
/// 用户签到数据导入实体
/// </summary>
[ExcelImporter(SheetIndex = 1, IsOnlyErrorRows = true)]
public class ImportXzCheckInput : BaseImportInput
{
    /// <summary>
    /// uid
    /// </summary>
    [ImporterHeader(Name = "uid")]
    [ExporterHeader("uid", Format = "", Width = 25, IsBold = true)]
    public long? uid { get; set; }
    
    /// <summary>
    /// 签到时间
    /// </summary>
    [ImporterHeader(Name = "签到时间")]
    [ExporterHeader("签到时间", Format = "", Width = 25, IsBold = true)]
    public DateTime? qdtime { get; set; }
    
    /// <summary>
    /// 记录时间
    /// </summary>
    [ImporterHeader(Name = "记录时间")]
    [ExporterHeader("记录时间", Format = "", Width = 25, IsBold = true)]
    public DateTime? createtime { get; set; }
    
}
