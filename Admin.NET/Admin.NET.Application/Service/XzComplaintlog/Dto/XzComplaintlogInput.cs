// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Admin.NET.Core;
using Magicodes.ExporterAndImporter.Core;
using Magicodes.ExporterAndImporter.Excel;
using SqlSugar;
using System.ComponentModel.DataAnnotations;

namespace Admin.NET.Application;

/// <summary>
/// 用户投诉记录表基础输入参数
/// </summary>
public class XzComplaintlogBaseInput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    public virtual int? Id { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public virtual int? uid { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public virtual string? cnum { get; set; }
    /// <summary>
    /// 投诉内容
    /// </summary>
    public virtual string? orderquestion { get; set; }

    /// <summary>
    /// 投诉标题
    /// </summary>
    public virtual string? title { get; set; }

    /// <summary>
    ///  0：订单-问答，1：订单-直播连麦，2：订单-语音，3：订单-测评，4：老师，5：其他
    /// </summary>
    public virtual int? ctype { get; set; }
    
    /// <summary>
    /// 关联id，后期可以单独拆成单独投诉表
    /// </summary>
    public virtual int? relevanceid { get; set; }
    
    /// <summary>
    /// 结束时间
    /// </summary>
    public virtual DateTime? overtime { get; set; }
    
    /// <summary>
    /// 0：正在投诉中，1：完成
    /// </summary>
    public virtual int? cstate { get; set; }
    
    /// <summary>
    /// 投诉内容描述
    /// </summary>
    public virtual string? content { get; set; }
    
    /// <summary>
    /// 投诉截图
    /// </summary>
    public virtual string? imgs { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public virtual DateTime? createtime { get; set; }
    
}

/// <summary>
/// 用户投诉记录表分页查询输入参数
/// </summary>
public class PageXzComplaintlogInput : BasePageInput
{
    /// <summary>
    /// 
    /// </summary>
    public int? uid { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public string? cnum { get; set; }
    /// <summary>
    /// 投诉内容
    /// </summary>
    public  string? orderquestion { get; set; }

    /// <summary>
    /// 投诉标题
    /// </summary>
    public string? title { get; set; }

    /// <summary>
    ///  0：订单-问答，1：订单-直播连麦，2：订单-语音，3：订单-测评，4：老师，5：其他
    /// </summary>
    public int? ctype { get; set; }
    
    /// <summary>
    /// 关联id，后期可以单独拆成单独投诉表
    /// </summary>
    public int? relevanceid { get; set; }
    
    /// <summary>
    /// 结束时间范围
    /// </summary>
     public DateTime?[] overtimeRange { get; set; }
    
    /// <summary>
    /// 0：正在投诉中，1：完成
    /// </summary>
    public int? cstate { get; set; }
    
    /// <summary>
    /// 投诉内容描述
    /// </summary>
    public string? content { get; set; }
    
    /// <summary>
    /// 投诉截图
    /// </summary>
    public string? imgs { get; set; }
    
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
/// 用户投诉记录表增加输入参数
/// </summary>
public class AddXzComplaintlogInput
{
    /// <summary>
    /// 
    /// </summary>
    public int? uid { get; set; }

    /// <summary>
    /// 投诉单号
    /// </summary>
    [MaxLength(20, ErrorMessage = "字符长度不能超过20")]
    public string? cnum { get; set; }
    /// <summary>
    /// 投诉内容
    /// </summary>
    public  string? orderquestion { get; set; }

    /// <summary>
    /// 投诉标题
    /// </summary>
    public string? title { get; set; }
    /// <summary>
    ///  0：订单-问答，1：订单-直播连麦，2：订单-语音，3：订单-测评，4：老师，5：其他
    /// </summary>
    public int? ctype { get; set; }
    
    /// <summary>
    /// 关联id，后期可以单独拆成单独投诉表
    /// </summary>
    public long? relevanceid { get; set; }
    
    /// <summary>
    /// 结束时间
    /// </summary>
    public DateTime? overtime { get; set; }
    
    /// <summary>
    /// 0：正在投诉中，1：完成
    /// </summary>
    public int? cstate { get; set; }
    
    /// <summary>
    /// 投诉内容描述
    /// </summary>
    public string? content { get; set; }
    
    /// <summary>
    /// 投诉截图
    /// </summary>
    public string? imgs { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public DateTime? createtime { get; set; }
    
}

/// <summary>
/// 用户投诉记录表删除输入参数
/// </summary>
public class DeleteXzComplaintlogInput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    [Required(ErrorMessage = "主键Id不能为空")]
    public int? Id { get; set; }
    
}

/// <summary>
/// 用户投诉记录表更新输入参数
/// </summary>
public class UpdateXzComplaintlogInput
{
    /// <summary>
    /// 主键Id
    /// </summary>    
    [Required(ErrorMessage = "主键Id不能为空")]
    public int? Id { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    public int? uid { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    [MaxLength(20, ErrorMessage = "字符长度不能超过20")]
    public string? cnum { get; set; }

    /// <summary>
    /// 投诉内容
    /// </summary>
    public  string? orderquestion { get; set; }

    /// <summary>
    /// 投诉标题
    /// </summary>
    public string? title { get; set; }

    /// <summary>
    /// 0：订单-问答，1：订单-直播连麦，2：订单-语音，3：订单-测评，4：老师，5：其他
    /// </summary>    
    public int? ctype { get; set; }
    
    /// <summary>
    /// 关联id，后期可以单独拆成单独投诉表
    /// </summary>    
    public int? relevanceid { get; set; }
    
    /// <summary>
    /// 结束时间
    /// </summary>    
    public DateTime? overtime { get; set; }
    
    /// <summary>
    /// 0：正在投诉中，1：完成
    /// </summary>    
    public int? cstate { get; set; }
    
    /// <summary>
    /// 投诉内容描述
    /// </summary>    
    public string? content { get; set; }
    
    /// <summary>
    /// 投诉截图
    /// </summary>    
    public string? imgs { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    public DateTime? createtime { get; set; }
    
}

/// <summary>
/// 用户投诉记录表主键查询输入参数
/// </summary>
public class QueryByIdXzComplaintlogInput : DeleteXzComplaintlogInput
{
}

/// <summary>
/// 用户投诉记录表数据导入实体
/// </summary>
[ExcelImporter(SheetIndex = 1, IsOnlyErrorRows = true)]
public class ImportXzComplaintlogInput : BaseImportInput
{
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public int? uid { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public string? cnum { get; set; }

    /// <summary>
    /// 投诉内容
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public  string? orderquestion { get; set; }

    /// <summary>
    /// 投诉标题
    /// </summary>
    [SugarColumn(ColumnName = "title", ColumnDescription = "投诉标题", Length = 20)]
    public virtual string? title { get; set; }
    /// <summary>
    /// 0：连麦，1：咨询师，2：
    /// </summary>
    [ImporterHeader(Name = "0：连麦，1：咨询师，2：")]
    [ExporterHeader("0：连麦，1：咨询师，2：", Format = "", Width = 25, IsBold = true)]
    public int? ctype { get; set; }
    
    /// <summary>
    /// 关联id，后期可以单独拆成单独投诉表
    /// </summary>
    [ImporterHeader(Name = "关联id，后期可以单独拆成单独投诉表")]
    [ExporterHeader("关联id，后期可以单独拆成单独投诉表", Format = "", Width = 25, IsBold = true)]
    public int? relevanceid { get; set; }
    
    /// <summary>
    /// 结束时间
    /// </summary>
    [ImporterHeader(Name = "结束时间")]
    [ExporterHeader("结束时间", Format = "", Width = 25, IsBold = true)]
    public DateTime? overtime { get; set; }
    
    /// <summary>
    /// 0：正在投诉中，1：完成
    /// </summary>
    [ImporterHeader(Name = "0：正在投诉中，1：完成")]
    [ExporterHeader("0：正在投诉中，1：完成", Format = "", Width = 25, IsBold = true)]
    public int? cstate { get; set; }
    
    /// <summary>
    /// 投诉内容描述
    /// </summary>
    [ImporterHeader(Name = "投诉内容描述")]
    [ExporterHeader("投诉内容描述", Format = "", Width = 25, IsBold = true)]
    public string? content { get; set; }
    
    /// <summary>
    /// 投诉截图
    /// </summary>
    [ImporterHeader(Name = "投诉截图")]
    [ExporterHeader("投诉截图", Format = "", Width = 25, IsBold = true)]
    public string? imgs { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public DateTime? createtime { get; set; }
    
}
