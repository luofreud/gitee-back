// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

namespace Admin.NET.Application;

/// <summary>
/// 星座咨询师输出参数
/// </summary>
public class XzTeacherDto
{
    /// <summary>
    /// 主键Id
    /// </summary>
    public long Id { get; set; }
    public long? uid { get; set; }

    /// <summary>
    /// 姓名
    /// </summary>
    public string? name { get; set; }
    
    /// <summary>
    /// 头像
    /// </summary>
    public string? headimg { get; set; }
    
    /// <summary>
    /// 等级
    /// </summary>
    public int? level { get; set; }
    
    /// <summary>
    /// 推广code
    /// </summary>
    public string? tgcode { get; set; }
    
    /// <summary>
    /// 介绍
    /// </summary>
    public string? introduction { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public double? score { get; set; }
    
    /// <summary>
    /// 星钻
    /// </summary>
    public double? xzmoney { get; set; }
    
    /// <summary>
    /// 从业年限
    /// </summary>
    public int? year { get; set; }
    
    /// <summary>
    /// 标签
    /// </summary>
    public string? tags { get; set; }
    
    /// <summary>
    /// 0：在线，1：离线
    /// </summary>
    public int? livestate { get; set; }
    
    /// <summary>
    /// 0：正常，1：审核中
    /// </summary>
    public int? state { get; set; }
    
    /// <summary>
    /// 电话
    /// </summary>
    public string? phone { get; set; }
    
    /// <summary>
    /// 身份证照片
    /// </summary>
    public string? card { get; set; }
    
    /// <summary>
    /// 银行卡照片
    /// </summary>
    public string? bankcard { get; set; }
    
    /// <summary>
    /// 银行卡编号
    /// </summary>
    public string? banknum { get; set; }
    
    /// <summary>
    /// 开户行
    /// </summary>
    public string? bankname { get; set; }
    
    /// <summary>
    /// 开户行名称
    /// </summary>
    public string? bankaddress { get; set; }
    
    /// <summary>
    /// 越大越靠前
    /// </summary>
    public int? sortcode { get; set; }
    
    /// <summary>
    /// 0：不推荐，1：推荐
    /// </summary>
    public int? istop { get; set; }
    
    /// <summary>
    /// 入住时间，审核成功修改时间
    /// </summary>
    public DateTime? checktime { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public DateTime? createtime { get; set; }
    
}
