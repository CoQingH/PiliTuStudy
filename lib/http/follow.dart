import 'package:pilistudy/http/api.dart';
import 'package:pilistudy/http/init.dart';
import 'package:pilistudy/http/loading_state.dart';
import 'package:pilistudy/models_new/follow/data.dart';

class FollowHttp {
  static Future<LoadingState<FollowData>> followings({
    int? vmid,
    int? pn,
    int ps = 20,
    String orderType = '', // ''=>最近关注，'attention'=>最常访问
  }) async {
    var res = await Request().get(
      Api.followings,
      queryParameters: {
        'vmid': vmid,
        'pn': pn,
        'ps': ps,
        'order': 'desc',
        'order_type': orderType,
      },
    );
    if (res.data['code'] == 0) {
      return Success(FollowData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }
}
