import 'package:flutter/material.dart';

import 'database_helper.dart';
import 'key_value_map.dart';

class ConfigScreen extends StatelessWidget {
  const ConfigScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('설정')),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: Column(
              children: [Text("설정")],
            )));
  }
}
