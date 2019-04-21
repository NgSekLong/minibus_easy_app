import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minibus_easy/model/locale/bloc_provider.dart';
import 'package:minibus_easy/model/locale/global_translations.dart';
import 'package:minibus_easy/model/locale/translations_bloc.dart';
import 'package:minibus_easy/view/main_navigation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

///
/// This Application provide two purpose:
/// 1. Load the translation library
/// 2. Asked for GPS. TODO: Evaluate if need to asked for GPS at this stage
///
class Application extends StatefulWidget {
  @override
  ApplicationState createState() => ApplicationState();
}

class ApplicationState extends State<Application> {
  TranslationsBloc translationsBloc;


  @override
  void initState() {
    super.initState();
    translationsBloc = TranslationsBloc();
  }

  @override
  void dispose() {
    translationsBloc?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // GPS Permission
    PermissionHandler().requestPermissions([PermissionGroup.location]);



    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return BlocProvider<TranslationsBloc>(
      bloc: translationsBloc,
      child: StreamBuilder<String>(
          stream: translationsBloc.currentLanguage,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            return MaterialApp(
              title: 'Minibus Easy',
              theme: ThemeData(
                // Define the default Brightness and Colors
                brightness: Brightness.light,
                primaryColor: Color(0xFFecd98b),
                accentColor: Colors.green,
                iconTheme:  IconThemeData(
                  color: Colors.white,
                ),
                bottomAppBarColor: Color(0xFFe7e2dd),
                indicatorColor: Colors.black,
                dividerColor: Colors.grey,
                buttonColor: Color(0xFFecd98b),
                buttonTheme: ButtonThemeData(
                  buttonColor: Color(0xFFecd98b), 
                ),




                // Define the default Font Family
                fontFamily: 'Montserrat',

                // Define the default TextTheme. Use this to specify the default
                // text styling for headlines, titles, bodies of text, and more.
                textTheme: TextTheme(
                  headline:
                      TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
                  title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
                  body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
                ),
              ),

              ///
              /// Multi lingual
              ///
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: locale.supportedLocales(),

              home: MainNavigation(),
            );
          }),
    );
  }
}
