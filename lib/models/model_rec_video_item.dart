import 'package:PiliPlus/models/model_owner.dart';
import 'package:PiliPlus/models/model_video.dart';

abstract class BaseRecVideoItemModel extends BaseVideoItemModel {
  String? goto;
  String? uri;
  String? rcmdReason;

  // app推荐专属
  int? param;
  String? pgcBadge;
}

class RecVideoItemModel extends BaseRecVideoItemModel {
  RecVideoItemModel.fromJson(Map<String, dynamic> json) {
    aid = json["id"];
    bvid = json["bvid"];
    cid = json["cid"];
    goto = json["goto"];
    uri = json["uri"];
    cover = json["pic"];
    title = json["title"];
    duration = json["duration"];
    pubdate = json["pubdate"];
    owner = Owner.fromJson(json["owner"]);
    stat = Stat.fromJson(json["stat"]);
    isFollowed = json["is_followed"] == 1;
    desc = json["desc"] ?? json["description"];
    rcmdReason = json["rcmd_reason"]?['content'];
  }
}

// @HiveType(typeId: 2)
// class RcmdReason {
//   RcmdReason({
//     this.reasonType,
//     this.content,
//   });
// //   int? reasonType;
// //   String? content;
//
//   RcmdReason.fromJson(Map<String, dynamic> json) {
//     reasonType = json["reason_type"];
//     content = json["content"] ?? '';
//   }
// }
