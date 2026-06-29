// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Admin.NET.Application;
using Admin.NET.Application.Entity;
using Admin.NET.Core.Service;
using AngleSharp.Dom;
using Azure.Core;
using Furion.DatabaseAccessor;
using Furion.DataEncryption;
using Furion.EventBus;
using Furion.FriendlyException;
using Furion.Logging;
using Furion.SpecificationDocument;
using Lazy.Captcha.Core;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Options;
using NewLife;
using NewLife.Reflection;
using SqlSugar;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using Yitter.IdGenerator;

namespace AAdmin.NET.Application.Service;

/// <summary>
/// app登录授权服务 🧩 
/// </summary>
[ApiDescriptionSettings(ApplicationConst.AppGroupName, Name = "AppXzUser", Order = 100)]
public class AppXzUserAuthService : IDynamicApiController, ITransient
{
    private readonly AppUserManager _userManager;
    private readonly SqlSugarRepository<XzUser> _sysUserRep;
    private readonly IHttpContextAccessor _httpContextAccessor;
    private readonly SysLdapService _sysLdapService;
    private readonly ICaptcha _captcha;
    private readonly IEventPublisher _eventPublisher;
    private readonly SysCacheService _sysCacheService;
    private readonly SysSmsService _sysSmsService;
    private readonly SysConfigService _sysConfigService;
    private readonly SqlSugarRepository<XzUserRoom> _xzUserRoomRep;
    private readonly ISqlSugarClient _sqlSugarClient;
    private readonly UploadOptions _uploadOptions;

    public AppXzUserAuthService(
        SqlSugarRepository<XzUser> sysUserRep,
        IHttpContextAccessor httpContextAccessor,
        SysConfigService sysConfigService,
        SysLdapService sysLdapService,
        IEventPublisher eventPublisher,
        SysSmsService sysSmsService,
        SysCacheService sysCacheService,
        AppUserManager userManager,
        ICaptcha captcha,
        SqlSugarRepository<XzUserRoom> xzUserRoomRep,
       ISqlSugarClient sqlSugarClient,
        IOptions<UploadOptions> uploadOptions

        )
    {
        _sysConfigService = sysConfigService;
        _captcha = captcha;
        _sysUserRep = sysUserRep;
        _userManager = userManager;
        _sysSmsService = sysSmsService;
        _eventPublisher = eventPublisher;
        _sysCacheService = sysCacheService;
        _httpContextAccessor = httpContextAccessor;
        _sysLdapService = sysLdapService;
        _xzUserRoomRep = xzUserRoomRep;
        _sqlSugarClient = sqlSugarClient;
        _uploadOptions = uploadOptions.Value;
    }

    ///// <summary>
    ///// 账号密码登录 🔖
    ///// </summary>
    ///// <param name="input"></param>
    ///// <remarks>用户名/密码：superadmin/123456</remarks>
    ///// <returns></returns>
    //[AllowAnonymous]
    //[DisplayName("账号密码登录")]
    //public virtual async Task<APPLoginOutput> Login([Required] LoginInput input)
    //{
    //    // 判断密码错误次数（缓存30分钟）
    //    var keyPasswordErrorTimes = $"{CacheConst.KeyPasswordErrorTimes}{input.Account}";
    //    var passwordErrorTimes = _sysCacheService.Get<int>(keyPasswordErrorTimes);
    //    var passwordMaxErrorTimes = await _sysConfigService.GetConfigValue<int>(ConfigConst.SysPasswordMaxErrorTimes);
    //    // 若未配置或误配置为0、负数, 则默认密码错误次数最大为5次
    //    if (passwordMaxErrorTimes < 1) passwordMaxErrorTimes = 5;
    //    if (passwordErrorTimes > passwordMaxErrorTimes) throw Oops.Oh(ErrorCodeEnum.D1027);

    //    // 获取登录租户和用户
    //    var user = await GetLoginUserAndTenant(input.Account);
    //    //检查用户是否存在
    //    _ = user ?? throw Oops.Oh(ErrorCodeEnum.D0009);

    //    // 账号是否被冻结
    //    if (user.state == 1) throw Oops.Oh(ErrorCodeEnum.D1017);


    //    VerifyPassword(input.Password, keyPasswordErrorTimes, passwordErrorTimes, user);



    //    // 登录成功则清空密码错误次数
    //    _sysCacheService.Remove(keyPasswordErrorTimes);

    //    return await CreateToken(user);
    //}

    /// <summary>
    /// 发送短信
    /// </summary>
    /// <param name="phone"></param>
    /// <param name="code">验证码</param>
    /// <param name="codeid">验证码</param>
    /// <returns></returns>
    [AllowAnonymous]
    [DisplayName("发送登录验证码")]
    public async Task SendPhoneCode(string phone, string code = null, string codeid = null)
    {
        if (string.IsNullOrWhiteSpace(code)) throw Oops.Oh(ErrorCodeEnum.D2102);

        if (string.IsNullOrWhiteSpace(codeid)) throw Oops.Oh(ErrorCodeEnum.D2102);

        // 校验验证码
        if (!_captcha.Validate(codeid, code)) throw Oops.Oh(ErrorCodeEnum.D0008);

        if (_sysCacheService.GetValue(phone) == null)
        {
            // 账号是否存在
            await _sysSmsService.TencentSendSms(phone, "2619523");
            _sysCacheService.Set(phone, DateTime.Now, TimeSpan.FromMinutes(5));
        }
    }
    /// <summary>
    /// 获取登录租户和用户
    /// </summary>
    /// <param name="phone"></param>
    /// <returns></returns>
    [NonAction]
    public async Task<XzUser> GetLoginUserAndTenant(string name, string phone = null)
    {
        // 账号是否存在
        var user = await _sysUserRep.AsQueryable().ClearFilter()
            .WhereIF(true, f => f.isdelete == 0)
            .WhereIF(!string.IsNullOrWhiteSpace(name), u => u.name.Equals(name))
            .WhereIF(!string.IsNullOrWhiteSpace(phone), u => u.phone.Equals(phone)).FirstAsync();
        return user;
    }

    /// <summary>
    /// 验证用户密码
    /// </summary>
    /// <param name="password"></param>
    /// <param name="keyPasswordErrorTimes"></param>
    /// <param name="passwordErrorTimes"></param>
    /// <param name="user"></param>
    private void VerifyPassword(string password, string keyPasswordErrorTimes, int passwordErrorTimes, XzUser user)
    {
        try
        {
            // 国密SM2解密（前端密码传输SM2加密后的）
            //password = CryptogramUtil.SM2Decrypt(password);
            if (CryptogramUtil.CryptoType == CryptogramEnum.MD5.ToString())
            {
                if (user.password.Equals(MD5Encryption.Encrypt(password))) return;
            }
            else
            {
                if (CryptogramUtil.Decrypt(user.password).Equals(password)) return;
            }
        }
        catch (Exception ex)
        {
            Log.Error("用户密码验证异常：", ex);
        }

        _sysCacheService.Set(keyPasswordErrorTimes, ++passwordErrorTimes, TimeSpan.FromMinutes(30));
        throw Oops.Oh(ErrorCodeEnum.D1000);
    }



    /// <summary>
    /// 首选-手机号登录 🔖
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [AllowAnonymous]
    [DisplayName("手机号登录")]
    [UnitOfWork]
    public virtual async Task<APPLoginOutput> LoginPhone([Required] AppLoginPhoneInput input)
    {
        // 校验短信验证码  验证码测试通过
        //_sysSmsService.VerifyCode(new SmsVerifyCodeInput { Phone = input.Phone, Code = input.Code });

        // 获取登录租户和用户
        var user = await GetLoginUserAndTenant("", phone: input.Phone);
        //如果不存在直接添加用户
        if (user == null)
        {
            user = new XzUser();
            user.phone = input.Phone;
            user.createtime = DateTime.Now;
            user.level = 1;
            user.state = 0;
            user.xbmoney = 0;
            user.xzmoney = 0;
            user.iscz = 0;
            user.lmtime = 0;
            user.isdelete = 0;
            user.utype = 0;
            user.nickname = "用户" + input.Phone.Substring(input.Phone.Length - 4);
            user.headimg = _uploadOptions.Host + "/upload/default_avatar.png";
            var result = await _sysUserRep.InsertReturnSnowflakeIdAsync(user);
            var roomid = await _xzUserRoomRep.InsertReturnIdentityAsync(new XzUserRoom()
            {
                createtime = DateTime.Now,
                uid = result
            });
            user.Id = result;
            user.roomid = roomid;
            await _sysUserRep.AsUpdateable(user).UpdateColumns(f => f.roomid).ExecuteCommandAsync();
            return await CreateToken(user, SysUserEventTypeEnum.Login, 0);

        }
        else
        {
            if (user.utype == 1)
            {
                user.teacher = await _sqlSugarClient.Queryable<XzTeacher>().Where(f => f.uid == user.Id).FirstAsync();
            }

        }
        return await CreateToken(user, SysUserEventTypeEnum.Login, 1);
    }

    /// <summary>
    /// 生成Token令牌 🔖
    /// </summary>
    /// <param name="user"></param>
    /// <param name="sysUserEventTypeEnum"></param>
    /// <returns></returns>
    [NonAction]
    internal virtual async Task<APPLoginOutput> CreateToken(XzUser user, SysUserEventTypeEnum sysUserEventTypeEnum = SysUserEventTypeEnum.Login, int isreg = 1)
    {
        //// 单用户登录
        //await _sysOnlineUserService.SingleLogin(user.Id);

        // 生成Token令牌
        var tokenExpire = await _sysConfigService.GetTokenExpire();
        var tokedic = new Dictionary<string, object>
        {
            { AppClaimConst.userid, user.Id },
            { AppClaimConst.name, user.name },
            { AppClaimConst.openid, user.openid },
            { AppClaimConst.level, user.level },
            { AppClaimConst.roomid, user.roomid },
            { AppClaimConst.utype, user.utype },
            { "LoginMode","2" } };
        if (user.utype == 1)
        {
            tokedic.Add(AppClaimConst.tid, user.teacher.Id);
        }
        var accessToken = JWTEncryption.Encrypt(tokedic
            , tokenExpire);

        // 生成刷新Token令牌
        var refreshTokenExpire = await _sysConfigService.GetRefreshTokenExpire();
        var refreshToken = JWTEncryption.GenerateRefreshToken(accessToken, refreshTokenExpire);

        // 设置响应报文头
        _httpContextAccessor.HttpContext.SetTokensOfResponseHeaders(accessToken, refreshToken);

        // Swagger Knife4UI-AfterScript登录脚本
        // ke.global.setAllHeader('Authorization', 'Bearer ' + ke.response.headers['access-token']);

        // 更新用户登录信息
        user.lastloginip = _httpContextAccessor.HttpContext.GetRemoteIpAddressToIPv4(true);
        (user.lastloginaddress, double? longitude, double? latitude) = CommonUtil.GetIpAddress(user.lastloginip);
        user.lastlogintime = DateTime.Now;
        await _sysUserRep.AsUpdateable(user).UpdateColumns(f => new
        {
            f.lastloginaddress,
            f.lastloginip,
            f.lastlogintime
        }).ExecuteCommandAsync();
        var payload = new
        {
            Entity = user,
            Output = new APPLoginOutput
            {
                AccessToken = accessToken,
                RefreshToken = refreshToken,
                isreg = isreg
            }
        };

        // 发布系统用户操作事件
        await _eventPublisher.PublishAsync(sysUserEventTypeEnum, payload);
        return payload.Output;
    }

    ///// <summary>
    ///// 获取登录账号 🔖
    ///// </summary>
    ///// <returns></returns>
    //[DisplayName("获取登录账号")]
    //public virtual async Task<LoginUserOutput> GetUserInfo()
    //{
    //    var user = await _sysUserRep.AsQueryable().ClearFilter().FirstAsync(u => u.Id == _userManager.UserId) ?? throw Oops.Oh(ErrorCodeEnum.D1011).StatusCode(401);


    //}

    /// <summary>
    /// 获取刷新Token 🔖
    /// </summary>
    /// <param name="accessToken">旧的AccessToken</param>
    /// <returns>新的AccessToken和RefreshToken</returns>
    [DisplayName("获取刷新Token")]
    public virtual async Task<APPLoginOutput> GetRefreshToken([FromQuery] string accessToken)
    {
        var httpContext = _httpContextAccessor.HttpContext;
        if (httpContext == null) throw Oops.Oh(ErrorCodeEnum.D1016);

        if (string.IsNullOrWhiteSpace(accessToken)) throw Oops.Oh(ErrorCodeEnum.D1011);

        if (string.IsNullOrWhiteSpace(_userManager.name)) throw Oops.Oh(ErrorCodeEnum.D1011);

        // 黑名单校验
        if (_sysCacheService.ExistKey($"appblacklist:token:{accessToken}")) throw Oops.Oh(ErrorCodeEnum.D1011);

        // 解析Token
        var (isValid, tokenData, validationResult) = JWTEncryption.Validate(accessToken);
        if (!isValid) throw Oops.Oh(ErrorCodeEnum.D1016);

        // 获取用户Id
        var user = await _sysUserRep.AsQueryable().ClearFilter().FirstAsync(u => u.Id == _userManager.userid) ?? throw Oops.Oh(ErrorCodeEnum.D1011).StatusCode(401);
        return await CreateToken(user, SysUserEventTypeEnum.RefreshToken);
    }

    /// <summary>
    /// 退出系统 🔖
    /// </summary>
    [DisplayName("退出系统")]
    public async Task Logout()
    {
        var httpContext = _httpContextAccessor.HttpContext;
        if (httpContext == null) throw Oops.Oh(ErrorCodeEnum.D1016);

        var token = httpContext.Request.Headers["Authorization"].ToString().Replace("Bearer ", "");

        if (string.IsNullOrWhiteSpace(token))
            throw Oops.Oh(ErrorCodeEnum.D1011);

        if (string.IsNullOrWhiteSpace(_userManager.name))
            throw Oops.Oh(ErrorCodeEnum.D1011);

        // 写入黑名单（设置过期时间，避免Redis膨胀）
        var tokenExpire = await _sysConfigService.GetTokenExpire();
        _sysCacheService.Set($"blacklist:token:{token}", "1", TimeSpan.FromMinutes(tokenExpire));

        // 发布登出事件（用户退出）
        var user = await _sysUserRep.GetByIdAsync(_userManager.userid);
        await _eventPublisher.PublishAsync(SysUserEventTypeEnum.LoginOut, new { Entity = user });

        // 清除 Swagger 登录信息
        httpContext.SignoutToSwagger();
    }

    /// <summary>
    /// 获取验证码 🔖
    /// </summary>
    /// <returns></returns>
    [AllowAnonymous]
    [SuppressMonitor]
    [DisplayName("获取验证码")]
    public dynamic GetCaptcha()
    {
        var codeId = YitIdHelper.NextId().ToString();
        var captcha = _captcha.Generate(codeId);
        var expirySeconds = App.GetOptions<CaptchaOptions>()?.ExpirySeconds ?? 60;
        return new { Id = codeId, Img = captcha.Base64, ExpirySeconds = expirySeconds };
    }

    ///// <summary>
    ///// 用户注册 🔖
    ///// </summary>
    ///// <param name="input"></param>
    ///// <returns></returns>
    //[UnitOfWork]
    //[AllowAnonymous]
    //[HttpPost, ApiDescriptionSettings(Description = "用户注册", DisableInherite = true)]
    //public async Task UserRegistration(UserRegistrationInput input)
    //{
    //    // 校验验证码
    //    if (!_captcha.Validate(input.CodeId.ToString(), input.Code)) throw Oops.Oh(ErrorCodeEnum.D0008);
    //    _captcha.Generate(input.CodeId.ToString());

    //    // 登录时隐藏租户，查找对应租户信息
    //    input.TenantId = input.TenantId <= 0 ? (await _sysTenantService.GetCurrentTenantSysInfo()).Id : input.TenantId;

    //    // 判断租户是否有效且启用注册功能
    //    var tenant = await _sysUserRep.Context.Queryable<SysTenant>().FirstAsync(u => u.Id == input.TenantId && u.Status == StatusEnum.Enable);
    //    if (tenant?.EnableReg != YesNoEnum.Y) throw Oops.Oh(ErrorCodeEnum.D1034);

    //    // 查找注册方案
    //    var wayId = input.WayId <= 0 ? tenant.RegWayId : input.WayId;
    //    var regWay = await _sysUserRep.Context.Queryable<SysUserRegWay>().FirstAsync(u => u.Id == wayId) ?? throw Oops.Oh(ErrorCodeEnum.D1035);

    //    var addUserInput = new AddUserInput
    //    {
    //        AccountType = regWay.AccountType,
    //        NickName = "注册用户-" + input.Account,
    //        OrgId = regWay.OrgId,
    //        PosId = regWay.PosId,
    //        TenantId = input.TenantId,
    //        RoleIdList = new List<long> { regWay.RoleId },
    //    };
    //    addUserInput.Copy(input);
    //    await _sysUserService.RegisterUser(addUserInput);
    //}


}