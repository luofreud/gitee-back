// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Admin.NET.Application.Entity;
using Admin.NET.Core.Service;
using Aop.Api.Domain;
using Dm.util;
using DocumentFormat.OpenXml.Wordprocessing;
using Furion.DatabaseAccessor;
using Furion.FriendlyException;
using Mapster;
using Microsoft.AspNetCore.Http;
using OfficeOpenXml.FormulaParsing.Excel.Functions.Logical;
using OfficeOpenXml.FormulaParsing.Excel.Functions.Math;
using SqlSugar;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using static SKIT.FlurlHttpClient.Wechat.Api.Models.ChannelsLeadsGetLeadsInfoByComponentIdResponse.Types;
namespace Admin.NET.Application;

/// <summary>
/// 用户评论列表服务 🧩
/// </summary>
[ApiDescriptionSettings(ApplicationConst.AppGroupName, Order = 100)]
public partial class AppXzArticlecommentsService : IDynamicApiController, ITransient
{
    private readonly SqlSugarRepository<XzArticlecomments> _xzArticlecommentsRep;
    private readonly ISqlSugarClient _sqlSugarClient;
    private readonly AppUserManager _userManager;


    public AppXzArticlecommentsService(SqlSugarRepository<XzArticlecomments> xzArticlecommentsRep, ISqlSugarClient sqlSugarClient, AppUserManager userManager)
    {
        _xzArticlecommentsRep = xzArticlecommentsRep;
        _sqlSugarClient = sqlSugarClient;
        _userManager = userManager;

    }

    /// <summary>
    /// 分页查询用户评论列表 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("分页查询用户评论列表")]
    [ApiDescriptionSettings(Name = "Page"), HttpPost]
    public async Task<SqlSugarPagedList<XzArticlecommentsOutput>> Page(PageXzArticlecommentsInput input)
    {
        var comments = await _xzArticlecommentsRep.AsQueryable()
                .Where(c => c.aid == input.aid && c.parentid == (input.parentid ?? 0) && c.state == 0)
                .Includes(c => c.xzuser)           // 自动加载 User 导航属性
                .Includes(c => c.commentlike.Where(l => l.uid == _userManager.userid && l.ltype == 1).ToList())
                .Includes(c => 
                    c.Replies.Where(r => r.state == 0).Take(1).ToList(),
                    r=>r.xzuser
                )
                //.OrderBy(c => new { c.createtime }, OrderByType.Desc)
                .OrderBuilder(input)
                .Select<XzArticlecommentsOutput>(f => new XzArticlecommentsOutput
                {
                    Id = f.Id,
                    content = f.content,
                    createtime = f.createtime,
                    replycount = f.replycount,
                    aid = f.aid,
                    uid = f.uid,
                    likecount = f.likecount,
                    islike = f.commentlike.Count(),
                    state = f.state,
                    xzuser = new XzUserDto
                    {
                        Id = f.xzuser.Id,
                        nickname = f.xzuser.nickname,
                        level = f.xzuser.level,
                    },
                    replay = f.Replies.Select(r => new XzArticlecommentsOutput
                    {
                        Id = r.Id,
                        content = r.content,
                        createtime = r.createtime,
                        replycount = r.replycount,
                        aid = r.aid,
                        uid = r.uid,
                        likecount = r.likecount,
                        islike = 0,
                        state = r.state,
                        xzuser = r.xzuser == null ? null : new XzUserDto
                        {
                            Id = r.xzuser.Id,
                            nickname = r.xzuser.nickname,
                            level = r.xzuser.level,
                        },
                        replay = null,  // 二级回复暂时不支持嵌套，设为null
                    }).ToList()
                })
                .ToPagedListAsync(input.Page, input.PageSize);

        return comments;
    }


    /// <summary>
    /// 增加用户评论 ➕
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("增加用户评论")]
    [ApiDescriptionSettings(Name = "Add"), HttpPost]
    [UnitOfWork]
    public async Task<bool> Add(AddXzArticlecommentsInput input)
    {
        var entity = input.Adapt<XzArticlecomments>();
        entity.state = 0;
        entity.uid = _userManager.userid;
        entity.createtime = DateTime.Now;
        entity.likecount = 0;
        entity.replycount = 0;
        if (entity.parentid == null)
        {
            entity.parentid = 0;
        }
        if (input.parentid != null && input.parentid > 0)
        {
            var pentity = await _xzArticlecommentsRep.GetByIdAsync(input.parentid);
            pentity.replycount += 1;
            await _xzArticlecommentsRep.AsUpdateable(pentity).UpdateColumns(f => new { f.replycount }).ExecuteCommandAsync();
        }
        else
        {
            input.parentid = 0;
        }

        await _xzArticlecommentsRep.InsertAsync(entity);

        //增加评论，需要为文章的评论数+1
        await _sqlSugarClient.Updateable<XzArticle>().SetColumns(it => it.commentcount == it.commentcount + 1)
        .Where(it => it.Id == input.aid)
        .ExecuteCommandAsync();

        return true;

    }


    /// <summary>
    /// 删除用户评论
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("删除用户评论")]
    [ApiDescriptionSettings(Name = "Delete"), HttpPost]
    [UnitOfWork]
    public async Task<bool> Delete(BaseIdInput input)
    {
        var entity = await _xzArticlecommentsRep.GetByIdAsync(input.Id);

        //删除评论，需要为文章的评论数-1
        await _sqlSugarClient.Updateable<XzArticle>().SetColumns(it => it.commentcount == it.commentcount - 1)
        .Where(it => it.Id == entity.aid)
        .ExecuteCommandAsync();

        return await _xzArticlecommentsRep.DeleteAsync(entity);

    }


    /// <summary>
    /// 点赞用户评论 ➕
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("点赞用户评论")]
    [ApiDescriptionSettings(Name = "AddLike"), HttpPost]
    [UnitOfWork]
    public async Task AddLike(BaseIdInput input)
    {
        var count = await _sqlSugarClient.Queryable<XzArticlelike>().Where(f => f.uid == _userManager.userid && f.aid == input.Id && f.ltype == 1).CountAsync();
        if (count == 0)
        {
            var entity = await _xzArticlecommentsRep.GetByIdAsync(input.Id);
            entity.likecount += 1;

            //添加日志
            XzArticlelike xzArticlelike = new XzArticlelike();
            xzArticlelike.uid = _userManager.userid;
            xzArticlelike.createtime = DateTime.Now;
            xzArticlelike.ltype = 1;
            xzArticlelike.aid = input.Id;
            await _sqlSugarClient.Insertable<XzArticlelike>(xzArticlelike).ExecuteCommandAsync();

            await _xzArticlecommentsRep.AsUpdateable(entity).UpdateColumns(f => new { f.likecount }).ExecuteCommandAsync();

        }
    }

    /// <summary>
    /// 取消评论点赞
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("取消评论点赞")]
    [ApiDescriptionSettings(Name = "DelLike"), HttpPost]
    [UnitOfWork]
    public async Task DelLike(BaseIdInput input)
    {
        var like = await _sqlSugarClient.Queryable<XzArticlelike>().Where(f => f.uid == _userManager.userid && f.aid == input.Id && f.ltype == 1).FirstAsync();
        if (like != null)
        {
            var entity = await _xzArticlecommentsRep.GetByIdAsync(like.aid);
            entity.likecount -= 1;
            await _sqlSugarClient.Deleteable(like).Where(f => f.Id == like.Id).ExecuteCommandAsync();
            await _xzArticlecommentsRep.AsUpdateable(entity).UpdateColumns(f => new { f.likecount }).ExecuteCommandAsync();
        }
    }

}
