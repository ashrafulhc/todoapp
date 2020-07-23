import 'package:todoapp/src/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/src/utils/colors.dart';

class SortDropdown extends StatelessWidget {
  final String currentValue;
  final List<String> itemList;
  final Function(String) onValueChange;

  SortDropdown({Key key, @required this.currentValue, @required this.itemList, @required this.onValueChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 32,
      padding: EdgeInsets.symmetric(horizontal: 0.0),
      decoration: BoxDecoration(
        //color: Color(0xfff8f8ff),
        color: Color(0x167b85da),
        borderRadius: BorderRadius.circular(41.0),
      ),
      child: Center(
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            items: itemList
                .map((value) => DropdownMenuItem(
              child: Row(
                children: <Widget>[
                  SizedBox(width: 35),
                  Text(value, style: DropdownTextStyle.primary,),
                  SizedBox(width: 19),
                ],
              ),
              value: value,
            ))
                .toList(),
            onChanged: (String value) {
              //TODO:
              onValueChange(value);
            },
            isExpanded: false,
            value: currentValue,
            icon: Icon(Icons.keyboard_arrow_down),
            iconDisabledColor: MyColors.primary,
          ),
        ),
      ),
    );
  }
}
