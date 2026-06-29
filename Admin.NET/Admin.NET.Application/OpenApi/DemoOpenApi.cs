// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Admin.NET.Core.Service;
using Furion.DataEncryption;
using Furion.EventBus;
using Furion.FriendlyException;
using Lazy.Captcha.Core;
using Microsoft.AspNetCore.Http;

namespace Admin.NET.Application;

/// <summary>
/// 示例开放接口
/// </summary>
[ApiDescriptionSettings("开放接口", Name = "Demo", Order = 100)]
[Authorize(AuthenticationSchemes = SignatureAuthenticationDefaults.AuthenticationScheme)]
public class DemoOpenApi : IDynamicApiController
{
    private readonly UserManager _userManager;
    private readonly IHttpContextAccessor _httpContextAccessor;


    public DemoOpenApi(UserManager userManager, IHttpContextAccessor httpContextAccessor)
    {
        _userManager = userManager;
        _httpContextAccessor = httpContextAccessor;
    }

    /// <summary>
    /// 用户登陆
    /// </summary>
    /// <param name="username"></param>
    /// <param name="password"></param>
    /// <returns></returns>
    [AllowAnonymous]
    public async Task<LoginOutput> Login(string username, string password)
    {

        return await CreateToken(username);
    }

    [HttpGet("helloWord")]
    public Task<string> HelloWord()
    {
        return Task.FromResult($"Hello word. {_userManager.UserId}");
    }

    /// <summary>
    /// 生成Token令牌 🔖
    /// </summary>
    /// <param name="user"></param>\
    /// <param name="sysUserEventTypeEnum"></param>\
    /// <returns></returns>
    [NonAction]
    internal virtual async Task<LoginOutput> CreateToken(string user, SysUserEventTypeEnum sysUserEventTypeEnum = SysUserEventTypeEnum.Login)
    {
        // 生成Token令牌
        var tokenExpire = 3000;
        var accessToken = JWTEncryption.Encrypt(new Dictionary<string, object>
        {
            { ClaimConst.UserId, user },

        }, tokenExpire);

        // 生成刷新Token令牌
        //var refreshTokenExpire = await _sysConfigService.GetRefreshTokenExpire();
        var refreshToken = JWTEncryption.GenerateRefreshToken(accessToken, tokenExpire);

        // 设置响应报文头
        //_httpContextAccessor.HttpContext.SetTokensOfResponseHeaders(accessToken, refreshToken);

        // Swagger Knife4UI-AfterScript登录脚本
        // ke.global.setAllHeader('Authorization', 'Bearer ' + ke.response.headers['access-token']);

        // 更新用户登录信息


        var payload = new
        {
            Entity = user,
            Output = new LoginOutput
            {
                AccessToken = accessToken,
                RefreshToken = refreshToken
            }
        };

        // 发布系统用户操作事件
        //await _eventPublisher.PublishAsync(sysUserEventTypeEnum, payload);
        return payload.Output;
    }

}