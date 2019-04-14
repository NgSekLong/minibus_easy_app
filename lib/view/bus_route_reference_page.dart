import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:minibus_easy/model/locale/global_translations.dart';

class BusRouteReferencePage extends StatelessWidget {
  final String route_id;
  //BusRouteReferencePage(Key key, this.route_id) : super(key:key);
  BusRouteReferencePage({this.route_id});


  @override
  Widget build(BuildContext context) {
    _launchURL(context);
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Scaffold(
        body: new Center(
          child: new FlatButton(
            child: new Text('Show Minibus price / info'),
            onPressed: () => _launchURL(context),
          ),
        ),
      ),
    );
  }



  void _launchURL(BuildContext context) async {
    try {
      var language = locale.currentLanguage.toString().toUpperCase();
      await launch(
        'http://hketransport.td.gov.hk/ris_page/get_gmb_detail.php?route_id='+route_id+'&lang='+language,
        option: new CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          animation: new CustomTabsAnimation.slideIn(),
          // or user defined animation.
        extraCustomTabs: <String>[
          // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
          'org.mozilla.firefox',
          // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
          'com.microsoft.emmx',
        ],
      ),
    );
    } catch (e) {
    // An exception is thrown if browser app is not installed on Android device.
    debugPrint(e.toString());
    }
  }
}
