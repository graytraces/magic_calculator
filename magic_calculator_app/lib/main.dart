import 'package:flutter/material.dart';

import 'database_helper.dart';
import 'key_value_map.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magic Calculator',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Magic Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _magicNumber = TextEditingController();
  String _resultMessage = "";
  String _firstNumberLength = "1";
  String _secondNumberLength = "1";

  var _numberPairList = [];

  final String FIRST_NUMBER_LENGTH = "firstNumberLength";
  final String SECOND_NUMBER_LENGTH = "secondNumberLength";

  @override
  void initState() {
    loadSavedLength();
  }

  @override
  void dispose() {
    super.dispose();
    _magicNumber.dispose();
  }

  //숫자 계산
  void _calculateNumber() {
    _numberPairList = [];

    var inputText = _magicNumber.text;

    if (!isInt(inputText)) {
      setState(() {
        _resultMessage = "정수 숫자를 입력해주세요";
      });
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    var inputNumber = int.parse(inputText);

    int startNumber = 1;
    int endNumber = 9;
    for (int idx = 1; idx < int.parse(_firstNumberLength); idx++) {
      startNumber *= 10;
      endNumber = endNumber * 10 + 9;
    }

    String resultFirstNumber = "";
    String resultSecondNumber = "";

    for (int firstNumber = startNumber;
        firstNumber <= endNumber;
        firstNumber++) {
      if (inputNumber % firstNumber == 0) {
        var secondNumber = (inputNumber / firstNumber).toInt();

        if (firstNumber.toString().length <= int.parse(_firstNumberLength) &&
            secondNumber.toString().length <= int.parse(_firstNumberLength)) {
          resultFirstNumber = firstNumber.toString();
          if (resultFirstNumber.length < int.parse(_firstNumberLength)) {
            for (int idx2 = resultFirstNumber.length;
                idx2 < int.parse(_firstNumberLength);
                idx2++) {
              resultFirstNumber = "0" + resultFirstNumber;
            }
          }

          resultSecondNumber = secondNumber.toString();

          if (resultSecondNumber.length < int.parse(_firstNumberLength)) {
            for (int idx2 = resultSecondNumber.length;
                idx2 < int.parse(_firstNumberLength);
                idx2++) {
              resultSecondNumber = "0" + resultSecondNumber;
            }
          }

          _numberPairList.add([resultFirstNumber, resultSecondNumber]);
          _numberPairList.add([resultSecondNumber, resultFirstNumber]);
        }
      }
    }
    
    if(_numberPairList.isEmpty){
      setState(() {
        _resultMessage = "계산결과값이 없습니다";
      });
    }
  }

  //숫자인지 검사
  bool isInt(String inputStr) {
    if (inputStr == null) {
      return false;
    }
    return int.tryParse(inputStr) != null;
  }

  //저장된 길이 세팅
  loadSavedLength() async {
    var db = DatabaseHelper.instance;
    KeyValueMap keyValueMap = await db.selectKeyValueMap(FIRST_NUMBER_LENGTH);
    if (keyValueMap.key != null) {
      setState(() {
        _firstNumberLength = keyValueMap.value!;
      });
    }

    KeyValueMap secondKeyValueMap =
        await db.selectKeyValueMap(SECOND_NUMBER_LENGTH);
    if (secondKeyValueMap.key != null) {
      setState(() {
        _secondNumberLength = secondKeyValueMap.value!;
      });
    }
  }

  //길이 저장
  saveKeyValue(String paramKey, String paramValue) async {
    var db = DatabaseHelper.instance;
    KeyValueMap keyValueMap = await db.selectKeyValueMap(paramKey);
    if (keyValueMap.key == null) {
      await db.insertKeyValueMap(paramKey, paramValue);
    } else {
      await db.updateKeyValueMap(paramKey, paramValue);
    }
    // await db.deleteKeyValueMap(paramKey);
    // await db.insertKeyValueMap(paramKey, paramValue);
  }

  _getTitleTextStyle() {
    return TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                controller: _magicNumber,
                keyboardType: TextInputType.number),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("첫번째 자릿수"),
                SizedBox(
                  width: 50,
                  child: DropdownButton(
                    isExpanded: true,
                    items: <String>['1', '2', '3', '4', '5', '6', '7', '8', '9']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Center(child: Text(value)),
                      );
                    }).toList(),
                    value: _firstNumberLength,
                    onChanged: (String? newValue) {
                      setState(() {
                        _firstNumberLength = newValue!;
                      });

                      saveKeyValue(FIRST_NUMBER_LENGTH, newValue!);
                    },
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("두번째 자릿수"),
                SizedBox(
                  width: 50,
                  child: DropdownButton(
                    isExpanded: true,
                    items: <String>['1', '2', '3', '4', '5', '6', '7', '8', '9']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Center(child: Text(value)),
                      );
                    }).toList(),
                    value: _secondNumberLength,
                    onChanged: (String? newValue) async {
                      setState(() {
                        _secondNumberLength = newValue!;
                      });
                      saveKeyValue(SECOND_NUMBER_LENGTH, newValue!);
                    },
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 30),
                ),
                onPressed: () {
                  _calculateNumber();
                },
                child: const Text('계산하기')),
            _numberPairList.length == 0
                ? SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: Text(_resultMessage, style: _getTitleTextStyle()),
                            ),
                          ],
                        )))
                : SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(_numberPairList[index][0],
                                  style: _getTitleTextStyle()),
                              Text("-", style: _getTitleTextStyle()),
                              Text(_numberPairList[index][1],
                                  style: _getTitleTextStyle())
                            ],
                          ),
                        );
                      },
                      scrollDirection: Axis.vertical,
                      itemCount: _numberPairList.length,
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
