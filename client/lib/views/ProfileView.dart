import 'package:client/utils/API.dart';
import 'package:client/utils/AuthProvider.dart';
import 'package:client/utils/RouteNames.dart';
import 'package:client/utils/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  @override
  ProfileViewState createState() => ProfileViewState();
}

// Creates a state class relating to the addRecipeForm widget
class ProfileViewState extends State<ProfileView> {
  Widget _buildLogoutButton(context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    return ElevatedButton(
      onPressed: () {
        auth.logout();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Logged out')));
        Navigator.pushNamedAndRemoveUntil(
            context, RouteName.LANDING, (_) => false);
      },
      child: Text('Logout'),
    );
  }

  Widget _emailText(String token) {
    return FutureBuilder(
      future: API().getUserInfo(token),
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Padding(
                padding: EdgeInsets.all(10),
                child: CircularProgressIndicator());
          default:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}',
                  style: TextStyle(fontSize: 32));
            else {
              var data = Map.from(snapshot.data!);
              return Text('${data['email']}', style: TextStyle(fontSize: 20));
            }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context, listen: false).user;
    return SingleChildScrollView(
      child: Container(
          child: Column(children: [
        Text(user.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28)),
        SizedBox(height: 16),
        _emailText(user.token),
        SizedBox(height: 16),
        _buildLogoutButton(context),
      ])),
    );
  }
}
