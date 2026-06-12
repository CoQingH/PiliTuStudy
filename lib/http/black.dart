import 'package:pilistudy/http/api.dart';
import 'package:pilistudy/http/init.dart';
import 'package:pilistudy/http/loading_state.dart';
import 'package:pilistudy/models_new/blacklist/data.dart';
import 'package:pilistudy/utils/accounts.dart';

class BlackHttp {
  static Future<LoadingState<BlackListData>> blackList({
    required int pn,
    int ps = 50,
  }) async {
    var res = await Request().get(
      Api.blackLst,
      queryParameters: {
        'pn': pn,
        'ps': ps,
        're_version': 0,
        'jsonp': 'jsonp',
        'csrf': Accounts.main.csrf,
      },
    );
    if (res.data['code'] == 0) {
      return Success(BlackListData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }
}
