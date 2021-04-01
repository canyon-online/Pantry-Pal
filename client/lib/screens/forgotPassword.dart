import 'package:client/utils/API.dart';
import 'package:client/widgets/InputBox.dart';
import 'package:flutter/material.dart';
import 'package:client/utils/StringValidator.dart';

// This screen is stateful becuase it changes the contents of itself depending
// on user interaction. The first stage involves providing an email, the seconds
// a verification password, and the last (and TODO) a page to update the password.
enum Step { email, verification, login }

// This is the state of the ForgotPassword screen. This changes depending on
// the selectedStep. The function setState() forces an update of the widget.
class ForgotPasswordState extends State<ForgotPassword> {
  // Form key is important for implementation of the InputBox class and reading the
  // form's fields. It essentially attaches to each field.
  final _formKeyEmail = GlobalKey<FormState>();
  final _formKeyVerification = GlobalKey<FormState>();
  final _formKeyResetPassword = GlobalKey<FormState>();

  // TextEditingControllers allow for simple getters from the fields.
  final TextEditingController _email = TextEditingController();
  final TextEditingController _verification = TextEditingController();

  // The current state of the widget.
  Step selectedStep = Step.email;

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

  // Important function called to handle submits of the pages. This function
  // will call the setState() on the widget depending on the current state.
  void handleSubmit() {
    switch (selectedStep) {
      // If we are currently on the email state...
      case Step.email:
        var validated = _formKeyEmail.currentState?.validate() ?? false;
        if (validated) {
          API()
              .sendEmailVerification(_email.text)
              .then((value) => {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(value.toString())))
                  })
              .catchError((error) => {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(error)))
                  });

          // We won't always want to go to the next step. For examples, if the
          // email wasn't in the database. This is outside just for testing.
          setState(() {
            // TODO: Move this to the valid email section of emailUser.
            selectedStep = Step.verification;
          });
        }
        break;
      // If we are currently on the verification state...
      case Step.verification:
        var validated = _formKeyVerification.currentState?.validate() ?? false;
        if (validated) {
          // TODO: Verify the submitted code.
          setState(() {
            selectedStep = Step.login;
          });
        }
        break;
      case Step.login:
        var validated = _formKeyResetPassword.currentState?.validate() ?? false;
        if (validated) {
          // TODO: Patch password call, navigate to home/login screen.
        }
        break;
    }
  }

  Widget _buildSubmit(context) {
    return ElevatedButton(
      onPressed: () {
        handleSubmit();
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
            ],
            _formKeyVerification,
            _buildSubmit(context));
      case Step.login:
        return InputBox(
            'Enter verification',
            <Widget>[
              _buildVerificationField(),
              SizedBox(height: 10),
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
