import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class NoticeViewUi extends StatefulWidget {
  String group;
  String uid;
  String? from;

  NoticeViewUi(this.group, this.uid, {this.from});
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
          _data = value['data'];
        }));
  }

  Future<dynamic> fetchData(uid) async {
    String url =
        'http://127.0.0.1:5001/lineone-cgm/asia-northeast3/web-get?type=notice_read';
    url += "&uid=" + uid;
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
    log('build ' + _data.toString());

    return Scaffold(
        backgroundColor: const Color(0xFFEEEEEE),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            '공지사항',
            // style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ),
        body: SafeArea(
          child: _data == null
              ? Container(
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.only(top: 100),
                  child: const CircularProgressIndicator(
                    color: colorMain,
                  ),
                )
              : Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      width: double.infinity,
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _data['noticeTitle'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text(
                            _data['noticeSubtitle'],
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 5),
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 15, right: 15),
                                  child: Text(_data['title']),
                                ),
                                const Divider(
                                  indent: 15,
                                  endIndent: 15,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, bottom: 10),
                                  child: Text(_data['content']),
                                )
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(
                                top: 10, left: 10, right: 10, bottom: 5),
                            padding: const EdgeInsets.all(10),
                            // color: Colors.white,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  '출결 알리미',
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
