import 'package:client/widgets/TextPill.dart';
import 'package:flutter/material.dart';

class TagFieldController {
  Set<String> list = Set();
}

class TagField extends StatefulWidget {
  final TagFieldController controller;
  TagField({required this.controller});

  @override
  TagFieldState createState() => TagFieldState();
}

class TagFieldState extends State<TagField> {
  final TextEditingController _tag = TextEditingController();

  Widget _buildTextField() {
    return TextFormField(
        keyboardType: TextInputType.text,
        controller: _tag,
        // textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          hintText: 'Enter a tag',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.only(left: 15.0),
        ));
  }

  @override
  build(BuildContext context) {
    return Container(
      child: Column(children: [
        Row(children: [
          Expanded(child: _buildTextField()),
          IconButton(
            icon: Icon(
              Icons.add,
              color: widget.controller.list.length < 3
                  ? Colors.black
                  : Colors.grey,
            ),
            tooltip: 'Add the selected tag',
            onPressed: () {
              setState(() {
                if (widget.controller.list.length < 3)
                  widget.controller.list.add(_tag.text);
                print(widget.controller.list);
              });
            },
          )
        ]),
        Container(
          height: widget.controller.list.length * 50 < 150
              ? widget.controller.list.length * 50
              : 150,
          child: ListView.builder(
              itemCount: widget.controller.list.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var item = widget.controller.list.elementAt(index);
                return Row(children: [
                  TextPill(item),
                  IconButton(
                    icon: const Icon(Icons.remove),
                    tooltip: 'Remove this tag',
                    onPressed: () {
                      setState(() {
                        widget.controller.list.remove(item);
                      });
                    },
                  )
                ]);
              }),
        )
      ]),
    );
  }
}
