import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalculatorHomeScreen extends StatelessWidget {
  const CalculatorHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive); //풀스크린

    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge); 풀스크린 해제

    //근데 둘다 필요 없는거 같다.
    return Container(
        color: Colors.grey,
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
                color: Colors.lightGreen,
                child: Text(' Item : 1'),
              ),
              Container(
                color: Colors.lightGreen,
                child: Text(' Item : 2'),
              ),
              Container(
                color: Colors.lightGreen,
                child: Text(' Item : 3'),
              ),
              Container(
                color: Colors.lightGreen,
                child: Text(' Item : 4'),
              ),
              Container(
                color: Colors.lightGreen,
                child: Text(' Item : 5'),
              ),
              Container(
                color: Colors.lightGreen,
                child: Text(' Item : 6'),
              ),
              Container(
                color: Colors.lightGreen,
                child: Text(' Item : 7'),
              ),
              Container(
                color: Colors.lightGreen,
                child: Text(' Item : 8'),
              ),
              Container(
                color: Colors.lightGreen,
                child: Text(' Item : 1'),
              ),
              Container(
                color: Colors.lightGreen,
                child: Text(' Item : 2'),
              ),
              Container(
                color: Colors.lightGreen,
                child: Text(' Item : 3'),
              ),
              Container(
                color: Colors.lightGreen,
                child: Text(' Item : 4'),
              ),
              Container(
                color: Colors.lightGreen,
                child: Text(' Item : 5'),
              ),
              Container(
                color: Colors.lightGreen,
                child: Text(' Item : 6'),
              ),
              Container(
                color: Colors.lightGreen,
                child: Text(' Item : 7'),
              ),
              Container(
                color: Colors.lightGreen,
                child: Text(' Item : 8'),
              ),
              Container(
                color: Colors.lightGreen,
                child: Text(' Item : 1'),
              ),
              Container(
                color: Colors.lightGreen,
                child: Text(' Item : 2'),
              ),
              Container(
                color: Colors.lightGreen,
                child: Text(' Item : 3'),
              ),
              Container(
                color: Colors.lightGreen,
                child: Text(' Item : 4'),
              ),
              Container(
                color: Colors.lightGreen,
                child: Text(' Item : 5'),
              ),
              Container(
                color: Colors.lightGreen,
                child: Text(' Item : 6'),
              ),
              Container(
                color: Colors.lightGreen,
                child: Text(' Item : 7'),
              ),
              Container(
                color: Colors.lightGreen,
                child: Text(''),
              ),
            ]));
  }
}
