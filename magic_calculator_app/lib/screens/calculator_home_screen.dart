import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:magic_calculator_app/viewmodels/calculator_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CalculatorHomeScreen extends StatelessWidget {
  const CalculatorHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive); //풀스크린

    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge); 풀스크린 해제

    var mySystemTheme =
        SystemUiOverlayStyle.light.copyWith(systemNavigationBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(mySystemTheme);

    var viewmodel = context.watch<CalculatorViewModel>();

    List<String> imageList = [];
    makeImageList(imageList);
    imageList.shuffle();

    List<String> badges = makeBadgeList(viewmodel);

    StatelessWidget makeBadge(int index) {
      StatelessWidget badge = Container();
      List<int> markPostion = [2, 5, 7, 8, 11, 12, 14, 17];
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

    StatelessWidget makeGridItem(int index) {
      return Container(
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                await launchIconAction(imageList[index]);
              },
              child: Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        imageList[index],
                        height: 70,
                      ),
                    ),
                  ),
                  makeBadge(index),
                ],
              ),
            ),
          ],
        ),
      );
    }

    //근데 둘다 필요 없는거 같다.
    return Scaffold(
      body: Container(
          color: Colors.lightBlueAccent,
          padding: EdgeInsets.all(20),
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
              itemCount: 23,
              itemBuilder: (BuildContext context, int index) {
                return makeGridItem(index);
              })),
    );
  }

  Future<void> launchIconAction(String imageName) async {
    if (imageName.contains("Phone")) {
      Uri sms = Uri.parse('tel:');
      await launchUrl(sms);
    } else if (imageName.contains("Messages")) {
      Uri sms = Uri.parse('sms:');
      await launchUrl(sms);
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

  List<String> makeBadgeList(CalculatorViewModel viewmodel) {
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

    List<String> badges = [];

    for (int i = 0; i < 8; i++) {
      String numberStr = fullNumberStr.substring(i, i + 1);
      if (numberStr == "0") {
        badges.add("");
      } else {
        badges.add(numberStr);
      }
    }
    return badges;
  }
}
