import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minibus_easy/view/setting_page.dart';
import 'package:path/path.dart';

class PassengerLayout {
  getAppBar(BuildContext context) {
    return AppBar(
      title: Row(children: <Widget>[
        //Text('Route List'),
        new Image.asset('assets/top_bar.jpeg', fit: BoxFit.cover),
      ]),
      //backgroundColor: Color(0xFFecd98b),
      actions: <Widget>[
        PopupMenuButton<String>(

          icon: Icon(Icons.settings,color: Theme.of(context).iconTheme.color,),
          onSelected: (String choice) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
          },
          itemBuilder: (BuildContext context) {
            return ['Settings', 'Rate Us'].map((String value) {
              return PopupMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList();
          },
        )
      ],
    );
  }

//  getBottomNavigationBar() {
//    return BottomNavigationBar(
//      currentIndex: 1, // this will be set when a new tab is tapped
//      //fixedColor: Colors.amber[900],
//
//      items: [
//        BottomNavigationBarItem(
//          icon: Icon(Icons.location_on),
//          title: Text('Map'),
//        ),
//        BottomNavigationBarItem(
//          icon: Icon(Icons.line_weight),
//          title: Text('Route List'),
//        ),
//        BottomNavigationBarItem(
//            icon: Icon(Icons.bookmark_border),
//            title: Text('Bookmark')
//        )
//      ],
//    );
//  }

  getBottomNavigationBar(BuildContext context) {
    return new Theme(
      data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
          canvasColor: Colors.green,
          // sets the active color of the `BottomNavigationBar` if `Brightness` is light
          primaryColor: Colors.red,
          textTheme: Theme.of(context)
              .textTheme
              .copyWith(caption: new TextStyle(color: Colors.yellow))),
      // sets the inactive color of the `BottomNavigationBar`
      child: new BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        items: [
          new BottomNavigationBarItem(
            icon: new Icon(Icons.add),
            title: new Text("Add"),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.delete),
            title: new Text("Delete"),
          )
        ],
      ),
    );
  }

  void _popupMenuOnSelect(String choice, BuildContext context) {
    if (choice == 'Settings') {}
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsPage()),
    );
    print('Working');
  }
}
