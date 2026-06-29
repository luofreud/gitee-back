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
/// 用户发布文章基础输入参数
/// </summary>
public class XzArticleBaseInput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    public virtual long? Id { get; set; }
    
    /// <summary>
    /// 板块id
    /// </summary>
    public virtual long? plateid { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public virtual long? uid { get; set; }
    
    /// <summary>
    /// 内容
    /// </summary>
    public virtual string? content { get; set; }
    
    /// <summary>
    /// 图片
    /// </summary>
    public virtual string? imgs { get; set; }
    
    /// <summary>
    /// 视频
    /// </summary>
    public virtual string? videos { get; set; }
    
    /// <summary>
    /// 话题
    /// </summary>
    public virtual string? tags { get; set; }
    /// <summary>
    /// 话题id
    /// </summary>
    public long? topicid { get; set; }

    /// <summary>
    /// 发布板块
    /// </summary>
    public virtual long? atype { get; set; }
    
    /// <summary>
    /// 0:否，1：匿名
    /// </summary>
    public virtual int? isanonymous { get; set; }
    
    /// <summary>
    /// 点赞
    /// </summary>
    public virtual int? likecount { get; set; }
    
    /// <summary>
    /// 评论
    /// </summary>
    public virtual int? commentcount { get; set; }
    
    /// <summary>
    /// 收藏
    /// </summary>
    public virtual int? collectioncount { get; set; }
    
    /// <summary>
    /// 0：不置顶，1：置顶
    /// </summary>
    public virtual int? istop { get; set; }
    
    /// <summary>
    /// createtime
    /// </summary>
    public virtual DateTime? createtime { get; set; }
    
}

/// <summary>
/// 用户发布文章分页查询输入参数
/// </summary>
public class PageXzArticleInput : BasePageInput
{
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
    /// 话题id
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
    /// 评论
    /// </summary>
    public int? commentcount { get; set; }
    
    /// <summary>
    /// 收藏
    /// </summary>
    public int? collectioncount { get; set; }
    
    /// <summary>
    /// 0：不置顶，1：置顶
    /// </summary>
    public int? istop { get; set; }
    
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
/// 用户发布文章增加输入参数
/// </summary>
public class AddXzArticleInput
{
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
    [MaxLength(500, ErrorMessage = "图片字符长度不能超过500")]
    public string? imgs { get; set; }
    
    /// <summary>
    /// 视频
    /// </summary>
    [MaxLength(500, ErrorMessage = "视频字符长度不能超过500")]
    public string? videos { get; set; }
    
    /// <summary>
    /// 话题
    /// </summary>
    [MaxLength(100, ErrorMessage = "话题字符长度不能超过100")]
    public string? tags { get; set; }

    /// <summary>
    /// 话题id
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
    /// 评论
    /// </summary>
    public int? commentcount { get; set; }
    
    /// <summary>
    /// 收藏
    /// </summary>
    public int? collectioncount { get; set; }
    
    /// <summary>
    /// 0：不置顶，1：置顶
    /// </summary>
    public int? istop { get; set; }
    
    /// <summary>
    /// createtime
    /// </summary>
    public DateTime? createtime { get; set; }
    
}

/// <summary>
/// 用户发布文章删除输入参数
/// </summary>
public class DeleteXzArticleInput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    [Required(ErrorMessage = "主键Id不能为空")]
    public long? Id { get; set; }
    
}

/// <summary>
/// 用户发布文章更新输入参数
/// </summary>
public class UpdateXzArticleInput
{
    /// <summary>
    /// 主键Id
    /// </summary>    
    [Required(ErrorMessage = "主键Id不能为空")]
    public long? Id { get; set; }
    
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
    [MaxLength(30, ErrorMessage = "标题不能超过30")]

    public string? title { get; set; }
    /// <summary>
    /// 内容
    /// </summary>    
    public string? content { get; set; }
    
    /// <summary>
    /// 图片
    /// </summary>    
    [MaxLength(500, ErrorMessage = "图片字符长度不能超过500")]
    public string? imgs { get; set; }
    
    /// <summary>
    /// 视频
    /// </summary>    
    [MaxLength(500, ErrorMessage = "视频字符长度不能超过500")]
    public string? videos { get; set; }
    
    /// <summary>
    /// 话题
    /// </summary>    
    [MaxLength(100, ErrorMessage = "话题字符长度不能超过100")]
    public string? tags { get; set; }
    /// <summary>
    /// 话题id
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
    /// 评论
    /// </summary>    
    public int? commentcount { get; set; }
    
    /// <summary>
    /// 收藏
    /// </summary>    
    public int? collectioncount { get; set; }
    
    /// <summary>
    /// 0：不置顶，1：置顶
    /// </summary>    
    public int? istop { get; set; }
    
    /// <summary>
    /// createtime
    /// </summary>    
    public DateTime? createtime { get; set; }
    
}

/// <summary>
/// 用户发布文章主键查询输入参数
/// </summary>
public class QueryByIdXzArticleInput : DeleteXzArticleInput
{
}

/// <summary>
/// 用户发布文章数据导入实体
/// </summary>
[ExcelImporter(SheetIndex = 1, IsOnlyErrorRows = true)]
public class ImportXzArticleInput : BaseImportInput
{
    /// <summary>
    /// 板块id
    /// </summary>
    [ImporterHeader(Name = "板块id")]
    [ExporterHeader("板块id", Format = "", Width = 25, IsBold = true)]
    public long? plateid { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public long? uid { get; set; }
    
    /// <summary>
    /// 内容
    /// </summary>
    [ImporterHeader(Name = "内容")]
    [ExporterHeader("内容", Format = "", Width = 25, IsBold = true)]
    public string? content { get; set; }

    /// <summary>
    /// 标题
    /// </summary>
    [ImporterHeader(Name = "标题")]
    [ExporterHeader("标题", Format = "", Width = 25, IsBold = true)]
    public string? title { get; set; }

    /// <summary>
    /// 图片
    /// </summary>
    [ImporterHeader(Name = "图片")]
    [ExporterHeader("图片", Format = "", Width = 25, IsBold = true)]
    public string? imgs { get; set; }
    
    /// <summary>
    /// 视频
    /// </summary>
    [ImporterHeader(Name = "视频")]
    [ExporterHeader("视频", Format = "", Width = 25, IsBold = true)]
    public string? videos { get; set; }
    
    /// <summary>
    /// 话题
    /// </summary>
    [ImporterHeader(Name = "话题")]
    [ExporterHeader("话题", Format = "", Width = 25, IsBold = true)]
    public string? tags { get; set; }
    
    /// <summary>
    /// 发布板块
    /// </summary>
    [ImporterHeader(Name = "发布板块")]
    [ExporterHeader("发布板块", Format = "", Width = 25, IsBold = true)]
    public long? atype { get; set; }
    
    /// <summary>
    /// 0:否，1：匿名
    /// </summary>
    [ImporterHeader(Name = "0:否，1：匿名")]
    [ExporterHeader("0:否，1：匿名", Format = "", Width = 25, IsBold = true)]
    public int? isanonymous { get; set; }
    
    /// <summary>
    /// 点赞
    /// </summary>
    [ImporterHeader(Name = "点赞")]
    [ExporterHeader("点赞", Format = "", Width = 25, IsBold = true)]
    public int? likecount { get; set; }
    
    /// <summary>
    /// 评论
    /// </summary>
    [ImporterHeader(Name = "评论")]
    [ExporterHeader("评论", Format = "", Width = 25, IsBold = true)]
    public int? commentcount { get; set; }
    
    /// <summary>
    /// 收藏
    /// </summary>
    [ImporterHeader(Name = "收藏")]
    [ExporterHeader("收藏", Format = "", Width = 25, IsBold = true)]
    public int? collectioncount { get; set; }
    
    /// <summary>
    /// 0：不置顶，1：置顶
    /// </summary>
    [ImporterHeader(Name = "0：不置顶，1：置顶")]
    [ExporterHeader("0：不置顶，1：置顶", Format = "", Width = 25, IsBold = true)]
    public int? istop { get; set; }
    
    /// <summary>
    /// createtime
    /// </summary>
    [ImporterHeader(Name = "createtime")]
    [ExporterHeader("createtime", Format = "", Width = 25, IsBold = true)]
    public DateTime? createtime { get; set; }
    
}
