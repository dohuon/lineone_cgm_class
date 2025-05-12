import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lineone_cgm_class/manage/widget_normal_button.dart';

import 'package:http/http.dart' as http;
import '../main.dart';

class ManageUi extends StatefulWidget {
  @override
  _ManageUiState createState() => _ManageUiState();
}

class _ManageUiState extends State<ManageUi> {
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _authCodeController = TextEditingController();
  // TextEditingController _phoneNumberController =
  //     TextEditingController(text: '01054819481');
  // TextEditingController _authCodeController =
  //     TextEditingController(text: '540281');
  TextEditingController _addPhoneNumberController = TextEditingController();
  TextEditingController _nameController = TextEditingController(text: '');

  final FocusNode _focusNodeEditName = FocusNode();
  // final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('출결 알리미 관리자'),
    //     automaticallyImplyLeading: false,
    //   ),
    //   body: getBody(context),
    // );
    return Center(
        child: Container(
      constraints: const BoxConstraints(maxWidth: 400),
      decoration: const BoxDecoration(
          border: Border.symmetric(
              vertical: BorderSide(color: Colors.black12, width: 1))),
      child: getBody(context),
    ));
  }

  // String _status = 'update_name';
  // String _status = 'code_requested';
  // String _status = 'code_requested';
  String _status = 'need_login';

  var _selectedItem;
  @override
  void initState() {
    super.initState();
    if (_phoneNumberController.text.length > 0 &&
        _authCodeController.text.length == 6) {
      request('list');
    }
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _authCodeController.dispose();
    _addPhoneNumberController.dispose();
    _focusNodeEditName.dispose();
    super.dispose();
  }

  String formatPhoneNumber(String input) {
    final regExp = RegExp(r'^(\d{3})(\d{4})(\d{4})$');
    final match = regExp.firstMatch(input);

    if (match != null) {
      return '${match[1]}-${match[2]}-${match[3]}';
    } else {
      return input; // 포맷이 안 맞으면 원본 반환
    }
  }

  Widget getBody(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
            child: Scaffold(
                appBar: AppBar(
                  title: Text('출결 알리미 관리자'),
                  automaticallyImplyLeading: false,
                ),
                body: _status == 'ready' || _status == 'update_name'
                    ? SingleChildScrollView(
                        child: Column(
                          spacing: 10,
                          children: [
                            getTitle('라이선스'),
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                width: double.infinity,
                                child: Text(
                                  data == null ? '' : data['license'],
                                )),
                            SizedBox(),
                            getTitle('신규 추가'),
                            Row(children: [
                              Expanded(
                                  child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: TextField(
                                        controller: _addPhoneNumberController,
                                        textInputAction: TextInputAction.done,
                                        keyboardType:
                                            TextInputType.phone, // 전화번호용 키패드
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      0), // 원하는 둥근 정도
                                            ),
                                            isDense: true,
                                            hintText: '휴대폰 번호'),
                                      ))),
                              WidgetNormalButton(
                                '번호 등록',
                                verticalMargin: 0,
                                horizontalMargin: 0,
                                verticalPadding: 10,
                                onTap: () async {
                                  await request('add');
                                  _addPhoneNumberController.text = '';
                                  setState(() {});
                                },
                              ),
                              SizedBox(width: 20),
                            ]),
                            SizedBox(),
                            getTitle('등록 번호',
                                trailing: data == null
                                    ? ''
                                    : '${data['members'].length}/${data['countLicense']}'),
                            if (data != null)
                              ...(List<Widget>.from(data['members'].map((e) {
                                return ListTile(
                                    title: Text(formatPhoneNumber(e['number'])),
                                    subtitle: Text(e['name']),
                                    trailing: Row(
                                        mainAxisSize: MainAxisSize.min, // 중요!!
                                        children: [
                                          TextButton(
                                              onPressed: () {
                                                log('change name');
                                                setState(() {
                                                  _status = 'update_name';
                                                  _selectedItem = e;
                                                  _nameController.text =
                                                      e['name'];
                                                });
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((_) {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          _focusNodeEditName);
                                                });
                                              },
                                              child: Text('이름 변경')),
                                          TextButton(
                                              onPressed: (e['usedAt'] > 0)
                                                  ? null
                                                  : () async {
                                                      _selectedItem = e;
                                                      await request('delete');
                                                      setState(() {});
                                                    },
                                              child: Text('삭제')),
                                        ])); //Text(e['number']);
                              })).toList().reversed)
                          ],
                        ),
                      )
                    : null)),
        if (_status == 'need_login' ||
            _status == 'code_requested' ||
            _status == 'update_name')
          Positioned.fill(
              child: GestureDetector(
                  onTap: () {
                    print("배경이 탭되었습니다.");
                    if (_status == 'update_name') {
                      setState(() {
                        _status = 'ready';
                      });
                    }
                  },
                  child: Material(
                      color: Colors.black12,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: _status == 'need_login' ? 50 : 18),
                            GestureDetector(
                                onTap: () {
                                  print("내부가 탭되었습니다.");
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  width: 250,
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      spacing: 10,
                                      children: [
                                        // SizedBox(),
                                        if (_status == 'need_login')
                                          ...dialogLogin(),
                                        if (_status == 'update_name')
                                          ...dialogUpdateName(),
                                        if (_status == 'code_requested')
                                          ...dialogAuthcode()
                                      ]),
                                ))
                          ]))))
      ],
    );
  }

  var data;
  getTitle(title, {trailing}) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 3, bottom: 3, left: 8, right: 8),
        // decoration: BoxDecoration(
        //     border: Border(
        //   bottom:
        //       BorderSide(width: 1.0, color: Colors.black12),
        // )),
        color: MyApp.colorMain.withOpacity(0.2),
        child: Row(children: [
          Expanded(
              child: Text(
            title,
            style: TextStyle(color: Colors.black87, fontSize: 13),
          )),
          if (trailing != null) Text(trailing)
        ]));
  }

  Future<void> request(action) async {
    String host = 'https://class.alimi.app/api/post/';
    // String host = 'http://127.0.0.1:5001/lineone-cgm/asia-northeast3/web-post/';

    final url = Uri.parse(host); // 요청할 URL을 입력하세요.

    final headers = {
      'Content-Type': 'application/json', // JSON 데이터 전송
    };

    try {
      final body = jsonEncode({
        "type": "manage",
        "action": action,
        "phoneNumber": _phoneNumberController.text.toString(),
        "authCode": _authCodeController.text.toString(),
        "inputNumber": _addPhoneNumberController.text.toString(),
        "selectedItem": _selectedItem,
      }); // JSON 형식의 데이터
      log('requrest ${body}');

      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        print('✅ 성공: ${response.body}');
        data = jsonDecode(response.body);
        if (data['isAuthorized']) {
          _status = 'ready';
        } else if (_status == 'ready') {
          _status = 'need_login';
        }
        log('map ' + data.keys.toString());
      } else {
        print('❌ 실패: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('🚨 오류 발생: $e');
    }
    setState(() {});
  }

  List<Widget> dialogAuthcode() {
    return [
      Text(
        '관리자 인증',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      Text(
        '카톡으로 인증번호를 전달하였습니다. 카카오톡 앱에서 확인해 주세요.',
        // textAlign: TextAlign.center,
      ),
      Container(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: TextField(
            controller: _authCodeController,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.phone, // 전화번호용 키패드
            textAlign: TextAlign.center,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0), // 원하는 둥근 정도
                ),
                isDense: true,
                hintText: '인증번호'),
          )),
      WidgetNormalButton(
        '인증번호 확인',
        verticalMargin: 0,
        horizontalMargin: 0,
        verticalPadding: 10,
        fillParent: true,
        onTap: () {
          request('list');
        },
      ),
      WidgetNormalButton(
        '다시 시도',
        outlined: true,
        fillParent: true,
        verticalMargin: 0,
        horizontalMargin: 0,
        verticalPadding: 10,
        onTap: () {
          setState(() {
            _status = 'need_login';
          });
        },
      ),
    ];
  }

  List<Widget> dialogUpdateName() {
    return [
      Text(
        '이름 입력',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      Container(
          padding: EdgeInsets.only(top: 5, bottom: 10),
          child: TextField(
            focusNode: _focusNodeEditName,
            controller: _nameController,
            textInputAction: TextInputAction.done,
            // keyboardType: TextInputType.phone, // 전화번호용 키패드
            textAlign: TextAlign.center,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0), // 원하는 둥근 정도
                ),
                isDense: true,
                hintText: '이름'),
          )),
      WidgetNormalButton(
        '저장',
        verticalMargin: 0,
        horizontalMargin: 0,
        verticalPadding: 10,
        fillParent: true,
        onTap: () {
          setState(() {
            _status = 'ready';
            _selectedItem['name'] = _nameController.text.toString();
            request('update_name');
          });
        },
      ),
      WidgetNormalButton(
        '취소',
        outlined: true,
        fillParent: true,
        verticalMargin: 0,
        horizontalMargin: 0,
        verticalPadding: 10,
        onTap: () {
          setState(() {
            _status = 'ready';
          });
        },
      ),
    ];
  }

  List<Widget> dialogLogin() {
    return [
      Text(
        '관리자 인증',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      Text(
        '관리자로 등록된 휴대폰 번호를 입력해 주세요.',
        // textAlign: TextAlign.center,
      ),
      Container(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: TextField(
            controller: _phoneNumberController,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.phone, // 전화번호용 키패드
            textAlign: TextAlign.center,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0), // 원하는 둥근 정도
                ),
                isDense: true,
                hintText: '휴대폰 번호'),
          )),
      WidgetNormalButton(
        '인증번호 전송',
        verticalMargin: 0,
        horizontalMargin: 0,
        verticalPadding: 10,
        fillParent: true,
        onTap: () {
          _authCodeController.text = '';
          request('request_authcode');
          setState(() {
            _status = 'code_requested';
          });
        },
      )
    ];
  }
}
