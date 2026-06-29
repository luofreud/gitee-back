using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Security.Cryptography;
using System.Text;

namespace Admin.NET.Core.Utils
{
    /// <summary>
    /// Agora AccessToken2 —— 完整 C# 实现
    /// 严格对照 Java 版 AccessToken2.java 逻辑移植
    ///
    /// 关键细节（与 Java 完全一致）：
    ///  1. getSign()  : HMAC-SHA256(key=issueTs小端字节, msg=appCert) → HMAC-SHA256(key=salt小端字节, msg=上步结果)
    ///  2. pack顺序   : type(short) → privileges(intMap) → 子类特有字段
    ///  3. bufferContent 最终拼包：
    ///       put(signature)          —— 带 uint16 长度前缀
    ///       buffer.put(buf.bytes()) —— 直接追加原始字节，无前缀
    ///  4. ByteBuf 全部使用小端序(Little-Endian)
    ///  5. put(byte[]) 带 uint16 长度前缀；put(String) → put(utf8bytes)
    ///  6. Utils.compress 使用 zlib (deflate with header)
    /// </summary>
    public class AccessToken2
    {
        public const string VERSION = "007";

        // 服务类型
        public const short SERVICE_TYPE_RTC   = 1;
        public const short SERVICE_TYPE_RTM   = 2;
        public const short SERVICE_TYPE_FPA   = 4;
        public const short SERVICE_TYPE_CHAT  = 5;
        public const short SERVICE_TYPE_APAAS = 7;

        // RTC 权限
        public enum PrivilegeRtc : int
        {
            PrivilegeJoinChannel        = 1,
            PrivilegePublishAudioStream = 2,
            PrivilegePublishVideoStream = 3,
            PrivilegePublishDataStream  = 4,
        }

        // RTM 权限
        public enum PrivilegeRtm : int
        {
            PrivilegeLogin = 1,
        }

        // Chat 权限
        public enum PrivilegeChat : int
        {
            PrivilegeUser = 1,
            PrivilegeApp  = 2,
        }

        // APaaS 权限
        public enum PrivilegeApaas : int
        {
            PrivilegeRoomUser = 1,
            PrivilegeUser     = 2,
            PrivilegeApp      = 3,
        }

        private readonly string _appId;
        private readonly string _appCert;
        private readonly int    _expire;
        private readonly int    _issueTs;
        private readonly int    _salt;

        // 按插入顺序迭代（Java 使用 TreeMap，按 key 升序；这里用 SortedDictionary 保持一致）
        private readonly SortedDictionary<short, Service> _services = new();

        public AccessToken2(string appId, string appCert, int expire)
        {
            _appId   = appId;
            _appCert = appCert;
            _expire  = expire;
            _issueTs = (int)DateTimeOffset.UtcNow.ToUnixTimeSeconds();
            _salt    = new Random().Next(1, int.MaxValue);
        }

        public void AddService(Service service)
        {
            _services[service.Type] = service;
        }

        // ----------------------------------------------------------------
        // build()
        // ----------------------------------------------------------------
        public string Build()
        {
            if (!IsUuid(_appId) || !IsUuid(_appCert))
                return string.Empty;

            // 1. 序列化主体 buf
            //    顺序：appId | issueTs | expire | salt | services.size (short) | services...
            var buf = new ByteBuf();
            buf.PutString(_appId);
            buf.PutInt(_issueTs);
            buf.PutInt(_expire);
            buf.PutInt(_salt);
            buf.PutShort((short)_services.Count);

            // 2. 先算 signing key（getSign），再 pack 各服务
            byte[] signing = GetSign();

            foreach (var svc in _services.Values)
                svc.Pack(buf);

            // 3. HMAC-SHA256(key=signing, msg=buf字节) → signature
            byte[] bufBytes   = buf.AsBytes();
            byte[] signature  = HmacSha256(signing, bufBytes);

            // 4. 最终拼包
            //    bufferContent.put(signature)          → 带 uint16 长度前缀
            //    bufferContent.buffer.put(bufBytes)    → 直接追加原始字节，无前缀
            var content = new ByteBuf();
            content.PutBytes(signature);          // put(byte[]) : uint16 + data
            content.PutRaw(bufBytes);             // buffer.put() : 直接写原始字节

            // 5. zlib compress + base64
            byte[] compressed = Compress(content.AsBytes());
            return VERSION + Convert.ToBase64String(compressed);
        }

        // ----------------------------------------------------------------
        // getSign()
        //   step1: key=issueTs小端4字节,  msg=appCert的UTF-8字节  → signing
        //   step2: key=salt小端4字节,     msg=signing             → result
        // ----------------------------------------------------------------
        private byte[] GetSign()
        {
            byte[] keyIssueTs = IntToLittleEndianBytes(_issueTs);
            byte[] step1 = HmacSha256(keyIssueTs, Encoding.UTF8.GetBytes(_appCert));

            byte[] keySalt = IntToLittleEndianBytes(_salt);
            return HmacSha256(keySalt, step1);
        }

        // ----------------------------------------------------------------
        // 工具
        // ----------------------------------------------------------------
        private static byte[] HmacSha256(byte[] key, byte[] data)
        {
            using var h = new HMACSHA256(key);
            return h.ComputeHash(data);
        }

        private static byte[] IntToLittleEndianBytes(int v)
        {
            var b = new byte[4];
            b[0] = (byte)(v);
            b[1] = (byte)(v >> 8);
            b[2] = (byte)(v >> 16);
            b[3] = (byte)(v >> 24);
            return b;
        }

        private static byte[] Compress(byte[] data)
        {
            // Java 用 java.util.zip.Deflater (zlib 格式，带 2 字节头)
            using var ms = new MemoryStream();
            using (var zs = new ZLibStream(ms, CompressionLevel.Optimal, leaveOpen: true))
                zs.Write(data, 0, data.Length);
            return ms.ToArray();
        }

        private static bool IsUuid(string s)
            => !string.IsNullOrEmpty(s) && s.Length == 32;

        /// <summary>uid == 0 时返回空字符串，否则返回数字字符串</summary>
        public static string GetUidStr(uint uid) => uid == 0 ? "" : uid.ToString();

        // ================================================================
        // Service 基类
        // ================================================================
        public abstract class Service
        {
            public abstract short Type { get; }

            // Java 用 TreeMap<Short,Integer>（按 key 升序），这里保持一致
            protected readonly SortedDictionary<short, int> _privileges = new();

            public void AddPrivilege(short privilege, int expire)
                => _privileges[privilege] = expire;

            /// <summary>
            /// pack 顺序与 Java 完全一致：
            ///   1. type (short)
            ///   2. privileges (intMap: short count + [short key, int val]...)
            ///   3. 子类特有字段
            /// </summary>
            internal virtual void Pack(ByteBuf buf)
            {
                buf.PutShort(Type);
                PutIntMap(buf, _privileges);
                PackInfo(buf);
            }

            protected abstract void PackInfo(ByteBuf buf);

            // putIntMap: short count → (short k, int v)...
            private static void PutIntMap(ByteBuf buf, SortedDictionary<short, int> map)
            {
                buf.PutShort((short)map.Count);
                foreach (var kv in map)
                {
                    buf.PutShort(kv.Key);
                    buf.PutInt(kv.Value);
                }
            }
        }

        // ================================================================
        // ServiceRtc
        // pack：type | privileges | channelName | uid
        // ================================================================
        public class ServiceRtc : Service
        {
            public override short Type => SERVICE_TYPE_RTC;

            private readonly string _channelName;
            private readonly string _uid;

            public ServiceRtc(string channelName, string uid)
            {
                _channelName = channelName;
                _uid         = uid;
            }

            public void AddPrivilegeRtc(PrivilegeRtc p, int expire)
                => AddPrivilege((short)p, expire);

            protected override void PackInfo(ByteBuf buf)
            {
                buf.PutString(_channelName);
                buf.PutString(_uid);
            }
        }

        // ================================================================
        // ServiceRtm
        // pack：type | privileges | userId
        // ================================================================
        public class ServiceRtm : Service
        {
            public override short Type => SERVICE_TYPE_RTM;

            private readonly string _userId;

            public ServiceRtm(string userId) { _userId = userId; }

            public void AddPrivilegeRtm(PrivilegeRtm p, int expire)
                => AddPrivilege((short)p, expire);

            protected override void PackInfo(ByteBuf buf)
                => buf.PutString(_userId);
        }

        // ================================================================
        // ServiceFpa
        // ================================================================
        public class ServiceFpa : Service
        {
            public override short Type => SERVICE_TYPE_FPA;
            protected override void PackInfo(ByteBuf buf) { }
        }

        // ================================================================
        // ServiceChat
        // pack：type | privileges | userId
        // ================================================================
        public class ServiceChat : Service
        {
            public override short Type => SERVICE_TYPE_CHAT;

            private readonly string _userId;

            public ServiceChat(string userId) { _userId = userId; }

            public void AddPrivilegeChat(PrivilegeChat p, int expire)
                => AddPrivilege((short)p, expire);

            protected override void PackInfo(ByteBuf buf)
                => buf.PutString(_userId);
        }

        // ================================================================
        // ServiceApaas
        // pack：type | privileges | roomUuid | userUuid | role
        // ================================================================
        public class ServiceApaas : Service
        {
            public override short Type => SERVICE_TYPE_APAAS;

            private readonly string _roomUuid;
            private readonly string _userUuid;
            private readonly short  _role;

            public ServiceApaas(string roomUuid, string userUuid, short role)
            {
                _roomUuid = roomUuid;
                _userUuid = userUuid;
                _role     = role;
            }

            public void AddPrivilegeApaas(PrivilegeApaas p, int expire)
                => AddPrivilege((short)p, expire);

            protected override void PackInfo(ByteBuf buf)
            {
                buf.PutString(_roomUuid);
                buf.PutString(_userUuid);
                buf.PutShort(_role);
            }
        }
    }

    // ====================================================================
    // ByteBuf —— 小端序字节缓冲区，严格对照 Java ByteBuf 行为
    // ====================================================================
    public class ByteBuf
    {
        private readonly MemoryStream _ms = new MemoryStream();

        // ---- 写方法（全部小端序）----

        public void PutShort(short v)
        {
            _ms.WriteByte((byte)(v));
            _ms.WriteByte((byte)(v >> 8));
        }

        public void PutInt(int v)
        {
            _ms.WriteByte((byte)(v));
            _ms.WriteByte((byte)(v >> 8));
            _ms.WriteByte((byte)(v >> 16));
            _ms.WriteByte((byte)(v >> 24));
        }

        /// <summary>put(byte[]) —— 带 uint16 长度前缀，然后写数据（对应 Java put(byte[])）</summary>
        public void PutBytes(byte[] data)
        {
            PutShort((short)data.Length);
            _ms.Write(data, 0, data.Length);
        }

        /// <summary>put(String) —— 转 UTF-8 后调用 put(byte[])（带长度前缀）</summary>
        public void PutString(string s)
            => PutBytes(Encoding.UTF8.GetBytes(s));

        /// <summary>
        /// buffer.put(byte[]) —— 直接写原始字节，无任何前缀
        /// 对应 Java: bufferContent.buffer.put(buf.asBytes())
        /// </summary>
        public void PutRaw(byte[] data)
            => _ms.Write(data, 0, data.Length);

        public byte[] AsBytes() => _ms.ToArray();
    }
}
