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
                                "assets/images/Amazon.png",
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
                                "assets/images/Discord.png",
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
                                "assets/images/Fitness.png",
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
                                "assets/images/Gmail.png",
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
                                "assets/images/Google-Chrome.png",
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
                                "assets/images/Google-Maps.png",
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
                                "assets/images/Google.png",
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
                                "assets/images/Instagram.png",
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
                                "assets/images/LinkedIn.png",
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
                                "assets/images/Lyft.png",
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
                                "assets/images/Mail.png",
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
                                  "assets/images/Messages.png",
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
                                "assets/images/Messenger.png",
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
                                "assets/images/Netflix.png",
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
                                "assets/images/Settings.png",
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
                                "assets/images/Spotify.png",
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
                                "assets/images/Starbucks.png",
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
                                "assets/images/Tinder.png",
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
                                "assets/images/Weather.png",
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
                                "assets/images/YouTube.png",
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
                                "assets/images/Zoom.png",
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
                                "assets/images/Camera.png",
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
                                  "assets/images/Phone.png",
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
}
