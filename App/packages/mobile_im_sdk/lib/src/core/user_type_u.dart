/// 业务消息子类型.
enum UserTypeU {
  privateMessage(0),
  groupMessage(1),
  systemNotification(9);

  final int value;
  const UserTypeU(this.value);
}
