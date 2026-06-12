import 'package:pilistudy/common/skeleton/msg_feed_top.dart';
import 'package:pilistudy/common/widgets/dialog/dialog.dart';
import 'package:pilistudy/common/widgets/image/network_img_layer.dart';
import 'package:pilistudy/common/widgets/loading_widget/http_error.dart';
import 'package:pilistudy/common/widgets/refresh_indicator.dart';
import 'package:pilistudy/common/widgets/view_sliver_safe_area.dart';
import 'package:pilistudy/http/loading_state.dart';
import 'package:pilistudy/models/common/image_type.dart';
import 'package:pilistudy/models_new/fans/list.dart';
import 'package:pilistudy/pages/fan/controller.dart';
import 'package:pilistudy/pages/share/view.dart' show UserModel;
import 'package:pilistudy/services/account_service.dart';
import 'package:pilistudy/utils/grid.dart';
import 'package:pilistudy/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FansPage extends StatefulWidget {
  const FansPage({
    super.key,
    this.mid,
    this.onSelect,
  });

  final int? mid;
  final ValueChanged<UserModel>? onSelect;

  @override
  State<FansPage> createState() => _FansPageState();
}

class _FansPageState extends State<FansPage> {
  late int mid;
  String? name;
  late bool isOwner;
  late FansController _fansController;

  @override
  void initState() {
    super.initState();
    AccountService accountService = Get.find<AccountService>();
    late final mid = Get.parameters['mid'];
    this.mid =
        widget.mid ?? (mid != null ? int.parse(mid) : accountService.mid);
    isOwner = this.mid == accountService.mid;
    name = Get.parameters['name'] ?? accountService.name.value;
    _fansController = Get.put(
      FansController(this.mid),
      tag: Utils.makeHeroTag(this.mid),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: widget.mid != null
          ? null
          : AppBar(title: Text(isOwner ? '我的粉丝' : '$name的粉丝')),
      body: refreshIndicator(
        onRefresh: _fansController.onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _fansController.scrollController,
          slivers: [
            ViewSliverSafeArea(
              sliver: Obx(
                () => _buildBody(theme, _fansController.loadingState.value),
              ),
            ),
          ],
        ),
      ),
    );
  }

  late final gridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: Grid.smallCardWidth * 2,
    mainAxisExtent: 66,
  );

  Widget _buildBody(
    ColorScheme theme,
    LoadingState<List<FansItemModel>?> loadingState,
  ) {
    return switch (loadingState) {
      Loading() => SliverGrid.builder(
        gridDelegate: gridDelegate,
        itemBuilder: (context, index) => const MsgFeedTopSkeleton(),
        itemCount: 16,
      ),
      Success(:var response) =>
        response?.isNotEmpty == true
            ? SliverGrid.builder(
                gridDelegate: gridDelegate,
                itemBuilder: (context, index) {
                  if (index == response.length - 1) {
                    _fansController.onLoadMore();
                  }
                  return _buildItem(theme, index, response[index]);
                },
                itemCount: response!.length,
              )
            : HttpError(onReload: _fansController.onReload),
      Error(:var errMsg) => HttpError(
        errMsg: errMsg,
        onReload: _fansController.onReload,
      ),
    };
  }

  Widget _buildItem(ColorScheme theme, int index, FansItemModel item) {
    return SizedBox(
      height: 66,
      child: InkWell(
        onTap: () {
          if (widget.onSelect != null) {
            widget.onSelect!(
              UserModel(
                mid: item.mid!,
                name: item.uname!,
                avatar: item.face!,
              ),
            );
            return;
          }
          Get.toNamed('/member?mid=${item.mid}');
        },
        onLongPress: widget.onSelect != null
            ? null
            : isOwner
            ? () => showConfirmDialog(
                context: context,
                title: '确定移除 ${item.uname} ？',
                onConfirm: () => _fansController.onRemoveFan(index, item.mid!),
              )
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          child: Row(
            spacing: 10,
            children: [
              NetworkImgLayer(
                width: 45,
                height: 45,
                type: ImageType.avatar,
                src: item.face,
              ),
              Column(
                spacing: 3,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.uname!,
                    style: const TextStyle(fontSize: 14),
                  ),
                  if (item.sign != null)
                    Text(
                      item.sign!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13, color: theme.outline),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
