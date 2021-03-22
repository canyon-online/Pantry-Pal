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
  Widget _buildForm() {
    return Form(
      key: widget._formKey,
      child: Column(
        children: widget.fields,
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      widget.title,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [widget.submit],
    );
  }

  @override
  Widget build(BuildContext context) {
    const div = Divider(height: 20, thickness: 2);

    return Container(
      width: 370,
      child: Column(children: <Widget>[
        _buildHeader(),
        div,
        _buildForm(),
        div,
        _buildFooter()
      ]),
      // padding: EdgeInsets.all(15.0),
      // decoration: BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.all(Radius.circular(10))),
    );
  }
}
