import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:minibus_easy/model/bus.dart';

Future<List<Bus>> fetchPost() async {
  final response =
  await http.post('http://34.92.224.245:80/list_bueses');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    List<Bus> post = Bus.fromJson(json.decode(response.body));
    return post;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}



class BusRoutePage extends StatelessWidget {

  Future<List<Bus>> post;
  //BusRoutePage({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final post = fetchPost();
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Row(children: <Widget>[
          //Text('Route List'),
          new Image.asset('assets/top_bar.jpeg', fit: BoxFit.cover),

        ]),
        backgroundColor: Color(0xFFecd98b),
        actions: <Widget>[
//          PopupMenuButton<String>(
//
//            icon: Icon(Icons.settings),
//          )
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
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
      ),
      body: Center(
        child: FutureBuilder<List<Bus>>(
          future: post,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Widget> listOfRow = new List();

              for(Bus bus in snapshot.data){
                // bus.route_id
                String demoText = "route_id: ${bus.route_id}, Bus number: ${bus.route_number}, \nRegion: ${bus.region}, \n";
                demoText += "From '${bus.route_start_at_en}' to: '${bus.route_end_at_en}', \n'${bus.route_start_at_tc}' 到 '${bus.route_end_at_tc}'";
                ListTile listTile = new ListTile(
                  title: new Text(demoText),
                );
                listOfRow.add(listTile);
              }

              final List<Widget> divided = ListTile
                  .divideTiles(
                context: context,
                tiles: listOfRow,
                color: Colors.blue,
              ).toList();

              return ListView(children: divided);



            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

}
