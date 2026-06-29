using System;

namespace Admin.NET.Core.Utils
{
    /// <summary>
    /// Agora RTC Token 构建器（AccessToken2 版本）
    /// 基于 Java 版本 AgoraIO/Tools RtcTokenBuilder2.java 移植到 C#
    ///
    /// 用法示例:
    ///   var builder = new RtcTokenBuilder2();
    ///   string token = builder.BuildTokenWithUid(appId, appCert, channelName, uid,
    ///                      Role.Publisher, tokenExpire, privilegeExpire);
    /// </summary>
    public class RtcTokenBuilder2
    {
        /// <summary>用户角色</summary>
        public enum Role
        {
            /// <summary>
            /// 发布者：可加入频道、发布音视频及数据流（推荐用于视频通话/直播主播）
            /// </summary>
            Publisher = 1,

            /// <summary>
            /// 订阅者：只能加入频道，不能发布流（需在控制台启用共同主持人验证）
            /// </summary>
            Subscriber = 2,
        }

        // -------------------------------------------------------------------
        // 1. 基于数字 UID 生成 RTC Token
        // -------------------------------------------------------------------

        /// <summary>
        /// 基于数字 UID 生成 RTC Token（角色模式）
        /// </summary>
        /// <param name="appId">Agora App ID（32位十六进制字符串）</param>
        /// <param name="appCertificate">Agora App Certificate（32位十六进制字符串）</param>
        /// <param name="channelName">频道名称</param>
        /// <param name="uid">用户 UID（0 表示任意用户）</param>
        /// <param name="role">用户角色</param>
        /// <param name="tokenExpire">Token 有效期（秒，从当前时间起）</param>
        /// <param name="privilegeExpire">权限有效期（秒，从当前时间起）</param>
        /// <returns>Token 字符串</returns>
        public string BuildTokenWithUid(
            string appId,
            string appCertificate,
            string channelName,
            uint   uid,
            Role   role,
            int    tokenExpire,
            int    privilegeExpire)
        {
            return BuildTokenWithUserAccount(
                appId, appCertificate, channelName,
                AccessToken2.GetUidStr(uid),
                role, tokenExpire, privilegeExpire);
        }

        // -------------------------------------------------------------------
        // 2. 基于用户账号字符串生成 RTC Token（角色模式）
        // -------------------------------------------------------------------

        /// <summary>
        /// 基于用户账号字符串生成 RTC Token（角色模式）
        /// </summary>
        /// <param name="account">用户账号（字符串形式）</param>
        public string BuildTokenWithUserAccount(
            string appId,
            string appCertificate,
            string channelName,
            string account,
            Role   role,
            int    tokenExpire,
            int    privilegeExpire)
        {
            var token   = new AccessToken2(appId, appCertificate, tokenExpire);
            var svcRtc  = new AccessToken2.ServiceRtc(channelName, account);

            svcRtc.AddPrivilegeRtc(AccessToken2.PrivilegeRtc.PrivilegeJoinChannel, privilegeExpire);

            if (role == Role.Publisher)
            {
                svcRtc.AddPrivilegeRtc(AccessToken2.PrivilegeRtc.PrivilegePublishAudioStream, privilegeExpire);
                svcRtc.AddPrivilegeRtc(AccessToken2.PrivilegeRtc.PrivilegePublishVideoStream, privilegeExpire);
                svcRtc.AddPrivilegeRtc(AccessToken2.PrivilegeRtc.PrivilegePublishDataStream,  privilegeExpire);
            }

            token.AddService(svcRtc);

            try
            {
                return token.Build();
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine(ex);
                return string.Empty;
            }
        }

        // -------------------------------------------------------------------
        // 3. 基于数字 UID、细粒度权限过期时间生成 RTC Token
        // -------------------------------------------------------------------

        /// <summary>
        /// 基于数字 UID 生成 RTC Token（细粒度权限模式）
        /// </summary>
        /// <param name="joinChannelPrivilegeExpire">加入频道权限有效期（秒）</param>
        /// <param name="pubAudioPrivilegeExpire">发布音频流权限有效期（秒）</param>
        /// <param name="pubVideoPrivilegeExpire">发布视频流权限有效期（秒）</param>
        /// <param name="pubDataStreamPrivilegeExpire">发布数据流权限有效期（秒）</param>
        public string BuildTokenWithUid(
            string appId,
            string appCertificate,
            string channelName,
            uint   uid,
            int    tokenExpire,
            int    joinChannelPrivilegeExpire,
            int    pubAudioPrivilegeExpire,
            int    pubVideoPrivilegeExpire,
            int    pubDataStreamPrivilegeExpire)
        {
            return BuildTokenWithUserAccount(
                appId, appCertificate, channelName,
                AccessToken2.GetUidStr(uid),
                tokenExpire,
                joinChannelPrivilegeExpire,
                pubAudioPrivilegeExpire,
                pubVideoPrivilegeExpire,
                pubDataStreamPrivilegeExpire);
        }

        // -------------------------------------------------------------------
        // 4. 基于用户账号、细粒度权限过期时间生成 RTC Token
        // -------------------------------------------------------------------

        /// <summary>
        /// 基于用户账号字符串生成 RTC Token（细粒度权限模式）
        /// </summary>
        public string BuildTokenWithUserAccount(
            string appId,
            string appCertificate,
            string channelName,
            string account,
            int    tokenExpire,
            int    joinChannelPrivilegeExpire,
            int    pubAudioPrivilegeExpire,
            int    pubVideoPrivilegeExpire,
            int    pubDataStreamPrivilegeExpire)
        {
            var token  = new AccessToken2(appId, appCertificate, tokenExpire);
            var svcRtc = new AccessToken2.ServiceRtc(channelName, account);

            svcRtc.AddPrivilegeRtc(AccessToken2.PrivilegeRtc.PrivilegeJoinChannel,        joinChannelPrivilegeExpire);
            svcRtc.AddPrivilegeRtc(AccessToken2.PrivilegeRtc.PrivilegePublishAudioStream,  pubAudioPrivilegeExpire);
            svcRtc.AddPrivilegeRtc(AccessToken2.PrivilegeRtc.PrivilegePublishVideoStream,  pubVideoPrivilegeExpire);
            svcRtc.AddPrivilegeRtc(AccessToken2.PrivilegeRtc.PrivilegePublishDataStream,   pubDataStreamPrivilegeExpire);

            token.AddService(svcRtc);

            try
            {
                return token.Build();
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine(ex);
                return string.Empty;
            }
        }

        // -------------------------------------------------------------------
        // 5. 同时生成 RTC + RTM Token（角色模式）
        // -------------------------------------------------------------------

        /// <summary>
        /// 基于数字 UID 同时生成 RTC + RTM Token
        /// </summary>
        public string BuildTokenWithRtm(
            string appId,
            string appCertificate,
            string channelName,
            uint   uid,
            Role   role,
            int    tokenExpire,
            int    privilegeExpire)
        {
            return BuildTokenWithRtm(
                appId, appCertificate, channelName,
                AccessToken2.GetUidStr(uid),
                role, tokenExpire, privilegeExpire);
        }

        /// <summary>
        /// 基于用户账号字符串同时生成 RTC + RTM Token
        /// </summary>
        public string BuildTokenWithRtm(
            string appId,
            string appCertificate,
            string channelName,
            string account,
            Role   role,
            int    tokenExpire,
            int    privilegeExpire)
        {
            var token  = new AccessToken2(appId, appCertificate, tokenExpire);

            // RTC 服务
            var svcRtc = new AccessToken2.ServiceRtc(channelName, account);
            svcRtc.AddPrivilegeRtc(AccessToken2.PrivilegeRtc.PrivilegeJoinChannel, privilegeExpire);
            if (role == Role.Publisher)
            {
                svcRtc.AddPrivilegeRtc(AccessToken2.PrivilegeRtc.PrivilegePublishAudioStream, privilegeExpire);
                svcRtc.AddPrivilegeRtc(AccessToken2.PrivilegeRtc.PrivilegePublishVideoStream, privilegeExpire);
                svcRtc.AddPrivilegeRtc(AccessToken2.PrivilegeRtc.PrivilegePublishDataStream,  privilegeExpire);
            }
            token.AddService(svcRtc);

            // RTM 服务
            var svcRtm = new AccessToken2.ServiceRtm(account);
            svcRtm.AddPrivilegeRtm(AccessToken2.PrivilegeRtm.PrivilegeLogin, tokenExpire);
            token.AddService(svcRtm);

            try
            {
                return token.Build();
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine(ex);
                return string.Empty;
            }
        }

        // -------------------------------------------------------------------
        // 6. 高级：RTC + RTM 分别指定参数
        // -------------------------------------------------------------------

        /// <summary>
        /// 高级模式：RTC 和 RTM 分别使用不同的 account 和过期时间
        /// </summary>
        /// <param name="rtcUid">RTC 用户 UID</param>
        /// <param name="rtmUserId">RTM 用户账号</param>
        /// <param name="tokenExpire">Token 有效期（秒）</param>
        /// <param name="privilegeExpire">RTC 权限有效期（秒）</param>
        /// <param name="rtmTokenExpire">RTM 权限有效期（秒）</param>
        public string BuildTokenWithAll(
            string appId,
            string appCertificate,
            string channelName,
            uint   rtcUid,
            string rtmUserId,
            Role   role,
            int    tokenExpire,
            int    privilegeExpire,
            int    rtmTokenExpire)
        {
            var token  = new AccessToken2(appId, appCertificate, tokenExpire);

            // RTC 服务
            var svcRtc = new AccessToken2.ServiceRtc(channelName, AccessToken2.GetUidStr(rtcUid));
            svcRtc.AddPrivilegeRtc(AccessToken2.PrivilegeRtc.PrivilegeJoinChannel, privilegeExpire);
            if (role == Role.Publisher)
            {
                svcRtc.AddPrivilegeRtc(AccessToken2.PrivilegeRtc.PrivilegePublishAudioStream, privilegeExpire);
                svcRtc.AddPrivilegeRtc(AccessToken2.PrivilegeRtc.PrivilegePublishVideoStream, privilegeExpire);
                svcRtc.AddPrivilegeRtc(AccessToken2.PrivilegeRtc.PrivilegePublishDataStream,  privilegeExpire);
            }
            token.AddService(svcRtc);

            // RTM 服务
            var svcRtm = new AccessToken2.ServiceRtm(rtmUserId);
            svcRtm.AddPrivilegeRtm(AccessToken2.PrivilegeRtm.PrivilegeLogin, rtmTokenExpire);
            token.AddService(svcRtm);

            try
            {
                return token.Build();
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine(ex);
                return string.Empty;
            }
        }
    }
}
