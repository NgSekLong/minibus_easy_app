import 'package:flutter/material.dart';
import 'package:minibus_easy/model/globals.dart';
import 'package:minibus_easy/view/main_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('PUT THE IMAGE HERE'),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Username:'),
                  TextField(),

                  Text('Password:'),
                  TextField(

                  ),
                  SizedBox(
                    width: double.infinity,
                    child: new RaisedButton(
                      child: Text('Sign'),
                      onPressed: () async {

                        final SharedPreferences prefs = await SharedPreferences.getInstance();

                        prefs.setString(CURRENT_USER_ROLE_PREF, CURRENT_USER_ROLE_PREF_DRIVER);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 60)
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
