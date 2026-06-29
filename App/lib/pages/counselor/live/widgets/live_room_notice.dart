import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/models/live/live_connect_record.dart';
import 'package:freud/widgets/component/image_view.dart';
import 'package:freud/widgets/gradient_button.dart';

class LiveRoomNotice extends StatefulWidget {
  final LiveRoomNoticeController? controller;

  const LiveRoomNotice({super.key, this.controller});

  @override
  State<LiveRoomNotice> createState() => _LiveRoomNoticeState();
}

class _LiveRoomNoticeState extends State<LiveRoomNotice> {
  double _top = -150;
  bool _show = true;

  bool _btnIgnore = true;
  String? _btnIgnoreText;
  Function? _onIgnore;
  bool _btnCancel = true;
  String? _btnCancelText;
  Function? _onCancel;
  bool _btnConfirm = true;
  String? _btnConfirmText;
  Function? _onConfirm;
  LiveConnectRecord? _record;

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    widget.controller?.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    if (widget.controller?._show == true) {
      if (_show == true) {
        setState(() {
          _top = -150;
          _show = false;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showNotice();
        });
      } else {
        showNotice();
      }
    } else {
      hideNotice();
    }
  }

  void showNotice() async {
    _btnIgnore = widget.controller?._btnIgnore ?? true;
    _btnCancel = widget.controller?._btnCancel ?? true;
    _btnConfirm = widget.controller?._btnConfirm ?? true;
    _btnIgnoreText = widget.controller?._btnIgnoreText;
    _btnCancelText = widget.controller?._btnCancelText;
    _btnConfirmText = widget.controller?._btnConfirmText;
    _onIgnore = widget.controller?._onIgnore;
    _onCancel = widget.controller?._onCancel;
    _onConfirm = widget.controller?._onConfirm;
    _record = widget.controller?._record;
    // 播放提示音
    if (widget.controller?._sound ?? true) {
      await _audioPlayer.stop();
      _audioPlayer.play(AssetSource('other/live_notice.mp3'), volume: 0.01);
    }

    setState(() {
      _show = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _top = 100;
      });
    });
  }

  void hideNotice() {
    setState(() {
      _top = -150;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_show != true) {
      return SizedBox.shrink();
    }
    return AnimatedPositioned(
      left: AppConst.PAGE_PADDING,
      right: AppConst.PAGE_PADDING,
      top: _top,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutBack,
      onEnd: () {
        if (_top < 0) {
          setState(() {
            _show = false;
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          spacing: 10,
          children: [
            Row(
              spacing: 10,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey.withAlpha(100),
                  foregroundImage: ImageView.provider(
                    _record?.user?.headimg ?? '',
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _record?.user?.nickname ?? '',
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _record?.itype == 1 ? '私密连麦申请' : '普通连麦申请',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              spacing: 10,
              children: [
                const Spacer(),
                if (_btnIgnore)
                  SizedBox(
                    height: 32,
                    child: OutlinedButton(
                      onPressed: () {
                        hideNotice();
                        _onIgnore?.call();
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Color(0xffF5F7F9),
                        foregroundColor: Colors.black,
                        side: BorderSide.none,
                      ),
                      child: Text(
                        _btnIgnoreText ?? '忽略',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                if (_btnCancel)
                  SizedBox(
                    height: 32,
                    child: OutlinedButton(
                      onPressed: () {
                        _onCancel?.call();
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Color(0xffF5F7F9),
                        foregroundColor: Colors.black,
                        side: BorderSide.none,
                      ),
                      child: Text(
                        _btnCancelText ?? '拒绝',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                if (_btnConfirm)
                  GradientButton(
                    onPressed: () {
                      _onConfirm?.call();
                    },
                    height: 32,
                    textStyle: TextStyle(fontSize: 12),
                    child: Text(_btnConfirmText ?? '同意'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LiveRoomNoticeController extends ChangeNotifier {
  LiveConnectRecord? _record;
  bool _show = false;

  bool _btnIgnore = true;
  String? _btnIgnoreText;
  Function? _onIgnore;
  bool _btnCancel = true;
  String? _btnCancelText;
  Function? _onCancel;
  bool _btnConfirm = true;
  String? _btnConfirmText;
  Function? _onConfirm;

  bool _sound = true;

  void show({
    bool btnIgnore = true,
    String? btnIgnoreText,
    Function? onIgnore,
    bool btnCancel = true,
    String? btnCancelText,
    Function? onCancel,
    bool btnConfirm = true,
    String? btnConfirmText,
    Function? onConfirm,
    bool sound = true,
    required LiveConnectRecord record,
  }) {
    _show = true;
    _btnIgnore = btnIgnore;
    _btnIgnoreText = btnIgnoreText;
    _onIgnore = onIgnore;
    _btnCancel = btnCancel;
    _btnCancelText = btnCancelText;
    _onCancel = onCancel;
    _btnConfirm = btnConfirm;
    _btnConfirmText = btnConfirmText;
    _onConfirm = onConfirm;
    _sound = sound;
    _record = record;
    notifyListeners();
  }

  void hide() {
    _show = false;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
