import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RefreshWidget extends StatefulWidget {
  final Widget child;
  final Future Function() onRefresh;

  const RefreshWidget({Key? key, required this.child, required this.onRefresh})
      : super(key: key);

  @override
  _RefreshWidgetState createState() => _RefreshWidgetState();
}

class _RefreshWidgetState extends State<RefreshWidget> {
  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid ? buildAndroidList() : buildIOSList();
  }

  Widget buildAndroidList() {
    return RefreshIndicator(onRefresh: widget.onRefresh, child: widget.child);
  }

  Widget buildIOSList() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: widget.onRefresh,
        ),
        SliverToBoxAdapter(child: widget.child),
      ],
    );
  }
}
