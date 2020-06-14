import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class FloatButtonItem{
  final Icon icon;
  final String label;
  final VoidCallback onTap;

  FloatButtonItem({this.icon, this.label, this.onTap});
}

class FloatingButtons extends StatefulWidget {

  final List<FloatButtonItem> actions;

  FloatingButtons({Key key, this.actions}):super(key:key);

  @override
  State<StatefulWidget> createState() => new _FloatingButtons();

}

class _FloatingButtons extends State<FloatingButtons> {

  @override
  Widget build(BuildContext context) {

    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      visible: true,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      shape: CircleBorder(),
      children: widget.actions.map((e) => SpeedDialChild(child: e.icon, label: e.label, onTap: e.onTap)).toList()
    );
  }
}
