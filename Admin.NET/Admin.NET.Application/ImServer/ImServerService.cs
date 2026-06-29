// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Microsoft.AspNetCore.Http;
using Newtonsoft.Json.Linq;

namespace Admin.NET.Application;

/// <summary>
/// IM Server 接口转发服务
/// </summary>
[ApiDescriptionSettings(ApplicationConst.AppGroupName, Name = "ImServer", Order = 100)]
[Route("api/imserver")]
public class ImServerService : IDynamicApiController, ITransient
{
    private readonly ImServerHttpClient _imServerHttpClient;
    private readonly IHttpContextAccessor _httpContextAccessor;

    public ImServerService(
        ImServerHttpClient imServerHttpClient,
        IHttpContextAccessor httpContextAccessor)
    {
        _imServerHttpClient = imServerHttpClient;
        _httpContextAccessor = httpContextAccessor;
    }

    /// <summary>
    /// 获取IM服务端连接配置
    /// </summary>
    [AllowAnonymous]
    [DisplayName("获取IM服务端配置")]
    [ApiDescriptionSettings(Name = "server-config"), HttpGet("server-config")]
    public async Task<JObject> GetServerConfig()
    {
        var headers = GetForwardHeaders();
        return await _imServerHttpClient.GetAsync("/api/user/server-config", headers);
    }

    /// <summary>
    /// 获取需要转发的请求头
    /// </summary>
    private Dictionary<string, string> GetForwardHeaders()
    {
        var headers = new Dictionary<string, string>();
        var request = _httpContextAccessor.HttpContext?.Request;
        if (request == null) return headers;

        // 转发常用 headers
        var headersToForward = new[]
        {
            "Authorization",
            "Bearer",
            "Token",
            "Content-Type",
            //"Accept",
            "User-Agent",
            "X-Requested-With",
            "X-Token"
        };

        foreach (var headerKey in headersToForward)
        {
            if (request.Headers.TryGetValue(headerKey, out var value) && !string.IsNullOrEmpty(value))
            {
                headers[headerKey] = value.ToString();
            }
        }

        return headers;
    }
}
