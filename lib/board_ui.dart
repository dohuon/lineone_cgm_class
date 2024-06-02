import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class NoticeViewUi extends StatefulWidget {
  String group;
  String uid;

  NoticeViewUi(this.group, this.uid);
  @override
  _NoticeViewUi createState() => _NoticeViewUi();
}

class _NoticeViewUi extends State<NoticeViewUi> {
  static const Color colorMain = Colors.green;
  var _data;

  @override
  void initState() {
    super.initState();
    fetchData(widget.uid).then((value) => setState(() {
          _data = value;
        }));
  }

  Future<dynamic> fetchData(uid) async {
    String url =
        'http://127.0.0.1:5001/lineone-cgm/asia-northeast3/web-get?type=notice_read';
    url += "&uid=" + 'rBwXPvUooVt3F2VRqJA1';
    url += "&from=" + 'test';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    log('build ');
    String orgName = '하나 초등학교';
    String groupName = '코딩 A반';
    String dateTime = '2023-10-20 오후 3시 20분 작성';

    return Scaffold(
        backgroundColor: Color(0xFFEEEEEE),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            '공지사항',
            // style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ),
        body: SafeArea(
          child: _data == null
              ? Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(top: 100),
                  child: CircularProgressIndicator(
                    color: colorMain,
                  ),
                )
              : Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      width: double.infinity,
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            orgName + ' ' + groupName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text(dateTime)
                        ],
                      ),
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin:
                                EdgeInsets.only(left: 10, right: 10, bottom: 5),
                            color: Colors.white,
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      top: 10, left: 15, right: 15),
                                  child: Text('2'),
                                ),
                                // Container(
                                //   margin: EdgeInsets.symmetric(horizontal: 20),
                                //   width: double.infinity,
                                //   height: 1,
                                //   color: Colors.grey,
                                // ),
                                Divider(
                                  indent: 15,
                                  endIndent: 15,
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 15, right: 15, bottom: 10),
                                  child: Text('1'),
                                )
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            margin: EdgeInsets.only(
                                left: 10, right: 10, bottom: 15, top: 10),
                            child: Material(
                                color: Colors.transparent,
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: InkWell(
                                            onTap: () {},
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            child: Container(
                                                padding: EdgeInsets.all(10),
                                                alignment: Alignment.center,
                                                child: Text('4명 읽음')))),
                                    Container(
                                      color: Color(0xFFEFEFEF),
                                      width: 2,
                                      height: 20,
                                    ),
                                    Expanded(
                                        child: InkWell(
                                            onTap: () {},
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            child: Container(
                                                padding: EdgeInsets.all(10),
                                                alignment: Alignment.center,
                                                child: Text('미리보기')))),
                                  ],
                                )),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin:
                                EdgeInsets.only(left: 10, right: 10, bottom: 5),
                            padding: EdgeInsets.all(10),
                            // color: Colors.white,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  '2024-01-10 수정됨 ',
                                  '2024-01-10 수 ',
                                ].map((e) {
                                  return Text(e);
                                }).toList()),
                          )
                        ],
                      ),
                    )),
                  ],
                ),
        ));
  }
}
