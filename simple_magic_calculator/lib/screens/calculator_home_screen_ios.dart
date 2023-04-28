import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_magic_calculator/viewmodels/calculator_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CalculatorHomeScreenIos extends StatelessWidget {
  const CalculatorHomeScreenIos({Key? key}) : super(key: key);
  final double _iconSize = 60;

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive); //풀스크린

    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge); 풀스크린 해제

    List<int> markPostion = [Random().nextInt(8), Random().nextInt(8) + 10];

    CalculatorViewModel viewmodel = context.watch<CalculatorViewModel>();

    List<String> imageList = [];
    makeIosImageList(imageList);
    List<String> textList = [];
    makeIosTextList(textList);
    //imageList.shuffle();

    List<String> badges = makeBadgeList(viewmodel);

    StatelessWidget makeBadge(int index) {
      StatelessWidget badge = Container();

      if (markPostion.contains(index)) {
        badge = Container(
          width: 24,
          height: 24,
          decoration: new BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          child: Center(child: Text(badges[markPostion.indexOf(index)])),
        );
      }

      return badge;
    }

    StatelessWidget makeGridItem(BuildContext context, int index, CalculatorViewModel viewmodel) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                await launchIconAction(context, imageList[index], viewmodel);
              },
              child: Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.asset(
                        imageList[index],
                        fit: BoxFit.fill,
                        height: _iconSize,
                      ),
                    ),
                  ),
                  makeBadge(index),
                ],
              ),
            ),
            Text(textList[index])
          ],
        ),
      );
    }

    //근데 둘다 필요 없는거 같다.
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: SafeArea(
          child: Column(
            children: [
              Flexible(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          //1 개의 행에 보여줄 item 개수
                          childAspectRatio: 1 / 1.2,
                          //item 의 가로 1, 세로 2 의 비율
                          mainAxisSpacing: 10,
                          //수평 Padding
                          crossAxisSpacing: 10,
                          //수직 Padding
                        ),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 19,
                        itemBuilder: (BuildContext context, int index) {
                          return makeGridItem(context, index, viewmodel);
                        }),
                  )),
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        color: Color(0xFFFFFFFF).withOpacity(0.5),
                        child: SizedBox(
                          width: double.infinity,
                          height: 90,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            String fullNumberStr = getFullNumberStr(viewmodel);
                            Uri call = Uri.parse('tel:010$fullNumberStr');
                            await launchUrl(call);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.asset(
                              'assets/images/ios/ios_call.png',
                              fit: BoxFit.fill,
                              height: _iconSize,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            String fullNumberStr = getFullNumberStr(viewmodel);
                            Uri sms = Uri.parse('sms:010$fullNumberStr');
                            await launchUrl(sms);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.asset(
                              'assets/images/ios/ios_message.png',
                              fit: BoxFit.fill,
                              height: _iconSize,
                            ),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.asset(
                            'assets/images/ios/safari-2021-12-07.png',
                            fit: BoxFit.fill,
                            height: _iconSize,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> launchIconAction(
      BuildContext context, String imageName, CalculatorViewModel viewmodel) async {
    String fullNumberStr = getFullNumberStr(viewmodel);

    if (imageName.contains("Phone")) {
      Uri sms = Uri.parse('tel:010$fullNumberStr');
      await launchUrl(sms);
    } else if (imageName.contains("Messages")) {
      Uri sms = Uri.parse('sms:010$fullNumberStr');
      await launchUrl(sms);
    } else {
      viewmodel.addPrevCounter();
      if (viewmodel.prevCounter == 5) {
        Navigator.pop(context);
        viewmodel.clearPrevCounter();
      }
    }
  }

  void makeImageList(List<String> imageList) {
    imageList.add("assets/images/Amazon.png");
    imageList.add("assets/images/Discord.png");
    imageList.add("assets/images/Fitness.png");
    imageList.add("assets/images/Gmail.png");
    imageList.add("assets/images/Google-Chrome.png");
    imageList.add("assets/images/Google-Maps.png");
    imageList.add("assets/images/Google.png");
    imageList.add("assets/images/Instagram.png");
    imageList.add("assets/images/LinkedIn.png");
    imageList.add("assets/images/Lyft.png");
    imageList.add("assets/images/Mail.png");
    imageList.add("assets/images/Messages.png");
    imageList.add("assets/images/Messenger.png");
    imageList.add("assets/images/Netflix.png");
    imageList.add("assets/images/Settings.png");
    imageList.add("assets/images/Spotify.png");
    imageList.add("assets/images/Starbucks.png");
    imageList.add("assets/images/Tinder.png");
    imageList.add("assets/images/Weather.png");
    imageList.add("assets/images/YouTube.png");
    imageList.add("assets/images/Zoom.png");
    imageList.add("assets/images/Camera.png");
    imageList.add("assets/images/Phone.png");
  }

  void makeIosImageList(List<String> imageList) {
    imageList.add("assets/images/ios/amazon-shopping-2021-03-02.png");
    imageList.add("assets/images/ios/lyft-2016-02-02.png");
    imageList.add("assets/images/ios/netflix-2018-11-01.png");
    imageList.add("assets/images/ios/activity-2017-09-26.png");
    imageList.add("assets/images/ios/apple-maps-2021-12-07.png");
    imageList.add("assets/images/ios/apple-music-2020-09-25.png");
    imageList.add("assets/images/ios/apple-podcasts-2022-01-30.png");
    imageList.add("assets/images/ios/chrome-web-browser-by-google-2016-01-25.png");
    imageList.add("assets/images/ios/facebook-2019-05-21.png");
    imageList.add("assets/images/ios/google-2015-10-22.png");
    imageList.add("assets/images/ios/instagram-2022-05-19.png");
    imageList.add("assets/images/ios/messenger-2020-11-17.png");
    imageList.add("assets/images/ios/microsoft-excel-2019-05-31.png");
    imageList.add("assets/images/ios/microsoft-office-2020-02-26.png");
    imageList.add("assets/images/ios/microsoft-teams-2019-05-31.png");
    imageList.add("assets/images/ios/microsoft-word-2019-05-31.png");
    imageList.add("assets/images/ios/notes-2017-09-26.png");
    imageList.add("assets/images/ios/photos-2022-09-26.png");
    imageList.add("assets/images/ios/reminders-2022-09-26.png");
    imageList.add("assets/images/ios/safari-2021-12-07.png");
    imageList.add("assets/images/ios/telegram-messenger-2019-01-15.png");
    imageList.add("assets/images/ios/twitter-2013-10-08.png");
    imageList.add("assets/images/ios/weather-2021-12-07.png");
  }

  List<String> makeBadgeList(CalculatorViewModel viewmodel) {
    String fullNumberStr = getFullNumberStr(viewmodel);

    String last2Chars = fullNumberStr.substring(fullNumberStr.length - 2); //끝에 2개만 띄우게 수정

    List<String> badges = [];

    for (int i = 0; i < 2; i++) {
      String numberStr = last2Chars.substring(i, i + 1);
      if (numberStr == "0") {
        badges.add("");
      } else {
        badges.add(numberStr);
      }
    }
    return badges;
  }

  String getFullNumberStr(CalculatorViewModel viewmodel) {
    List<String> splitResult = viewmodel.splitResult;

    if (splitResult.isEmpty) {
      splitResult = ["0", "0"];
    }

    String firstNumberStr = splitResult[0];
    String secondNumberStr = splitResult[1];

    int maxIter = firstNumberStr.length;

    for (int i = 0; i < 4 - maxIter; i++) {
      firstNumberStr = "0" + firstNumberStr;
    }

    maxIter = secondNumberStr.length;
    for (int i = 0; i < 4 - maxIter; i++) {
      secondNumberStr = "0" + secondNumberStr;
    }

    String fullNumberStr = firstNumberStr + secondNumberStr;
    return fullNumberStr;
  }

  void makeIosTextList(List<String> textList) {
    textList.add('Amazon');
    textList.add('리프트');
    textList.add('넷플릭스');
    textList.add('활동');
    textList.add('지도');
    textList.add('음악');
    textList.add('팟캐스트');
    textList.add('Chrome');
    textList.add('Facebook');
    textList.add('Google');
    textList.add('Instagram');
    textList.add('Messenger');
    textList.add('Excel');
    textList.add('Office');
    textList.add('Teams');
    textList.add('Word');
    textList.add('메모');
    textList.add('사진');
    textList.add('미리 알림');
    textList.add('Safari');
    textList.add('텔레그램');
    textList.add('Twitter');
    textList.add('날씨');
  }
}
