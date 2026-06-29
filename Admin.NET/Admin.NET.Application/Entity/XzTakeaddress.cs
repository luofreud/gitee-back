// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Admin.NET.Core;
using SqlSugar;
namespace Admin.NET.Application.Entity;

/// <summary>
/// 收货地址
/// </summary>
[Tenant("1300000000001")]
[SugarTable("xz_takeaddress", "收货地址")]
public partial class XzTakeaddress : EntityBaseId
{
    /// <summary>
    /// uid
    /// </summary>
    [SugarColumn(ColumnName = "uid", ColumnDescription = "uid")]
    public virtual long? uid { get; set; }
    
    /// <summary>
    /// 收货姓名
    /// </summary>
    [SugarColumn(ColumnName = "name", ColumnDescription = "收货姓名")]
    public virtual string? name { get; set; }
    
    /// <summary>
    /// 联系电话
    /// </summary>
    [SugarColumn(ColumnName = "phone", ColumnDescription = "联系电话")]
    public virtual string? phone { get; set; }
    
    /// <summary>
    /// 区域
    /// </summary>
    [SugarColumn(ColumnName = "area", ColumnDescription = "区域")]
    public virtual string? area { get; set; }
    
    /// <summary>
    /// 详细地址
    /// </summary>
    [SugarColumn(ColumnName = "address", ColumnDescription = "详细地址")]
    public virtual string? address { get; set; }
    
    /// <summary>
    /// 是否默认地址1:是
    /// </summary>
    [SugarColumn(ColumnName = "isdefault", ColumnDescription = "是否默认地址")]
    public virtual int? isdefault { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    [SugarColumn(ColumnName = "createtime", ColumnDescription = "")]
    public virtual DateTime? createtime { get; set; }
    
}
