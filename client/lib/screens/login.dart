import 'package:client/utils/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:client/utils/AuthProvider.dart';
import 'package:client/utils/RouteNames.dart';
import 'package:client/widgets/InputBox.dart';
import 'package:client/utils/StringValidator.dart';
import 'package:provider/provider.dart';

// Login page class that extends stateless widget because it won't change itself.
class Login extends StatelessWidget {
  // Form key is important for implementation of the InputBox class and reading the
  // form's fields. It essentially attaches to each field.
  final _formKey = GlobalKey<FormState>();

  // TextEditingControllers allow for simple getters from the fields.
  final TextEditingController _login = TextEditingController();
  final TextEditingController _pass = TextEditingController();

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
                  'Sign in with Google',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ))),
        onTap: () async {
          // TODO: Apply Google signin.
          print('Google Sign On Tapped');
        });
  }

  // Function to build and return a signup link button.
  Widget _buildSignupLink(context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(2),
        shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
      ),
      onPressed: () {
        Navigator.pushNamed(context, RouteName.SIGNUP);
      },
      child: Text('Sign up for Pantry Pal'),
    );
  }

  // Function to build and return a login field text box.
  Widget _buildLoginField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.emailAddress,
      // Be sure to pass in the text controller to fields to grab their text.
      controller: _login,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        hintText: 'Email or username',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.only(left: 15.0),
      ),
      validator: (value) {
        // The ? operator will not allow the access of the proceeding field if it
        // is null. The ?? operator will reassign null values to the proceeding value.
        var empty = value?.isEmpty ?? true;
        if (empty) {
          return 'Please enter your email or username';
        } else if (!value.isValidEmail() && !value.isValidName()) {
          return 'Please enter a valid email or username';
        }
        return null;
      },
    );
  }

  // Function to build and return a password field text box.
  Widget _buildPasswordField() {
    return TextFormField(
      textInputAction: TextInputAction.done,
      obscureText: true,
      controller: _pass,
      enableSuggestions: false,
      autocorrect: false,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.only(left: 15.0),
        hintText: 'Password',
        border: OutlineInputBorder(),
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

  // Function to build and return a "forgot password" button.
  Widget _buildForgotPasswordLink(context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(10),
        shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
      ),
      onPressed: () {
        Navigator.pushNamed(context, RouteName.FORGOTPASSWORD);
      },
      child: Text('Forgot my password'),
    );
  }

  // Function to build and return a form submit button. This is critical to the
  // implementation of the InputBox class.
  Widget _buildSubmit(context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    return ElevatedButton(
      onPressed: () {
        var validated = _formKey.currentState?.validate() ?? false;
        // If the form is valid, then execute the following code. This is where
        // the user will get logged in, by calling the loginUser function. The function
        // returns a Future object, which may be used in implementing spining loading
        // wheel objects and such.
        if (validated) {
          auth
              .login(_login.text, _pass.text)
              .then((value) => {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(value['message']))),
                    if (value['status'] == true)
                      {
                        print('setting user in login: ' + value['user'].name),
                        Provider.of<UserProvider>(context, listen: false)
                            .setUser(value['user']),
                        Navigator.pushNamedAndRemoveUntil(
                            context, RouteName.HOME, (_) => false)
                      }
                  })
              .catchError((error) => {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(error.toString())))
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
      // The InputBox field is essentially the entire form.
      child: InputBox(
          // Name of the form
          'Log in to Pantry Pal',
          // What widgets to display in the form.
          <Widget>[
            _buildLoginField(),
            SizedBox(height: 10),
            _buildPasswordField(),
            SizedBox(height: 15),
            Text('Or'),
            SizedBox(height: 15),
            _buildGoogleSignOn(),
            SizedBox(height: 10),
            // Additional button links to signup/password screens.
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _buildSignupLink(context),
              _buildForgotPasswordLink(context)
            ])
          ],
          // Attach the form key to the InputBox.
          _formKey,
          // Attach the submit button to the InputBox.

          // auth.loggedInStatus == Status.Authenticating
          //     ? loading
          //     : longButtons("Login", doLogin),
          _buildSubmit(context)),
    ));
  }

  // This function is called to build the actual Login widget itself.
  @override
  Widget build(BuildContext context) {
    // Always wrap screens in a safe area and a scaffold. The safearea prevents
    // parts of the screen getting clipped from the shape of the device,
    // and the scaffold allows for use of objects such as drawers.
    return SafeArea(
      child: Scaffold(
        body: Container(
          // Background image. I'm a bit annoyed how each screen reloads it.
          // Bounty for whoever can fix that.
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
