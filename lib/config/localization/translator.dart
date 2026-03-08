import 'package:flutter/material.dart';

import 'dictionaries/english_dictionary.dart';
import 'dictionaries/ukrainian_dictionary.dart';

class Translator {
  late Map<String, String> _localizedStrings;

  bool load(String language) {
    if (language == 'en') {
      _localizedStrings = DictionaryEnglish.localizedStrings;
    } else if (language == 'uk') {
      _localizedStrings = DictionaryUkrainian.localizedStrings;
    } else {
      throw Exception('Локалізація для вибраної мови недоступна.');
    }
    return true;
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  static Translator of(BuildContext context) {
    return Localizations.of<Translator>(context, Translator)!;
  }

  static const LocalizationsDelegate<Translator> delegate =
      _TranslatorDelegate();
}

class _TranslatorDelegate extends LocalizationsDelegate<Translator> {
  const _TranslatorDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'uk'].contains(locale.languageCode);
  }

  @override
  Future<Translator> load(Locale locale) async {
    final Translator translator = Translator();
    translator.load(locale.languageCode);
    return translator;
  }

  @override
  bool shouldReload(_TranslatorDelegate old) => false;
}
