// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Admin.NET.Core.Service;

using Furion.FriendlyException;
using SqlSugar;
using System.ComponentModel;
using Admin.NET.Application.Entity;
using Mapster;
using Furion.JsonSerialization;
namespace Admin.NET.Application;

/// <summary>
/// 用户问答服务🧩
/// </summary>
[ApiDescriptionSettings(ApplicationConst.AppGroupName, Name = "AppXzQuestion", Order = 100)]
public partial class AppXzQuestionService : IDynamicApiController, ITransient
{
    private readonly SqlSugarRepository<XzQuestion> _xzQuestionRep;
    private readonly ISqlSugarClient _sqlSugarClient;
    private readonly AppUserManager _userManager;
    private readonly AppXzXingpanService _appXzXingpanService;


    public AppXzQuestionService(SqlSugarRepository<XzQuestion> xzQuestionRep, ISqlSugarClient sqlSugarClient, AppUserManager userManager, AppXzXingpanService appXzXingpanService)
    {
        _xzQuestionRep = xzQuestionRep;
        _sqlSugarClient = sqlSugarClient;
        _userManager = userManager;
        _appXzXingpanService = appXzXingpanService;

    }

    /// <summary>
    /// 分页查询用户问答 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("分页查询用户问答")]
    [ApiDescriptionSettings(Name = "Page"), HttpPost]
    public async Task<SqlSugarPagedList<XzQuestionOutput>> Page(PageXzQuestionInput input)
    {
        var query = _xzQuestionRep.AsQueryable()
            .Where(u => u.uid == _userManager.userid && u.isdel == 0)
            .WhereIF(input.tid != null, u => u.tid == input.tid)
            .WhereIF(input.ordertype != null, u => u.ordertype == input.ordertype)
            .WhereIF(input.orderstate != null, u => u.orderstate == input.orderstate)
            .OrderByDescending(f => f.createtime)
            .Select<XzQuestionOutput>();
        return await query.OrderBuilder(input).ToPagedListAsync(input.Page, input.PageSize);
    }

    /// <summary>
    /// 获取用户问答详情 ℹ️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("获取用户问答详情")]
    [ApiDescriptionSettings(Name = "Detail"), HttpGet]
    public async Task<XzQuestionOutput> Detail([FromQuery] QueryByIdXzQuestionInput input)
    {
        var data = await _xzQuestionRep.AsQueryable().Includes(u=>u.astrology)
            .FirstAsync(u => u.Id == input.Id);
        return data.Adapt<XzQuestionOutput>();
    }

    /// <summary>
    /// 新增用户问答 ➕
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("新增用户问答")]
    [ApiDescriptionSettings(Name = "Add"), HttpPost]
    [UnitOfWork]
    public async Task<XzQuestionOutput> Add(AddXzQuestionInput input)
    {
        var entity = input.Adapt<XzQuestion>();
        entity.uid = _userManager.userid;
        entity.createtime = DateTime.Now;
        entity.isdel = 0;
        entity.orderno = "Q" + DateTime.Now.Ticks;
        var id = await _xzQuestionRep.InsertAsync(entity) ? entity.Id : 0;

        var data = entity.Adapt<XzQuestionOutput>();

        dynamic xingpanRes = null;
        if (entity.ordertype == 0)
        {
            // 获取骰子
            xingpanRes = await _appXzXingpanService.DiceGenerate();
        }
        else if (entity.ordertype == 1)
        {
            // 获取星盘
            var phase = new Dictionary<string, string>();
            phase.Add("0", "0.5");
            phase.Add("180", "6");
            phase.Add("120", "6");
            phase.Add("90", "6");
            phase.Add("60", "6");
            phase.Add("30", "2");
            phase.Add("36", "2");
            phase.Add("45", "2");
            phase.Add("72", "2");
            phase.Add("135", "0.5");
            phase.Add("144", "2");
            phase.Add("150", "2");
            xingpanRes = await _appXzXingpanService.Natal(new XzXingpanChartInput { 
                ArchiveId = entity.aid1,
                SvgType = "0",
                IsCorpus="1",
                Planets = ["0","1", "2", "3", "4", "5", "6", "7", "8", "9", "t"],
                PlanetXs = ["D","F", "E", "G", "H", "I", "433", "16"],
                Virtual = ["10", "11", "13", "14", "18", "19", "20", "21", "m", "A", "pFortune"],
                HSys = "K",
                Phase = phase
            });
        }
        else if (entity.ordertype == 2)
        {
            // 获取智慧牌
            xingpanRes = await _appXzXingpanService.TarotGenerate(new XzXingpanTarotGenerateInput { Number = 3 });
        }
        else if (entity.ordertype == 3)
        {
            // 获取合盘
            // 获取星盘
            var phase = new Dictionary<string, string>();
            phase.Add("0", "0.5");
            phase.Add("180", "6");
            phase.Add("120", "6");
            phase.Add("90", "6");
            phase.Add("60", "6");
            phase.Add("30", "2");
            phase.Add("36", "2");
            phase.Add("45", "2");
            phase.Add("72", "2");
            phase.Add("135", "0.5");
            phase.Add("144", "2");
            phase.Add("150", "2");
            xingpanRes = await _appXzXingpanService.Composite(new XzXingpanCompositeInput
            {
                ArchiveId1 = entity.aid1,
                ArchiveId2 = entity.aid2,
                SvgType = "0",
                IsCorpus = "1",
                Planets = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "t"],
                PlanetXs = ["D", "F", "E", "G", "H", "I", "433", "16"],
                Virtual = ["10", "11", "13", "14", "18", "19", "20", "21", "m", "A", "pFortune"],
                HSys = "K",
                Phase = phase
            });
        }

        try
        {
            if (xingpanRes != null)
            {
                string jsonStr = JSON.Serialize(xingpanRes);
                var astrologyEntity = new XzQuestionAstrology { qid = id, content = jsonStr, ordertype = entity.ordertype };
                await _sqlSugarClient.Insertable<XzQuestionAstrology>(astrologyEntity).ExecuteCommandAsync();
                data.astrology = astrologyEntity;
            }
            
        }
        catch (Exception ex) { }

        return data;
    }

    /// <summary>
    /// 删除用户问答 ❌
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("删除用户问答")]
    [ApiDescriptionSettings(Name = "Delete"), HttpPost]
    public async Task Delete(DeleteXzQuestionInput input)
    {
        var entity = await _xzQuestionRep.AsQueryable()
            .Where(u => u.Id == input.Id && u.isdel == 0)
            .FirstAsync();
        if (entity == null)
            throw Oops.Oh(ErrorCodeEnum.D1002);
        if (entity.uid != _userManager.userid)
            throw new Exception("只能删除自己的问答");
        entity.isdel = 1;
        await _xzQuestionRep.AsUpdateable(entity).UpdateColumns(f => f.isdel).ExecuteCommandAsync();
    }
}
