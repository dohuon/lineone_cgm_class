import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PageComplete extends StatelessWidget {
  var _callback;

  String _key, _completeTitle, _completeDescription, _url;

  PageComplete(this._completeTitle, this._completeDescription, this._url,
      this._key, this._callback);

  @override
  Widget build(BuildContext context) {
    String url = '${_url}&key=${_key}';
    log('url ' + url);
    return Container(
        width: 400,
        child: Column(spacing: 20, mainAxisSize: MainAxisSize.max, children: [
          Text(_completeTitle, style: Theme.of(context).textTheme.bodyMedium),
          if (_key.isNotEmpty && _url.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: QrImageView(
                data: url,
                version: QrVersions.auto,
                size: 100.0,
              ),
              // Text(_code, style: Theme.of(context).textTheme.bodyLarge),
            ),
          Text(_completeDescription,
              style: Theme.of(context).textTheme.bodyMedium),
        ]));
  }
}
