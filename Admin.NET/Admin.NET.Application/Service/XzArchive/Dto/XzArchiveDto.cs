// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using SqlSugar;

namespace Admin.NET.Application;

/// <summary>
/// 用户档案输出参数
/// </summary>
public class XzArchiveDto
{
    /// <summary>
    /// 主键Id
    /// </summary>
    public long Id { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public long? uid { get; set; }

    /// <summary>
    /// 名称
    /// </summary>
    public  string? name { get; set; }

    /// <summary>
    /// 关系
    /// </summary>
    public  string? relation { get; set; }

    /// <summary>
    /// 性别 0:男，1：女
    /// </summary>
    public  int? sex { get; set; }

    /// <summary>
    /// 生产日期
    /// </summary>
    public  string? birthday { get; set; }

    /// <summary>
    /// 出生地址
    /// </summary>
    public  string? address { get; set; }

    /// <summary>
    /// 出生地址经度
    /// </summary>
    public  string? addresslat { get; set; }


    /// <summary>
    /// 出生地址纬度
    /// </summary>
    public  string? addresslong { get; set; }

    /// <summary>
    /// 现居地址
    /// </summary>
    public  string? nowaddress { get; set; }

    /// <summary>
    /// 现居地址经度
    /// </summary>
    public  string? nowaddresslat { get; set; }


    /// <summary>
    /// 现居地址纬度
    /// </summary>
    public  string? nowaddresslong { get; set; }

    /// <summary>
    /// 0：否，1：是（夏令时）
    /// </summary>
    public  int? isdst { get; set; }

    /// <summary>
    /// 时区
    /// </summary>
    public  string? timezone { get; set; }

    /// <summary>
    /// 
    /// </summary>
    public DateTime? createtime { get; set; }
    
}
