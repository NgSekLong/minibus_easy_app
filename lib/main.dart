import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Post>> fetchPost() async {
  final response =
  await http.post('http://10.0.2.2:8000/list_bueses');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    List<Post> post = Post.fromJson(json.decode(response.body));
    return post;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class Post {



  final String route_id;
  final String route_number;
  final String region;
  final String route_start_at_en;
  final String route_start_at_tc;
  final String route_end_at_en;
  final String route_end_at_tc;

  Post({this.route_id, this.route_number, this.region, this.route_start_at_en, this.route_start_at_tc, this.route_end_at_en, this.route_end_at_tc});

  //factory Post.fromJson(Map<String, dynamic> json) {
  static List<Post> fromJson(List<dynamic> jsons) {
    Map<String, dynamic> json = jsons[0];
    List<Post> listOfPost = new List();

    for(json in jsons){

      Post post =  Post(
        route_id : json['route_id'],
        route_number : json['route_number'],
        region : json['region'],
        route_start_at_en : json['route_start_at_en'],
        route_start_at_tc : json['route_start_at_tc'],
        route_end_at_en : json['route_end_at_en'],
        route_end_at_tc : json['route_end_at_tc'],
      );
      listOfPost.add(post);
    }



    return listOfPost;
  }
}

void main() => runApp(MyApp(post: fetchPost()));

class MyApp extends StatelessWidget {
  final Future<List<Post>> post;

  MyApp({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Row(children: <Widget>[
            Text('Route List'),
            new Image.asset('assets/top_bar.jpeg', fit: BoxFit.cover),

          ]),
          //title: new Image.asset('assets/top_bar.jpeg', fit: BoxFit.cover),
          backgroundColor: Color(0xFFecd98b),
          //title: Text('Route List'),
        ),
        body: Center(
          child: FutureBuilder<List<Post>>(
            future: post,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Widget> listOfRow = new List();

                for(Post bus in snapshot.data){
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
      ),
    );
  }
}