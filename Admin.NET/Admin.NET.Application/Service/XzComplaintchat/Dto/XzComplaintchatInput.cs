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
/// 用户投诉聊天记录基础输入参数
/// </summary>
public class XzComplaintchatBaseInput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    public virtual long? Id { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public virtual long? cid { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public virtual long? uid { get; set; }
    
    /// <summary>
    /// 0:用户发送，1：系统发送
    /// </summary>
    public virtual int? direction { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public virtual string? content { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public virtual DateTime? createtime { get; set; }
    
}

/// <summary>
/// 用户投诉聊天记录分页查询输入参数
/// </summary>
public class PageXzComplaintchatInput : BasePageInput
{
    /// <summary>
    /// 
    /// </summary>
    public long? cid { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public long? uid { get; set; }
    
    /// <summary>
    /// 0:用户发送，1：系统发送
    /// </summary>
    public int? direction { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public string? content { get; set; }
    
    /// <summary>
    /// 范围
    /// </summary>
     public DateTime?[] createtimeRange { get; set; }
    
    /// <summary>
    /// 选中主键列表
    /// </summary>
     public List<long> SelectKeyList { get; set; }
}

/// <summary>
/// 用户投诉聊天记录增加输入参数
/// </summary>
public class AddXzComplaintchatInput
{
    /// <summary>
    /// 
    /// </summary>
    public long? cid { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public long? uid { get; set; }
    
    /// <summary>
    /// 0:用户发送，1：系统发送
    /// </summary>
    public int? direction { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public string? content { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public DateTime? createtime { get; set; }
    
}

/// <summary>
/// 用户投诉聊天记录删除输入参数
/// </summary>
public class DeleteXzComplaintchatInput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    [Required(ErrorMessage = "主键Id不能为空")]
    public long? Id { get; set; }
    
}

/// <summary>
/// 用户投诉聊天记录更新输入参数
/// </summary>
public class UpdateXzComplaintchatInput
{
    /// <summary>
    /// 主键Id
    /// </summary>    
    [Required(ErrorMessage = "主键Id不能为空")]
    public long? Id { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    public long? cid { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    public long? uid { get; set; }
    
    /// <summary>
    /// 0:用户发送，1：系统发送
    /// </summary>    
    public int? direction { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    public string? content { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    public DateTime? createtime { get; set; }
    
}

/// <summary>
/// 用户投诉聊天记录主键查询输入参数
/// </summary>
public class QueryByIdXzComplaintchatInput : DeleteXzComplaintchatInput
{
}

/// <summary>
/// 用户投诉聊天记录数据导入实体
/// </summary>
[ExcelImporter(SheetIndex = 1, IsOnlyErrorRows = true)]
public class ImportXzComplaintchatInput : BaseImportInput
{
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public long? cid { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public long? uid { get; set; }
    
    /// <summary>
    /// 0:用户发送，1：系统发送
    /// </summary>
    [ImporterHeader(Name = "0:用户发送，1：系统发送")]
    [ExporterHeader("0:用户发送，1：系统发送", Format = "", Width = 25, IsBold = true)]
    public long? direction { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public string? content { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public DateTime? createtime { get; set; }
    
}
