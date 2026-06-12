import 'dart:math';

import 'package:pilistudy/http/live.dart';
import 'package:pilistudy/http/loading_state.dart';
import 'package:pilistudy/models_new/live/live_area_list/area_item.dart';
import 'package:pilistudy/pages/common/common_list_controller.dart';
import 'package:pilistudy/services/account_service.dart';
import 'package:get/get.dart';

class LiveAreaDatailController
    extends CommonListController<List<AreaItem>?, AreaItem> {
  LiveAreaDatailController(this.areaId, this.parentAreaId);
  final dynamic areaId;
  final dynamic parentAreaId;

  late int initialIndex = 0;

  AccountService accountService = Get.find<AccountService>();

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  List<AreaItem>? getDataList(List<AreaItem>? response) {
    if (response?.isNotEmpty == true) {
      initialIndex = max(0, response!.indexWhere((e) => e.id == areaId));
    }
    return response;
  }

  @override
  Future<LoadingState<List<AreaItem>?>> customGetData() =>
      LiveHttp.liveRoomAreaList(
        isLogin: accountService.isLogin.value,
        parentid: parentAreaId,
      );
}
