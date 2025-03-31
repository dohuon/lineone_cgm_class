import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WidgetTitle extends StatelessWidget {
  String _title;
  bool? shrink;
  int? index;
  bool alignCenter;

  WidgetTitle(this._title, {this.shrink, this.index, this.alignCenter = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment:
            alignCenter ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          if (index != null) ...[
            ClipOval(
              child: Container(
                alignment: Alignment.center,
                width: 30,
                height: 30,
                color: Colors.green,
                child: Text(
                  (index).toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
          ],
          Text(
            _title,
            style: (shrink != null && shrink!)
                ? Theme.of(context).textTheme.titleMedium
                : Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}
