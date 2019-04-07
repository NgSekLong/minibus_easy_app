import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PassengerLayout {


  getAppBar() {
    return AppBar(
      title: Row(children: <Widget>[
        //Text('Route List'),
        new Image.asset('assets/top_bar.jpeg', fit: BoxFit.cover),

      ]),
      backgroundColor: Color(0xFFecd98b),
      actions: <Widget>[
          PopupMenuButton<String>(
            icon: Icon(Icons.settings),
            onSelected: _popupMenuOnSelect,
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
  void _popupMenuOnSelect(String choice){
    print('Working');
  }
}