// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！
using Magicodes.ExporterAndImporter.Core;
using SqlSugar;
namespace Admin.NET.Application;

/// <summary>
/// 星币兑换商城输出参数
/// </summary>
public class XzExchangeshopOutput
{
    /// <summary>
    /// 主键Id
    /// </summary>
    public long Id { get; set; }

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
    /// createtime
    /// </summary>
    public DateTime? createtime { get; set; }

    /// <summary>
    /// 标签名称
    /// </summary>
    public string? lable { get; set; }

    /// <summary>
    /// 兑换商品等级
    /// </summary>
    public int? level { get; set; }

    /// <summary>
    /// 0:实物，1：虚拟商品
    /// </summary>
    public int? virtualgood { get; set; }

    /// <summary>
    /// 兑换次数
    /// </summary>
    public int? limitcount { get; set; }

    /// <summary>
    /// 排序
    /// </summary>
    public virtual int? sortcode { get; set; }

    /// <summary>
    /// 0：每月兑换，1：只能兑换
    /// </summary>
    public virtual int? limittype { get; set; }

}
/// <summary>
/// 输出
/// </summary>
public class AppXzExchangeshopOutput
{
    /// <summary>
    /// 标签名称
    /// </summary>
    public string? lable { get; set; }

    public List<XzExchangeshopOutput> xzExchangeshops =new List<XzExchangeshopOutput>();

}

/// <summary>
/// 星币兑换商城数据导入模板实体
/// </summary>
public class ExportXzExchangeshopOutput : ImportXzExchangeshopInput
{
    [ImporterHeader(IsIgnore = true)]
    [ExporterHeader(IsIgnore = true)]
    public override string Error { get; set; }
}
