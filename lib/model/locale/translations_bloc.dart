import 'package:minibus_easy/model/locale/bloc_provider.dart';
import 'package:minibus_easy/model/locale/global_translations.dart';
import 'package:minibus_easy/model/locale/preferences.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _kDefaultLanguageName = 'en';

class TranslationsBloc implements BlocBase {
  BehaviorSubject<String> _languageController = BehaviorSubject<String>();
  Stream<String> get currentLanguage => _languageController;

  TranslationsBloc(){
    _init();
  }

  void _init() async {
    String languageName = await preferences.getPreferredLanguage();
    if (languageName == ''){
      languageName = _kDefaultLanguageName;
    }
    _languageController.sink.add(languageName);
  }

  @override
  void dispose() {
    _languageController?.close();
  }

  void setNewLanguage(String newLanguage) async {
    // Save the selected language as a user preference
    await preferences.setPreferredLanguage(newLanguage);

    // Notification the translations module about the new language
    await locale.setNewLanguage(newLanguage);

    _languageController.sink.add(newLanguage);
  }
}
