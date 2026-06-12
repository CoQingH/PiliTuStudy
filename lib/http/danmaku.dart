import 'package:pilistudy/utils/accounts.dart';

class DanmakuHttp {
  static Future shootDanmaku({
    int type = 1,
    required int oid,
    required String msg,
    int mode = 1,
    required String bvid,
    int? progress,
    int? color,
    int? fontsize,
    int? pool,
    bool colorful = false,
    int? checkboxType,
  }) async {
    // 构建参数对象（保留原样，免得其他地方依赖）
    var data = <String, dynamic>{
      'type': type,
      'oid': oid,
      'msg': msg,
      'mode': mode,
      'bvid': bvid,
      'progress': progress,
      'color': colorful ? 16777215 : color,
      'fontsize': fontsize,
      'pool': pool,
      'rnd': DateTime.now().microsecondsSinceEpoch,
      'colorful': colorful ? 60001 : null,
      'checkbox_type': checkboxType,
      'csrf': Accounts.main.csrf,
    }..removeWhere((key, value) => value == null);

    // 真正的请求已经注释掉
    // var response = await Request().post(...)

    // 添加这一行，直接返回“弹幕功能已禁用”
    return {
      'status': false,
      'msg': '弹幕功能已禁用',
    };
  }
}
