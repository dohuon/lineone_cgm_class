import 'package:flutter/material.dart';
import 'package:lineone_cgm_class/import/widget_title.dart';

class PageStart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.start,
      spacing: 30,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WidgetTitle('소개'),
            Text(
                '출결 알리미를 쉽고 빠르게 시작할 수 있도록, PC에서 작성한 엑셀 파일이나 구글 시트를 활용하여 주소록을 만들 수 있는 기능을 제공하고 있습니다.\n\n엑셀이나 구글 시트를 이용하면 여러 명의 정보를 한 번에 정리하고 입력할 수 있어 빠르고 효율적으로 주소록을 관리할 수 있습니다.\n\nv1.1.37'),
            // SizedBox(height: 30),
            // getTitle(context, '엑셀/구글 시트 작성 규칙'),
            // Text('[조직] [그룹] [이름] [전화번호] 순으로 입력합니다.엑셀 샘플,  구글문서 샘플')
          ],
        )),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WidgetTitle('엑셀/구글 시트 작성 규칙'),
            Text('[조직] [그룹] [이름] [전화번호] 순으로 입력합니다.'),
            SizedBox(height: 10),
            // Text('[조직] [그룹] [이름] [전화번호] 순으로 입력합니다.엑셀 샘플,  구글문서 샘플')
            Image.asset('assets/images/excel.png')
          ],
        ))
      ],
    );
  }
}
