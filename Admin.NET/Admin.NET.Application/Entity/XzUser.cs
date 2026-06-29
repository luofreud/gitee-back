// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Admin.NET.Core;
using Elastic.Clients.Elasticsearch;
using SqlSugar;
namespace Admin.NET.Application.Entity;

/// <summary>
/// 用户表
/// </summary>
[Tenant("1300000000001")]
[SugarTable("xz_user", "用户表")]
public partial class XzUser : EntityBaseId
{
    /// <summary>
    /// 昵称
    /// </summary>
    [SugarColumn(ColumnName = "nickname", ColumnDescription = "昵称", Length = 50)]
    public virtual string? nickname { get; set; }

    /// <summary>
    /// 登陆账号
    /// </summary>
    [SugarColumn(ColumnName = "name", ColumnDescription = "登陆账号", Length = 50)]
    public virtual string? name { get; set; }


    /// <summary>
    /// 所属星座名称
    /// </summary>
    [SugarColumn(ColumnName = "xzname", ColumnDescription = "所属星座名称", Length = 50)]
    public virtual string? xzname { get; set; }


    /// <summary>
    /// 星座图标
    /// </summary>
    [SugarColumn(ColumnName = "xzimg", ColumnDescription = "星座图标", Length = 50)]
    public virtual string? xzimg { get; set; }


    /// <summary>
    /// 密码
    /// </summary>
    [SugarColumn(ColumnName = "password", ColumnDescription = "密码", Length = 50)]
    public virtual string? password { get; set; }


    /// <summary>
    /// 电话
    /// </summary>
    [SugarColumn(ColumnName = "phone", ColumnDescription = "电话", Length = 20)]
    public virtual string? phone { get; set; }

    /// <summary>
    /// openid
    /// </summary>
    [SugarColumn(ColumnName = "openid", ColumnDescription = "openid", Length = 40)]
    public virtual string? openid { get; set; }

    /// <summary>
    /// 0:男，1:女
    /// </summary>
    [SugarColumn(ColumnName = "sex", ColumnDescription = "0:男，1:女")]
    public virtual int? sex { get; set; }

    /// <summary>
    /// 直播间id
    /// </summary>
    [SugarColumn(ColumnName = "roomid", ColumnDescription = "直播间id")]
    public virtual int? roomid { get; set; }

    /// <summary>
    /// 0:普通，1:导师，2：管理员
    /// </summary>
    [SugarColumn(ColumnName = "utype", ColumnDescription = "0:普通，1:导师，2：管理员")]
    public virtual int? utype { get; set; }

    /// <summary>
    /// 等级1-5
    /// </summary>
    [SugarColumn(ColumnName = "level", ColumnDescription = "等级1-5")]
    public virtual int? level { get; set; }

    /// <summary>
    /// 出生地址
    /// </summary>
    [SugarColumn(ColumnName = "address", ColumnDescription = "出生地址", Length = 100)]
    public virtual string? address { get; set; }

    /// <summary>
    /// 头像
    /// </summary>
    [SugarColumn(ColumnName = "headimg", ColumnDescription = "头像", Length = 100)]
    public virtual string? headimg { get; set; }

    /// <summary>
    /// 现居地址
    /// </summary>
    [SugarColumn(ColumnName = "nowaddress", ColumnDescription = "现居地址", Length = 100)]
    public virtual string? nowaddress { get; set; }

    /// <summary>
    /// 星币
    /// </summary>
    [SugarColumn(ColumnName = "xbmoney", ColumnDescription = "星币")]
    public virtual int? xbmoney { get; set; }

    /// <summary>
    /// 星钻 1-1
    /// </summary>
    [SugarColumn(ColumnName = "xzmoney", ColumnDescription = "星钻 1-1")]
    public virtual double? xzmoney { get; set; }

    /// <summary>
    /// 连麦时长（剩余）
    /// </summary>
    [SugarColumn(ColumnName = "lmtime", ColumnDescription = "连麦时长（剩余）")]
    public virtual int? lmtime { get; set; }

    /// <summary>
    /// 是否首充
    /// </summary>
    [SugarColumn(ColumnName = "iscz", ColumnDescription = "是否首充")]
    public virtual int? iscz { get; set; }

    /// <summary>
    /// 签名限定20个字
    /// </summary>
    [SugarColumn(ColumnName = "sign", ColumnDescription = "签名限定20个字", Length = 100)]
    public virtual string? sign { get; set; }

    /// <summary>
    /// 0：正常，1：异常
    /// </summary>
    [SugarColumn(ColumnName = "state", ColumnDescription = "0：正常，1：异常")]
    public virtual int? state { get; set; }

    /// <summary>
    /// 推广code
    /// </summary>
    [SugarColumn(ColumnName = "tgcode", ColumnDescription = "", Length = 50)]
    public virtual string? tgcode { get; set; }

    /// <summary>
    /// 创建时间
    /// </summary>
    [SugarColumn(ColumnName = "createtime", ColumnDescription = "")]
    public virtual DateTime? createtime { get; set; }


    /// <summary>
    /// 最后登陆时间
    /// </summary>
    [SugarColumn(ColumnName = "lastlogintime", ColumnDescription = "")]
    public virtual DateTime? lastlogintime { get; set; }

    /// <summary>
    /// 登陆登陆ip
    /// </summary>
    [SugarColumn(ColumnName = "lastloginip", ColumnDescription = "")]
    public virtual string? lastloginip { get; set; }

    /// <summary>
    /// 最后登陆地址
    /// </summary>
    [SugarColumn(ColumnName = "lastloginaddress", ColumnDescription = "")]
    public virtual string? lastloginaddress { get; set; }

    /// <summary>
    /// 出生日期
    /// </summary>
    [SugarColumn(ColumnName = "birthday", ColumnDescription = "")]
    public virtual DateTime? birthday { get; set; }

    /// <summary>
    /// 删除，0:正常，1：删除
    /// </summary>
    public virtual int? isdelete { get; set; }

    /// <summary>
    /// 导师teacher
    /// </summary>
    [Navigate(NavigateType.OneToOne, nameof(Id),nameof(teacher.uid))]
    public XzTeacher teacher { get; set; }
}
