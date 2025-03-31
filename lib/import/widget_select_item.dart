import 'package:flutter/material.dart';

class WidgetSelectItem extends StatelessWidget {
  String title;
  String description;
  bool isSelected;
  Null Function() onTap;

  WidgetSelectItem(context,
      {required this.title,
      required this.description,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color selected =
        !isSelected ? Colors.black12 : Theme.of(context).primaryColor;
    return GestureDetector(
        onTap: onTap,
        child: Container(
          width: 400,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(width: 2, color: selected)),
          child: Row(
            spacing: 10,
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    description,
                    style: TextStyle(color: Colors.black54),
                  )
                ],
              )),
              Icon(Icons.check, color: selected)
            ],
          ),
        ));
  }
}
