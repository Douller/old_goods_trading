import 'package:event_bus/event_bus.dart';

final EventBus eventBus = EventBus();

class RefreshPublishPage {
  final bool isRefreshPublish;

  RefreshPublishPage(this.isRefreshPublish);
}

class BackHomePage {
  final bool backHomePage;

  BackHomePage(this.backHomePage);
}

class ChooseLocation {
  final String address;
  final String latitude;
  final String longitude;

  ChooseLocation(this.address, this.latitude, this.longitude);
}