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
/// 导师直播间基础输入参数
/// </summary>
public class XzTeachroomBaseInput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    public virtual long? Id { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public virtual long? tid { get; set; }
    
    /// <summary>
    /// 直播间id
    /// </summary>
    public virtual long? roomid { get; set; }
    
    /// <summary>
    /// 直播间图片
    /// </summary>
    public virtual string? img { get; set; }

    /// <summary>
    /// 直播间背景图片
    /// </summary>
    public virtual string? bgimg { get; set; }

    /// <summary>
    /// 1：置顶
    /// </summary>
    public virtual int? istop { get; set; }
    
    /// <summary>
    /// 1：火热
    /// </summary>
    public virtual int? ishot { get; set; }
    
    /// <summary>
    /// 0：1v1,1:问答
    /// </summary>
    public virtual int? rtype { get; set; }
    
    /// <summary>
    /// 标题
    /// </summary>
    public virtual string? title { get; set; }
    
    /// <summary>
    /// 房间人数
    /// </summary>
    public virtual int? rnum { get; set; }
    
    /// <summary>
    /// 0：在线，1：连麦中，2：结束
    /// </summary>
    public virtual int? state { get; set; }
    
    /// <summary>
    /// 时间
    /// </summary>
    public virtual DateTime? createtime { get; set; }
    
    /// <summary>
    /// 标签
    /// </summary>
    public virtual string? tags { get; set; }
    
    /// <summary>
    /// 结束时间
    /// </summary>
    public virtual DateTime? overtime { get; set; }
    
    /// <summary>
    /// 直播时长
    /// </summary>
    public virtual int? livetime { get; set; }
    
}

/// <summary>
/// 导师直播间分页查询输入参数
/// </summary>
public class PageXzTeachroomInput : BasePageInput
{
    /// <summary>
    /// 
    /// </summary>
    public long? tid { get; set; }
    
    /// <summary>
    /// 直播间id
    /// </summary>
    public long? roomid { get; set; }
    
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
    /// 标题
    /// </summary>
    public string? title { get; set; }
    
    /// <summary>
    /// 房间人数
    /// </summary>
    public int? rnum { get; set; }
    
    /// <summary>
    /// 0：在线，1：连麦中，2：结束
    /// </summary>
    public int? state { get; set; }
    
    /// <summary>
    /// 时间范围
    /// </summary>
     public DateTime?[] createtimeRange { get; set; }
    
    /// <summary>
    /// 标签
    /// </summary>
    public string? tags { get; set; }
    
    /// <summary>
    /// 结束时间范围
    /// </summary>
     public DateTime?[] overtimeRange { get; set; }
    
    /// <summary>
    /// 直播时长
    /// </summary>
    public int? livetime { get; set; }
    
    /// <summary>
    /// 选中主键列表
    /// </summary>
     public List<long> SelectKeyList { get; set; }
}

/// <summary>
/// 导师直播间增加输入参数
/// </summary>
public class AddXzTeachroomInput
{
    public long? Id { get; set; }

    /// <summary>
    /// 用户uid连线
    /// </summary>
    public long uid { get; set; }

    /// <summary>
    /// 
    /// </summary>
    public long? tid { get; set; }
    
    /// <summary>
    /// 直播间id
    /// </summary>
    public long? roomid { get; set; }
    
    /// <summary>
    /// 直播间图片
    /// </summary>
    [MaxLength(200, ErrorMessage = "直播间图片字符长度不能超过200")]
    public string? img { get; set; }


    /// <summary>
    /// 直播间背景图片
    /// </summary>
    [MaxLength(200, ErrorMessage = "直播间图片字符长度不能超过200")]
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
    /// 标题
    /// </summary>
    [MaxLength(100, ErrorMessage = "标题字符长度不能超过100")]
    public string? title { get; set; }

    /// <summary>
    /// 介绍
    /// </summary>
    public  string? content { get; set; }

    /// <summary>
    /// 房间人数
    /// </summary>
    public int? rnum { get; set; }


    /// <summary>
    /// 点赞数
    /// </summary>
    public int? likenum { get; set; }


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
    [MaxLength(100, ErrorMessage = "标签字符长度不能超过100")]
    public string? tags { get; set; }
    
    /// <summary>
    /// 结束时间
    /// </summary>
    public DateTime? overtime { get; set; }
    
    /// <summary>
    /// 直播时长
    /// </summary>
    public int? livetime { get; set; }
    
}

/// <summary>
/// 导师直播间删除输入参数
/// </summary>
public class DeleteXzTeachroomInput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    [Required(ErrorMessage = "主键Id不能为空")]
    public long? Id { get; set; }
    
}

/// <summary>
/// 导师直播间更新输入参数
/// </summary>
public class UpdateXzTeachroomInput
{
    /// <summary>
    /// 主键Id
    /// </summary>    
    [Required(ErrorMessage = "主键Id不能为空")]
    public long? Id { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    public long? tid { get; set; }
    
    /// <summary>
    /// 直播间id
    /// </summary>    
    public long? roomid { get; set; }
    
    /// <summary>
    /// 直播间图片
    /// </summary>    
    [MaxLength(200, ErrorMessage = "直播间图片字符长度不能超过200")]
    public string? img { get; set; }


    /// <summary>
    /// 直播间背景图片
    /// </summary>    
    [MaxLength(200, ErrorMessage = "直播间图片字符长度不能超过200")]
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
    /// 标题
    /// </summary>    
    [MaxLength(100, ErrorMessage = "标题字符长度不能超过100")]
    public string? title { get; set; }
    
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
    [MaxLength(100, ErrorMessage = "标签字符长度不能超过100")]
    public string? tags { get; set; }
    
    /// <summary>
    /// 结束时间
    /// </summary>    
    public DateTime? overtime { get; set; }
    
    /// <summary>
    /// 直播时长
    /// </summary>    
    public int? livetime { get; set; }
    
}

/// <summary>
/// 导师直播间主键查询输入参数
/// </summary>
public class QueryByIdXzTeachroomInput : DeleteXzTeachroomInput
{
}

public class TeacherConnectUserInput
{

    /// <summary>
    /// 房间id
    /// </summary>
    [Required(ErrorMessage = "主键Id不能为空")]
    public long? RoomId { get; set; }


    /// <summary>
    /// 0：普通连麦，1：1v1连麦，2：及时通话
    /// </summary>
    public virtual int? itype { get; set; }
}

/// <summary>
/// 导师直播间数据导入实体
/// </summary>
[ExcelImporter(SheetIndex = 1, IsOnlyErrorRows = true)]
public class ImportXzTeachroomInput : BaseImportInput
{
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public long? tid { get; set; }
    
    /// <summary>
    /// 直播间id
    /// </summary>
    [ImporterHeader(Name = "直播间id")]
    [ExporterHeader("直播间id", Format = "", Width = 25, IsBold = true)]
    public long? roomid { get; set; }
    
    /// <summary>
    /// 直播间图片
    /// </summary>
    [ImporterHeader(Name = "直播间图片")]
    [ExporterHeader("直播间图片", Format = "", Width = 25, IsBold = true)]
    public string? img { get; set; }


    /// <summary>
    /// 直播间图片
    /// </summary>
    [ImporterHeader(Name = "直播间背景图片")]
    [ExporterHeader("直播间背景图片", Format = "", Width = 25, IsBold = true)]
    public string? bgimg { get; set; }

    /// <summary>
    /// 1：置顶
    /// </summary>
    [ImporterHeader(Name = "1：置顶")]
    [ExporterHeader("1：置顶", Format = "", Width = 25, IsBold = true)]
    public int? istop { get; set; }
    
    /// <summary>
    /// 1：火热
    /// </summary>
    [ImporterHeader(Name = "1：火热")]
    [ExporterHeader("1：火热", Format = "", Width = 25, IsBold = true)]
    public int? ishot { get; set; }
    
    /// <summary>
    /// 0：1v1,1:问答
    /// </summary>
    [ImporterHeader(Name = "0：1v1,1:问答")]
    [ExporterHeader("0：1v1,1:问答", Format = "", Width = 25, IsBold = true)]
    public int? rtype { get; set; }
    
    /// <summary>
    /// 标题
    /// </summary>
    [ImporterHeader(Name = "标题")]
    [ExporterHeader("标题", Format = "", Width = 25, IsBold = true)]
    public string? title { get; set; }
    
    /// <summary>
    /// 房间人数
    /// </summary>
    [ImporterHeader(Name = "房间人数")]
    [ExporterHeader("房间人数", Format = "", Width = 25, IsBold = true)]
    public int? rnum { get; set; }
    
    /// <summary>
    /// 0：在线，1：连麦中，2：结束
    /// </summary>
    [ImporterHeader(Name = "0：在线，1：连麦中，2：结束")]
    [ExporterHeader("0：在线，1：连麦中，2：结束", Format = "", Width = 25, IsBold = true)]
    public int? state { get; set; }
    
    /// <summary>
    /// 时间
    /// </summary>
    [ImporterHeader(Name = "时间")]
    [ExporterHeader("时间", Format = "", Width = 25, IsBold = true)]
    public DateTime? createtime { get; set; }
    
    /// <summary>
    /// 标签
    /// </summary>
    [ImporterHeader(Name = "标签")]
    [ExporterHeader("标签", Format = "", Width = 25, IsBold = true)]
    public string? tags { get; set; }
    
    /// <summary>
    /// 结束时间
    /// </summary>
    [ImporterHeader(Name = "结束时间")]
    [ExporterHeader("结束时间", Format = "", Width = 25, IsBold = true)]
    public DateTime? overtime { get; set; }
    
    /// <summary>
    /// 直播时长
    /// </summary>
    [ImporterHeader(Name = "直播时长")]
    [ExporterHeader("直播时长", Format = "", Width = 25, IsBold = true)]
    public int? livetime { get; set; }
    
}
