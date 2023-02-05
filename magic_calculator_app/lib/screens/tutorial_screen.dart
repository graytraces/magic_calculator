import 'package:flutter/material.dart';
import 'package:magic_calculator_app/screens/video_player.dart';
import 'package:provider/provider.dart';

import '../app_stat_provider.dart';

class TutorialScreen extends StatelessWidget {
  const TutorialScreen({Key? key}) : super(key: key);

  _getSubTitleTextStyle() {
    return const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );
  }

  _getContentTextStyle() {
    return const TextStyle(fontSize: 14);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('앱에 대하여')),
        body: SingleChildScrollView(
            child: Provider.of<AppStatProvider>(context, listen: false).getIsAuthorized()
                ? drawAuthTutorial()
                : drawNonAuthTutorial()
        ));
  }

  drawNonAuthTutorial() {
    return Column(
      children: const [
        Padding(padding: EdgeInsets.fromLTRB(16, 16, 8, 8),
          child: SizedBox(
            width: double.infinity,
            child: Text("테스트"),
          ),)
      ],
    );
  }

  drawAuthTutorial() {
    return Column(
      children: [
        //VideoPlayerScreen(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              '1) 기본 동작',
              style: _getSubTitleTextStyle(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24,                                               2, 8, 2),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              '- 4자리 이상의 숫자가 입력되면 경우의 수를 계산하여 화면에 마킹을 표시합니다.',
              style: _getContentTextStyle(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 2, 8, 2),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              '- 클립 아이콘을 2번 터치하면 답을 입력할 수 있는 계산메뉴가 보여집니다.',
              style: _getContentTextStyle(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 2, 8, 2),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              '- 클립 아이콘을 2번 더 터치하면 계산메뉴가 사라집니다',
              style: _getContentTextStyle(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 2, 8, 2),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              '- 숫자 입력시 터치 카운트가 초기화됩니다',
              style: _getContentTextStyle(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 2, 8, 2),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              '- 한자리를 직접 묻는 질문은 설정에서 끌 수 있습니다.',
              style: _getContentTextStyle(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 2, 8, 2),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              '- 추천질문은 최대 4개입니다.',
              style: _getContentTextStyle(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              '2) 표시되는 마킹은 다음과 같습니다.',
              style: _getSubTitleTextStyle(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 2, 8, 2),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              '- 제목 옆에 (숫자) 가 표시되면 해당 자릿수가 무엇인지 물어야함을 의미합니다.',
              style: _getContentTextStyle(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 2, 8, 2),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              '제목(8) = 8번째 자리가 뭔가요?',
              style: _getContentTextStyle(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 2, 8, 2),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              '- 북마크 버튼이 채워지면 앞자리가 큰지 뒷자리가 큰지 물어야 합니다.',
              style: _getContentTextStyle(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(36, 2, 8, 2),
          child: SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Icon(Icons.bookmark_border),
                  Text('->'),
                  Icon(Icons.bookmark),
                ],
              )),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 2, 8, 2),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              '- 키보드 위의 아이콘 중 좌측 붓 아이콘 옆 숫자는 홀짝을 물어야 하는 자릿수를 표시합니다.',
              style: _getContentTextStyle(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(36, 2, 8, 2),
          child: SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Icon(Icons.brush),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text('14 : 1번째, 4번째 자리가 홀수?'),
                  ),
                ],
              )),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 2, 8, 2),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              '- 키보드 위의 아이콘 중 가운데 목차아이콘 옆 숫자는 4보다 큰지를 물어야 하는 자릿수를 표시합니다.',
              style: _getContentTextStyle(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(36, 2, 8, 2),
          child: SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Icon(Icons.format_line_spacing),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text('5 : 5번째 숫자가 4보다 큼?'),
                  ),
                ],
              )),
        ),
      ],
    );
  }
}
