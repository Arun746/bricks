import 'urls.dart';

enum ConfigEnums { production, development, staging }

class Configs {
  static final String _currentStage = ConfigEnums.development.name;
  static Urls urls = _currentStage == ConfigEnums.production.name
      ? ProductionUrls()
      : _currentStage == ConfigEnums.development.name
          ? DevelopmentUrls()
          : StagingUrls();

  static String get baseUrl => urls.baseUrl;
  static String get googleWorkspaceWebhookUrl => urls.googleWorkspaceWebhookUrl;
  static String get currentStage => _currentStage;
}
