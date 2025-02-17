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
              const Divider(height: 0),
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
          Divider(color: Colors.white30),
          ListTile(
            leading: Icon(Icons.language),
            title: Text(LocaleKeys.language.tr()),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.amber,
            ),
            subtitle: Text(
              _langCodeToFullLanguage(context.locale.languageCode).tr(),
            ),
            onTap: () {
              _onTapLanguage(context);
            },
          ),
          Divider(color: Colors.white30),
          ListTile(
            leading: Icon(Icons.notifications_active),
            title: Text(LocaleKeys.notification.tr()),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.amber,
            ),
            onTap: _onTapNotificationSettings,
          ),
          Divider(color: Colors.white30),
        ],
      ),
    );
  }
}
