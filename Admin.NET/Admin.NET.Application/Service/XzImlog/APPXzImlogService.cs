// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Admin.NET.Application.Entity;
using Admin.NET.Core.Service;
using Furion.DatabaseAccessor;
using Furion.FriendlyException;
using Mapster;
using Microsoft.AspNetCore.Http;
using SqlSugar;
using System;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
namespace Admin.NET.Application;

/// <summary>
/// APP咨询连麦记录服务 🧩
/// </summary>
[ApiDescriptionSettings(ApplicationConst.AppGroupName, Name = "AppXzImlog", Order = 100)]
public partial class APPXzImlogService : IDynamicApiController, ITransient
{
    private readonly SqlSugarRepository<XzImlog> _xzImlogRep;
    private readonly ISqlSugarClient _sqlSugarClient;
    private readonly AppUserManager _userManager;
    private readonly SqlSugarRepository<XzTeachroom> _xzTeachroomRep;

    public APPXzImlogService(SqlSugarRepository<XzImlog> xzImlogRep, ISqlSugarClient sqlSugarClient, AppUserManager userManager, SqlSugarRepository<XzTeachroom> xzTeachroomRep)
    {
        _xzImlogRep = xzImlogRep;
        _sqlSugarClient = sqlSugarClient;
        _userManager = userManager;
        _xzTeachroomRep = xzTeachroomRep;

    }

    /// <summary>
    /// 分页查询咨询连麦记录 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("分页查询咨询连麦记录")]
    [ApiDescriptionSettings(Name = "Page"), HttpPost]
    public async Task<SqlSugarPagedList<XzImlogOutput>> Page(PageXzImlogInput input)
    {
        input.Keyword = input.Keyword?.Trim();
        var query = _xzImlogRep.AsQueryable()
            .Includes(u => u.teacher)
            .Where(u => u.uid == _userManager.userid && u.isdel == 0)
            .WhereIF(input.state != null, u => u.state == input.state);
        if (input.itype != null)
        {
            if (input.itype == 2)
            {
                query.Where(u => u.itype == 2);
            }
            else
            {
                query.Where(u => u.itype != 2);
            }
        }
        var pageListData = await query.OrderBuilder(input).ToPagedListAsync(input.Page, input.PageSize);
        return pageListData.Adapt<SqlSugarPagedList<XzImlogOutput>>();
    }



    /// <summary>
    /// 查询房间等待连麦用户和连麦中用户列表
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("查询房间等待连麦用户和连麦中用户列表")]
    [ApiDescriptionSettings(Name = "RoomWaitImLog"), HttpPost]
    public async Task<List<XzImlog>> RoomWaitImLog(XzImlog input)
    {
        var query = _xzImlogRep.AsQueryable()
            .Includes(u => u.user)
            .Where(u => u.roomid == input.roomid)
            .WhereIF(input.state != null, u => u.state == input.state)
            .WhereIF(input.state == null, u => u.state < 2)
            .Select<XzImlog>();
        var list = await query.ToListAsync();
        foreach (var item in list)
        {
            var user = item.user;
            item.user = new XzUser
            {
                Id = user.Id,
                nickname = user.nickname,
                headimg = user.headimg,
                roomid = user.roomid,
            };
        }
        return list;
    }


    /// <summary>
    /// 获取咨询连麦记录详情 ℹ️
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("获取咨询连麦记录详情")]
    [ApiDescriptionSettings(Name = "Detail"), HttpGet]
    public async Task<XzImlog> Detail([FromQuery] QueryByIdXzImlogInput input)
    {
        return await _xzImlogRep.AsQueryable().Includes(u => u.user).FirstAsync(u => u.Id == input.Id);
    }

    /// <summary>
    /// 更新连麦记录，同意、拒绝、开始、断开
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("更新连麦记录，同意、拒绝、开始、断开")]
    [ApiDescriptionSettings(Name = "UpdateImLog"), HttpPost]
    public async Task UpdateImLog(XzImlog input)
    {
        var imLog = await _xzImlogRep.AsQueryable()
            .Where(u => u.Id == input.Id).FirstAsync();
        if (imLog == null)
        {
            throw new Exception("数据异常");
        }
        if (input.state == 1)
        {
            //连麦开始，设置开始连麦时间
            imLog.starttime = DateTime.Now;
            _xzTeachroomRep.AsUpdateable()
                .SetColumns(it => it.state == 1)
                .Where(it => it.Id == imLog.roomid)
                .ExecuteCommand();
        }
        if (input.state==2)
        {
            //结束连麦，计算价格等

            if (imLog.state != 2)
            {
                imLog.overtime = DateTime.Now;
                //TimeSpan timeSpan = imLog.overtime - imLog.starttime ?? new TimeSpan();
                //imLog.imtime = (int)Math.Ceiling(timeSpan.TotalMinutes);
                //imLog.xzmoney = imLog.imtime * imLog.price;
            }
            _xzTeachroomRep.AsUpdateable()
                .SetColumns(it => it.state == 0)
                .Where(it => it.Id == imLog.roomid)
                .ExecuteCommand();

        }
        imLog.state = input.state;
        await _xzImlogRep.AsUpdateable(imLog).ExecuteCommandAsync();
    }

    /// <summary>
    /// 用户端删除连麦记录 ❌
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("用户端删除连麦记录")]
    [ApiDescriptionSettings(Name = "Delete"), HttpPost]
    public async Task Delete(DeleteXzImlogInput input)
    {
        var imLog = await _xzImlogRep.AsQueryable()
            .Where(u => u.Id == input.Id && u.isdel == 0)
            .FirstAsync();
        if (imLog == null)
            throw Oops.Oh(ErrorCodeEnum.D1002);
        if (imLog.uid != _userManager.userid)
            throw new Exception("只能删除自己的连麦记录");
        imLog.isdel = 1;
        await _xzImlogRep.AsUpdateable(imLog).UpdateColumns(f => f.isdel).ExecuteCommandAsync();
    }
}
