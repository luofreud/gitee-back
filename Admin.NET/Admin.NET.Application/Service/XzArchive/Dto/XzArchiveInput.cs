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
/// 用户档案基础输入参数
/// </summary>
public class XzArchiveBaseInput
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
    /// 名称
    /// </summary>
    public virtual string? name { get; set; }

    /// <summary>
    /// 关系
    /// </summary>
    public virtual string? relation { get; set; }

    /// <summary>
    /// 性别 0:男，1：女
    /// </summary>
    public virtual int? sex { get; set; }

    /// <summary>
    /// 生产日期
    /// </summary>
    public virtual string? birthday { get; set; }

    /// <summary>
    /// 出生地址
    /// </summary>
    public virtual string? address { get; set; }

    /// <summary>
    /// 出生地址经度
    /// </summary>
    public virtual string? addresslat { get; set; }


    /// <summary>
    /// 出生地址纬度
    /// </summary>
    public virtual string? addresslong { get; set; }

    /// <summary>
    /// 现居地址
    /// </summary>
    public virtual string? nowaddress { get; set; }

    /// <summary>
    /// 现居地址经度
    /// </summary>
    public virtual string? nowaddresslat { get; set; }


    /// <summary>
    /// 现居地址纬度
    /// </summary>
    public virtual string? nowaddresslong { get; set; }

    /// <summary>
    /// 0：否，1：是（夏令时）
    /// </summary>
    public virtual int? isdst { get; set; }

    /// <summary>
    /// 时区
    /// </summary>
    public virtual string? timezone { get; set; }

    /// <summary>
    /// 
    /// </summary>
    public virtual DateTime? createtime { get; set; }
    
}

/// <summary>
/// 用户档案分页查询输入参数
/// </summary>
public class PageXzArchiveInput : BasePageInput
{
    /// <summary>
    /// 
    /// </summary>
    public long? uid { get; set; }

    /// <summary>
    /// 名称
    /// </summary>
    public string? name { get; set; }

    /// <summary>
    /// 关系
    /// </summary>
    public string? relation { get; set; }

    /// <summary>
    /// 性别 0:男，1：女
    /// </summary>
    public int? sex { get; set; }

    /// <summary>
    /// 生产日期
    /// </summary>
    public string? birthday { get; set; }

    /// <summary>
    /// 出生地址
    /// </summary>
    public string? address { get; set; }

    /// <summary>
    /// 出生地址经度
    /// </summary>
    public string? addresslat { get; set; }


    /// <summary>
    /// 出生地址纬度
    /// </summary>
    public string? addresslong { get; set; }

    /// <summary>
    /// 现居地址
    /// </summary>
    public string? nowaddress { get; set; }

    /// <summary>
    /// 现居地址经度
    /// </summary>
    public string? nowaddresslat { get; set; }


    /// <summary>
    /// 现居地址纬度
    /// </summary>
    public string? nowaddresslong { get; set; }

    /// <summary>
    /// 0：否，1：是（夏令时）
    /// </summary>
    public int? isdst { get; set; }

    /// <summary>
    /// 时区
    /// </summary>
    public string? timezone { get; set; }

    /// <summary>
    /// 范围
    /// </summary>
    public DateTime?[] createtimeRange { get; set; }
    
    /// <summary>
    /// 选中主键列表
    /// </summary>
     public List<long> SelectKeyList { get; set; }
}

/// <summary>
/// 用户档案增加输入参数
/// </summary>
public class AddXzArchiveInput
{
    /// <summary>
    /// 
    /// </summary>
    public long? uid { get; set; }

    /// <summary>
    /// 
    /// </summary>
    [MaxLength(50, ErrorMessage = "字符长度不能超过50")]
    public string? name { get; set; }

    /// <summary>
    /// 关系
    /// </summary>
    [MaxLength(20, ErrorMessage = "字符长度不能超过20")]
    public string? relation { get; set; }

    /// <summary>
    /// 性别 0:男，1：女
    /// </summary>
    public int? sex { get; set; }

    /// <summary>
    /// 日期
    /// </summary>
    [MaxLength(50, ErrorMessage = "字符长度不能超过50")]
    public string? birthday { get; set; }

    /// <summary>
    /// 出生地址
    /// </summary>
    [MaxLength(100, ErrorMessage = "字符长度不能超过100")]
    public string? address { get; set; }

    /// <summary>
    /// 现居地址
    /// </summary>
    [MaxLength(100, ErrorMessage = "字符长度不能超过100")]
    public string? nowaddress { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public DateTime? createtime { get; set; }

    /// <summary>
    /// 出生地址经度
    /// </summary>
    [MaxLength(100, ErrorMessage = "字符长度不能超过100")]
    public string? addresslat { get; set; }


    /// <summary>
    /// 出生地址纬度
    /// </summary>
    [MaxLength(100, ErrorMessage = "字符长度不能超过100")]
    public string? addresslong { get; set; }


    /// <summary>
    /// 现居地址经度
    /// </summary>
    [MaxLength(100, ErrorMessage = "字符长度不能超过100")]
    public string? nowaddresslat { get; set; }


    /// <summary>
    /// 现居地址纬度
    /// </summary>
    [MaxLength(100, ErrorMessage = "字符长度不能超过100")]
    public string? nowaddresslong { get; set; }

    /// <summary>
    /// 0：否，1：是（夏令时）
    /// </summary>
    public int? isdst { get; set; }

    /// <summary>
    /// 时区
    /// </summary>
    [MaxLength(100, ErrorMessage = "字符长度不能超过100")]
    public string? timezone { get; set; }

}

/// <summary>
/// 用户档案删除输入参数
/// </summary>
public class DeleteXzArchiveInput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    [Required(ErrorMessage = "主键Id不能为空")]
    public long? Id { get; set; }
    
}

/// <summary>
/// 用户档案更新输入参数
/// </summary>
public class UpdateXzArchiveInput
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
    [MaxLength(50, ErrorMessage = "字符长度不能超过50")]
    public string? name { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    [MaxLength(20, ErrorMessage = "字符长度不能超过20")]
    public string? relation { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    public int? sex { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    [MaxLength(50, ErrorMessage = "字符长度不能超过50")]
    public string? birthday { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    [MaxLength(100, ErrorMessage = "字符长度不能超过100")]
    public string? address { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    [MaxLength(100, ErrorMessage = "字符长度不能超过100")]
    public string? nowaddress { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    public DateTime? createtime { get; set; }

    /// <summary>
    /// 出生地址经度
    /// </summary>
    [MaxLength(100, ErrorMessage = "字符长度不能超过100")]
    public string? addresslat { get; set; }


    /// <summary>
    /// 出生地址纬度
    /// </summary>
    [MaxLength(100, ErrorMessage = "字符长度不能超过100")]
    public string? addresslong { get; set; }


    /// <summary>
    /// 现居地址经度
    /// </summary>
    [MaxLength(100, ErrorMessage = "字符长度不能超过100")]
    public string? nowaddresslat { get; set; }


    /// <summary>
    /// 现居地址纬度
    /// </summary>
    [MaxLength(100, ErrorMessage = "字符长度不能超过100")]
    public string? nowaddresslong { get; set; }

    /// <summary>
    /// 0：否，1：是（夏令时）
    /// </summary>
    public int? isdst { get; set; }

    /// <summary>
    /// 时区
    /// </summary>
    [MaxLength(100, ErrorMessage = "字符长度不能超过100")]
    public string? timezone { get; set; }

}

/// <summary>
/// 用户档案主键查询输入参数
/// </summary>
public class QueryByIdXzArchiveInput : DeleteXzArchiveInput
{
}

/// <summary>
/// 用户档案数据导入实体
/// </summary>
[ExcelImporter(SheetIndex = 1, IsOnlyErrorRows = true)]
public class ImportXzArchiveInput : BaseImportInput
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
    public string? name { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public string? relation { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public int? sex { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public string? birthday { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public string? address { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public string? nowaddress { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public DateTime? createtime { get; set; }
    
}
