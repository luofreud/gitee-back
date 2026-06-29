class LiveRoomRequest {
  final int? id;
  final int? uid;
  final int? tid;
  final int? roomid;
  final String? img;
  final String? bgimg;
  final int? istop;
  final int? ishot;
  final int? rtype;
  final int? level;
  final String? major;
  final int? lookrum;
  final String? title;
  final int? rnum;
  final int? state;
  final String? createtime;
  final String? tags;
  final String? content;
  final String? overtime;
  final int? livetime;

  LiveRoomRequest({
    this.id,
    this.uid,
    this.tid,
    this.roomid,
    this.img,
    this.bgimg,
    this.istop,
    this.ishot,
    this.rtype,
    this.level,
    this.major,
    this.lookrum,
    this.title,
    this.rnum,
    this.state,
    this.createtime,
    this.tags,
    this.content,
    this.overtime,
    this.livetime,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.id != null) data['id'] = this.id;
    if (this.uid != null) data['uid'] = this.uid;
    if (this.tid != null) data['tid'] = this.tid;
    if (this.roomid != null) data['roomid'] = this.roomid;
    if (this.img != null) data['img'] = this.img;
    if (this.bgimg != null) data['bgimg'] = this.bgimg;
    if (this.istop != null) data['istop'] = this.istop;
    if (this.ishot != null) data['ishot'] = this.ishot;
    if (this.rtype != null) data['rtype'] = this.rtype;
    if (this.level != null) data['level'] = this.level;
    if (this.major != null) data['major'] = this.major;
    if (this.lookrum != null) data['lookrum'] = this.lookrum;
    if (this.title != null) data['title'] = this.title;
    if (this.rnum != null) data['rnum'] = this.rnum;
    if (this.state != null) data['state'] = this.state;
    if (this.createtime != null) data['createtime'] = this.createtime;
    if (this.tags != null) data['tags'] = this.tags;
    if (this.content != null) data['content'] = this.content;
    if (this.overtime != null) data['overtime'] = this.overtime;
    if (this.livetime != null) data['livetime'] = this.livetime;
    return data;
  }
}