import 'package:pilistudy/common/skeleton/msg_feed_top.dart';
import 'package:pilistudy/common/widgets/image/network_img_layer.dart';
import 'package:pilistudy/common/widgets/loading_widget/http_error.dart';
import 'package:pilistudy/common/widgets/refresh_indicator.dart';
import 'package:pilistudy/http/loading_state.dart';
import 'package:pilistudy/models/common/image_type.dart';
import 'package:pilistudy/models_new/blacklist/list.dart';
import 'package:pilistudy/pages/blacklist/controller.dart';
import 'package:pilistudy/utils/date_utils.dart';
import 'package:pilistudy/utils/global_data.dart';
import 'package:pilistudy/utils/storage_pref.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlackListPage extends StatefulWidget {
  const BlackListPage({super.key});

  @override
  State<BlackListPage> createState() => _BlackListPageState();
}

class _BlackListPageState extends State<BlackListPage> {
  final _blackListController = Get.put(BlackListController());

  @override
  void dispose() {
    if (_blackListController.loadingState.value.isSuccess) {
      final blackMids =
          _blackListController.loadingState.value.data
              ?.map((e) => e.mid!)
              .toSet() ??
          {};
      GlobalData().blackMids = blackMids;
      Pref.blackMids = blackMids;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Obx(
          () => Text(
            '黑名单管理${_blackListController.total.value == -1 ? '' : ': ${_blackListController.total.value}'}',
          ),
        ),
      ),
      body: refreshIndicator(
        onRefresh: _blackListController.onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _blackListController.scrollController,
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.viewPaddingOf(context).bottom + 100,
              ),
              sliver: Obx(
                () => _buildBody(_blackListController.loadingState.value),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(LoadingState<List<BlackListItem>?> loadingState) {
    late final style = TextStyle(color: Theme.of(context).colorScheme.outline);
    return switch (loadingState) {
      Loading() => SliverList.builder(
        itemCount: 12,
        itemBuilder: (context, index) => const MsgFeedTopSkeleton(),
      ),
      Success(:var response) =>
        response?.isNotEmpty == true
            ? SliverList.builder(
                itemCount: response!.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index == response.length - 1) {
                    _blackListController.onLoadMore();
                  }
                  final item = response[index];
                  return ListTile(
                    onTap: () => Get.toNamed('/member?mid=${item.mid}'),
                    leading: NetworkImgLayer(
                      width: 45,
                      height: 45,
                      type: ImageType.avatar,
                      src: item.face,
                    ),
                    title: Text(
                      item.uname!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                    subtitle: Text(
                      '添加时间: ${DateFormatUtils.format(item.mtime, format: DateFormatUtils.longFormatDs)}',
                      maxLines: 1,
                      style: style,
                      overflow: TextOverflow.ellipsis,
                    ),
                    dense: true,
                    trailing: TextButton(
                      onPressed: () => _blackListController.onRemove(
                        context,
                        index,
                        item.uname,
                        item.mid,
                      ),
                      child: const Text('移除'),
                    ),
                  );
                },
              )
            : HttpError(onReload: _blackListController.onReload),
      Error(:var errMsg) => HttpError(
        errMsg: errMsg,
        onReload: _blackListController.onReload,
      ),
    };
  }
}
