import 'package:flutter/material.dart';

class AboveKeyboard extends StatelessWidget {
  const AboveKeyboard(
      {Key? key, required this.redQuestionNumbers, required this.blueQuestionNumbers})
      : super(key: key);
  final String redQuestionNumbers;
  final String blueQuestionNumbers;

  final double normalButtonWidth = 45;
  final double numberButtonWidth = 60;

  _getAboveKeyboardStyle() {
    return TextButton.styleFrom(
      foregroundColor: Colors.white
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(
            width:normalButtonWidth,
            child: TextButton(
              style: _getAboveKeyboardStyle(),
              onPressed: () {},
              child: (Icon(Icons.brush)),
            ),
          ),
          SizedBox(
              width: numberButtonWidth,
              child: TextButton(
                  style: _getAboveKeyboardStyle(),
                  onPressed: () {},
                  child: Text(redQuestionNumbers))),
          SizedBox(
            width:normalButtonWidth,
            child: TextButton(
              style: _getAboveKeyboardStyle(),
              onPressed: () {},
              child: (Icon(Icons.check_box_outlined)),
            ),
          ),
          SizedBox(
            width:normalButtonWidth,
            child: TextButton(
              style: _getAboveKeyboardStyle(),
              onPressed: () {},
              child: (Icon(Icons.format_color_text)),
            ),
          ),
          SizedBox(
            width:normalButtonWidth,
            child: TextButton(
              style: _getAboveKeyboardStyle(),
              onPressed: () {},
              child: (Icon(Icons.format_line_spacing)),
            ),
          ),
          SizedBox(
            width: numberButtonWidth,
            child: TextButton(
                style: _getAboveKeyboardStyle(),
                onPressed: () {},
                child: Text(blueQuestionNumbers)),
          ),
          SizedBox(
            width:normalButtonWidth,
            child: TextButton(
              style: _getAboveKeyboardStyle(),
              onPressed: () {},
              child: (Icon(Icons.undo)),
            ),
          ),
          SizedBox(
            width:normalButtonWidth,
            child: TextButton(
              style: _getAboveKeyboardStyle(),
              onPressed: () {},
              child: (Icon(Icons.redo)),
            ),
          ),
        ],
      ),
    );
  }
}
