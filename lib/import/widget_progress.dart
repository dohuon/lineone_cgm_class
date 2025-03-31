import 'package:flutter/material.dart';

class WidgetProgressUi extends StatelessWidget {
  int progressIndex;
  WidgetProgressUi(this.progressIndex);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Row(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            children: ['시작하기', '주소록', '전송', '완료']
                .asMap()
                .entries
                .map((entry) => Row(
                      children: [
                        ClipOval(
                            child: Container(
                                alignment: Alignment.center,
                                width: 30,
                                height: 30,
                                color: progressIndex != entry.key
                                    ? Colors.green.withOpacity(0.3)
                                    : Colors.green,
                                child: Text((entry.key + 1).toString(),
                                    style: TextStyle(
                                        fontWeight: progressIndex == entry.key
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: progressIndex == entry.key
                                            ? Colors.white
                                            : Colors.black)))),
                        SizedBox(width: 10),
                        Container(
                            width: 60,
                            child: Text(
                              entry.value,
                              style: TextStyle(
                                  fontWeight: progressIndex == entry.key
                                      ? FontWeight.bold
                                      : FontWeight.normal),
                            ))
                      ],
                    ))
                .toList()));
  }
}
