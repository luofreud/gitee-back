// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Admin.NET.Core;
using SqlSugar;
namespace Admin.NET.Application.Entity;

/// <summary>
/// 用户档案
/// </summary>
[Tenant("1300000000001")]
[SugarTable("xz_archive", "用户档案")]
public partial class XzArchive : EntityBaseId
{
    /// <summary>
    /// 
    /// </summary>
    [SugarColumn(ColumnName = "uid", ColumnDescription = "")]
    public virtual long? uid { get; set; }

    /// <summary>
    /// 名称
    /// </summary>
    [SugarColumn(ColumnName = "name", ColumnDescription = "名称", Length = 50)]
    public virtual string? name { get; set; }

    /// <summary>
    /// 关系
    /// </summary>
    [SugarColumn(ColumnName = "relation", ColumnDescription = "关系", Length = 20)]
    public virtual string? relation { get; set; }

    /// <summary>
    /// 性别 0:男，1：女
    /// </summary>
    [SugarColumn(ColumnName = "sex", ColumnDescription = "性别")]
    public virtual int? sex { get; set; }

    /// <summary>
    /// 生产日期
    /// </summary>
    [SugarColumn(ColumnName = "birthday", ColumnDescription = "生产日期", Length = 50)]
    public virtual string? birthday { get; set; }

    /// <summary>
    /// 出生地址
    /// </summary>
    [SugarColumn(ColumnName = "address", ColumnDescription = "出生地址", Length = 100)]
    public virtual string? address { get; set; }

    /// <summary>
    /// 出生地址经度
    /// </summary>
    [SugarColumn(ColumnName = "addresslat", ColumnDescription = "出生地址经度", Length = 100)]
    public virtual string? addresslat { get; set; }


    /// <summary>
    /// 出生地址纬度
    /// </summary>
    [SugarColumn(ColumnName = "addresslong", ColumnDescription = "出生地址纬度", Length = 100)]
    public virtual string? addresslong { get; set; }

    /// <summary>
    /// 现居地址
    /// </summary>
    [SugarColumn(ColumnName = "nowaddress", ColumnDescription = "现居地址", Length = 100)]
    public virtual string? nowaddress { get; set; }

    /// <summary>
    /// 现居地址经度
    /// </summary>
    [SugarColumn(ColumnName = "nowaddresslat", ColumnDescription = "现居地址经度", Length = 100)]
    public virtual string? nowaddresslat { get; set; }


    /// <summary>
    /// 现居地址纬度
    /// </summary>
    [SugarColumn(ColumnName = "nowaddresslong", ColumnDescription = "现居地址纬度", Length = 100)]
    public virtual string? nowaddresslong { get; set; }

    /// <summary>
    /// 0：否，1：是（夏令时）
    /// </summary>
    [SugarColumn(ColumnName = "isdst", ColumnDescription = "0：否，1：是")]
    public virtual int? isdst { get; set; }

    /// <summary>
    /// 时区
    /// </summary>
    [SugarColumn(ColumnName = "timezone", ColumnDescription = "时区", Length = 100)]
    public virtual string? timezone { get; set; }

    /// <summary>
    /// 时间
    /// </summary>
    [SugarColumn(ColumnName = "createtime", ColumnDescription = "时间")]
    public virtual DateTime? createtime { get; set; }

}
