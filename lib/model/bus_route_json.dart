

class BusRouteJson {
  final String stopNameEn;

  BusRouteJson({this.stopNameEn});

  factory BusRouteJson.fromJson(Map<String, dynamic> json) {
    return BusRouteJson(
      stopNameEn: json['stop_name_en']
    );
  }
}