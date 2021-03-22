import 'package:flutter/material.dart';
import 'package:client/widgets/InputBox.dart';
import 'package:client/utils/stringValidator.dart';

// Google sign in:
// import 'package:google_sign_in/google_sign_in.dart';

// GoogleSignIn _googleSignIn = GoogleSignIn(
//   scopes: [
//     'email',
//     'https://www.googleapis.com/auth/contacts.readonly',
//   ],
// );

// Future<void> _handleSignIn() async {
//   try {
//     await _googleSignIn.signIn();
//   } catch (error) {
//     print(error);
//   }
// }

class Signup extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  Widget _buildGoogleSignOn() {
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
          print('Google Sign On Tapped');
        });
  }

  Widget _buildNameField() {
    return TextFormField(
      textInputAction: TextInputAction.next,
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

  Widget _buildEmailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
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

  Widget _buildPassowordField() {
    return TextFormField(
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

  Widget _buildConfirmPasswordField() {
    return TextFormField(
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

  Widget _buildSubmit(context) {
    return ElevatedButton(
      onPressed: () {
        var validated = _formKey.currentState?.validate() ?? false;
        if (validated) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Account successfuly created')));
        }
      },
      child: Text('Next'),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
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
