import 'package:pilistudy/http/loading_state.dart';
import 'package:pilistudy/http/video.dart';
import 'package:pilistudy/models/model_hot_video_item.dart';
import 'package:pilistudy/pages/common/common_list_controller.dart';
import 'package:pilistudy/utils/storage_pref.dart';
import 'package:get/get.dart';

class HotController
    extends CommonListController<List<HotVideoItemModel>, HotVideoItemModel> {
  final RxBool showHotRcmd = Pref.showHotRcmd.obs;

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  Future<LoadingState<List<HotVideoItemModel>>> customGetData() =>
      VideoHttp.hotVideoList(
        pn: page,
        ps: 20,
      );
}
