import 'package:flutter/material.dart';

import '../main.dart';

class WidgetNormalButton extends StatelessWidget {
  String label;
  var onTap;
  IconData? icon;
  double? verticalMargin;
  double? horizontalMargin;
  double verticalPadding;
  bool fillParent;
  bool outlined;

  WidgetNormalButton(this.label,
      {this.onTap,
      this.icon,
      this.verticalMargin,
      this.verticalPadding = 0,
      this.horizontalMargin,
      this.fillParent = false,
      this.outlined = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: fillParent ? double.infinity : null,
        // width: double.infinity,
        margin: EdgeInsets.symmetric(
            vertical: verticalMargin ?? 30, horizontal: horizontalMargin ?? 0),
        alignment: fillParent ? null : Alignment.center,
        child: ElevatedButton(
          style: ButtonStyle(
            // foregroundColor: outlined
            //     ? MaterialStateProperty.all<Color>(Colors.black)
            //     : MaterialStateProperty.all<Color>(Colors.white),
            shape: MaterialStateProperty.all(
              outlined
                  ? RoundedRectangleBorder(
                      side: BorderSide(
                          color: MyApp.colorMain,
                          width: 1,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(8),
                    )
                  : RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
            ),
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.disabled)) {
                return Colors.black26;
              }
              return outlined ? Colors.white : MyApp.colorMain;
            }),
            elevation: MaterialStateProperty.all(0), //Defines Elevation
          ),
          onPressed: onTap,
          child: Container(
              padding: EdgeInsets.symmetric(vertical: verticalPadding),
              child: RichText(
                  text: TextSpan(children: <InlineSpan>[
                if (icon != null)
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Padding(
                        padding: const EdgeInsets.only(right: 6.0, top: 1),
                        child: Icon(
                          icon,
                          color: Colors.white,
                        )),
                  ),
                TextSpan(
                    text: label,
                    style: TextStyle(
                        color: outlined ? MyApp.colorMain : Colors.white)),
              ]))),
          // Row(
          //     mainAxisSize: MainAxisSize.min,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       if (icon != null) Container(color: Colors.red, child: Icon(icon, )),
          //       SizedBox(width: 10),
          //       Container(
          //           color: Colors.blue,
          //           child: Text(label))
          //     ])
        ));
  }
}
