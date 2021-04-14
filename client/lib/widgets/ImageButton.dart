import 'package:client/models/User.dart';
import 'package:client/utils/API.dart';
import 'package:client/utils/UserProvider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImageButtonController {
  String fileName = 'No file selected';
  String url = '/images/4bade9c7fb6df087d927e753f77ae354da950f3e.png';

  void clear() {
    fileName = 'No file selected';
    url = '/images/4bade9c7fb6df087d927e753f77ae354da950f3e.png';
  }
}

class ImageButton extends StatefulWidget {
  final ImageButtonController controller;
  ImageButton({required this.controller});

  @override
  ImageButtonState createState() => ImageButtonState();
}

class ImageButtonState extends State<ImageButton> {
  PickedFile? file;
  bool uploading = false;
  bool uploaded = false;

  @override
  void initState() {
    super.initState();
  }

  void _choose(String token) async {
    setState(() {
      uploading = true;
    });

    try {
      PickedFile image = (await ImagePicker().getImage(
          source: ImageSource.gallery, maxHeight: 320, maxWidth: 400))!;

      setState(() {
        file = PickedFile(image.path);
        widget.controller.fileName = file!.path.split('/').last;
      });
    } catch (on) {
      widget.controller.fileName = 'No file selected';
      file = null;
    }

    if (file != null)
      _upload(token, file!, widget.controller.fileName);
    else
      setState(() {
        uploading = false;
        uploaded = false;
      });
  }

  void _upload(String token, PickedFile file, String name) async {
    Map<String, dynamic> response = await API().uploadFile(token, file, name);

    widget.controller.url = response['image'];
    widget.controller.fileName = name;

    setState(() {
      uploading = false;
      uploaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context, listen: false).user;
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          uploading == true
              ? CircularProgressIndicator()
              : TextButton(
                  onPressed: () {
                    _choose(user.token);
                  },
                  child: Text('Choose Image'),
                ),
          SizedBox(width: 10.0),
          Flexible(
            child: Text(
              widget.controller.fileName,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      // file == null ? SizedBox(height: 10) : Image.file(file)
    ]);
  }
}
