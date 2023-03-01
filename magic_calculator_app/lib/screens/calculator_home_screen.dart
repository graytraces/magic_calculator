import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalculatorHomeScreen extends StatelessWidget {
  const CalculatorHomeScreen({Key? key}) : super(key: key);

  _getQuestionExplainTextStyle() {
    return const TextStyle(fontSize: 12, color: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive); //풀스크린

    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge); 풀스크린 해제

    var mySystemTheme =
        SystemUiOverlayStyle.light.copyWith(systemNavigationBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(mySystemTheme);

    //근데 둘다 필요 없는거 같다.
    return Scaffold(
      body: Container(
          color: Colors.lightBlueAccent,
          child: GridView.count(
              crossAxisCount: 4,
              //1 개의 행에 보여줄 item 개수
              childAspectRatio: 1 / 1.2,
              //item 의 가로 1, 세로 2 의 비율
              mainAxisSpacing: 20,
              //수평 Padding
              crossAxisSpacing: 20,
              //수직 Padding
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Container(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                            child: Image.asset(
                              "assets/images/kakao_icon.png",
                              height: 70,
                            ),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: new BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(child: Text('10')),
                          ),
                        ],
                      ),
                      Text(
                        '카카오톡',
                        style: _getQuestionExplainTextStyle(),
                      )
                    ],
                  ),
                ),Container(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                            child: Image.asset(
                              "assets/images/kakao_icon.png",
                              height: 70,
                            ),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: new BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(child: Text('10')),
                          ),
                        ],
                      ),
                      Text(
                        '카카오톡',
                        style: _getQuestionExplainTextStyle(),
                      )
                    ],
                  ),
                ),Container(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                            child: Image.asset(
                              "assets/images/kakao_icon.png",
                              height: 70,
                            ),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: new BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(child: Text('10')),
                          ),
                        ],
                      ),
                      Text(
                        '카카오톡',
                        style: _getQuestionExplainTextStyle(),
                      )
                    ],
                  ),
                ),Container(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                            child: Image.asset(
                              "assets/images/kakao_icon.png",
                              height: 70,
                            ),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: new BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(child: Text('10')),
                          ),
                        ],
                      ),
                      Text(
                        '카카오톡',
                        style: _getQuestionExplainTextStyle(),
                      )
                    ],
                  ),
                ),Container(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                            child: Image.asset(
                              "assets/images/kakao_icon.png",
                              height: 70,
                            ),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: new BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(child: Text('10')),
                          ),
                        ],
                      ),
                      Text(
                        '카카오톡',
                        style: _getQuestionExplainTextStyle(),
                      )
                    ],
                  ),
                ),Container(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                            child: Image.asset(
                              "assets/images/kakao_icon.png",
                              height: 70,
                            ),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: new BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(child: Text('10')),
                          ),
                        ],
                      ),
                      Text(
                        '카카오톡',
                        style: _getQuestionExplainTextStyle(),
                      )
                    ],
                  ),
                ),Container(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                            child: Image.asset(
                              "assets/images/kakao_icon.png",
                              height: 70,
                            ),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: new BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(child: Text('10')),
                          ),
                        ],
                      ),
                      Text(
                        '카카오톡',
                        style: _getQuestionExplainTextStyle(),
                      )
                    ],
                  ),
                ),Container(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                            child: Image.asset(
                              "assets/images/kakao_icon.png",
                              height: 70,
                            ),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: new BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(child: Text('10')),
                          ),
                        ],
                      ),
                      Text(
                        '카카오톡',
                        style: _getQuestionExplainTextStyle(),
                      )
                    ],
                  ),
                ),Container(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                            child: Image.asset(
                              "assets/images/kakao_icon.png",
                              height: 70,
                            ),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: new BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(child: Text('10')),
                          ),
                        ],
                      ),
                      Text(
                        '카카오톡',
                        style: _getQuestionExplainTextStyle(),
                      )
                    ],
                  ),
                ),Container(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                            child: Image.asset(
                              "assets/images/kakao_icon.png",
                              height: 70,
                            ),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: new BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(child: Text('10')),
                          ),
                        ],
                      ),
                      Text(
                        '카카오톡',
                        style: _getQuestionExplainTextStyle(),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                            child: Image.asset(
                              "assets/images/kakao_icon.png",
                              height: 70,
                            ),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: new BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(child: Text('10')),
                          ),
                        ],
                      ),
                      Text(
                        '카카오톡',
                        style: _getQuestionExplainTextStyle(),
                      )
                    ],
                  ),
                ),
              ])),
    );
  }
}
