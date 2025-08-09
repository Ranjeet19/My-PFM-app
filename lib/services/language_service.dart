import 'package:flutter/material.dart';

class LanguageService extends ChangeNotifier {
  String _selectedLanguage = 'English';
  String get selectedLanguage => _selectedLanguage;

  // This is a placeholder translation map for demo purposes
  final Map<String, Map<String, String>> _translations = {
    'English': {
      'finance_tracker': 'Finance Tracker',
      'goals': 'Goals',
      'quiz': 'Quiz',
      'quotes': 'Quotes',
    },
    'Nepali': {
      'finance_tracker': 'वित्त ट्र्याकर',
      'goals': 'लक्ष्यहरू',
      'quiz': 'क्विज',
      'quotes': 'उद्धरणहरू',
    },
    'Hindi': {
      'finance_tracker': 'वित्त ट्रैकर',
      'goals': 'लक्ष्य',
      'quiz': 'क्विज',
      'quotes': 'उद्धरण',
    },
    'Spanish': {
      'finance_tracker': 'Rastreador de Finanzas',
      'goals': 'Metas',
      'quiz': 'Cuestionario',
      'quotes': 'Citas',
    },
    'French': {
      'finance_tracker': 'Suivi Financier',
      'goals': 'Objectifs',
      'quiz': 'Quiz',
      'quotes': 'Citations',
    },
    'Chinese': {
      'finance_tracker': '财务跟踪器',
      'goals': '目标',
      'quiz': '测验',
      'quotes': '名言',
    },
  };

  void changeLanguage(String language) {
    _selectedLanguage = language;
    notifyListeners();
  }

  String t(String key) {
    return _translations[_selectedLanguage]?[key] ?? key;
  }
}
