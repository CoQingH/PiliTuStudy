import 'package:pilistudy/pages/fav/article/view.dart';
import 'package:pilistudy/pages/fav/cheese/view.dart';
import 'package:pilistudy/pages/fav/note/view.dart';
import 'package:pilistudy/pages/fav/video/view.dart';
import 'package:flutter/material.dart';

enum FavTabType {
  video('视频', FavVideoPage()),
  article('专栏', FavArticlePage()),
  note('笔记', FavNotePage()),
  cheese('课堂', FavCheesePage());

  final String title;
  final Widget page;
  const FavTabType(this.title, this.page);
}
