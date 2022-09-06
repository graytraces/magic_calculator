import 'package:flutter/material.dart';
import 'package:magic_calculator_app/config_screen.dart';

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
  var _numberPairListReverse = [];

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
    _numberPairListReverse = [];

    var inputText = _magicNumber.text;

    if (!isInt(inputText)) {
      setState(() {
        _resultMessage = "정수 숫자를 입력해주세요";
      });
      return;
    }

    var inputNumber = int.parse(inputText);

    int startNumber = 1;
    int endNumber = 9;
    for (int idx = 1; idx < int.parse(_firstNumberLength); idx++) {
      //startNumber *= 10;
      endNumber = endNumber * 10 + 9;
    }

    String resultFirstNumber = "";
    String resultSecondNumber = "";

    for (int firstNumber = startNumber;
        firstNumber <= endNumber;
        firstNumber++) {
      if (inputNumber % firstNumber == 0) {
        var secondNumber = (inputNumber / firstNumber).toInt();

        if (firstNumber.toString().length > int.parse(_firstNumberLength) ||
            secondNumber.toString().length > int.parse(_secondNumberLength)) {
          continue;
        }

        resultFirstNumber = firstNumber.toString();
        if (resultFirstNumber.length < int.parse(_firstNumberLength)) {
          for (int idx2 = resultFirstNumber.length;
              idx2 < int.parse(_firstNumberLength);
              idx2++) {
            resultFirstNumber = "0" + resultFirstNumber;
          }
        }

        resultSecondNumber = secondNumber.toString();

        if (resultSecondNumber.length < int.parse(_secondNumberLength)) {
          for (int idx2 = resultSecondNumber.length;
              idx2 < int.parse(_secondNumberLength);
              idx2++) {
            resultSecondNumber = "0" + resultSecondNumber;
          }
        }

        setState(() {
          _numberPairList.add([resultFirstNumber, resultSecondNumber]);
          _numberPairListReverse.add([resultSecondNumber, resultFirstNumber]);
        });

        endNumber = secondNumber - 1;
        //_numberPairList.add([resultSecondNumber, resultFirstNumber]);
      }
    }

    if (_numberPairList.isEmpty) {
      setState(() {
        _resultMessage = "계산결과값이 없습니다";
      });
    }

    // setState(() {
    //   _numberPairList.sort((a, b) => int.parse(b[0]) - int.parse(a[0]));
    //   _numberPairListReverse.sort((a, b) => int.parse(b[0]) - int.parse(a[0]));
    // });

    FocusManager.instance.primaryFocus?.unfocus();
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

  _getTitleTextStyle() {
    return TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), actions: [
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ConfigScreen()),
            ).then((value) => loadSavedLength());
          },
          style: TextButton.styleFrom(primary: Colors.white),
          child: const Icon(Icons.settings),
        ),
      ]),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  controller: _magicNumber,
                  keyboardType: TextInputType.number),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40),
                  ),
                  onPressed: () {
                    _calculateNumber();
                  },
                  child: const Text('계산하기')),
              SizedBox(
                height: 20,
              ),
              _numberPairList.length == 0
                  ? SizedBox(
                      width: double.infinity,
                      height: 180,
                      child: Center(
                          child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(40.0),
                            child:
                                Text(_resultMessage, style: _getTitleTextStyle()),
                          ),
                        ],
                      )))
                  : SizedBox(
                      width: double.infinity,
                      height: 400,
                      child: ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("010-", style: _getTitleTextStyle()),
                                    Text(_numberPairListReverse[index][0],
                                        style: _getTitleTextStyle()),
                                    Text("-", style: _getTitleTextStyle()),
                                    Text(_numberPairListReverse[index][1],
                                        style: _getTitleTextStyle())
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("010-", style: _getTitleTextStyle()),
                                    Text(_numberPairList[index][0],
                                        style: _getTitleTextStyle()),
                                    Text("-", style: _getTitleTextStyle()),
                                    Text(_numberPairList[index][1],
                                        style: _getTitleTextStyle())
                                  ],
                                ),
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
      ),
    );
  }
}
