import 'package:flutter/material.dart';

class AboveKeyboard extends StatelessWidget {
  const AboveKeyboard( {Key? key, required this.redQuestionNumbers, required this.blueQuestionNumbers}) : super(key: key);
  final String redQuestionNumbers;
  final String blueQuestionNumbers;

  _getAboveKeyboardStyle() {
    return TextButton.styleFrom(
      foregroundColor: Colors.black,
      backgroundColor: Colors.white,
      minimumSize: Size(40, 40),
      maximumSize: Size(40, 40),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          TextButton(
            style: _getAboveKeyboardStyle(),
            onPressed: () {},
            child: (Icon(Icons.color_lens)),
          ),
          TextButton(style: _getAboveKeyboardStyle(), onPressed: () {}, child: Text(redQuestionNumbers)),
          TextButton(
            style: _getAboveKeyboardStyle(),
            onPressed: () {},
            child: (Icon(Icons.format_bold)),
          ),
          TextButton(
            style: _getAboveKeyboardStyle(),
            onPressed: () {},
            child: (Icon(Icons.format_italic)),
          ),
          TextButton(
            style: _getAboveKeyboardStyle(),
            onPressed: () {},
            child: (Icon(Icons.list_rounded)),
          ),
          TextButton(style: _getAboveKeyboardStyle(), onPressed: () {}, child: Text(blueQuestionNumbers)),
          TextButton(
            style: _getAboveKeyboardStyle(),
            onPressed: () {},
            child: (Icon(Icons.undo)),
          ),
          TextButton(
            style: _getAboveKeyboardStyle(),
            onPressed: () {},
            child: (Icon(Icons.redo)),
          ),
          TextButton(
            style: _getAboveKeyboardStyle(),
            onPressed: () {},
            child: (Icon(Icons.redo)),
          ),
        ],
      ),
    );
  }
}
