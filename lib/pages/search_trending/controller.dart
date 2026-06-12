import 'package:pilistudy/http/loading_state.dart';
import 'package:pilistudy/http/search.dart';
import 'package:pilistudy/models_new/search/search_trending/data.dart';
import 'package:pilistudy/models_new/search/search_trending/list.dart';
import 'package:pilistudy/pages/common/common_list_controller.dart';

class SearchTrendingController
    extends CommonListController<SearchTrendingData, SearchTrendingItemModel> {
  int topCount = 0;

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  List<SearchTrendingItemModel>? getDataList(SearchTrendingData response) {
    List<SearchTrendingItemModel> topList =
        response.topList ?? <SearchTrendingItemModel>[];
    topCount = topList.length;
    return response.list == null ? topList : topList
      ..addAll(response.list ?? []);
  }

  @override
  Future<LoadingState<SearchTrendingData>> customGetData() =>
      SearchHttp.searchTrending();
}
