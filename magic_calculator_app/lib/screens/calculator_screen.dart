import 'package:flutter/material.dart';
import 'dart:io';
import 'package:magic_calculator_app/screens/calculator_home_screen.dart';
import 'package:magic_calculator_app/widgets/header_display.dart';
import 'package:magic_calculator_app/widgets/input_pad.dart';

const kSidePadding = 20.0;

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //var mySystemTheme =
    //SystemUiOverlayStyle.light.copyWith(systemNavigationBarColor: Colors.transparent);
    //SystemChrome.setSystemUIOverlayStyle(mySystemTheme);

//     // 화면 로테이션이 없는 풀스크린 앱
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
//
// // 화면 로테이션이 가능한 풀스크린 앱
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
//
// // 상단바만 보이기 (하단 네비게이션바 없애기)
//     SystemChrome.setEnabledSystemUIMode(
//       SystemUiMode.manual,
//       overlays: [
//         SystemUiOverlay.top,
//       ],
//     );
//
// // 하단바만 보이기 (상단 상태바 없애기)
//     SystemChrome.setEnabledSystemUIMode(
//       SystemUiMode.manual,
//       overlays: [
//         SystemUiOverlay.bottom,
//       ],
//     );
//
// // 풀스크린 해제
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    return Scaffold(
      body: SafeArea(
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSidePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: HeaderDisplay()),
          InputPad(),
          SizedBox(
            height: kSidePadding * 3,
            child: GestureDetector(onTap: () {
              if (!Platform.isAndroid) {
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CalculatorHomeScreen()),
              );
              return;
            }, onVerticalDragUpdate: (details) {
              if (!Platform.isIOS) {
                return;
              }
              double sensitivity = 1.0;
              if (details.delta.dy < -sensitivity) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CalculatorHomeScreen()),
                );
                return;
                //Up Swipe
              }
            }),
          ),
        ],
      ),
    );
  }
}
