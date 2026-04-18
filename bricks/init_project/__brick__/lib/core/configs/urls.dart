abstract class Urls {
  String get baseUrl;
  String get googleWorkspaceWebhookUrl;
}

class ProductionUrls implements Urls {
  @override
  String get baseUrl => "";

  @override
  String get googleWorkspaceWebhookUrl => "";
}

class DevelopmentUrls implements Urls {
  @override
  String get baseUrl => "https://devbolts.tenetsofficial.com/api/v1";

  @override
  String get googleWorkspaceWebhookUrl => "";
}

class StagingUrls implements Urls {
  @override
  String get baseUrl => "";

  @override
  String get googleWorkspaceWebhookUrl => "";
}
