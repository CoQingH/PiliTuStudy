import 'package:pilistudy/common/widgets/dialog/dialog.dart';
import 'package:pilistudy/common/widgets/loading_widget/http_error.dart';
import 'package:pilistudy/common/widgets/refresh_indicator.dart';
import 'package:pilistudy/http/loading_state.dart';
import 'package:pilistudy/models_new/space/space_cheese/item.dart';
import 'package:pilistudy/pages/fav/cheese/controller.dart';
import 'package:pilistudy/pages/member_cheese/widgets/item.dart';
import 'package:pilistudy/utils/grid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavCheesePage extends StatefulWidget {
  const FavCheesePage({super.key});

  @override
  State<FavCheesePage> createState() => _FavCheesePageState();
}

class _FavCheesePageState extends State<FavCheesePage>
    with AutomaticKeepAliveClientMixin, GridMixin {
  final FavCheeseController _controller = Get.put(FavCheeseController());

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ThemeData theme = Theme.of(context);
    return refreshIndicator(
      onRefresh: _controller.onRefresh,
      child: CustomScrollView(
        controller: _controller.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(
              top: 7,
              bottom: MediaQuery.viewPaddingOf(context).bottom + 100,
            ),
            sliver: Obx(
              () => _buildBody(theme, _controller.loadingState.value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
    ThemeData theme,
    LoadingState<List<SpaceCheeseItem>?> loadingState,
  ) {
    return switch (loadingState) {
      Loading() => gridSkeleton,
      Success(:var response) =>
        response?.isNotEmpty == true
            ? SliverGrid.builder(
                gridDelegate: gridDelegate,
                itemBuilder: (context, index) {
                  if (index == response.length - 1) {
                    _controller.onLoadMore();
                  }
                  final item = response[index];
                  return MemberCheeseItem(
                    item: item,
                    onRemove: () => showConfirmDialog(
                      context: context,
                      title: '确定取消收藏该课堂？',
                      onConfirm: () =>
                          _controller.onRemove(index, item.seasonId),
                    ),
                  );
                },
                itemCount: response!.length,
              )
            : HttpError(onReload: _controller.onReload),
      Error(:var errMsg) => HttpError(
        errMsg: errMsg,
        onReload: _controller.onReload,
      ),
    };
  }
}
