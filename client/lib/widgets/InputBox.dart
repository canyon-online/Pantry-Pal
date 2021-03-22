import 'package:flutter/material.dart';

class InputBox extends StatefulWidget {
  final String title;
  final List<Widget> fields;
  final GlobalKey<FormState> _formKey;
  final Widget submit;

  const InputBox(this.title, this.fields, this._formKey, this.submit);

  @override
  InputBoxState createState() => InputBoxState();
}

class InputBoxState extends State<InputBox> {
  @override
  Widget build(BuildContext context) {
    var header = Text(
      widget.title,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );

    var form = Form(
      key: widget._formKey,
      child: Column(
        children: widget.fields,
      ),
    );

    var footer = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [widget.submit],
    );

    const div = Divider(height: 20, thickness: 2);

    return Container(
      width: 370,
      child: Column(children: <Widget>[header, div, form, div, footer]),
      // padding: EdgeInsets.all(15.0),
      // decoration: BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.all(Radius.circular(10))),
    );
  }
}
