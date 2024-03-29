
import 'package:flutter/material.dart';
import 'package:minibus_easy/application.dart';
import 'package:minibus_easy/model/locale/global_translations.dart';
import 'package:minibus_easy/view/bus_route_page.dart';
import 'package:minibus_easy/view/main_navigation.dart';
import 'package:minibus_easy/view/numpad_page.dart';


void main() async {
  ///
  /// Initialization of the translations based on preferred language
  ///
  await locale.init();

  ///
  /// Launch the application
  ///
  runApp(
    Application(),
  );
}
