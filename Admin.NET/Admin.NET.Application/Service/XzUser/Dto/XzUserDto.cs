// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

namespace Admin.NET.Application;

/// <summary>
/// 用户信息输出参数
/// </summary>
public class XzUserDto
{
    /// <summary>
    /// 主键Id
    /// </summary>
    public long Id { get; set; }
    
    /// <summary>
    /// 昵称
    /// </summary>
    public string? nickname { get; set; }
    
    /// <summary>
    /// 电话
    /// </summary>
    public string? phone { get; set; }
    
    /// <summary>
    /// openid
    /// </summary>
    public string? openid { get; set; }
    
    /// <summary>
    /// 0:男，1:女
    /// </summary>
    public int? sex { get; set; }
    
    /// <summary>
    /// 等级1-5
    /// </summary>
    public int? level { get; set; }
    
    /// <summary>
    /// 出生地址
    /// </summary>
    public string? address { get; set; }
    
    /// <summary>
    /// 头像
    /// </summary>
    public string? headimg { get; set; }
    
    /// <summary>
    /// 现居地址
    /// </summary>
    public string? nowaddress { get; set; }
    
    /// <summary>
    /// 星币
    /// </summary>
    public int? xbmoney { get; set; }
    
    /// <summary>
    /// 星钻 1-1
    /// </summary>
    public double? xzmoney { get; set; }
    
    /// <summary>
    /// 连麦时长（剩余）
    /// </summary>
    public int? lmtime { get; set; }
    
    /// <summary>
    /// 是否首充
    /// </summary>
    public int? iscz { get; set; }
    
    /// <summary>
    /// 签名限定20个字
    /// </summary>
    public string? sign { get; set; }
    
    /// <summary>
    /// 0：正常，1：异常
    /// </summary>
    public int? state { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public string? tgcode { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public DateTime? createtime { get; set; }
    
}
