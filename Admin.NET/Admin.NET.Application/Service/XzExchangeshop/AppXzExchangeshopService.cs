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
using OfficeOpenXml.FormulaParsing.Excel.Functions.DateTime;
using SqlSugar;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
namespace Admin.NET.Application;

/// <summary>
/// APP-星币兑换商城服务 🧩
/// </summary>
[ApiDescriptionSettings(ApplicationConst.AppGroupName, Name = "AppXzExchangeshop", Order = 100)]
public partial class AppXzExchangeshopService : IDynamicApiController, ITransient
{
    private readonly SqlSugarRepository<XzExchangeshop> _xzExchangeshopRep;
    private readonly SqlSugarRepository<XzUser> _xzUser;

    private readonly ISqlSugarClient _sqlSugarClient;
    private readonly AppUserManager _userManager;
    private readonly SqlSugarRepository<XzCoupon> _xzXzCouponRep;
    private readonly SqlSugarRepository<XzUsercoupon> _xzXzUsercouponRep;
    private readonly SqlSugarRepository<XzXblog> _xzXblog;
    private readonly SqlSugarRepository<XzUexchagelog> _xzXzUexchagelogRep;


    public AppXzExchangeshopService(SqlSugarRepository<XzExchangeshop> xzExchangeshopRep, ISqlSugarClient sqlSugarClient, AppUserManager userManager, SqlSugarRepository<XzUser> xzUser, SqlSugarRepository<XzUexchagelog> xzXzUexchagelogRep, SqlSugarRepository<XzCoupon> xzXzCouponRep, SqlSugarRepository<XzUsercoupon> xzXzUsercouponRep, SqlSugarRepository<XzXblog> xzXblog)
    {
        _xzExchangeshopRep = xzExchangeshopRep;
        _sqlSugarClient = sqlSugarClient;
        _userManager = userManager;
        _xzUser = xzUser;
        _xzXzUexchagelogRep = xzXzUexchagelogRep;
        _xzXzCouponRep = xzXzCouponRep;
        _xzXzUsercouponRep = xzXzUsercouponRep;
        _xzXblog = xzXblog;

    }


    /// <summary>
    /// 查询星币兑换商城 🔖
    /// </summary>
    /// <returns></returns>
    [DisplayName("查询星币兑换商城")]
    [ApiDescriptionSettings(Name = "GetShop"), HttpPost]
    [AllowAnonymous]
    public async Task<List<AppXzExchangeshopOutput>> GetShop()
    {

        var query = _xzExchangeshopRep.AsQueryable()
             .LeftJoin<SysDictData>((f, s) => f.goodtypeid == s.Id)
           .Where(f => f.level <= _userManager.level && f.state == 0)
           .OrderBy(f => f.sortcode, OrderByType.Desc)
            .Select<XzExchangeshopOutput>((f, s) => new XzExchangeshopOutput
            {
                lable = s.Value,
                count = f.count,
                createtime = f.createtime,
                goodimg = f.goodimg,
                goodname = f.goodname,
                goodtypeid = f.goodtypeid,
                xbmoney = f.xbmoney,
                Id = f.Id,
                state = f.state,
                xzmoney = f.xzmoney,
                level = f.level,
                limitcount = f.limitcount,
                limittype = f.limittype,
                sortcode = f.sortcode,
                virtualgood = f.virtualgood
            });
        var shops = await query.ToListAsync();
        List<AppXzExchangeshopOutput> appXzExchangeshopOutputs = new List<AppXzExchangeshopOutput>();

        shops.ForEach(f =>
        {
            var tempmodel = appXzExchangeshopOutputs.Where(s => s.lable == f.lable).FirstOrDefault();
            if (tempmodel != null)
            {
                tempmodel.xzExchangeshops.Add(f.Adapt<XzExchangeshopOutput>());
            }
            else
            {
                var tempexchange = new AppXzExchangeshopOutput
                {
                    lable = f.lable
                };
                tempexchange.xzExchangeshops.Add(f.Adapt<XzExchangeshopOutput>());
                appXzExchangeshopOutputs.Add(tempexchange);
            }

        });

        return appXzExchangeshopOutputs;
    }


    /// <summary>
    /// 用户兑换商品 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("用户兑换商品")]
    [ApiDescriptionSettings(Name = "UserExchange"), HttpPost]
    [UnitOfWork]
    public async Task<bool> UserExchange(XzUexchagelog input)
    {
        var user = await _xzUser.GetByIdAsync(_userManager.userid);
        var shopmodel = await _xzExchangeshopRep.GetByIdAsync(input.gid);

        var taskmodel = await _sqlSugarClient.Queryable<XzTakeaddress>().Where(f => f.Id == input.takeid).FirstAsync();
        if (shopmodel == null)
            return false;

        if (user == null)
            return false;

        if (shopmodel.xbmoney > user.xbmoney)
            throw Oops.Oh("兑换星币不足");

        if (shopmodel.count <= 0)
            throw Oops.Oh("兑换商品不足！");


        if (shopmodel.limittype == 1)
        {
            var nowmonth = DateTime.Parse(DateTime.Now.ToString("yyyy-MM-01"));

            var excount = await _xzXzUexchagelogRep.AsQueryable().Where(f => f.uid == user.Id)
                .WhereIF(shopmodel.limittype == 0, f => f.createtime >= nowmonth)
                .CountAsync();

            if (shopmodel.limitcount <= excount)
                throw Oops.Oh("商品已达兑换次数！");
        }

        user.xbmoney = user.xbmoney - shopmodel.xbmoney;
        shopmodel.count -= 1;
        input.uid = _userManager.userid;
        input.xbmoney = shopmodel.xbmoney;
        input.evaluatestate = 0;
        input.expressnum = 1;
        input.orderstate = 1;
        input.orderno = "EG" + DateTime.Now.Ticks;
        input.ordertype = string.Empty;
        input.virtualgood = shopmodel.virtualgood;
        input.createtime = DateTime.Now;
        input.name = taskmodel.name;
        input.address = taskmodel.address;
        input.phone = taskmodel.phone;
        input.area = taskmodel.area;
        input.gname = shopmodel.goodname;
        input.gimg= shopmodel.goodimg;
        List<Task> task = new List<Task>();
        //兑换优惠券
        if (shopmodel.virtualgood == 1)
        {
            //查询优惠劵
            var coupon = await _xzXzCouponRep.GetByIdAsync(shopmodel.cid);

            XzUsercoupon xzUsercoupon = new XzUsercoupon();
            xzUsercoupon.uid = user.Id;
            xzUsercoupon.cid = coupon.Id;
            xzUsercoupon.state = 0;
            xzUsercoupon.stime = DateTime.Now;
            xzUsercoupon.etime = coupon.etime;
            xzUsercoupon.ctype = coupon.ctype;
            xzUsercoupon.mark = string.Empty;
            xzUsercoupon.createtime = DateTime.Now;
            xzUsercoupon.isdel = 0;
            coupon.lqcount += 1;
            if (coupon.count != -1)
            {
                if (coupon.count > 0)
                {
                    coupon.count -= 1;
                }
                else
                {
                    throw Oops.Oh("优惠劵数量不足！");
                }
            }
            input.orderstate = 2;
            input.expressnum = 1;
            input.cid = coupon.Id;

            task.Add(_xzXzCouponRep.AsUpdateable(coupon).UpdateColumns(it => new { it.lqcount, it.count }).ExecuteCommandAsync());
            task.Add(_xzXzUsercouponRep.InsertAsync(xzUsercoupon));
        }

        //插入日志
        task.Add(_xzXblog.InsertAsync(new XzXblog { uid = _userManager.userid, xb = input.xbmoney, createtime = DateTime.Now, mark = "兑换商品", xbye = user.xbmoney + input.xbmoney }));
        task.Add(_xzUser.AsUpdateable(user).UpdateColumns(it => new { it.xbmoney }).ExecuteCommandAsync());
        task.Add(_xzExchangeshopRep.AsUpdateable(shopmodel).UpdateColumns(it => new { it.count }).Where(it => it.count == (shopmodel.count + 1) && it.Id == shopmodel.Id).ExecuteCommandAsync());
        task.Add(_xzXzUexchagelogRep.InsertAsync(input));

        await Task.WhenAll(task);

        return true;
    }


    /// <summary>
    /// 分页查询用户兑换商品列表 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("分页查询用户兑换商品列表")]
    [ApiDescriptionSettings(Name = "Page"), HttpPost]
    public async Task<SqlSugarPagedList<XzUexchagelogOutput>> Page(XzUexchagelogOutput input)
    {
        var query = _xzXzUexchagelogRep.AsQueryable()
            .Where(f => f.uid == _userManager.userid)
            .WhereIF(input.orderstate != null, u => u.orderstate == input.orderstate)
            .WhereIF(input.evaluatestate != null, u => u.evaluatestate == input.evaluatestate)
            .OrderBy(f => f.createtime).Select<XzUexchagelogOutput>();
        return await query.OrderBuilder(input).ToPagedListAsync(input.Page, input.PageSize);
    }

}
