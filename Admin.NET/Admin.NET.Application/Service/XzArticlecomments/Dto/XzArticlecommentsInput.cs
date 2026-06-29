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
/// 用户评论列表基础输入参数
/// </summary>
public class XzArticlecommentsBaseInput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    public virtual long? Id { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public virtual long? uid { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public virtual long? aid { get; set; }
    
    /// <summary>
    /// 内容
    /// </summary>
    public virtual string? content { get; set; }
    
    /// <summary>
    /// 点赞数量
    /// </summary>
    public virtual int? likecount { get; set; }
    
    /// <summary>
    /// 父级
    /// </summary>
    public virtual long? parentid { get; set; }
    
    /// <summary>
    /// 回复数量
    /// </summary>
    public virtual int? replycount { get; set; }
    
    /// <summary>
    /// 0：正常，1：待审核，2：禁用
    /// </summary>
    public virtual int? state { get; set; }
    
    /// <summary>
    /// createtime
    /// </summary>
    public virtual DateTime? createtime { get; set; }
    
}

/// <summary>
/// 用户评论列表分页查询输入参数
/// </summary>
public class PageXzArticlecommentsInput : BasePageInput
{
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
    /// createtime范围
    /// </summary>
     public DateTime?[] createtimeRange { get; set; }
    
    /// <summary>
    /// 选中主键列表
    /// </summary>
     public List<long> SelectKeyList { get; set; }
}

/// <summary>
/// 用户评论列表增加输入参数
/// </summary>
public class AddXzArticlecommentsInput
{
    public long? id { get; set; }
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
    [MaxLength(500, ErrorMessage = "内容字符长度不能超过500")]
    public string? content { get; set; }
    
    /// <summary>
    /// 点赞数量
    /// </summary>
    public int? likecount { get; set; }
    
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
    
}

/// <summary>
/// 用户评论列表删除输入参数
/// </summary>
public class DeleteXzArticlecommentsInput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    [Required(ErrorMessage = "主键Id不能为空")]
    public long? Id { get; set; }
    
}

/// <summary>
/// 用户评论列表更新输入参数
/// </summary>
public class UpdateXzArticlecommentsInput
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
    public long? aid { get; set; }
    
    /// <summary>
    /// 内容
    /// </summary>    
    [MaxLength(500, ErrorMessage = "内容字符长度不能超过500")]
    public string? content { get; set; }
    
    /// <summary>
    /// 点赞数量
    /// </summary>    
    public int? likecount { get; set; }
    
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
    
}

/// <summary>
/// 用户评论列表主键查询输入参数
/// </summary>
public class QueryByIdXzArticlecommentsInput : DeleteXzArticlecommentsInput
{
}

/// <summary>
/// 用户评论列表数据导入实体
/// </summary>
[ExcelImporter(SheetIndex = 1, IsOnlyErrorRows = true)]
public class ImportXzArticlecommentsInput : BaseImportInput
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
    public long? aid { get; set; }
    
    /// <summary>
    /// 内容
    /// </summary>
    [ImporterHeader(Name = "内容")]
    [ExporterHeader("内容", Format = "", Width = 25, IsBold = true)]
    public string? content { get; set; }
    
    /// <summary>
    /// 点赞数量
    /// </summary>
    [ImporterHeader(Name = "点赞数量")]
    [ExporterHeader("点赞数量", Format = "", Width = 25, IsBold = true)]
    public int? likecount { get; set; }
    
    /// <summary>
    /// 父级
    /// </summary>
    [ImporterHeader(Name = "父级")]
    [ExporterHeader("父级", Format = "", Width = 25, IsBold = true)]
    public long? parentid { get; set; }
    
    /// <summary>
    /// 回复数量
    /// </summary>
    [ImporterHeader(Name = "回复数量")]
    [ExporterHeader("回复数量", Format = "", Width = 25, IsBold = true)]
    public int? replycount { get; set; }
    
    /// <summary>
    /// 0：正常，1：待审核，2：禁用
    /// </summary>
    [ImporterHeader(Name = "0：正常，1：待审核，2：禁用")]
    [ExporterHeader("0：正常，1：待审核，2：禁用", Format = "", Width = 25, IsBold = true)]
    public int? state { get; set; }
    
    /// <summary>
    /// createtime
    /// </summary>
    [ImporterHeader(Name = "createtime")]
    [ExporterHeader("createtime", Format = "", Width = 25, IsBold = true)]
    public DateTime? createtime { get; set; }
    
}
