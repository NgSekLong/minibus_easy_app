
class RouteDetail {



  final String stop_name_en;
  final String stop_name_tc;
  final int duration_sec;

  RouteDetail({this.stop_name_en, this.stop_name_tc, this.duration_sec});

  //factory Post.fromJson(Map<String, dynamic> json) {
  static List<RouteDetail> fromJson(List<dynamic> jsons) {
    //Map<String, dynamic> json = jsons[0];
    List<RouteDetail> listOfRouteDetail = new List();

    for(Map<String, dynamic> json in jsons){

      RouteDetail routeDetail =  RouteDetail(
        stop_name_en : json['stop_name_en'],
        stop_name_tc : json['stop_name_tc'],
        duration_sec : json['duration_sec'],

      );
      listOfRouteDetail.add(routeDetail);
    }
    return listOfRouteDetail;
  }
}
