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

    List<String> badges = markBadge(viewmodel);

    //근데 둘다 필요 없는거 같다.
    return Scaffold(
      body: Container(
          color: Colors.lightBlueAccent,
          padding: EdgeInsets.all(20),
          child: GridView.count(
              crossAxisCount: 4,
              //1 개의 행에 보여줄 item 개수
              childAspectRatio: 1 / 1.2,
              //item 의 가로 1, 세로 2 의 비율
              mainAxisSpacing: 10,
              //수평 Padding
              crossAxisSpacing: 10,
              //수직 Padding
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Container(    //1
                  child: Column(
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                imageList[0],
                                height: 70,
                              ),
                            ),
                          ),
                          // Container(
                          //   width: 24,
                          //   height: 24,
                          //   decoration: new BoxDecoration(
                          //     color: Colors.red,
                          //     shape: BoxShape.circle,
                          //   ),
                          //   child: Center(child: Text('10')),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(  //2
                  child: Column(
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                imageList[1],
                                height: 70,
                              ),
                            ),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: new BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(child: Text(badges[0])),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(  //3
                  child: Column(
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                imageList[2],
                                height: 70,
                              ),
                            ),
                          ),
                          // Container(
                          //   width: 24,
                          //   height: 24,
                          //   decoration: new BoxDecoration(
                          //     color: Colors.red,
                          //     shape: BoxShape.circle,
                          //   ),
                          //   child: Center(child: Text('10')),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(  //4
                  child: Column(
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                imageList[3],
                                height: 70,
                              ),
                            ),
                          ),
                          // Container(
                          //   width: 24,
                          //   height: 24,
                          //   decoration: new BoxDecoration(
                          //     color: Colors.red,
                          //     shape: BoxShape.circle,
                          //   ),
                          //   child: Center(child: Text('10')),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(  //5
                  child: Column(
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                imageList[4],
                                height: 70,
                              ),
                            ),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: new BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(child: Text(badges[1])),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(  //6
                  child: Column(
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                imageList[5],
                                height: 70,
                              ),
                            ),
                          ),
                          // Container(
                          //   width: 24,
                          //   height: 24,
                          //   decoration: new BoxDecoration(
                          //     color: Colors.red,
                          //     shape: BoxShape.circle,
                          //   ),
                          //   child: Center(child: Text('10')),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(  //7
                  child: Column(
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                imageList[6],
                                height: 70,
                              ),
                            ),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: new BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(child: Text(badges[2])),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(  //8
                  child: Column(
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                imageList[7],
                                height: 70,
                              ),
                            ),
                          ),
                          // Container(
                          //   width: 24,
                          //   height: 24,
                          //   decoration: new BoxDecoration(
                          //     color: Colors.red,
                          //     shape: BoxShape.circle,
                          //   ),
                          //   child: Center(child: Text('10')),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(  //9
                  child: Column(
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                imageList[8],
                                height: 70,
                              ),
                            ),
                          ),
                          // Container(
                          //   width: 24,
                          //   height: 24,
                          //   decoration: new BoxDecoration(
                          //     color: Colors.red,
                          //     shape: BoxShape.circle,
                          //   ),
                          //   child: Center(child: Text(badges[3])),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(  //10
                  child: Column(
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                imageList[9],
                                height: 70,
                              ),
                            ),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: new BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(child: Text(badges[3])),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(  //11
                  child: Column(
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                imageList[10],
                                height: 70,
                              ),
                            ),
                          ),
                          // Container(
                          //   width: 24,
                          //   height: 24,
                          //   decoration: new BoxDecoration(
                          //     color: Colors.red,
                          //     shape: BoxShape.circle,
                          //   ),
                          //   child: Center(child: Text('10')),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(  //12
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Uri sms = Uri.parse('sms:');
                          await launchUrl(sms);
                        },
                        child: Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  imageList[11],
                                  height: 70,
                                ),
                              ),
                            ),
                            Container(
                              width: 24,
                              height: 24,
                              decoration: new BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Center(child: Text(badges[4])),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(  //13
                  child: Column(
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                imageList[12],
                                height: 70,
                              ),
                            ),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: new BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(child: Text(badges[5])),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(  //14
                  child: Column(
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                imageList[13],
                                height: 70,
                              ),
                            ),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: new BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(child: Text(badges[6])),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(  //15
                  child: Column(
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                imageList[14],
                                height: 70,
                              ),
                            ),
                          ),
                          // Container(
                          //   width: 24,
                          //   height: 24,
                          //   decoration: new BoxDecoration(
                          //     color: Colors.red,
                          //     shape: BoxShape.circle,
                          //   ),
                          //   child: Center(child: Text(badges[6])),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(  //16
                  child: Column(
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                imageList[15],
                                height: 70,
                              ),
                            ),
                          ),
                          // Container(
                          //   width: 24,
                          //   height: 24,
                          //   decoration: new BoxDecoration(
                          //     color: Colors.red,
                          //     shape: BoxShape.circle,
                          //   ),
                          //   child: Center(child: Text('10')),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(  //17
                  child: Column(
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                imageList[16],
                                height: 70,
                              ),
                            ),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: new BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(child: Text(badges[7])),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(  //18
                  child: Column(
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                imageList[17],
                                height: 70,
                              ),
                            ),
                          ),
                          // Container(
                          //   width: 24,
                          //   height: 24,
                          //   decoration: new BoxDecoration(
                          //     color: Colors.red,
                          //     shape: BoxShape.circle,
                          //   ),
                          //   child: Center(child: Text('10')),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(  //19
                  child: Column(
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                imageList[18],
                                height: 70,
                              ),
                            ),
                          ),
                          // Container(
                          //   width: 24,
                          //   height: 24,
                          //   decoration: new BoxDecoration(
                          //     color: Colors.red,
                          //     shape: BoxShape.circle,
                          //   ),
                          //   child: Center(child: Text('10')),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(  //20
                  child: Column(
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                imageList[19],
                                height: 70,
                              ),
                            ),
                          ),
                          // Container(
                          //   width: 24,
                          //   height: 24,
                          //   decoration: new BoxDecoration(
                          //     color: Colors.red,
                          //     shape: BoxShape.circle,
                          //   ),
                          //   child: Center(child: Text('10')),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(  //21
                  child: Column(
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                imageList[20],
                                height: 70,
                              ),
                            ),
                          ),
                          // Container(
                          //   width: 24,
                          //   height: 24,
                          //   decoration: new BoxDecoration(
                          //     color: Colors.red,
                          //     shape: BoxShape.circle,
                          //   ),
                          //   child: Center(child: Text('10')),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(  //22
                  child: Column(
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                imageList[21],
                                height: 70,
                              ),
                            ),
                          ),
                          // Container(
                          //   width: 24,
                          //   height: 24,
                          //   decoration: new BoxDecoration(
                          //     color: Colors.red,
                          //     shape: BoxShape.circle,
                          //   ),
                          //   child: Center(child: Text('10')),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(  //23
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Uri sms = Uri.parse('tel:');
                          await launchUrl(sms);
                        },
                        child: Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  imageList[22],
                                  height: 70,
                                ),
                              ),
                            ),
                            // Container(
                            //   width: 24,
                            //   height: 24,
                            //   decoration: new BoxDecoration(
                            //     color: Colors.red,
                            //     shape: BoxShape.circle,
                            //   ),
                            //   child: Center(child: Text('10')),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ])),
    );
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

  List<String> markBadge(CalculatorViewModel viewmodel) {
    List<String> splitResult = viewmodel.splitResult;

    String firstNumberStr = splitResult[0];
    String secondNumberStr = splitResult[1];

    for (int i = 0; i < 4 - firstNumberStr.length; i++) {
      firstNumberStr = "0" + firstNumberStr;
    }

    for (int i = 0; i < 4 - secondNumberStr.length; i++) {
      secondNumberStr = "0" + secondNumberStr;
    }

    String fullNumberStr = firstNumberStr + secondNumberStr;


    List<String> badges = [];

    for(int i=0; i<8; i++){
      String numberStr = fullNumberStr.substring(i, i+1);
      if(numberStr == "0"){
        badges.add("");
      }else{
        badges.add(numberStr);
      }
    }
    return badges;
  }
}
