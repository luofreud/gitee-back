// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace Admin.NET.Application;

/// <summary>
/// 天文日历 响应
/// <para>对应接口：<c>sign/astrocalendar</c>。</para>
/// <para>上游 data 是 <c>{ "日": [event, event, ...] }</c> 的字典（key 为字符串形式的 1-31），内嵌 Converter 会展平为 <see cref="List{XingpanAstroCalendarEvent}"/>，并把日填入每项的 <see cref="XingpanAstroCalendarEvent.Day"/>。</para>
/// <para>反向序列化时按 <see cref="XingpanAstroCalendarEvent.Day"/> 分组还原为字典。</para>
/// </summary>
[JsonConverter(typeof(XingpanAstroCalendarResponseConverter))]
public class XingpanAstroCalendarResponse : List<XingpanAstroCalendarEvent>
{
    /// <summary>
    /// 把上游 <c>{day: [events]}</c> 字典展平为 List 并填入 <see cref="XingpanAstroCalendarEvent.Day"/>；同时支持按 Day 分组写回字典。
    /// </summary>
    private sealed class XingpanAstroCalendarResponseConverter : JsonConverter
    {
        public override bool CanConvert(Type objectType) => objectType == typeof(XingpanAstroCalendarResponse);

        public override object ReadJson(JsonReader reader, Type objectType, object existingValue, JsonSerializer serializer)
        {
            var jo = JObject.Load(reader);
            var resp = new XingpanAstroCalendarResponse();
            foreach (var prop in jo.Properties())
            {
                if (!int.TryParse(prop.Name, out var day)) continue;
                if (prop.Value is not JArray arr) continue;
                foreach (var item in arr)
                {
                    var ev = item.ToObject<XingpanAstroCalendarEvent>(serializer);
                    if (ev == null) continue;
                    ev.Day = day;
                    resp.Add(ev);
                }
            }
            return resp;
        }

        public override void WriteJson(JsonWriter writer, object value, JsonSerializer serializer)
        {
            var list = (XingpanAstroCalendarResponse)value;
            var dict = list
                .GroupBy(e => e.Day)
                .ToDictionary(g => g.Key.ToString(), g => g.ToList());
            serializer.Serialize(writer, dict);
        }
    }
}
