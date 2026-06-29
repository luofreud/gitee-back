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
/// APP-收货地址 🧩
/// </summary>
[ApiDescriptionSettings(ApplicationConst.AppGroupName, Order = 100)]
public partial class AppXzTakeAddressService : IDynamicApiController, ITransient
{
    private readonly SqlSugarRepository<XzTakeaddress> _xzTakeaddress;
    private readonly SqlSugarRepository<XzUser> _xzUser;

    private readonly ISqlSugarClient _sqlSugarClient;
    private readonly AppUserManager _userManager;

    public AppXzTakeAddressService(SqlSugarRepository<XzTakeaddress> xzTakeaddress, ISqlSugarClient sqlSugarClient, AppUserManager userManager, SqlSugarRepository<XzUser> xzUser)
    {
        _xzTakeaddress = xzTakeaddress;
        _sqlSugarClient = sqlSugarClient;
        _userManager = userManager;
        _xzUser = xzUser;
    }


    /// <summary>
    /// 获取默认收货地址 🔖
    /// </summary>
    /// <returns></returns>
    [DisplayName("获取默认收货地址")]
    [ApiDescriptionSettings(Name = "GetDefaultAddress"), HttpPost]
    public async Task<XzTakeaddress> GetDefaultAddress()
    {
        return await _xzTakeaddress.AsQueryable()
            .Where(f => f.uid == _userManager.userid && f.isdefault == 0)
             .FirstAsync();
    }

    /// <summary>
    /// 获取列表收货地址 🔖
    /// </summary>
    /// <returns></returns>
    [DisplayName("获取列表收货地址")]
    [ApiDescriptionSettings(Name = "GetAddressPage"), HttpPost]
    public async Task<List<XzTakeaddress>> GetAddressPage()
    {
        return await _xzTakeaddress.AsQueryable()
            .Where(f => f.uid == _userManager.userid)
             .ToListAsync();
    }

    /// <summary>
    /// 添加收货、修改地址 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [DisplayName("添加收货地址")]
    [ApiDescriptionSettings(Name = "EditAddAddress"), HttpPost]
    [UnitOfWork]
    public async Task<int> EditAddAddress(XzTakeaddress input)
    {
        if (input.Id > 0)
        {
            if (input.isdefault == 1)
            {
                await _xzTakeaddress.AsUpdateable(new XzTakeaddress { isdefault = 0 }).UpdateColumns(f => new { f.isdefault })
                 .Where(t => t.uid == _userManager.userid).ExecuteCommandAsync();
            }

            return await _xzTakeaddress.AsUpdateable(input).UpdateColumns(f => new { f.address, f.isdefault, f.name, f.area, f.phone })
                 .Where(t => t.Id == input.Id).ExecuteCommandAsync();
        }
        else
        {
            if (input.isdefault == 1)
            {
                await _xzTakeaddress.AsUpdateable(new XzTakeaddress { isdefault = 0 }).UpdateColumns(f => new { f.isdefault })
                 .Where(t => t.uid == _userManager.userid).ExecuteCommandAsync();
            }

            input.uid = _userManager.userid;
            input.createtime = DateTime.Now;
            var result = await _xzTakeaddress.InsertAsync(input);
            return result ? 1 : 0;
        }

    }

    /// <summary>
    /// 删除收货地址 🔖
    /// </summary>
    /// <returns></returns>
    [DisplayName("删除收货地址")]
    [ApiDescriptionSettings(Name = "AddressDel"), HttpPost]
    public async Task<bool> AddressDel(XzTakeaddress input)
    {
        return await _xzTakeaddress.DeleteByIdAsync(input.Id);
    }

}
