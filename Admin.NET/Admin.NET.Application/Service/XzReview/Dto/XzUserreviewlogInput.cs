// Admin.NET 项目的版权、商标、专利和其他相关权利均受相应法律法规的保护。使用本项目应遵守相关法律法规和许可证的要求。
//
// 本项目主要遵循 MIT 许可证和 Apache 许可证（版本 2.0）进行分发和使用。许可证位于源代码树根目录中的 LICENSE-MIT 和 LICENSE-APACHE 文件。
//
// 不得利用本项目从事危害国家安全、扰乱社会秩序、侵犯他人合法权益等法律法规禁止的活动！任何基于本项目二次开发而产生的一切法律纠纷和责任，我们不承担任何责任！

using Admin.NET.Core;
using Magicodes.ExporterAndImporter.Core;
using Magicodes.ExporterAndImporter.Excel;
using SqlSugar;
using System.ComponentModel.DataAnnotations;

namespace Admin.NET.Application;


/// <summary>
/// 
/// </summary>
public class PageXzUserreviewlogInput : BasePageInput
{
    public virtual long? id { get; set; }
    /// <summary>
    /// uid
    /// </summary>
    public virtual long? uid { get; set; }

    /// <summary>
    /// rid 测评id
    /// </summary>
    public virtual long? rid { get; set; }

    /// <summary>
    /// 金额
    /// </summary>
    public virtual double? money { get; set; }

    /// <summary>
    /// 0：等待支付，1：已支付
    /// </summary>
    public virtual int? orderstate { get; set; }

    /// <summary>
    /// 单号
    /// </summary>
    public virtual string? ordernum { get; set; }

    /// <summary>
    /// 标题
    /// </summary>
    public virtual string? title { get; set; }

    /// <summary>
    /// 咨询师id
    /// </summary>
    public virtual int? tid { get; set; }

    /// <summary>
    /// 报告内容
    /// </summary>
    public virtual string? content { get; set; }

    /// <summary>
    ///  0：等待分配，1：已分配等待完成，2：完成
    /// </summary>
    public virtual int? rstate { get; set; }

    /// <summary>
    /// 
    /// </summary>
    public virtual DateTime? createtime { get; set; }
}