import 'package:todoapp/src/components/show_flushbar/show_flushbar.dart';
import 'package:todoapp/src/utils/text_styles.dart';
import 'package:flutter/material.dart';

class AddCategoryDialog extends StatefulWidget {
  final text;

  const AddCategoryDialog({Key key, this.text}) : super(key: key);

  @override
  _AddCategoryDialogState createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    if( widget.text != null ) {
      _titleController.text = widget.text;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: _myDialog(context),
    );
  }

  Widget _myDialog(BuildContext context) {
    return Container(
      width: 282,
      height: 220,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 35, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Category Name',
              style: ButtonTextStyle.accent,
            ),
            SizedBox(
              height: 20,
            ),
            _titleTextField(),
            SizedBox(
              height: 36,
            ),
            Center(
              child: startText(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _titleTextField() {
    return new Container(
      width: 249,
      height: 42,
      decoration: new BoxDecoration(
        color: Color(0x167b85da),
        borderRadius: BorderRadius.circular(43),
      ),
      child: TextField(
        controller: _titleController,
        decoration: new InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding:
                EdgeInsets.only(left: 15, bottom: 11, top: 5, right: 15),
            hintText: ''),
      ),
    );
  }

  Widget startText(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Conversation title: ${_titleController.text}');
        String titleName = _titleController.text.trim();
        if (titleName == null || titleName == '') {
          ShowFlushbar.showFlushbar(context, 'Enter Title Name!', 1500);
          return;
        }
        Navigator.pop(context, titleName);
      },
      child: Text(
        "Done",
        style: ButtonTextStyle.accent,
      ),
    );
  }
}
