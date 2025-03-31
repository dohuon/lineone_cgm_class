import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lineone_cgm_class/import/widget_select_item.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PageSend extends StatelessWidget {
  var _callback;

  bool _sendAgreed;
  bool _sendAgreedConfirm;
  String _sendType;
  bool _sendTypeConfirm;

  PageSend(this._sendType, this._sendTypeConfirm, this._sendAgreed,
      this._sendAgreedConfirm, this._callback);

  @override
  Widget build(BuildContext context) {
    if (_sendTypeConfirm) {
      Color textDefaultColor = Colors.black;
      return Container(
          width: 400,
          child: Column(
            spacing: 30,
            mainAxisSize: MainAxisSize.max,
            children: [
              // Text(
              //     '주소록을 전송합니다. 전송된 주소록은 최대 10분 동안 서버에 남아 있게 되며 그 이후 삭제됩니다. 자세한 내용은 개인정보 보호 방침을 확인해 주세요.',
              //     style: Theme.of(context).textTheme.bodyMedium),
              Container(
                // padding:
                // EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 4),
                // padding: EdgeInsets.all(5),
                child: new RichText(
                  text: new TextSpan(
                    children: [
                      new TextSpan(
                        text:
                            '주소록을 전송합니다. 종단간 암호화로 안전하게 전송되며, 생성된 QR 코드를 가진 사람만 내용을 확인할 수 있습니다. 자세한 내용은 ',
                        style: TextStyle(fontSize: 14, color: textDefaultColor),
                      ),
                      new TextSpan(
                        text: '이용약관',
                        style: new TextStyle(color: Colors.blue, fontSize: 14),
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () {
                            launchUrlString(
                              'https://docs-termsofservice-opwgebu2jq-du.a.run.app/?product=cgm',
                            );
                          },
                      ),
                      new TextSpan(
                        text: '과 ',
                        style: TextStyle(fontSize: 15, color: textDefaultColor),
                      ),
                      new TextSpan(
                        text: '개인정보 처리방침',
                        style: new TextStyle(color: Colors.blue, fontSize: 14),
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () {
                            launchUrlString(
                                'https://docs-privacy-opwgebu2jq-du.a.run.app/?product=cgm');
                          },
                      ),
                      new TextSpan(
                        text: '을 확인하세요.',
                        style: TextStyle(fontSize: 14, color: textDefaultColor),
                      ),
                    ],
                  ),
                ),

                // Text(
                //   (Platform.isIOS
                //           ? 'subscription.premium_subscription_long_detail'
                //           : 'subscription.premium_subscription_detail')
                //
                //       .replaceAll('{price}', price),
                //   textAlign: TextAlign.center,
                //   style: TextStyle(fontSize: 14),
                // ),
              ),
              GestureDetector(
                  onTap: () {
                    _callback(!_sendAgreed);
                  },
                  child: Container(
                      width: 300,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.black12)),
                      child: Row(
                        children: [
                          Checkbox(
                              value: _sendAgreed,
                              onChanged: (value) {
                                _callback(value!);
                              }),
                          Text('주소록 전송에 동의합니다.')
                        ],
                      ))),
            ],
          ));
    } else {
      return getSelection(context);
    }
  }

  getContainer({child}) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.black12.withOpacity(0.04)),
        child: child);
  }

  getButton({label, onPressed}) {
    return FilledButton(
      onPressed: onPressed,
      child: Text(label),
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // 둥근 모서리
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6), // 내부 여백
        minimumSize: Size(80, 50),
      ),
    );
  }

  getSelection(context) {
    return Column(
      spacing: 10,
      children: [
        Text('적용 방법 선택'),
        WidgetSelectItem(context,
            title: '연락처 추가하기',
            description: '폰에 저장되어 있는 연락처를 유지하고 지금 생성한 연락처를 추가합니다.',
            isSelected: _sendType == 'add',
            onTap: () => _callback('add')),
        WidgetSelectItem(context,
            title: '연락처 덮어 쓰기',
            description: '폰에 저장되어있는 연락처를 초기화하고 지금 생성한 연락처로 새로 지정합니다.',
            isSelected: _sendType == 'overwrite',
            onTap: () => _callback('overwrite')),
      ],
    );
  }

  // List<List<dynamic>> getSummaryData() {
  //   Map<String, List<String>> map = {};

  //   for (var row in _rows) {
  //     // log('length ' + row.length.toString() + ' ' + row.toString());
  //     String key = '${row[0]}_${row[1]}';
  //     if (map[key] == null) {
  //       map[key] = [row[0].toString(), row[1].toString(), '0'];
  //     }
  //     map[key]![2] = (int.parse(map[key]![2]) + 1).toString();
  //   }

  //   List<List<dynamic>> summary = [];
  //   summary = map.values.toList();
  //   return summary;
  // }
}
