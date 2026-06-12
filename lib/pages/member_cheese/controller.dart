import 'package:pilistudy/http/loading_state.dart';
import 'package:pilistudy/http/member.dart';
import 'package:pilistudy/models_new/space/space_cheese/data.dart';
import 'package:pilistudy/models_new/space/space_cheese/item.dart';
import 'package:pilistudy/pages/common/common_list_controller.dart';

class MemberCheeseController
    extends CommonListController<SpaceCheeseData, SpaceCheeseItem> {
  MemberCheeseController(this.mid);

  final int mid;

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  List<SpaceCheeseItem>? getDataList(SpaceCheeseData response) {
    isEnd = response.page?.next == false;
    return response.items;
  }

  @override
  Future<LoadingState<SpaceCheeseData>> customGetData() =>
      MemberHttp.spaceCheese(
        page: page,
        mid: mid,
      );
}
