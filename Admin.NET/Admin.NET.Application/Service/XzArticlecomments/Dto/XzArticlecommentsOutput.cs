// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！
using Admin.NET.Application.Entity;
using Aop.Api.Domain;
using Magicodes.ExporterAndImporter.Core;
using SqlSugar;
namespace Admin.NET.Application;

/// <summary>
/// 用户评论列表输出参数
/// </summary>
public class XzArticlecommentsOutput
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
    public long? aid { get; set; }    
    
    /// <summary>
    /// 内容
    /// </summary>
    public string? content { get; set; }    
    
    /// <summary>
    /// 点赞数量
    /// </summary>
    public int? likecount { get; set; }

    /// <summary>
    /// 是否点赞0否 1是
    /// </summary>
    public int? islike { get; set; }

    /// <summary>
    /// 父级
    /// </summary>
    public long? parentid { get; set; }    
    
    /// <summary>
    /// 回复数量
    /// </summary>
    public int? replycount { get; set; }    
    
    /// <summary>
    /// 0：正常，1：待审核，2：禁用
    /// </summary>
    public int? state { get; set; }    
    
    /// <summary>
    /// createtime
    /// </summary>
    public DateTime? createtime { get; set; }

    public XzUserDto xzuser { get; set; }

    public List<XzArticlecommentsOutput> replay { get; set; }

}

/// <summary>
/// 用户评论列表数据导入模板实体
/// </summary>
public class ExportXzArticlecommentsOutput : ImportXzArticlecommentsInput
{
    [ImporterHeader(IsIgnore = true)]
    [ExporterHeader(IsIgnore = true)]
    public override string Error { get; set; }
}
