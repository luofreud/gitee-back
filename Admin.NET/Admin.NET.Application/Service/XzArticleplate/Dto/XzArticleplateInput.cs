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
/// 板块基础输入参数
/// </summary>
public class XzArticleplateBaseInput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    public virtual long? Id { get; set; }


    /// <summary>
    /// 标题
    /// </summary>
    public string? title { get; set; }

    /// <summary>
    /// 内容
    /// </summary>
    public virtual string? content { get; set; }

    /// <summary>
    /// 图片
    /// </summary>
    public string? image { get; set; }
    /// <summary>
    /// 热度
    /// </summary>
    public virtual int? ishot { get; set; }
    
    /// <summary>
    /// 新
    /// </summary>
    public virtual int? isnew { get; set; }
    
    /// <summary>
    /// 关联数量
    /// </summary>
    public virtual int? count { get; set; }
    
    /// <summary>
    /// 0：不置顶，1：置顶
    /// </summary>
    public virtual int? istop { get; set; }

    /// <summary>
    /// 类型 0:板块，1：话题
    /// </summary>
    public int? ltype { get; set; }
    /// <summary>
    /// createtime
    /// </summary>
    public virtual DateTime? createtime { get; set; }
    
}

/// <summary>
/// 板块分页查询输入参数
/// </summary>
public class PageXzArticleplateInput : BasePageInput
{


    /// <summary>
    /// 标题
    /// </summary>
    public string? title { get; set; }
    /// <summary>
    /// 内容
    /// </summary>
    public string? content { get; set; }
    
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
    /// createtime范围
    /// </summary>
    public DateTime?[] createtimeRange { get; set; }
    
    /// <summary>
    /// 选中主键列表
    /// </summary>
     public List<long> SelectKeyList { get; set; }
}

/// <summary>
/// 板块增加输入参数
/// </summary>
public class AddXzArticleplateInput: XzArticleplateBaseInput
{
    
}

/// <summary>
/// 板块删除输入参数
/// </summary>
public class DeleteXzArticleplateInput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    [Required(ErrorMessage = "主键Id不能为空")]
    public long? Id { get; set; }
    
}

/// <summary>
/// 板块更新输入参数
/// </summary>
public class UpdateXzArticleplateInput : XzArticleplateBaseInput
{
    /// <summary>
    /// 主键Id
    /// </summary>    
    [Required(ErrorMessage = "主键Id不能为空")]
    public long? Id { get; set; }
    
}

/// <summary>
/// 板块主键查询输入参数
/// </summary>
public class QueryByIdXzArticleplateInput : DeleteXzArticleplateInput
{
}

/// <summary>
/// 板块数据导入实体
/// </summary>
[ExcelImporter(SheetIndex = 1, IsOnlyErrorRows = true)]
public class ImportXzArticleplateInput : BaseImportInput
{
    /// <summary>
    /// 内容
    /// </summary>
    [ImporterHeader(Name = "内容")]
    [ExporterHeader("内容", Format = "", Width = 25, IsBold = true)]
    public string? content { get; set; }
    
    /// <summary>
    /// 热度
    /// </summary>
    [ImporterHeader(Name = "热度")]
    [ExporterHeader("热度", Format = "", Width = 25, IsBold = true)]
    public int? ishot { get; set; }
    
    /// <summary>
    /// 新
    /// </summary>
    [ImporterHeader(Name = "新")]
    [ExporterHeader("新", Format = "", Width = 25, IsBold = true)]
    public int? isnew { get; set; }
    
    /// <summary>
    /// 关联数量
    /// </summary>
    [ImporterHeader(Name = "关联数量")]
    [ExporterHeader("关联数量", Format = "", Width = 25, IsBold = true)]
    public int? count { get; set; }
    
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
