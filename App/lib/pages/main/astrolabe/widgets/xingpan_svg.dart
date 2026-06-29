import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class XingpanSvgController {
  String _mode;
  VoidCallback? _listener;

  XingpanSvgController({String mode = 'cn'}) : _mode = mode;

  String get mode => _mode;

  String get fontFamily => _mode == 'en' ? 'web_ixingpan' : 'web_ixingpan_cn';

  int get planetFontSize => _mode == 'en' ? 24 : 16;

  int get signFontSize => _mode == 'en' ? 34 : 28;

  void setMode(String m) {
    if (m != _mode && (m == 'cn' || m == 'en')) {
      _mode = m;
      _listener?.call();
    }
  }

  void addListener(VoidCallback cb) => _listener = cb;

  void removeListener() => _listener = null;
}

class XingpanSvg extends StatefulWidget {
  final String? svgString;
  final double? width;
  final double? height;
  final String? styles;
  final XingpanSvgController? controller;

  const XingpanSvg({
    super.key,
    this.svgString,
    this.width,
    this.height,
    this.styles,
    this.controller,
  });

  @override
  State<XingpanSvg> createState() => _XingpanSvgState();
}

class _XingpanSvgState extends State<XingpanSvg> {
  String? _fontCss;
  late final WebViewController _webCtrl;

  @override
  void initState() {
    super.initState();
    _webCtrl = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (_) => NavigationDecision.prevent,
          onPageFinished: (_) => _reapplyFont(),
        ),
      );
    widget.controller?.addListener(_onModeChanged);
    _loadHtml();
    _loadFonts();
  }

  @override
  void didUpdateWidget(XingpanSvg oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.svgString != widget.svgString) {
      _loadHtml();
    }
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener();
      widget.controller?.addListener(_onModeChanged);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener();
    super.dispose();
  }

  void _onModeChanged() {
    _reapplyFont();
  }

  void _reapplyFont() {
    final c = widget.controller;
    if (c == null) {
      _applyFont('web_ixingpan_cn', 16, 28);
      return;
    }
    ;
    _applyFont(c.fontFamily, c.planetFontSize, c.signFontSize);
  }

  void _applyFont(String fontName, int planetSize, int signSize) {
    _webCtrl.runJavaScript('''
      document.querySelectorAll('.text_font').forEach(function(el) {
        el.style.fontFamily = '$fontName';
      });
      document.querySelectorAll('.planet_font').forEach(function(el) {
        el.style.fontSize = '${planetSize}px';
        el.style.fontFamily = '$fontName';
      });
      document.querySelectorAll('.sign_font').forEach(function(el) {
        el.style.fontFamily = '$fontName';
        el.style.fontSize = '${signSize}px';
      });
    ''');
  }

  Future<void> _loadFonts() async {
    try {
      final f1 = await rootBundle.load('assets/fonts/iconfont/ixingpan.woff');
      final f2 = await rootBundle.load('assets/fonts/iconfont/ixingpancn.woff');
      _fontCss =
          '@font-face{font-family:web_ixingpan;src:url(data:font/woff;base64,${base64Encode(f1.buffer.asUint8List())})}'
          '@font-face{font-family:web_ixingpan_cn;src:url(data:font/woff;base64,${base64Encode(f2.buffer.asUint8List())})}';
      if (mounted) _loadHtml();
    } catch (_) {}
  }

  void _loadHtml() {
    _webCtrl.loadHtmlString(_buildHtml());
  }

  String _buildHtml() {
    final svg = widget.svgString ?? '';
    final css = widget.styles ?? '';

    final m = widget.controller?.mode ?? "cn";
    final fontFamily = m == 'en' ? 'web_ixingpan' : 'web_ixingpan_cn';
    final planetSize = m == 'en' ? 24 : 16;
    final signSize = m == 'en' ? 34 : 28;
    final modeCss =
        '.text_font{font-family:$fontFamily}.planet_font{font-size:${planetSize}px}.sign_font{font-size:${signSize}px}';

    return '''
    <!DOCTYPE html>
    <html>
    <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,user-scalable=no">
    <style>
    ${_fontCss ?? ''}
    *{margin:0;padding:0;box-sizing:border-box}
    html,body{width:100%;height:100%;overflow:hidden;background:transparent}
    body{display:flex;align-items:center;justify-content:center}
    svg{width:100%;height:100%;display:block}
    #chartbody #zodiac{fill:#f8f8c1;stroke:#b58c00;stroke-width:2}#chartbody #zodiac_min{fill:#EFF;stroke:#b58c00;stroke-width:2}#chartbody #hcircle{fill:white;stroke:#2279ab;stroke-width:1}#chartbody #hcircle_min{fill:white;stroke:#2279ab;stroke-width:1}#chartbody .origin{stroke:#505050;stroke-width:0.8}#chartbody .zodiac_grid{stroke:#b58d00;stroke-width:2}#chartbody .origin:hover{fill:#CCF}#chartbody .house_grid{stroke:#6699CC;fill:none;stroke-width:0.5;stroke-dasharray:2,1}#chartbody .house_dark_grid{stroke:#2279ab;stroke-width:1}#chartbody .house_dark_grid_attribute{stroke:#2279ab;stroke-width:2}#chartbody .house_id{font-size:16px;stroke-width:1}#chartbody .house_id:hover{line-height:1;font-size:20px}.longitude__font{font-size:10px;stroke:none;fill:#000}.longitude__font{font-size:10px;stroke:none;fill:#000}.house_1,.house_5,.house_9{fill:red;color:red}.house_2,.house_6,.house_10{fill:#CC9933;color:#CC9933}.house_3,.house_7,.house_11{fill:#006633;color:#006633}.house_4,.house_8,.house_12{fill:#0A0AFF;color:#0A0AFF}.sign_font{font-size:26px}.sign_font:hover{font-size:28px}.sign_Aries,.sign_Leo,.sign_Sagittarius{stroke:none;fill:red;color:red}.sign_Taurus,.sign_Virgo,.sign_Capricorn{stroke:none;fill:#CC9933;color:#CC9933}.sign_Gemini,.sign_Libra,.sign_Aquarius{stroke:none;fill:#006633;color:#006633}.sign_Cancer,.sign_Scorpio,.sign_Pisces{stroke:none;fill:#0A0AFF;color:#0A0AFF}.senior_sign_font{font-size:20px !important}.senior_sign_font:hover{font-size:22px !important}.guardian_font{font-size:16px}.guardian_font:hover{font-size:20px}.planet_font{font-size:14px;line-height:1;stroke:none}.planet_font:hover{font-size:16px}.planet_font2{font-size:14px;line-height:1;stroke:none}.planet_font2:hover{font-size:16px}.planets_Sun,.planets_Ascendant,.planets_Jupiter,.planets_Mars{fill:red;color:red;stroke:none}.planets_Moon,.planets_IC,.planets_Neptune,.planets_Pluto{fill:#0A0AFF;color:#0A0AFF;stroke:none}.planets_Saturn,.planets_Venus,.planets_MC{fill:#CC9933;color:#CC9933;stroke:none;font-family:web_ixingpan}.planets_Mercury,.planets_Uranus{fill:#006633;color:#006633;stroke:none}.planets_Mercury font-family{fill:#006633;color:#006633;stroke:none}.planets_empty,.planets_Empty{fill:white;color:black;stroke:none}.aspect{stroke:#999;fill:none;stroke-width:1.2;stroke-dasharray:1,0}.aspect:hover{stroke:#333;stroke-width:2}
    $css
    $modeCss
    </style>
    </head>
    <body>
    $svg
    </body>
    </html>
''';
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.width ?? MediaQuery.of(context).size.width;
    final h = widget.height ?? w;

    return SizedBox(
      width: w,
      height: h,
      child: WebViewWidget(controller: _webCtrl),
    );
  }
}
