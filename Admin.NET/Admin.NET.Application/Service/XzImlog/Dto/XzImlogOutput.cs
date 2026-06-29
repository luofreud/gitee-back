// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！
using Magicodes.ExporterAndImporter.Core;
using SqlSugar;
namespace Admin.NET.Application;

/// <summary>
/// 咨询连麦记录输出参数
/// </summary>
public class XzImlogOutput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    public long Id { get; set; }    
    
    /// <summary>
    /// 
    /// </summary>
    public long? uid { get; set; }    
    
    /// <summary>
    /// 
    /// </summary>
    public long? tid { get; set; }

    /// <summary>
    /// 房间id
    /// </summary>
    public long? roomid { get; set; }


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
    public int? state { get; set; }    
    
    /// <summary>
    /// 连麦时长
    /// </summary>
    public int? imtime { get; set; }

    /// <summary>
    /// 开始时间
    /// </summary>
    public DateTime? starttime { get; set; }
    /// <summary>
    /// 结束时间
    /// </summary>
    public DateTime? overtime { get; set; }

    /// <summary>
    /// 付费时常
    /// </summary>
    public int? paytime { get; set; }

    /// <summary>
    /// 免费时常
    /// </summary>
    public int? freetime { get; set; }

    /// <summary>
    /// createtime
    /// </summary>
    public DateTime? createtime { get; set; }


    /// <summary>
    /// 用户星钻
    /// </summary>
    public double? userxzmoney { get; set; }

    /// <summary>
    /// 直播app
    /// </summary>
    public string appid { get; set; }

    /// <summary>
    /// 直播间token
    /// </summary>
    public string roomtoken { get; set; }


    /// <summary>
    /// 用户信息
    /// </summary>
    public XzTeacherOutput teacher { get; set; }
}

/// <summary>
/// 咨询连麦记录数据导入模板实体
/// </summary>
public class ExportXzImlogOutput : ImportXzImlogInput
{
    [ImporterHeader(IsIgnore = true)]
    [ExporterHeader(IsIgnore = true)]
    public override string Error { get; set; }
}
