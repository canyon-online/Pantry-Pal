import 'package:client/models/User.dart';
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(child: _buildLogoutButton(context)),
    );
  }
}
