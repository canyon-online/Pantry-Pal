import 'package:flutter/material.dart';

// InputBox(
//   title: string,
//   _formKey: GlobalKey,
//   fields: List<Widget>
// ),

class InputBox extends StatefulWidget {
  final String title;
  final List<Widget> fields;
  final GlobalKey<FormState> _formKey;

  const InputBox(this.title, this.fields, this._formKey);

  @override
  InputBoxState createState() => InputBoxState();
}

class InputBoxState extends State<InputBox> {
  @override
  Widget build(BuildContext context) {
    // Here you direct access using widget
    // return Text(widget.clientName);
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
      children: [
        ElevatedButton(
          onPressed: () {
            // Validate returns true if the form is valid, otherwise false.
            var validated = widget._formKey.currentState?.validate() ?? false;
            if (validated) {
              // If the form is valid, display a snackbar. In the real world,
              // you'd often call a server or save the information in a database.
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Account successfuly created')));
            }
          },
          child: Text('Next'),
        )
      ],
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
