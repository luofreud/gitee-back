// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！
using Admin.NET.Application.Entity;
using Magicodes.ExporterAndImporter.Core;
namespace Admin.NET.Application;

/// <summary>
/// 用户发布文章输出参数
/// </summary>
public class XzArticleOutput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    public long Id { get; set; }    
    
    /// <summary>
    /// 板块id
    /// </summary>
    public long? plateid { get; set; }    
    
    /// <summary>
    /// 
    /// </summary>
    public long? uid { get; set; }
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
    public string? imgs { get; set; }    
    
    /// <summary>
    /// 视频
    /// </summary>
    public string? videos { get; set; }    
    
    /// <summary>
    /// 话题
    /// </summary>
    public string? tags { get; set; }    

    /// <summary>
    /// 话题关联id
    /// </summary>
    public long? topicid { get; set; }

    /// <summary>
    /// 发布板块
    /// </summary>
    public long? atype { get; set; }    
    
    /// <summary>
    /// 0:否，1：匿名
    /// </summary>
    public int? isanonymous { get; set; }    
    
    /// <summary>
    /// 点赞
    /// </summary>
    public int? likecount { get; set; }

    /// <summary>
    /// 是否点赞0否 1：是
    /// </summary>
    public int? islike { get; set; }

    /// <summary>
    /// 评论
    /// </summary>
    public int? commentcount { get; set; }

    /// <summary>
    /// 收藏
    /// </summary>
    public int? collectioncount { get; set; }

    /// <summary>
    /// 是否收藏 0否 1：是
    /// </summary>
    public int? iscollection { get; set; }

    /// <summary>
    /// 0：不置顶，1：置顶
    /// </summary>
    public int? istop { get; set; }    
    
    /// <summary>
    /// 用户信息
    /// </summary>
    public XzUser? user { get; set; }

    /// <summary>
    /// 导师直播间
    /// </summary>
    public XzTeachroom? teachroom { get; set; }

}

/// <summary>
/// 用户发布文章数据导入模板实体
/// </summary>
public class ExportXzArticleOutput : ImportXzArticleInput
{
    [ImporterHeader(IsIgnore = true)]
    [ExporterHeader(IsIgnore = true)]
    public override string Error { get; set; }
}
