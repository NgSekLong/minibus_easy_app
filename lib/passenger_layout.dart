import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minibus_easy/view/setting_page.dart';
import 'package:path/path.dart';

class PassengerLayout {


  getAppBar(context) {
    return AppBar(
      title: Row(children: <Widget>[
        //Text('Route List'),
        new Image.asset('assets/top_bar.jpeg', fit: BoxFit.cover),

      ]),
      backgroundColor: Color(0xFFecd98b),
      actions: <Widget>[
          PopupMenuButton<String>(
            icon: Icon(Icons.settings),
            onSelected: (String choice) {

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SettingsPage()),
              );
            },
            itemBuilder: (BuildContext context) {
              return ['Settings', 'Rate Us'].map((String value) {
                return PopupMenuItem<String> (
                  value: value,
                  child: Text(value),
                );
              }).toList();
            },
          )
      ],
    );
  }

  getBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 1, // this will be set when a new tab is tapped
      fixedColor: Colors.amber[900],

      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.location_on),
          title: Text('Map'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.line_weight),
          title: Text('Route List'),
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            title: Text('Bookmark')
        )
      ],
    );
  }
  void _popupMenuOnSelect(String choice, BuildContext context){
    if(choice == 'Settings'){

    }
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SettingsPage()),
    );
    print('Working');
  }
}