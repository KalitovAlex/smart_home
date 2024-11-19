import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    'ru': {
      // Общие
      'home': 'Главная',
      'rooms': 'Комнаты',
      'settings': 'Настройки',
      'my_home': 'Мой дом',
      'my_rooms': 'Мои комнаты',
      
      // Сцены
      'scenes': 'Сцены',
      'morning_scene': 'Утренняя сцена',
      'night_scene': 'Ночная сцена',
      'devices_configured': 'устройств настроено',
      
      // Устройства
      'tv': 'Телевизор',
      'light': 'Освещение',
      'air_purifier': 'Очиститель воздуха',
      'other': 'Другое',
      'thermostat': 'Термостат',
      'speaker': 'Колонка',
      'security_camera': 'Камера',
      'smart_plug': 'Умная розетка',
      
      // Состояния
      'on': 'Вкл',
      'off': 'Выкл',
      'timer': 'Таймер',
      'ended': 'Завершен',
      'hours_short': 'ч',
      'minutes_short': 'м',
    },
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
} 