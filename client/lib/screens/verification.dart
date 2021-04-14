import 'package:client/models/User.dart';
import 'package:client/screens/landing.dart';
import 'package:client/utils/API.dart';
import 'package:client/utils/AuthProvider.dart';
import 'package:client/utils/RouteNames.dart';
import 'package:client/utils/UserProvider.dart';
import 'package:client/widgets/InputBox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Verification extends StatefulWidget {
  @override
  VerificationState createState() => new VerificationState();
}

class VerificationState extends State<Verification> {
  final _formKey = GlobalKey<FormState>();
  final _verify = TextEditingController();

  // Function to build and return a login field text box.
  Widget _buildVerificationField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.disabled,
      keyboardType: TextInputType.number,
      // Be sure to pass in the text controller to fields to grab their text.
      controller: _verify,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
        hintText: 'Verification code',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.only(left: 15.0),
      ),
      validator: (value) {
        if (value?.isEmpty ?? true)
          return 'Please enter your verification code';
        return null;
      },
    );
  }

  Future<Map<String, dynamic>> handleRequestCode(context) async {
    var result;
    String token = Provider.of<UserProvider>(context, listen: false).user.token;

    final Map<String, dynamic> responseData =
        await API().requestVerification(token);

    try {
      switch (responseData['code']) {
        case 200:
          result = {
            'status': true,
            'code': responseData['code'],
            'message': 'Sent a new verification email'
          };
          break;
        default:
          result = {
            'status': false,
            'code': responseData['code'],
            'message': 'Failed to send a new verification email'
          };
      }
    } catch (on, stacktrace) {
      result = {
        'status': false,
        'message':
            'Failed to send a new verification email: ${stacktrace.toString()}'
      };
    }

    return result;
  }

  Widget _buildRequestCode(context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(2),
        shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
      ),
      onPressed: () {
        handleRequestCode(context).then(
          (value) => ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(value['message']))),
        );
      },
      child: Text('Request a new verification code'),
    );
  }

  void handleSubmit(context) {
    User user = Provider.of<UserProvider>(context, listen: false).user;
    AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);

    auth
        .verify(_verify.text, user.token)
        .then((value) => {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(value['message']))),
              if (value['status'] == true)
                {
                  Navigator.pushNamedAndRemoveUntil(
                      context, RouteName.HOME, (_) => false)
                }
            })
        // ignore: return_of_invalid_type_from_catch_error
        .catchError((error) => {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(error.toString())))
            });
  }

  // Function to build and return a form submit button. This is critical to the
  // implementation of the InputBox class.
  Widget _buildSubmit(context) {
    return ElevatedButton(
      onPressed: () {
        var validated = _formKey.currentState?.validate() ?? false;
        if (validated) handleSubmit(context);
      },
      child: Text('Verify'),
    );
  }

  // Function called to build the widget in the center.
  Widget _buildCenter(context) {
    return Center(
      child: Container(
          width: 370,
          padding: EdgeInsets.all(15.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: InputBox(
              'Verify your account',
              <Widget>[
                _buildVerificationField(),
                _buildRequestCode(context),
                // request a new code button
              ],
              _formKey,
              _buildSubmit(context))),
    );
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    return auth.verificationStatus != Status.Verified
        ? SafeArea(
            child: Scaffold(
            body: Container(
              // Background image. I'm a bit annoyed how each screen reloads it.
              // Bounty for whoever can fix that
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/BackgroundBlurred.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[_buildCenter(context)],
              ),
            ),
          ))
        : Landing();
  }
}
