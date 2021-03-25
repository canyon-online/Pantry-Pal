import 'package:flutter/material.dart';

// This class build a container that holds form fields and displays a beautiful
// header and footer. Styled from the prototypes within the Figma.
// Admittedly this likely did not need to be a stateful widget. But it allows for
// the modification of itself in the future.
class InputBox extends StatefulWidget {
  final String title;
  final List<Widget> fields;
  final GlobalKey<FormState> _formKey;
  final Widget submit;

  // Constructor to require the title, fields, form key, and submit button.
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
    // Fancy and beautiful divider to make the form look nice :-)
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
    );
  }
}
