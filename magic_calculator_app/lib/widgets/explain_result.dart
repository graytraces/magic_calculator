import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_stat_provider.dart';

class ExplainResult extends StatelessWidget {
  const ExplainResult(List<List<String>> this._strFilteredNumberPairList, this._appStatProvider, {Key? key}) : super(key: key);
  final List<List<String>> _strFilteredNumberPairList;
  final AppStatProvider _appStatProvider;


  _getContentTextStyle() {
    return const TextStyle(fontSize: 16);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        width: double.infinity,
        child: _strFilteredNumberPairList.isEmpty
          ? Text(
        "답변이 잘못 입력되었습니다.",
        style: _getContentTextStyle(),
      )
          : SizedBox(
        width: double.infinity,
        height: (20 * _strFilteredNumberPairList.length).toDouble(),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Text("010-" +
                        _strFilteredNumberPairList[index][0] +
                        "-" +
                        _strFilteredNumberPairList[index][1]),
                  ),
                  SizedBox(
                    height: 20,
                    child: IconButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () async {
                          String sendNum = "010-" +
                              _strFilteredNumberPairList[index][0] +
                              "-" +
                              _strFilteredNumberPairList[index][1];
                          Uri sms = Uri.parse('sms:' +
                              sendNum +
                              '?body=' +
                              _appStatProvider.getSendMessage());
                          await launchUrl(sms);
                        },
                        icon: const Icon(Icons.sms)),
                  )
                ],
              );
            },
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _strFilteredNumberPairList.length,
          ),
        ),
      ),
    ) );
  }
}
