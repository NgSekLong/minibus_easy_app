import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:minibus_easy/model/locale/bloc_provider.dart';
import 'package:minibus_easy/model/locale/global_translations.dart';
import 'package:minibus_easy/model/locale/translations_bloc.dart';
import 'package:minibus_easy/view/bus_route_detail_navigation.dart';
import 'package:minibus_easy/model/bus.dart';
import 'package:minibus_easy/passenger_layout.dart';

import 'package:flutter/material.dart';

class Language {
  const Language(this.id, this.value);

  final String id;
  final String value;
}

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => new _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  List<DropdownMenuItem<Language>> _dropDownMenuItems;

  Language selectedLanguage;
  List<Language> languages = <Language>[
    const Language('en', 'English'),
    const Language('tc', '中文'),
  ];

  @override
  void initState() {

    super.initState();
    int index = langTextToId(locale.currentLanguage);

    _dropDownMenuItems = getDropDownMenuItems();

    selectedLanguage = _dropDownMenuItems[index].value;

  }


  List<DropdownMenuItem<Language>> getDropDownMenuItems() {
    List<DropdownMenuItem<Language>> items = new List();
    for (Language language in languages) {
      items.add(new DropdownMenuItem(
          value: language, child: new Text(language.value)));
    }
    return items;
  }

  int langTextToId(String text) {
    for (int i = 0; i < languages.length; i++) {
      Language language = languages[i];
      if (language.id == text) {
        return i;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    //
    // Retrieves the BLoC that handles the changes to the current language
    //
    final TranslationsBloc translationsBloc =
        BlocProvider.of<TranslationsBloc>(context);

    //
    // Retrieves the title of the page, from the translations
    //
    final String pageTitle = locale.text("page.title");


    //get currentLanguage => _locale == null ? '' : _locale.languageCode;

    return new Container(
        color: Colors.white,
        child: Scaffold(
          appBar: AppBar(
            title: Text(locale.text("pages.settings.title")),
          ),
          body: ListView(
            children: <Widget>[
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Text(locale.text("pages.settings.body.language")),
                    new Container(
                      padding: new EdgeInsets.all(16.0),
                    ),
                    new DropdownButton(
                      value: selectedLanguage,
                      items: getDropDownMenuItems(),
                      onChanged: (Language language) {
                        setState(() {
                          selectedLanguage = language;

                          translationsBloc.setNewLanguage(language.id);
                        });
                      },
                    ),
                  ],
                ),
              ),
              Divider()
            ],
          ),
        )
      );
  }

}
