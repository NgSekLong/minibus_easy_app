
class Bus {



  final String route_id;
  final String route_number;
  final String region;
  final String route_start_at_en;
  final String route_start_at_tc;
  final String route_end_at_en;
  final String route_end_at_tc;

  Bus({this.route_id, this.route_number, this.region, this.route_start_at_en, this.route_start_at_tc, this.route_end_at_en, this.route_end_at_tc});

  //factory Post.fromJson(Map<String, dynamic> json) {
  static List<Bus> fromJson(List<dynamic> jsons) {
    Map<String, dynamic> json = jsons[0];
    List<Bus> listOfPost = new List();

    for(json in jsons){

      Bus post =  Bus(
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
