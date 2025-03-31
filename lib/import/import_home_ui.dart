import 'dart:convert';
import 'dart:developer';
import 'dart:math' show Random;
import 'dart:typed_data';
import 'dart:convert';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lineone_cgm_class/import/page_address.dart';
import 'package:lineone_cgm_class/import/page_complete.dart';
import 'package:lineone_cgm_class/import/page_send.dart';
import 'package:lineone_cgm_class/import/page_start.dart';
import 'package:lineone_cgm_class/import/widget_progress.dart';

class ImportHomeUi extends StatefulWidget {
  @override
  _ImportHomeUi createState() => _ImportHomeUi();
}

class _ImportHomeUi extends State<ImportHomeUi> {
  int _progressIndex = 0;
  // String _uploadType = 'excel';
  // bool _uploadTypeConfirm = true;

  String _uploadType = '';
  bool _uploadTypeConfirm = false;

  String _sendType = '';
  bool _sendTypeConfirm = false;

  bool _sendAgreed = false;
  bool _sendAgreedConfirm = false;

  String _url = '';
  List<String> _encrypted = [];

  String _sendStatus = '';

  String _completeTitle = '입력 키가 발급되었습니다.';
  String _completeDescription =
      '앱 설정 → 주소록 PC에서 가지고 오기에서 이 키를 입력해 주세요.\n 5분 내에 사용되지 않으면 자동으로 삭제 됩 니다.';

  List<List<dynamic>> _rows = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                            width: 30,
                            height: 30,
                            child: Image.asset('assets/images/Icon-192.png')),
                      ),
                      Container(
                          padding: const EdgeInsets.all(8),
                          child: const Text('출결 알리미 '))
                    ],
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(children: [
                            WidgetProgressUi(_progressIndex),
                            const SizedBox(height: 50),
                            getPage(),
                            if (_progressIndex != 1 ||
                                (_progressIndex == 1 && !_uploadTypeConfirm))
                              const SizedBox(height: 30),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (_progressIndex != 0 &&
                                      _progressIndex != 3)
                                    getResetButton(),
                                  getNextButton()
                                ])
                          ])))
                ],
              ))),
    );
  }

  Widget getPage() {
    switch (_progressIndex) {
      case 0:
        return PageStart();
      case 1:
        return PageAddress(_uploadType, _uploadTypeConfirm, _rows, (data) {
          // log('clcock ' + data.toString());
          if (data.runtimeType == String) {
            setState(() {
              _uploadType = data;
            });
          } else {
            setState(() {
              _rows = data;
            });
          }
        });
      case 2:
        return PageSend(
            _sendType, _sendTypeConfirm, _sendAgreed, _sendAgreedConfirm,
            (data) {
          log('getpage ${data.runtimeType} ${data}');
          if (data.runtimeType == bool) {
            setState(() {
              _sendAgreed = data;
            });
          }
          if (data.runtimeType == String) {
            setState(() {
              _sendType = data;
            });
          }
        });

      case 3:
        return PageComplete(_completeTitle, _completeDescription, _url,
            _encrypted[0], (data) {});
    }
    return const SizedBox();
  }

  reset() {
    setState(() {
      _progressIndex = 0;
      _uploadType = '';
      _uploadTypeConfirm = false;
      _sendType = '';
      _sendTypeConfirm = false;
      _sendAgreed = false;
      _sendAgreedConfirm = false;
      _url = '';
      _sendStatus = '';
      _completeTitle = '';
      _completeDescription = '';
      _rows = [];
    });
  }

  getNextButton() {
    String label = '다음';
    var onPressed;
    switch (_progressIndex) {
      case 0:
        label = '시작';
        onPressed = () {
          setState(() {
            _progressIndex++;
          });
        };
        break;
      case 1:
        if (_uploadType.length > 0 && !_uploadTypeConfirm) {
          onPressed = () {
            setState(() {
              _uploadTypeConfirm = true;
            });
          };
        }
        log('netxt button ${_uploadType.length > 0} ${_uploadTypeConfirm} ${_rows.length > 0} ${_rows.length > 0 ? _rows[0].length : 0}');
        if (_uploadType.length > 0 &&
            _uploadTypeConfirm &&
            _rows.length > 0 &&
            _rows[0].length > 0) {
          onPressed = () => setState(() => _progressIndex++);
        }
      case 2:
        if (_sendTypeConfirm) {
          label = '전송';
        }
        if (_sendType.length > 0 && !_sendTypeConfirm) {
          onPressed = () {
            setState(() {
              _sendTypeConfirm = true;
            });
          };
        }
        if (_sendTypeConfirm && _sendAgreed) {
          if (_sendStatus != 'loading') {
            onPressed = () async {
              await sendPostRequest();
              setState(() => _progressIndex++);
            };
          }
          // else if (_sendStatus == 'error' || _sendStatus == 'failed') {
          //   label = '처음으로';
          //   onPressed = () async {
          //     reset();
          //   };
          // }
        }
      case 3:
        label = '처음으로';
        onPressed = () async {
          reset();
        };
        break;
    }
    return Container(
        margin: const EdgeInsets.all(15),
        child: FilledButton(
            onPressed: onPressed,
            child: Text(label),
            style: FilledButton.styleFrom(
              // backgroundColor: Colors.blue, // 버튼 색상
              // foregroundColor: Colors.white, // 텍스트 색상
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30), // 둥근 모서리
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 12), // 내부 여백
              minimumSize: const Size(200, 60),
            )));
  }

  Future<void> sendPostRequest() async {
    String host = 'https://class.alimi.app/api/post/';
    // String host = 'http://127.0.0.1:5001/lineone-cgm/asia-northeast3/web-post/';

    final url = Uri.parse(host); // 요청할 URL을 입력하세요.

    final headers = {
      'Content-Type': 'application/json', // JSON 데이터 전송
    };

    setState(() {
      _sendStatus = 'loading';
    });
    try {
      List<List<String>> rows = [];
      for (var row in _rows) {
        List<String> list = [];
        for (var item in row) {
          list.add(item.toString());
        }
        rows.add(list);
      }
      _encrypted = await encryptText(jsonEncode(rows));
      final body = jsonEncode({
        "type": "import",
        "importType": _sendType.toString(),
        "encrypted": _encrypted[1]
      }); // JSON 형식의 데이터

      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        print('✅ 성공: ${response.body}');
        var map = jsonDecode(response.body);
        log('map ' + map.keys.toString());
        _sendStatus = 'success';
        _url = map['url'];
        _completeTitle = map['title'];
        _completeDescription = map['description'];
      } else {
        print('❌ 실패: ${response.statusCode} - ${response.body}');
        _sendStatus = 'failed';
        _url = '';
        _completeTitle = '실패!';
        _completeDescription = '요청 실패';
      }
    } catch (e) {
      print('🚨 오류 발생: $e');
      _sendStatus = 'error';
      _url = '';
      _completeTitle = '실패!';
      _completeDescription = '무언가 잘못되었습니다.';
    }
    setState(() {});
  }

  Widget getResetButton() {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 15),
        child: FilledButton(
            onPressed: () {
              setState(() {
                reset();
              });
            },
            child: Text('처음으로', style: TextStyle(color: Colors.black)),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white, // 버튼 색상
              // foregroundColor: Colors.white, // 텍스트 색상
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // 둥근 모서리
                  side: BorderSide(color: Colors.green)),
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 12), // 내부 여백
              minimumSize: const Size(200, 60),
            )));
  }

  Future<List<String>> encryptText(String text) async {
    final keyBytes = Uint8List.fromList(
        List<int>.generate(32, (i) => Random.secure().nextInt(256)));
    final key = encrypt.Key(keyBytes);
    final keyBase64 = base64.encode(keyBytes); // Base64로 저장

    // 16바이트 IV 생성
    final ivBytes = Uint8List.fromList(
        List<int>.generate(16, (i) => Random.secure().nextInt(256)));
    final iv = encrypt.IV(ivBytes);

    // 암호화 수행
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(text, iv: iv);

    final combinedBytes = iv.bytes + encrypted.bytes;
    final encryptedBase64 = base64.encode(combinedBytes);

    // log('encrypted ' + encrypted.base64);

    // final decrypted = encrypter.decrypt(encrypted, iv: iv);
    // log('decrypted ' + decrypted);
    return [
      keyBase64
          .replaceAll('+', '-') // +를 -로 변경
          .replaceAll('/', '_') // /를 _로 변경
          .replaceAll('=', ''),
      encryptedBase64
    ];
  }
}
