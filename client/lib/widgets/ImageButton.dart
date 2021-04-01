import 'package:client/models/User.dart';
import 'package:client/utils/API.dart';
import 'package:client/utils/UserProvider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImageButtonController {
  late String fileName;
  late String url;
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
  String fileName = 'No file selected';

  void _choose(String token) async {
    setState(() {
      uploading = true;
    });

    PickedFile image = (await ImagePicker()
        .getImage(source: ImageSource.gallery, maxHeight: 320, maxWidth: 400))!;

    setState(() {
      file = PickedFile(image.path);
      fileName = file!.path.split('/').last;
      print(file.toString() + ' ' + fileName);
    });

    if (file != null)
      _upload(token, file!, fileName);
    else
      setState(() {
        uploading = false;
      });
  }

  void _upload(String token, PickedFile file, String name) async {
    Map<String, dynamic> response = await API().uploadFile(token, file, name);

    print("Result: $response");
    widget.controller.url = response['image'];
    widget.controller.fileName = name;

    setState(() {
      uploading = false;
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
          Text(
            fileName,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      // file == null ? SizedBox(height: 10) : Image.file(file)
    ]);
  }
}
