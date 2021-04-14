import 'package:client/utils/API.dart';
import 'package:client/utils/RouteNames.dart';
import 'package:client/widgets/InputBox.dart';
import 'package:flutter/material.dart';
import 'package:client/utils/StringValidator.dart';

enum Step { email, verification }

// This is the state of the ForgotPassword screen. This changes depending on
// the selectedStep. The function setState() forces an update of the widget.
class ForgotPasswordState extends State<ForgotPassword> {
  // Form key is important for implementation of the InputBox class and reading the
  // form's fields. It essentially attaches to each field.
  final _formKeyEmail = GlobalKey<FormState>();
  final _formKeyVerification = GlobalKey<FormState>();

  // TextEditingControllers allow for simple getters from the fields.
  final TextEditingController _email = TextEditingController();
  final TextEditingController _verification = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  // The current state of the widget.
  Step selectedStep = Step.email;

  String email = '';

  Widget _buildEmailField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.emailAddress,
      controller: _email,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
        hintText: 'Email',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.only(left: 15.0),
      ),
      validator: (value) {
        var empty = value?.isEmpty ?? true;
        if (empty) {
          return 'Please enter your email';
        } else if (!value.isValidEmail()) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  // Function to build and return a password field text box.
  Widget _buildPasswordField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textInputAction: TextInputAction.next,
      controller: _pass,
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.only(left: 15.0),
        border: OutlineInputBorder(),
        hintText: 'Password',
      ),
      validator: (value) {
        var empty = value?.isEmpty ?? true;
        if (empty) {
          return 'Please enter your password';
        } else if (!value.isValidPassword()) {
          return 'Please enter a password with at least eight characters';
        }
        return null;
      },
    );
  }

  // Function to build and return a confirm password field text box.
  Widget _buildConfirmPasswordField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textInputAction: TextInputAction.done,
      controller: _confirmPass,
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.only(left: 15.0),
        border: OutlineInputBorder(),
        hintText: 'Confirm password',
        // labelText: 'Name *',
      ),
      // The validator receives the text that the user has entered.
      validator: (value) {
        var empty = value?.isEmpty ?? true;
        if (empty) {
          return 'Please confirm your password';
        } else if (value != _pass.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  Widget _buildVerificationField() {
    return TextFormField(
      controller: _verification,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
        hintText: 'Verification',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.only(left: 15.0),
      ),
      validator: (value) {
        var empty = value?.isEmpty ?? true;
        if (empty) {
          return 'Please your verification code';
        }
        return null;
      },
    );
  }

  void verifyPasswordResult(Map<String, dynamic> responseData) {
    var result;
    try {
      switch (responseData['code']) {
        case 200:
          result = {'status': true, 'message': 'Password reset'};
          break;
        case 404:
          result = {'status': false, 'message': 'Email does not exist'};
          break;
        case 410:
          result = {'status': false, 'message': 'Verification code timed out'};
          break;
        case 500:
          result = {'status': false, 'message': 'Server error'};
          break;
        case 422:
          result = {
            'status': false,
            'message': 'No valid reset can be made for account'
          };
          break;
        default:
          result = {'status': false, 'message': responseData.toString()};
      }
    } catch (on, stacktrace) {
      result = {'status': false, 'message': stacktrace.toString()};
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(result['message'])));
    if (result['status'])
      Navigator.pushNamedAndRemoveUntil(context, RouteName.LOGIN, (_) => false);
  }

  // Important function called to handle submits of the pages. This function
  // will call the setState() on the widget depending on the current state.
  void handleSubmit(context) {
    switch (selectedStep) {
      // If we are currently on the email state...
      case Step.email:
        var validated = _formKeyEmail.currentState?.validate() ?? false;
        email = _email.text.trim();
        if (validated && email != '') {
          // ignore: return_of_invalid_type_from_catch_error
          API().sendPasswordReset(email).catchError((error) => {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(error)))
              });
          setState(() {
            selectedStep = Step.verification;
          });
        }
        break;
      // If we are currently on the verification state...
      case Step.verification:
        var validated = _formKeyVerification.currentState?.validate() ?? false;

        if (validated) {
          API()
              .verifyPasswordReset(email, _verification.text.trim(), _pass.text)
              .then((value) => {verifyPasswordResult(value)});
        }
        break;
    }
  }

  Widget _buildSubmit(context) {
    return ElevatedButton(
      onPressed: () {
        handleSubmit(context);
      },
      child: Text('Next'),
    );
  }

  Widget _buildInputBox(context) {
    switch (selectedStep) {
      case Step.email:
        return InputBox(
            'Find your Pantry Pal account',
            <Widget>[
              _buildEmailField(),
              SizedBox(height: 10),
            ],
            _formKeyEmail,
            _buildSubmit(context));
      case Step.verification:
        return InputBox(
            'Enter verification',
            <Widget>[
              _buildVerificationField(),
              SizedBox(height: 10),
              _buildPasswordField(),
              SizedBox(height: 10),
              _buildConfirmPasswordField(),
            ],
            _formKeyVerification,
            _buildSubmit(context));
    }
  }

  Widget _buildCenter(context) {
    return Center(
        child: Container(
      width: 370,
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: _buildInputBox(context),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
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
      ),
    );
  }
}

// This is the main function that returns the widget itself. It depends on the
// ForgotPasswordState class.
class ForgotPassword extends StatefulWidget {
  State<StatefulWidget> createState() => ForgotPasswordState();
}
