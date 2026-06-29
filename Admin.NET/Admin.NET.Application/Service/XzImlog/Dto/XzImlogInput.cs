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
/// 咨询连麦记录基础输入参数
/// </summary>
public class XzImlogBaseInput
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
    /// 0：普通连麦，1：1v1连麦，2：及时通话
    /// </summary>
    public virtual int? itype { get; set; }
    
    /// <summary>
    /// 消费星钻
    /// </summary>
    public virtual double? xzmoney { get; set; }
    
    /// <summary>
    /// 订单号
    /// </summary>
    public virtual string? orderno { get; set; }
    
    /// <summary>
    /// 0：不删除，1：删除
    /// </summary>
    public virtual int? isdel { get; set; }
    
    /// <summary>
    /// 单价
    /// </summary>
    public virtual double? price { get; set; }

    /// <summary>
    /// 0：未连麦，1：正在连麦，2：已完成连麦，3：投诉状态
    /// </summary>
    public virtual int? state { get; set; }
    
    /// <summary>
    /// 连麦时长
    /// </summary>
    public virtual int? imtime { get; set; }
    
    /// <summary>
    /// 结束时间
    /// </summary>
    public virtual DateTime? overtime { get; set; }
    
    /// <summary>
    /// 付费时常
    /// </summary>
    public virtual int? paytime { get; set; }

    /// <summary>
    /// 免费时常
    /// </summary>
    public virtual int? freetime { get; set; }
    /// <summary>
    /// createtime
    /// </summary>
    public virtual DateTime? createtime { get; set; }
    
}

/// <summary>
/// 咨询连麦记录分页查询输入参数
/// </summary>
public class PageXzImlogInput : BasePageInput
{
    /// <summary>
    /// 
    /// </summary>
    public long? uid { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public int? tid { get; set; }
    
    /// <summary>
    /// 0：普通连麦，1：1v1连麦，2：及时通话
    /// </summary>
    public int? itype { get; set; }
    
    /// <summary>
    /// 消费星钻
    /// </summary>
    public double? xzmoney { get; set; }
    
    /// <summary>
    /// 订单号
    /// </summary>
    public string? orderno { get; set; }
    
    /// <summary>
    /// 0：不删除，1：删除
    /// </summary>
    public int? isdel { get; set; }
    
    /// <summary>
    /// 单价
    /// </summary>
    public double? price { get; set; }

    /// <summary>
    /// 0：未连麦，1：正在连麦，2：已完成连麦，3：投诉状态
    /// </summary>
    public virtual int? state { get; set; }

    /// <summary>
    /// 连麦时长
    /// </summary>
    public int? imtime { get; set; }
    
    /// <summary>
    /// 结束时间范围
    /// </summary>
     public DateTime?[] overtimeRange { get; set; }
        
    /// <summary>
    /// createtime范围
    /// </summary>
     public DateTime?[] createtimeRange { get; set; }
    
    /// <summary>
    /// 选中主键列表
    /// </summary>
     public List<long> SelectKeyList { get; set; }
}

/// <summary>
/// 咨询连麦记录增加输入参数
/// </summary>
public class AddXzImlogInput
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
    /// 0：普通连麦，1：1v1连麦，2：及时通话
    /// </summary>
    public int? itype { get; set; }
    
    /// <summary>
    /// 消费星钻
    /// </summary>
    public double? xzmoney { get; set; }
    
    /// <summary>
    /// 订单号
    /// </summary>
    [MaxLength(20, ErrorMessage = "订单号字符长度不能超过20")]
    public string? orderno { get; set; }
    
    /// <summary>
    /// 0：不删除，1：删除
    /// </summary>
    public int? isdel { get; set; }
    
    /// <summary>
    /// 单价
    /// </summary>
    public double? price { get; set; }

    /// <summary>
    /// 0：未连麦，1：正在连麦，2：已完成连麦，3：投诉状态
    /// </summary>
    public  int? state { get; set; }

    /// <summary>
    /// 连麦时长
    /// </summary>
    public int? imtime { get; set; }
    
    /// <summary>
    /// 结束时间
    /// </summary>
    public DateTime? overtime { get; set; }
    
    
    /// <summary>
    /// createtime
    /// </summary>
    public DateTime? createtime { get; set; }
    
}

/// <summary>
/// 咨询连麦记录删除输入参数
/// </summary>
public class DeleteXzImlogInput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    [Required(ErrorMessage = "主键Id不能为空")]
    public long? Id { get; set; }
    
}

/// <summary>
/// 咨询连麦记录更新输入参数
/// </summary>
public class UpdateXzImlogInput
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
    /// 0：普通连麦，1：1v1连麦，2：及时通话
    /// </summary>    
    public int? itype { get; set; }
    
    /// <summary>
    /// 消费星钻
    /// </summary>    
    public double? xzmoney { get; set; }
    
    /// <summary>
    /// 订单号
    /// </summary>    
    [MaxLength(20, ErrorMessage = "订单号字符长度不能超过20")]
    public string? orderno { get; set; }
    
    /// <summary>
    /// 0：不删除，1：删除
    /// </summary>    
    public int? isdel { get; set; }
    
    /// <summary>
    /// 单价
    /// </summary>    
    public double? price { get; set; }

    /// <summary>
    /// 0：未连麦，1：正在连麦，2：已完成连麦，3：投诉状态
    /// </summary>
    public  int? state { get; set; }

    /// <summary>
    /// 连麦时长
    /// </summary>    
    public int? imtime { get; set; }
    
    /// <summary>
    /// 结束时间
    /// </summary>    
    public DateTime? overtime { get; set; }
    
    
    /// <summary>
    /// createtime
    /// </summary>    
    public DateTime? createtime { get; set; }
    
}

/// <summary>
/// 咨询连麦记录主键查询输入参数
/// </summary>
public class QueryByIdXzImlogInput : DeleteXzImlogInput
{
}

/// <summary>
/// 咨询连麦记录数据导入实体
/// </summary>
[ExcelImporter(SheetIndex = 1, IsOnlyErrorRows = true)]
public class ImportXzImlogInput : BaseImportInput
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
    /// 0：普通连麦，1：1v1连麦，2：及时通话
    /// </summary>
    [ImporterHeader(Name = "0：普通连麦，1：1v1连麦，2：及时通话")]
    [ExporterHeader("0：普通连麦，1：1v1连麦，2：及时通话", Format = "", Width = 25, IsBold = true)]
    public int? itype { get; set; }
    
    /// <summary>
    /// 消费星钻
    /// </summary>
    [ImporterHeader(Name = "消费星钻")]
    [ExporterHeader("消费星钻", Format = "", Width = 25, IsBold = true)]
    public double? xzmoney { get; set; }
    
    /// <summary>
    /// 订单号
    /// </summary>
    [ImporterHeader(Name = "订单号")]
    [ExporterHeader("订单号", Format = "", Width = 25, IsBold = true)]
    public string? orderno { get; set; }
    
    /// <summary>
    /// 0：不删除，1：删除
    /// </summary>
    [ImporterHeader(Name = "0：不删除，1：删除")]
    [ExporterHeader("0：不删除，1：删除", Format = "", Width = 25, IsBold = true)]
    public int? isdel { get; set; }
    
    /// <summary>
    /// 单价
    /// </summary>
    [ImporterHeader(Name = "单价")]
    [ExporterHeader("单价", Format = "", Width = 25, IsBold = true)]
    public double? price { get; set; }
    
    /// <summary>
    /// 0：未连麦，1：正在连麦，2：已完成连麦
    /// </summary>
    [ImporterHeader(Name = "0：未连麦，1：正在连麦，2：已完成连麦,3：投诉状态")]
    [ExporterHeader("0：未连麦，1：正在连麦，2：已完成连麦", Format = "", Width = 25, IsBold = true)]
    public int? state { get; set; }
    
    /// <summary>
    /// 连麦时长
    /// </summary>
    [ImporterHeader(Name = "连麦时长")]
    [ExporterHeader("连麦时长", Format = "", Width = 25, IsBold = true)]
    public int? imtime { get; set; }
    
    /// <summary>
    /// 结束时间
    /// </summary>
    [ImporterHeader(Name = "结束时间")]
    [ExporterHeader("结束时间", Format = "", Width = 25, IsBold = true)]
    public DateTime? overtime { get; set; }
    
  
    
    /// <summary>
    /// createtime
    /// </summary>
    [ImporterHeader(Name = "createtime")]
    [ExporterHeader("createtime", Format = "", Width = 25, IsBold = true)]
    public DateTime? createtime { get; set; }
    
}
