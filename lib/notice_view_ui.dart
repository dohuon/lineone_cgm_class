import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
          if (value == null || value['isSuccess'] == false) {
            log('faield');
            _data = 'failed';
          } else {
            log('good');
            _data = value['data'];
          }
        }));
  }

  Future<dynamic> fetchData(uid) async {
    log('fetchData 1 ${widget.group} ${widget.uid} ${widget.from}');
    // String host = 'https://web-get-opwgebu2jq-du.a.run.app/';
    String host = 'https://class.alimi.app/api/get/';
    // String host = 'http://127.0.0.1:5001/lineone-cgm/asia-northeast3/web-get/';
    String url = "$host?type=notice_read";
    url += "&uid=${uid}";
    url += "&from=${widget.from ?? ""}";

    try {
      log('url ' + url);
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        log('fetchData 2');
        return json.decode(response.body);
      } else {
        log('fetchData 3');
      }
    } catch (e) {
      log('fetchData 4 ' + e.toString());
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // log('build ' + _data.toString());

    Widget scaffold = Scaffold(
        // backgroundColor: const Color(0xFFEEEEEE),
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   centerTitle: true,
        //   title: const Text(
        //     '알림장',
        //     // style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        //   ),
        // ),
        body: SafeArea(child: getContent()));

    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 400) {
      return Center(
        child: Container(
            // decoration: const BoxDecoration(
            //     border: Border.symmetric(
            //         vertical: BorderSide(color: Colors.black38, width: 0.5))),
            width: 400,
            child: scaffold),
      );
    } else {
      return scaffold;
    }
  }

  static const Color textLessImportant = Colors.black54;
  Widget getContent() {
    // if (_data == null) {
    //   return Container(
    //     alignment: Alignment.topCenter,
    //     padding: const EdgeInsets.only(top: 100),
    //     child: const CircularProgressIndicator(
    //       color: colorMain,
    //     ),
    //   );
    // }
    // log('_data ' + _data.toString());

    // if (_data == 'failed') {
    //   return const Center(
    //       child: Text(
    //     '불러오기 실패!\n😢',
    //     textAlign: TextAlign.center,
    //   ));
    // }

    BoxDecoration borderDecoration = const BoxDecoration(
        border: Border.symmetric(
            vertical: BorderSide(color: Colors.black38, width: 0.5)));

    if (_data == null || _data == 'failed') {
      Widget getErrorWidget() {
        if (_data == null) {
          return Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 100, bottom: 150),
            child: const CircularProgressIndicator(
              color: colorMain,
            ),
          );
        }

        if (_data == 'failed') {
          return Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.only(top: 100, bottom: 150),
              child: Text(
                '불러오기 실패!\n😢',
                textAlign: TextAlign.center,
              ));
        }
        return SizedBox();
      }

      return Column(children: [
        Container(
            width: double.infinity,
            decoration: borderDecoration.copyWith(color: Colors.green),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Text('알림장',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.white))),
        Container(
          decoration: borderDecoration,
          height: 1,
        ),
        Container(
            decoration: const BoxDecoration(
                border: Border(
              left: BorderSide(color: Colors.black38, width: 0.5), // 왼쪽
              right: BorderSide(color: Colors.black38, width: 0.5), // 오른쪽
              bottom: BorderSide(color: Colors.black38, width: 0.5), // 아래쪽
            )),
            child: getErrorWidget())
      ]);
    }
    return Column(children: [
      Container(
          width: double.infinity,
          decoration: borderDecoration.copyWith(color: Colors.green),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text('알림장',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.white))),
      Container(
        decoration: borderDecoration,
        height: 1,
      ),
      Expanded(
          child: SingleChildScrollView(
              child: Column(
        children: [
          Container(
            decoration: borderDecoration,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            width: double.infinity,
            // color: Colors.white,
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  _data['noticeTitle'],
                  // style: TextStyle(color: textLessImportant),
                )),
                Text(
                  _data['noticeSubtitle'],
                  // style: TextStyle(color: textLessImportant),
                )
              ],
            ),
          ),
          Container(
            decoration:
                borderDecoration.copyWith(color: const Color(0xFFEEEEEE)),
            height: 4,
          ),
          Container(
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(color: Colors.black38, width: 0.5), // 왼쪽
                  right: BorderSide(color: Colors.black38, width: 0.5), // 오른쪽
                  bottom: BorderSide(color: Colors.black38, width: 0.5), // 아래쪽
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 0, right: 0, bottom: 5),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              top: 15, left: 15, right: 15, bottom: 10),
                          child: Text(
                            _data['title'],
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        // const Divider(
                        //   indent: 15,
                        //   endIndent: 15,
                        // ),
                        Container(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 10),
                          child: Text(_data['content']),
                        ),
                        if (_data['images'] != null &&
                            _data['images'].length > 0)
                          Container(
                              padding: EdgeInsets.all(10),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(_data['imageHost']
                                      .replaceAll(
                                          '{fileName}', _data['images'][0])))),
                      ],
                    ),
                  ),
                  Container(
                    decoration: borderDecoration.copyWith(
                        color: const Color(0xFFEEEEEE)),
                    height: 4,
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(
                        top: 4, left: 10, right: 10, bottom: 4),
                    padding: const EdgeInsets.all(2),
                    // color: Colors.white,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          '출결 알리미',
                        ].map((e) {
                          return Text(
                            e,
                            style: TextStyle(fontSize: 12),
                          );
                        }).toList()),
                  )
                ],
              )),
        ],
      )))
    ]);
  }
}
