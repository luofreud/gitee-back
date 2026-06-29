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
/// 星币兑换商城基础输入参数
/// </summary>
public class XzExchangeshopBaseInput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    public virtual long? Id { get; set; }
    
    /// <summary>
    /// 商品名称
    /// </summary>
    public virtual string? goodname { get; set; }
    
    /// <summary>
    /// 商品图片
    /// </summary>
    public virtual string? goodimg { get; set; }
    
    /// <summary>
    /// 兑换星币数量
    /// </summary>
    public virtual int? xbmoney { get; set; }
    
    /// <summary>
    /// 商品数量
    /// </summary>
    public virtual int? count { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public virtual int? xzmoney { get; set; }
    
    /// <summary>
    /// 类型id
    /// </summary>
    public virtual long? goodtypeid { get; set; }
    
    /// <summary>
    /// 0：正常，1：下架
    /// </summary>
    public virtual int? state { get; set; }
    
    /// <summary>
    /// createtime
    /// </summary>
    public virtual DateTime? createtime { get; set; }
    
}

/// <summary>
/// 星币兑换商城分页查询输入参数
/// </summary>
public class PageXzExchangeshopInput : BasePageInput
{
    /// <summary>
    /// 商品名称
    /// </summary>
    public string? goodname { get; set; }
    
    /// <summary>
    /// 商品图片
    /// </summary>
    public string? goodimg { get; set; }
    
    /// <summary>
    /// 兑换星币数量
    /// </summary>
    public int? xbmoney { get; set; }
    
    /// <summary>
    /// 商品数量
    /// </summary>
    public int? count { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public int? xzmoney { get; set; }
    
    /// <summary>
    /// 类型id
    /// </summary>
    public long? goodtypeid { get; set; }
    
    /// <summary>
    /// 0：正常，1：下架
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
/// 星币兑换商城增加输入参数
/// </summary>
public class AddXzExchangeshopInput
{
    /// <summary>
    /// 商品名称
    /// </summary>
    [MaxLength(200, ErrorMessage = "商品名称字符长度不能超过200")]
    public string? goodname { get; set; }
    
    /// <summary>
    /// 商品图片
    /// </summary>
    [MaxLength(200, ErrorMessage = "商品图片字符长度不能超过200")]
    public string? goodimg { get; set; }
    
    /// <summary>
    /// 兑换星币数量
    /// </summary>
    public int? xbmoney { get; set; }
    
    /// <summary>
    /// 商品数量
    /// </summary>
    public int? count { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public int? xzmoney { get; set; }
    
    /// <summary>
    /// 类型id
    /// </summary>
    public long? goodtypeid { get; set; }
    
    /// <summary>
    /// 0：正常，1：下架
    /// </summary>
    public int? state { get; set; }
    
    /// <summary>
    /// createtime
    /// </summary>
    public DateTime? createtime { get; set; }
    
}

/// <summary>
/// 星币兑换商城删除输入参数
/// </summary>
public class DeleteXzExchangeshopInput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    [Required(ErrorMessage = "主键Id不能为空")]
    public long? Id { get; set; }
    
}

/// <summary>
/// 星币兑换商城更新输入参数
/// </summary>
public class UpdateXzExchangeshopInput
{
    /// <summary>
    /// 主键Id
    /// </summary>    
    [Required(ErrorMessage = "主键Id不能为空")]
    public long? Id { get; set; }
    
    /// <summary>
    /// 商品名称
    /// </summary>    
    [MaxLength(200, ErrorMessage = "商品名称字符长度不能超过200")]
    public string? goodname { get; set; }
    
    /// <summary>
    /// 商品图片
    /// </summary>    
    [MaxLength(200, ErrorMessage = "商品图片字符长度不能超过200")]
    public string? goodimg { get; set; }
    
    /// <summary>
    /// 兑换星币数量
    /// </summary>    
    public int? xbmoney { get; set; }
    
    /// <summary>
    /// 商品数量
    /// </summary>    
    public int? count { get; set; }
    
    /// <summary>
    /// 
    /// </summary>    
    public int? xzmoney { get; set; }
    
    /// <summary>
    /// 类型id
    /// </summary>    
    public long? goodtypeid { get; set; }
    
    /// <summary>
    /// 0：正常，1：下架
    /// </summary>    
    public int? state { get; set; }
    
    /// <summary>
    /// createtime
    /// </summary>    
    public DateTime? createtime { get; set; }
    
}

/// <summary>
/// 星币兑换商城主键查询输入参数
/// </summary>
public class QueryByIdXzExchangeshopInput : DeleteXzExchangeshopInput
{
}

/// <summary>
/// 星币兑换商城数据导入实体
/// </summary>
[ExcelImporter(SheetIndex = 1, IsOnlyErrorRows = true)]
public class ImportXzExchangeshopInput : BaseImportInput
{
    /// <summary>
    /// 商品名称
    /// </summary>
    [ImporterHeader(Name = "商品名称")]
    [ExporterHeader("商品名称", Format = "", Width = 25, IsBold = true)]
    public string? goodname { get; set; }
    
    /// <summary>
    /// 商品图片
    /// </summary>
    [ImporterHeader(Name = "商品图片")]
    [ExporterHeader("商品图片", Format = "", Width = 25, IsBold = true)]
    public string? goodimg { get; set; }
    
    /// <summary>
    /// 兑换星币数量
    /// </summary>
    [ImporterHeader(Name = "兑换星币数量")]
    [ExporterHeader("兑换星币数量", Format = "", Width = 25, IsBold = true)]
    public int? xbmoney { get; set; }
    
    /// <summary>
    /// 商品数量
    /// </summary>
    [ImporterHeader(Name = "商品数量")]
    [ExporterHeader("商品数量", Format = "", Width = 25, IsBold = true)]
    public int? count { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [ImporterHeader(Name = "")]
    [ExporterHeader("", Format = "", Width = 25, IsBold = true)]
    public int? xzmoney { get; set; }
    
    /// <summary>
    /// 类型id
    /// </summary>
    [ImporterHeader(Name = "类型id")]
    [ExporterHeader("类型id", Format = "", Width = 25, IsBold = true)]
    public long? goodtypeid { get; set; }
    
    /// <summary>
    /// 0：正常，1：下架
    /// </summary>
    [ImporterHeader(Name = "0：正常，1：下架")]
    [ExporterHeader("0：正常，1：下架", Format = "", Width = 25, IsBold = true)]
    public int? state { get; set; }
    
    /// <summary>
    /// createtime
    /// </summary>
    [ImporterHeader(Name = "createtime")]
    [ExporterHeader("createtime", Format = "", Width = 25, IsBold = true)]
    public DateTime? createtime { get; set; }
    
}
