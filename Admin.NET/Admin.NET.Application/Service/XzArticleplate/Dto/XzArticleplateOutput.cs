// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！
using Magicodes.ExporterAndImporter.Core;
using SqlSugar;
namespace Admin.NET.Application;

/// <summary>
/// 板块输出参数
/// </summary>
public class XzArticleplateOutput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    public long Id { get; set; }

    /// <summary>
    /// 标题
    /// </summary>
    public string? title { get; set; }

    /// <summary>
    /// 内容
    /// </summary>
    public string? content { get; set; }

    /// <summary>
    /// 图片
    /// </summary>
    public string? image { get; set; }

    /// <summary>
    /// 热度
    /// </summary>
    public int? ishot { get; set; }    
    
    /// <summary>
    /// 新
    /// </summary>
    public int? isnew { get; set; }    
    
    /// <summary>
    /// 关联数量
    /// </summary>
    public int? count { get; set; }    
    
    /// <summary>
    /// 0：不置顶，1：置顶
    /// </summary>
    public int? istop { get; set; }

    /// <summary>
    /// 类型 0:板块，1：话题
    /// </summary>
    public int? ltype { get; set; }
    /// <summary>
    /// createtime
    /// </summary>
    public DateTime? createtime { get; set; }    
    
}

/// <summary>
/// 板块数据导入模板实体
/// </summary>
public class ExportXzArticleplateOutput : ImportXzArticleplateInput
{
    [ImporterHeader(IsIgnore = true)]
    [ExporterHeader(IsIgnore = true)]
    public override string Error { get; set; }
}
