import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SwitchWidget extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const SwitchWidget({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(5, 0),
      child: Transform.scale(
        scale: 0.8,
        child: CupertinoSwitch(
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: Colors.white,
          thumbColor: Colors.white,
          activeTrackColor: Color(0xff43CF7C),
          trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.selected)) {
              return Color(0xff43CF7C);
            }
            return Color(0xffD7DBDE);
          }),
          trackOutlineWidth: WidgetStateProperty.resolveWith<double?>((
            Set<WidgetState> states,
          ) {
            return 1.5;
          }),
          value: value,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
