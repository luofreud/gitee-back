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
/// 用户问答基础输入参数
/// </summary>
public class XzQuestionBaseInput
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
    public virtual int? tid { get; set; }

    /// <summary>
    /// 名称
    /// </summary>
    public virtual string? name { get; set; }

    /// <summary>
    /// 解读内容
    /// </summary>
    public virtual string? content { get; set; }

    /// <summary>
    /// 0:骰子,1:星盘,2:智慧牌,3:合盘
    /// </summary>
    public virtual int? ordertype { get; set; }

    /// <summary>
    /// 0：待完成，1：已完成，2：投诉
    /// </summary>
    public virtual int? orderstate { get; set; }

    /// <summary>
    /// 完成时间
    /// </summary>
    public virtual DateTime? ftime { get; set; }

    /// <summary>
    /// 星钻
    /// </summary>
    public virtual double? money { get; set; }

    /// <summary>
    /// 
    /// </summary>
    public virtual DateTime? createtime { get; set; }

    /// <summary>
    /// 图片
    /// </summary>
    public virtual string? img { get; set; }

    /// <summary>
    /// 订单编号
    /// </summary>
    public string? orderno { get; set; }

    /// <summary>
    /// 开始时间
    /// </summary>
    public virtual DateTime? stime { get; set; }

    /// <summary>
    /// 结束时间
    /// </summary>
    public virtual DateTime? etime { get; set; }

    /// <summary>
    /// 付费时间
    /// </summary>
    public virtual int? paytime { get; set; }

    /// <summary>
    /// 免费时间
    /// </summary>
    public virtual int? freetime { get; set; }

    /// <summary>
    /// 单价
    /// </summary>
    public virtual double? price { get; set; }

}

/// <summary>
/// 用户问答分页查询输入参数
/// </summary>
public class PageXzQuestionInput : BasePageInput
{
    /// <summary>
    /// 
    /// </summary>
    public long? uid { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public long? tid { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public string? name { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public string? content { get; set; }
    
    /// <summary>
    /// 1：星盘解读，2：测评解读
    /// </summary>
    public int? ordertype { get; set; }

    /// <summary>
    /// 0：待完成，1：完成，2：投诉
    /// </summary>
    public int? orderstate { get; set; }
    
    /// <summary>
    /// 范围
    /// </summary>
     public DateTime?[] ftimeRange { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public int? money { get; set; }
    
    /// <summary>
    /// 范围
    /// </summary>
     public DateTime?[] createtimeRange { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public string? img { get; set; }
    
    /// <summary>
    /// 选中主键列表
    /// </summary>
     public List<long> SelectKeyList { get; set; }
}

/// <summary>
/// 用户问答增加输入参数
/// </summary>
public class AddXzQuestionInput
{
    /// <summary>
    /// 用户id
    /// </summary>
    public long? uid { get; set; }
    
    /// <summary>
    /// 导师id
    /// </summary>
    public long? tid { get; set; }

    /// <summary>
    /// 用户档案1
    /// </summary>
    public long? aid1 { get; set; }


    /// <summary>
    /// 用户档案2
    /// </summary>
    public long? aid2 { get; set; }
    /// <summary>
    /// 
    /// </summary>
    [MaxLength(100, ErrorMessage = "字符长度不能超过100")]
    public string? name { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public string? content { get; set; }

    /// <summary>
    /// 0:骰子,1:星盘,2:智慧牌,3:合盘
    /// </summary>
    public int? ordertype { get; set; }
    
    /// <summary>
    /// 0：已完成，1：待完成
    /// </summary>
    public int? orderstate { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public DateTime? ftime { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public double? money { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public DateTime? createtime { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [MaxLength(300, ErrorMessage = "字符长度不能超过300")]
    public string? img { get; set; }
    
}

/// <summary>
/// 用户问答删除输入参数
/// </summary>
public class DeleteXzQuestionInput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    [Required(ErrorMessage = "主键Id不能为空")]
    public long? Id { get; set; }
    
}

/// <summary>
/// 用户问答更新输入参数
/// </summary>
public class UpdateXzQuestionInput
{
    /// <summary>
    /// 主键Id
    /// </summary>    
    [Required(ErrorMessage = "主键Id不能为空")]
    public long? Id { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    public long? uid { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    public long? tid { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    [MaxLength(100, ErrorMessage = "字符长度不能超过100")]
    public string? name { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    public string? content { get; set; }
    
    /// <summary>
    /// 1：星盘解读，2：测评解读
    /// </summary>    
    public int? ordertype { get; set; }
    
    /// <summary>
    /// 0：已完成，1：待完成
    /// </summary>    
    public int? orderstate { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    public DateTime? ftime { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    public int? money { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    public DateTime? createtime { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    [MaxLength(300, ErrorMessage = "字符长度不能超过300")]
    public string? img { get; set; }
    
}

/// <summary>
/// 用户问答主键查询输入参数
/// </summary>
public class QueryByIdXzQuestionInput : DeleteXzQuestionInput
{
}

/// <summary>
/// 用户问答数据导入实体
/// </summary>
[ExcelImporter(SheetIndex = 1, IsOnlyErrorRows = true)]
public class ImportXzQuestionInput : BaseImportInput
{
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public long? uid { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public long? tid { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public string? name { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public string? content { get; set; }
    
    /// <summary>
    /// 1：星盘解读，2：测评解读
    /// </summary>
    [ImporterHeader(Name = "1：星盘解读，2：测评解读")]
    [ExporterHeader("1：星盘解读，2：测评解读", Format = "", Width = 25, IsBold = true)]
    public int? ordertype { get; set; }
    
    /// <summary>
    /// 0：已完成，1：待完成
    /// </summary>
    [ImporterHeader(Name = "0：已完成，1：待完成")]
    [ExporterHeader("0：已完成，1：待完成", Format = "", Width = 25, IsBold = true)]
    public int? orderstate { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public DateTime? ftime { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public int? money { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public DateTime? createtime { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public string? img { get; set; }
    
}
