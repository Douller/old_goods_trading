class VersionModel {
  String? appVersionName;
  String? appVersionDesc;
  String? appVersion;
  String? appDownloadAndroid;
  String? appDownloadIos;

  VersionModel(
      {this.appVersionName,
        this.appVersionDesc,
        this.appVersion,
        this.appDownloadAndroid,
        this.appDownloadIos});

  VersionModel.fromJson(Map<String, dynamic> json) {
    appVersionName = json['app_version_name'];
    appVersionDesc = json['app_version_desc'];
    appVersion = json['app_version'];
    appDownloadAndroid = json['app_download_android'];
    appDownloadIos = json['app_download_ios'];
  }
}
