// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Furion.HttpRemote;
using Microsoft.Extensions.Options;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace Admin.NET.Application;

/// <summary>
/// IM Server HTTP 客户端封装
/// </summary>
public class ImServerHttpClient : ITransient
{
    private readonly IHttpRemoteService _httpRemoteService;
    private readonly ImServerOptions _options;

    public ImServerHttpClient(
        IHttpRemoteService httpRemoteService,
        IOptions<ImServerOptions> options)
    {
        _httpRemoteService = httpRemoteService;
        _options = options.Value;
    }

    /// <summary>
    /// GET 请求转发 - 返回 JObject
    /// </summary>
    public async Task<JObject> GetAsync(string endpoint, Dictionary<string, string> headers = null)
    {
        var url = _options.ApiUrl + endpoint;
        var raw = await _httpRemoteService.GetAsStringAsync(url, builder =>
        {
            if (headers != null)
            {
                foreach (var header in headers)
                {
                    builder.WithHeader(header.Key, header.Value);
                }
            }
        });
        return ParseToJObject(raw);
    }

    /// <summary>
    /// POST 请求转发 - 返回 JObject
    /// </summary>
    public async Task<JObject> PostAsync(string endpoint, object request, Dictionary<string, string> headers = null)
    {
        var url = _options.ApiUrl + endpoint;
        var raw = await _httpRemoteService.PostAsStringAsync(url, builder =>
        {
            builder.SetContent(request, "application/json");
            if (headers != null)
            {
                foreach (var header in headers)
                {
                    builder.WithHeader(header.Key, header.Value);
                }
            }
        });
        return ParseToJObject(raw);
    }

    /// <summary>
    /// 解析上游响应为 JObject
    /// </summary>
    private static JObject ParseToJObject(string raw)
    {
        if (string.IsNullOrWhiteSpace(raw))
            return JObject.FromObject(new { code = -1, msg = "上游响应为空" });

        try
        {
            var token = JToken.Parse(raw);
            if (token is JObject obj) return obj;
            return JObject.FromObject(new { code = 0, data = token });
        }
        catch (JsonException)
        {
            return JObject.FromObject(new { code = -1, msg = $"上游响应格式异常：{raw}" });
        }
    }
}
