import 'package:pantrypal/utils/AuthProvider.dart';
import 'package:pantrypal/utils/RouteNames.dart';
import 'package:pantrypal/utils/UserProvider.dart';
import 'package:pantrypal/widgets/GoogleSignIn.dart';
import 'package:flutter/material.dart';
import 'package:pantrypal/widgets/InputBox.dart';
import 'package:pantrypal/utils/StringValidator.dart';
import 'package:provider/provider.dart';

class Signup extends StatelessWidget {
  // Form key is important for implementation of the InputBox class and reading the
  // form's fields. It essentially attaches to each field.
  final _formKey = GlobalKey<FormState>();

  // TextEditingControllers allow for simple getters from the fields.
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  // Function to build and return a name field text box.
  Widget _buildNameField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textInputAction: TextInputAction.next,
      controller: _name,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.only(left: 15.0),
        border: OutlineInputBorder(),
        // icon: Icon(Icons.person),
        hintText: 'Name',
        // labelText: 'Name *',
      ),
      validator: (value) {
        var empty = value?.isEmpty ?? true;
        if (empty) {
          return 'Please enter your name';
        } else if (!value.isValidName()) {
          return 'Please enter a valid name';
        }
        return null;
      },
    );
  }

  // Function to build and return an email field text box.
  Widget _buildEmailField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.emailAddress,
      controller: _email,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.only(left: 15.0),
        border: OutlineInputBorder(),
        hintText: 'Email',
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

  void handleSubmit(context) {
    Provider.of<AuthProvider>(context, listen: false)
        .signup(_name.text, _email.text, _pass.text)
        .then((value) => {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(value['message']))),
              if (value['status'] == true)
                {
                  Provider.of<UserProvider>(context, listen: false)
                      .setUser(value['user']),
                  // Go to verification
                  Navigator.pushNamedAndRemoveUntil(
                      context, RouteName.VERIFICATION, (_) => false)
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
      child: Text('Next'),
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
              'Create your account',
              <Widget>[
                _buildNameField(),
                SizedBox(height: 10),
                _buildEmailField(),
                SizedBox(height: 10),
                _buildPasswordField(),
                SizedBox(height: 10),
                _buildConfirmPasswordField(),
                SizedBox(height: 15),
                Text('Or'),
                SizedBox(height: 15),
                GoogleSignIn()
              ],
              _formKey,
              _buildSubmit(context))),
    );
  }

  // This function is called to build the actual Signup widget itself.
  @override
  Widget build(BuildContext context) {
    // Always wrap screens in a safe area and a scaffold. The safearea prevents
    // parts of the screen getting clipped from the shape of the device,
    // and the scaffold allows for use of objects such as drawers.
    return SafeArea(
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
      ),
    );
  }
}
