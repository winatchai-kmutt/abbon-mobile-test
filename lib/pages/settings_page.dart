import 'package:abbon_mobile_test/utils/codegen_loader.g.dart';
import 'package:app_settings/app_settings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const Map<String, String> languagesMap = {
  "th": LocaleKeys.thaiLanguage,
  "en": LocaleKeys.englishLanguage,
};

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _onTapNotificationSettings() {
    AppSettings.openAppSettings(type: AppSettingsType.location);
  }

  void _changeLanguage(BuildContext context, Locale locale) async {
    await context.setLocale(locale);
  }

  String _langCodeToFullLanguage(String langCode) {
    return languagesMap[langCode] ?? langCode.toUpperCase();
  }

  void _onTapLanguage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(LocaleKeys.selectLanguage.tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(LocaleKeys.thaiLanguage.tr()),
                onTap: () {
                  _changeLanguage(context, Locale('th', 'TH'));
                  context.pop();
                },
              ),
              ListTile(
                title: Text(LocaleKeys.englishLanguage.tr()),
                onTap: () {
                  _changeLanguage(context, Locale('en', 'US'));
                  context.pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr(LocaleKeys.settingsPage)),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(LocaleKeys.language.tr()),
            subtitle: Text(
              _langCodeToFullLanguage(context.locale.languageCode).tr(),
            ),
            onTap: () {
              _onTapLanguage(context);
            },
          ),
          ListTile(
            title: Text(LocaleKeys.notification.tr()),
            onTap: _onTapNotificationSettings,
          ),
        ],
      ),
    );
  }
}
