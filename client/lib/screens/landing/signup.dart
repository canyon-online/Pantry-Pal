import 'package:client/utils/AuthProvider.dart';
import 'package:client/utils/routeNames.dart';
import 'package:flutter/material.dart';
import 'package:client/widgets/InputBox.dart';
import 'package:client/utils/stringValidator.dart';

class Signup extends StatelessWidget {
  // Form key is important for implementation of the InputBox class and reading the
  // form's fields. It essentially attaches to each field.
  final _formKey = GlobalKey<FormState>();

  // TextEditingControllers allow for simple getters from the fields.
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  // Function to build and return a Google Sign On button.
  Widget _buildGoogleSignOn() {
    // An InkWell object is sort of a fancy button that has a little splash
    // animation to it.
    return InkWell(
        child: Container(
            width: 200,
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.black),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  height: 30.0,
                  width: 30.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/google.jpg'),
                        fit: BoxFit.cover),
                    shape: BoxShape.circle,
                  ),
                ),
                Text(
                  'Sign up with Google',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ))),
        onTap: () async {
          // TODO: Apply Google signup.
          print('Google Sign Up Tapped');
        });
  }

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
  Widget _buildPassowordField() {
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

  // Function to build and return a form submit button. This is critical to the
  // implementation of the InputBox class.
  Widget _buildSubmit(context) {
    return ElevatedButton(
      onPressed: () {
        var validated = _formKey.currentState?.validate() ?? false;
        // If the form is valid, then execute the following code. This is where
        // the user will get signed up and logged in, by calling the createUser
        // function. The function returns a Future object, which may be used in
        // implementing spining loading wheel objects and such.
        if (validated) {
          AuthProvider()
              .signup(_name.text, _email.text, _pass.text)
              .then((value) => {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(value['message']))),
                    if (value['status'] == true)
                      Navigator.pushNamed(context, RouteName.HOME)
                  })
              .catchError((error) => {
                    print(error),
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('error')))
                  });
        }
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
                _buildPassowordField(),
                SizedBox(height: 10),
                _buildConfirmPasswordField(),
                SizedBox(height: 15),
                Text('Or'),
                SizedBox(height: 15),
                _buildGoogleSignOn()
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
              image: AssetImage("assets/images/BackgroundBlurred.jpg"),
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
