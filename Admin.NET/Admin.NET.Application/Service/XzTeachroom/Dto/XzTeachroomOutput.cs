// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！
using Admin.NET.Application.Entity;
using Magicodes.ExporterAndImporter.Core;
using SqlSugar;
namespace Admin.NET.Application;

/// <summary>
/// 导师直播间输出参数
/// </summary>
public class XzTeachroomOutput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    public long Id { get; set; }

    /// <summary>
    /// 
    /// </summary>
    public long? tid { get; set; }

    /// <summary>
    /// 直播间id
    /// </summary>
    public long? roomid { get; set; }

    /// <summary>
    /// 导师直播间id
    /// </summary>
    public long? uroomid { get; set; }

    /// <summary>
    /// 直播间图片
    /// </summary>
    public string? img { get; set; }


    /// <summary>
    /// 直播间背景图片
    /// </summary>
    public string? bgimg { get; set; }

    /// <summary>
    /// 1：置顶
    /// </summary>
    public int? istop { get; set; }

    /// <summary>
    /// 1：火热
    /// </summary>
    public int? ishot { get; set; }

    /// <summary>
    /// 0：1v1,1:问答
    /// </summary>
    public int? rtype { get; set; }

    /// <summary>
    /// 0普通、1中级，2高级，3资深
    /// </summary>
    public int? level { get; set; }
    /// <summary>
    ///星盘、合盘、塔罗
    /// </summary>
    public string? major { get; set; }

    /// <summary>
    /// 观看人数
    /// </summary>
    public int? lookrum { get; set; }

    /// <summary>
    /// 点赞数
    /// </summary>
    public int? likerum { get; set; }
    /// <summary>
    /// 标题
    /// </summary>
    public string? title { get; set; }

    /// <summary>
    /// 介绍
    /// </summary>
    public string? content { get; set; }


    /// <summary>
    /// 房间人数
    /// </summary>
    public int? rnum { get; set; }

    /// <summary>
    /// 0：在线，1：连麦中，2：结束
    /// </summary>
    public int? state { get; set; }

    /// <summary>
    /// 时间
    /// </summary>
    public DateTime? createtime { get; set; }

    /// <summary>
    /// 标签
    /// </summary>
    public string? tags { get; set; }

    /// <summary>
    /// 结束时间
    /// </summary>
    public DateTime? overtime { get; set; }

    /// <summary>
    /// 直播时长
    /// </summary>
    public int? livetime { get; set; }

    /// <summary>
    /// 导师
    /// </summary>
    public AppXzTeacherInput teacher {get;set;}
    
}

/// <summary>
/// 导师直播间数据导入模板实体
/// </summary>
public class ExportXzTeachroomOutput : ImportXzTeachroomInput
{
    [ImporterHeader(IsIgnore = true)]
    [ExporterHeader(IsIgnore = true)]
    public override string Error { get; set; }
}
