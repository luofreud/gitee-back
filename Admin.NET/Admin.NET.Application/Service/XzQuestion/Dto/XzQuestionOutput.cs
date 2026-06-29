// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！
using Magicodes.ExporterAndImporter.Core;
using SqlSugar;
namespace Admin.NET.Application;

/// <summary>
/// 用户问答输出参数
/// </summary>
public class XzQuestionOutput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    public long Id { get; set; }

    /// <summary>
    /// 
    /// </summary>
    public int? uid { get; set; }

    /// <summary>
    /// 
    /// </summary>
    public int? tid { get; set; }
    
    
    /// <summary>
    /// 用户档案1
    /// </summary>
    public long? aid1 { get; set; }


    /// <summary>
    /// 用户档案2
    /// </summary>
    public long? aid2 { get; set; }

    /// <summary>
    /// 名称
    /// </summary>
    public string? name { get; set; }

    /// <summary>
    /// 解读内容
    /// </summary>
    public string? content { get; set; }

    /// <summary>
    /// 0:骰子,1:星盘,2:智慧牌,3:合盘
    /// </summary>
    public int? ordertype { get; set; }

    /// <summary>
    /// 0：待完成，1：已完成，2：投诉
    /// </summary>
    public int? orderstate { get; set; }

    /// <summary>
    /// 完成时间
    /// </summary>
    public DateTime? ftime { get; set; }

    /// <summary>
    /// 星钻
    /// </summary>
    public double? money { get; set; }

    /// <summary>
    /// 
    /// </summary>
    public DateTime? createtime { get; set; }

    /// <summary>
    /// 图片
    /// </summary>
    public string? img { get; set; }

    /// <summary>
    /// 订单编号
    /// </summary>
    public string? orderno { get; set; }

    /// <summary>
    /// 开始时间
    /// </summary>
    public DateTime? stime { get; set; }

    /// <summary>
    /// 结束时间
    /// </summary>
    public DateTime? etime { get; set; }

    /// <summary>
    /// 付费时间
    /// </summary>
    public double? paytime { get; set; }

    /// <summary>
    /// 免费时间
    /// </summary>
    public int? freetime { get; set; }

    /// <summary>
    /// 单价
    /// </summary>
    public int? price { get; set; }

    /// <summary>
    /// 星盘解析
    /// </summary>
    public XzQuestionAstrology astrology { get; set; }

}

/// <summary>
/// 用户问答数据导入模板实体
/// </summary>
public class ExportXzQuestionOutput : ImportXzQuestionInput
{
    [ImporterHeader(IsIgnore = true)]
    [ExporterHeader(IsIgnore = true)]
    public override string Error { get; set; }
}
