import 'package:pilistudy/http/live.dart';
import 'package:pilistudy/http/loading_state.dart';
import 'package:pilistudy/models/common/live_search_type.dart';
import 'package:pilistudy/models_new/live/live_search/data.dart';
import 'package:pilistudy/pages/common/common_list_controller.dart';
import 'package:pilistudy/pages/live_search/controller.dart';
import 'package:pilistudy/services/account_service.dart';
import 'package:get/get.dart';

class LiveSearchChildController
    extends CommonListController<LiveSearchData, dynamic> {
  LiveSearchChildController(this.controller, this.searchType);

  final LiveSearchController controller;
  final LiveSearchType searchType;

  AccountService accountService = Get.find<AccountService>();

  @override
  void checkIsEnd(int length) {
    switch (searchType) {
      case LiveSearchType.room:
        if (controller.counts.first != -1 &&
            length >= controller.counts.first) {
          isEnd = true;
        }
        break;
      case LiveSearchType.user:
        if (controller.counts[1] != -1 && length >= controller.counts[1]) {
          isEnd = true;
        }
        break;
    }
  }

  @override
  List? getDataList(response) {
    switch (searchType) {
      case LiveSearchType.room:
        controller.counts[searchType.index] = response.room?.totalRoom ?? 0;
        return response.room?.list;
      case LiveSearchType.user:
        controller.counts[searchType.index] = response.user?.totalUser ?? 0;
        return response.user?.list;
    }
  }

  @override
  Future<LoadingState<LiveSearchData>> customGetData() {
    return LiveHttp.liveSearch(
      isLogin: accountService.isLogin.value,
      page: page,
      keyword: controller.editingController.text,
      type: searchType,
    );
  }
}
