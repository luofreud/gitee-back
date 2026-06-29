// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

namespace Admin.NET.Application;

/// <summary>
/// 系统优惠券输出参数
/// </summary>
public class XzCouponDto
{
    /// <summary>
    /// 主键Id
    /// </summary>
    public int Id { get; set; }
    
    /// <summary>
    /// 0：商品优惠券，1：星币优惠券，2：商品兑换券，3：充值折扣券
    /// </summary>
    public int? ctype { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public DateTime? stime { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public DateTime? etime { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public string? name { get; set; }
    
    /// <summary>
    /// 0：正常，1：删除
    /// </summary>
    public int? isdel { get; set; }
    
    /// <summary>
    /// -1：无限制
    /// </summary>
    public int? count { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public int? lqcount { get; set; }
    
    /// <summary>
    /// 
    /// </summary>
    public DateTime? createtime { get; set; }
    
}
