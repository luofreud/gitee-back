// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Admin.NET.Core;
/// <summary>
/// app 用户基本信息
/// </summary>
public class AppUserManager : IScoped
{

    private readonly IHttpContextAccessor _httpContextAccessor;

    /// <summary>
    /// 用户ID
    /// </summary>
    public long userid => (_httpContextAccessor.HttpContext?.User.FindFirst(AppClaimConst.userid)?.Value).ToLong();


    /// <summary>
    /// 用户name
    /// </summary>
    public string name => (_httpContextAccessor.HttpContext?.User.FindFirst(AppClaimConst.name)?.Value).ToString();

    /// <summary>
    /// 用户openid
    /// </summary>
    public string openid => (_httpContextAccessor.HttpContext?.User.FindFirst(AppClaimConst.openid)?.Value).ToString();

    /// <summary>
    /// 用户等级
    /// </summary>
    public int level => (_httpContextAccessor.HttpContext?.User.FindFirst(AppClaimConst.level)?.Value).ToInt();
    
    /// <summary>
    /// 用户直播id
    /// </summary>
    public int roomid => (_httpContextAccessor.HttpContext?.User.FindFirst(AppClaimConst.roomid)?.Value).ToInt();

    /// <summary>
    /// 用户身份
    /// </summary>
    public int utype => (_httpContextAccessor.HttpContext?.User.FindFirst(AppClaimConst.utype)?.Value).ToInt();

    /// <summary>
    /// 老师id
    /// </summary>
    public long tid => (_httpContextAccessor.HttpContext?.User.FindFirst("http://schemas.microsoft.com/identity/claims/tenantid")?.Value).ToLong();

    public AppUserManager(IHttpContextAccessor httpContextAccessor)
    {
        _httpContextAccessor = httpContextAccessor;

        var user = _httpContextAccessor.HttpContext?.User;
        var allClaims = user?.Claims?.Select(c => $"Type={c.Type}, Value={c.Value}");

        Console.WriteLine($"[DEBUG] All Claims: {string.Join("; ", allClaims)}");
        Console.WriteLine($"[DEBUG] Looking for 'tid', AppClaimConst.tid = '{AppClaimConst.tid}'");
    }
}
