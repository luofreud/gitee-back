// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Admin.NET.Core.Service;
using Microsoft.AspNetCore.Http;
using Furion.DatabaseAccessor;
using Furion.FriendlyException;
using Mapster;
using SqlSugar;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using Admin.NET.Application.Entity;
namespace Admin.NET.Application;

/// <summary>
/// 系统优惠券服务 🧩
/// </summary>
[ApiDescriptionSettings(ApplicationConst.AppGroupName, Name = "AppXzCoupon", Order = 100)]
public partial class APPXzCouponService : IDynamicApiController, ITransient
{
    private readonly SqlSugarRepository<XzCoupon> _xzCouponRep;
    private readonly ISqlSugarClient _sqlSugarClient;
    private readonly AppUserManager _userManager;

    public APPXzCouponService(SqlSugarRepository<XzCoupon> xzCouponRep, ISqlSugarClient sqlSugarClient, AppUserManager userManager)
    {
        _xzCouponRep = xzCouponRep;
        _sqlSugarClient = sqlSugarClient;
        _userManager = userManager;

    }

    /// <summary>
    /// 分页查询系统优惠券 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("分页查询系统优惠券")]
    [ApiDescriptionSettings(Name = "Page"), HttpPost]
    public async Task<SqlSugarPagedList<XzCouponOutput>> Page(PageXzCouponInput input)
    {
        input.Keyword = input.Keyword?.Trim();
        var query = _xzCouponRep.AsQueryable()            
            .WhereIF(input.ctype != null, u => u.ctype == input.ctype)
            .WhereIF(input.stimeRange?.Length == 2, u => u.stime >= input.stimeRange[0] && u.stime <= input.stimeRange[1])
            .WhereIF(input.etimeRange?.Length == 2, u => u.etime >= input.etimeRange[0] && u.etime <= input.etimeRange[1])
            .WhereIF(input.isdel != null, u => u.isdel == input.isdel)
            .WhereIF(input.count != null, u => u.count == input.count)
            .Select<XzCouponOutput>();
		return await query.OrderBuilder(input).ToPagedListAsync(input.Page, input.PageSize);
    }

    
}
