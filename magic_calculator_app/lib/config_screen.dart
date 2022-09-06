import 'package:flutter/material.dart';

import 'database_helper.dart';
import 'key_value_map.dart';

class ConfigScreen extends StatelessWidget {
  const ConfigScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConfigScreenStateful();
  }
}

class ConfigScreenStateful extends StatefulWidget {
  const ConfigScreenStateful({Key? key}) : super(key: key);

  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreenStateful> {
  String _firstNumberLength = "1";
  String _secondNumberLength = "1";

  final String FIRST_NUMBER_LENGTH = "firstNumberLength";
  final String SECOND_NUMBER_LENGTH = "secondNumberLength";

  @override
  void initState() {
    loadSavedLength();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('설정')),
        body: SingleChildScrollView(
          child: Column(
            children: [
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
                      items: <String>[
                        '1',
                        '2',
                        '3',
                        '4',
                        '5',
                        '6',
                        '7',
                        '8',
                        '9'
                      ].map<DropdownMenuItem<String>>((String value) {
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
                      items: <String>[
                        '1',
                        '2',
                        '3',
                        '4',
                        '5',
                        '6',
                        '7',
                        '8',
                        '9'
                      ].map<DropdownMenuItem<String>>((String value) {
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
            ],
          ),
        ));
  }
}
