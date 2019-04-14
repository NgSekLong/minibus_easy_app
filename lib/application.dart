import 'package:flutter/material.dart';
import 'package:minibus_easy/model/locale/bloc_provider.dart';
import 'package:minibus_easy/model/locale/global_translations.dart';
import 'package:minibus_easy/model/locale/translations_bloc.dart';
import 'package:minibus_easy/view/main_navigation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
    return BlocProvider<TranslationsBloc>(
      bloc: translationsBloc,
      child: StreamBuilder<String>(
          stream: translationsBloc.currentLanguage,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            return MaterialApp(
              title: 'Minibus Easy',

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
          }
      ),
    );
  }
}