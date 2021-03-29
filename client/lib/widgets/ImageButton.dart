import 'dart:io';
import 'package:client/models/User.dart';
import 'package:client/utils/API.dart';
import 'package:client/utils/UserProvider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
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
  File? file;
  bool uploading = false;
  String fileName = 'No file selected';

  void _choose(String token) async {
    setState(() {
      uploading = true;
    });

    PickedFile image = (await ImagePicker()
        .getImage(source: ImageSource.gallery, maxHeight: 320, maxWidth: 400))!;

    setState(() {
      file = File(image.path);
      fileName = file!.path.split('/').last;
      print(file.toString() + ' ' + fileName);
    });

    if (file != null)
      _upload(file!, fileName, token);
    else
      setState(() {
        uploading = false;
      });
  }

  void _upload(File file, String name, String token) async {
    var request =
        http.MultipartRequest('POST', Uri.https(API.baseURL, API.imageUpload));
    request.headers
        .addAll({HttpHeaders.authorizationHeader: 'bearer ' + token});

    request.files.add(http.MultipartFile(
      'image',
      file.openRead(),
      await file.length(),
      filename: name,
      contentType: MediaType('image', 'jpeg'),
    ));

    http.Response response =
        await http.Response.fromStream(await request.send());

    print("Result: ${response.body}");
    widget.controller.url = json.decode(response.body)['image'];
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
      file == null ? SizedBox(height: 10) : Image.file(file!)
    ]);
  }
}
