// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Admin.NET.Application.Entity;
using Admin.NET.Core.Service;
using Furion.DatabaseAccessor;
using Furion.FriendlyException;
using Microsoft.AspNetCore.Http;
using SqlSugar;
using System.ComponentModel;
namespace Admin.NET.Application;

/// <summary>
/// IM 消息服务 🧩
/// </summary>
[ApiDescriptionSettings(ApplicationConst.AppGroupName, Name = "imMessage", Order = 100)]
public class ImMessageService : IDynamicApiController, ITransient
{
    private readonly ISqlSugarClient _sqlSugarClient;
    private readonly AppUserManager _userManager;
    private readonly SysFileService _sysFileService;

    public ImMessageService(ISqlSugarClient sqlSugarClient, AppUserManager userManager, SysFileService sysFileService)
    {
        _sqlSugarClient = sqlSugarClient;
        _userManager = userManager;
        _sysFileService = sysFileService;
    }

    /// <summary>
    /// 分页查询当前用户会话列表 🔖
    /// </summary>
    /// <param name="input">分页查询参数</param>
    /// <returns></returns>
    [DisplayName("分页查询会话列表")]
    [ApiDescriptionSettings(Name = "Page"), HttpPost]
    public async Task<SqlSugarPagedList<ImConversation>> Page(PageImMessageInput input)
    {
        var currentUid = _userManager.userid.ToString();

        // 主查询：当前用户的所有会话，并通过导航属性加载对方用户信息
        var list = await _sqlSugarClient.Queryable<ImConversation>()
            .Includes(c => c.TargetUser.ToList(it => new XzUser() { nickname = it.nickname, headimg = it.headimg, utype = it.utype }))
            .Where(c => c.OwnerUid == currentUid)
            .OrderBy(c => c.IsTop, OrderByType.Desc)
            .OrderBy(c => c.LastTime, OrderByType.Desc)
            .ToPagedListAsync(input.Page, input.PageSize);

        // 筛选出 TargetUser != null 且 utype==1（导师）的目标 id
        var teacherTargetIds = list.Items
            .Where(c => c.TargetUser != null && c.TargetUser.utype == 1 && !string.IsNullOrWhiteSpace(c.TargetId))
            .Select(c => c.TargetId!)
            .Distinct()
            .Select(id => long.TryParse(id, out var l) ? (long?)l : null)
            .Where(x => x.HasValue)
            .Select(x => x!.Value)
            .ToList();

        if (teacherTargetIds.Count > 0)
        {
            // 查 XzTeacher，匹配 uid
            var teachers = await _sqlSugarClient.Queryable<XzTeacher>()
                .Where(t => t.uid != null && teacherTargetIds.Contains(t.uid.Value))
                .Select(t => new { t.uid, t.name, t.headimg })
                .ToListAsync();

            var teacherMap = teachers
                .Where(t => t.uid.HasValue)
                .ToDictionary(t => t.uid!.Value, t => new { t.name, t.headimg });

            // 覆盖 TargetUser.nickname/headimg
            foreach (var c in list.Items)
            {
                if (c.TargetUser != null && c.TargetUser.utype == 1
                    && !string.IsNullOrWhiteSpace(c.TargetId)
                    && long.TryParse(c.TargetId, out var tid)
                    && teacherMap.TryGetValue(tid, out var t))
                {
                    c.TargetUser.nickname = t.name;
                    c.TargetUser.headimg = t.headimg;
                }
            }
        }

        return list;
    }

    /// <summary>
    /// 分页获取与指定用户的聊天记录 🔖
    /// </summary>
    /// <param name="input">分页参数（必传 Uid）</param>
    /// <returns></returns>
    [DisplayName("分页获取聊天记录")]
    [ApiDescriptionSettings(Name = "MessageList"), HttpPost]
    public async Task<SqlSugarPagedList<ImMessage>> MessageList(MessageListInput input)
    {
        if (string.IsNullOrWhiteSpace(input.Uid))
            throw Oops.Oh(ErrorCodeEnum.D1002);

        var currentUid = _userManager.userid.ToString();
        var targetUid = input.Uid!;

        // 1. 当前用户与对方的会话未读数置 0
        await _sqlSugarClient.Updateable<ImConversation>()
            .SetColumns(c => c.UnreadCount == 0)
            .SetColumns(c => c.UpdatedAt == DateTime.Now)
            .Where(c => c.OwnerUid == currentUid
                     && c.TargetId == targetUid)
            .ExecuteCommandAsync();

        // 2. 对方发给我的未送达消息 (status=0) 置为已送达 (status=1)
        await _sqlSugarClient.Updateable<ImMessage>()
            .SetColumns(m => m.Status == 1)
            .Where(m => m.ToUid == currentUid
                     && m.FromUid == targetUid
                     && m.Status == 0)
            .ExecuteCommandAsync();

        // 3. 分页查询
        return await _sqlSugarClient.Queryable<ImMessage>()
            .Where(m =>
                (m.FromUid == currentUid && m.ToUid == targetUid) ||
                (m.FromUid == targetUid && m.ToUid == currentUid)
            )
            .OrderBy(m => m.CreatedAt, OrderByType.Desc)
            .ToPagedListAsync(input.Page, input.PageSize);
    }

    /// <summary>
    /// 通过UID获取用户头像、昵称、utype信息 ℹ️
    /// </summary>
    /// <param name="uid">用户ID</param>
    /// <returns></returns>
    [DisplayName("通过UID获取用户信息")]
    [ApiDescriptionSettings(Name = "GetUserInfo"), HttpGet]
    public async Task<XzUser> GetUserInfo([FromQuery]string uid)
    {
        if (string.IsNullOrWhiteSpace(uid))
            throw Oops.Oh(ErrorCodeEnum.D1002);

        var res = await _sqlSugarClient.Queryable<XzUser>()
            .Includes(u => u.teacher)
            .Where(u => u.Id.ToString() == uid)
            .Select(u => new XzUser { Id = u.Id, nickname = u.nickname, headimg = u.headimg, utype = u.utype, teacher = u.teacher })
            .FirstAsync() ?? throw Oops.Oh(ErrorCodeEnum.D1002);
        if(res.teacher!=null)
        {
            res.nickname = res.teacher?.name;
            res.headimg = res.teacher?.headimg;
        }

        return res;
    }


    [DisplayName("上传单文件")]
    public async Task<SysFile> UploadFile(IFormFile file)
    {
        if (file == null) throw Oops.Oh(ErrorCodeEnum.D2102);
        string targetPath = "upload/message/"+DateTime.Now.ToString("yyyy/MM/dd");
        
        return await _sysFileService.UploadFile(new UploadFileInput { File = file, AllowSuffix = ".jpg,.jpeg,.jpe,.jfif,.png,.gif,.webp,.bmp,.tif,.tiff,.heic,.ico,.psd,.xcf,.cr2,.jp2,.jpx,.jxr,.mp3,.aac,.m4a,.wav,.amr,.flac,.ogg,.wma,.aiff,.mid,.mp4,.m4v,.3gp,.3gpp,.mov,.avi,.mkv,.flv,.wmv,.webm,.mpg,.rmvb" }, targetPath);
    }
}
