import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:excel/excel.dart' as excelLib;
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'package:lineone_cgm_class/import/widget_select_item.dart';
import 'package:lineone_cgm_class/import/widget_title.dart';
import 'package:lineone_cgm_class/toast.dart';

class PageAddress extends StatelessWidget {
  String _uploadType;
  bool _uploadTypeConfirm;
  var _callback;
  List<List<dynamic>> _rows = [];

  PageAddress(
      this._uploadType, this._uploadTypeConfirm, this._rows, this._callback);

  @override
  Widget build(BuildContext context) {
    log('_rows ${_rows.runtimeType}');

    bool isPaste = _uploadType == 'paste';
    String actionMessage =
        isPaste ? '복사 후 붙여넣기를 눌러 눌러 주세요.' : '엑셀 파일을 선택해 주세요.';

    if (_uploadTypeConfirm) {
      List<List<dynamic>> summary = getSummaryData();
      return Expanded(
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.start,
        spacing: 30,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WidgetTitle('엑셀 파일을 선택'),
              Row(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Text(actionMessage)),
                    getButton(
                        label: isPaste ? '붙여넣기' : '파일선택',
                        onPressed: () async {
                          var result = isPaste
                              ? await _readClipboard()
                              : await _readExcelFile();
                          if (result != null) {
                            _callback(result);
                          }
                        })
                  ]),
              if (isPaste)
                Expanded(
                    child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                      SizedBox(height: 20),
                      WidgetTitle('엑셀이나 구글 시트에서 복사하기', shrink: true, index: 1),
                      Image.asset('assets/images/excel_copy.png'),
                      SizedBox(height: 40),
                      WidgetTitle('클립보드 복사 권한을 허용', shrink: true, index: 1),
                      Image.asset('assets/images/excel_copy_permission.png')
                    ])))
            ],
          )),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WidgetTitle('요약'),
              Container(
                  height: 200,
                  child: getContainer(
                      child: _rows.length == 0
                          ? SizedBox()
                          : _buildExcelTable(
                              rows: summary,
                              isPrimary: true,
                              headers: ['조직', '그룹', '인원']))),
              WidgetTitle('주소록'),
              Expanded(
                  child: getContainer(
                      child: _rows.length == 0
                          ? SizedBox()
                          : _buildExcelTable(
                              rows: _rows,
                              isPrimary: true,
                              headers: ['조직', '그룹', '이름', '전화번호'])))
            ],
          ))
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

  Widget _buildExcelTable(
      {required List<List<dynamic>> rows, isPrimary, headers}) {
    return Scrollbar(
        child: SingleChildScrollView(
      primary: isPrimary,
      child: rows.isEmpty
          ? SizedBox()
          : DataTable(
              columnSpacing: 0.0, // 열 간의 간격을 좁힘
              horizontalMargin: 0.0, // 셀 안의 간격을 좁힘
              dividerThickness: 0, // 구분선 두께
              headingRowHeight: 30,

              dataRowMinHeight: 20,
              dataRowMaxHeight: 30,

              border: const TableBorder(
                // horizontalInside: BorderSide(color: Colors.red, width: 2),
                // verticalInside: BorderSide(color: Colors.red, width: 2),
                // borderRadius: BorderRadius.circular(10),
                bottom: BorderSide(color: Colors.black45, width: 1),
                // top: BorderSide(color: Colors.white, width: 0.7),
                // left: BorderSide(color: Colors.white, width: 0.7),
                // right: BorderSide(color: Colors.white, width: 0.7),
              ),
              columns: List<DataColumn>.from(headers.map((e) => DataColumn(
                      label: Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                        Expanded(
                            child: Text(
                          e,
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                        )),
                        Container(
                          height: 1,
                          // width: 20,
                          color: Colors.black45,
                        )
                      ]))))),
              rows: [
                for (var row in rows)
                  DataRow(cells: [
                    for (var cell in row)
                      DataCell(Text(
                        cell?.toString() ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                      )),
                  ]),
              ],
            ),
    ));
  }

  Future<dynamic> _readClipboard() async {
    try {
      final clipboardText = await html.window.navigator.clipboard?.readText();
      if (clipboardText != null) {
        log('clipboard ' + clipboardText.toString());

        List<List<dynamic>> rows = [];
        List<String> lines = clipboardText.split('\n');
        log('lines ${lines.length}');
        for (String line in lines) {
          List<String> row = [];
          List<String> items = line.split('\t');
          for (String item in items) {
            row.add(item);
          }
          if (row.length == 4) {
            rows.add(row);
          }
        }
        log('rows ${rows.length} ${rows[0].length}');
        log('rows ${rows[0]}');
        if (rows.length > 0 && rows[0].length > 0) {
          return rows;
        }
      }
    } catch (e) {}
    Toast.show('잘못된 붙여넣기 데이터. 복사 방법을 확인해 주세요.');
  }

  Future<dynamic> _readExcelFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
        withData: true, // 웹에서 bytes 사용 가능하게 설정
      );

      if (result != null) {
        Uint8List? bytes = result.files.single.bytes; // 웹에서 bytes 가져오기
        if (bytes == null) {
          File file = File(result.files.single.path!);
          bytes = await file.readAsBytes();
        }

        if (bytes != null) {
          var excel = excelLib.Excel.decodeBytes(bytes);

          var sheet = excel.sheets[excel.sheets.keys.first]; // 첫 번째 시트 가져오기
          if (sheet != null) {
            List<List<dynamic>> rows = [];
            for (var row in sheet.rows) {
              rows.add(row.map((cell) => cell?.value).toList());
            }

            return rows;
          }
        }
      }
    } catch (e) {
      print("엑셀 파일 읽기 오류: $e");
    }
    return null;
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
        Text('주소 입력 방법을 선택해 주세요',
            style: Theme.of(context).textTheme.titleLarge),
        WidgetSelectItem(context,
            title: '저장된 엑셀 파일 선택',
            description: 'PC에 저장되어있는 xslx 파일을 선택해서 주소록을 불러옵니다.',
            isSelected: _uploadType == 'file',
            onTap: () => _callback('file')),
        WidgetSelectItem(context,
            title: '엑셀/구글독 내용을 복사해서 붙여넣기',
            description: '주소록 셀을 선택해서 복사하고 (ctrl + c) 붙여넣기를 통해 주소록을 불러옵니다.',
            isSelected: _uploadType == 'paste',
            onTap: () => _callback('paste')),
      ],
    );
  }

  List<List<dynamic>> getSummaryData() {
    Map<String, List<String>> map = {};

    for (var row in _rows) {
      // log('length ' + row.length.toString() + ' ' + row.toString());
      String key = '${row[0]}_${row[1]}';
      if (map[key] == null) {
        map[key] = [row[0].toString(), row[1].toString(), '0'];
      }
      map[key]![2] = (int.parse(map[key]![2]) + 1).toString();
    }

    List<List<dynamic>> summary = [];
    summary = map.values.toList();
    return summary;
  }
}
