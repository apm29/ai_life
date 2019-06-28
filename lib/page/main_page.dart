import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;

import '../index.dart';
import 'home_page.dart';
import 'mine_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          return Future.delayed(Duration(seconds: 2));
        },
        child: Consumer<MainIndexModel>(
          builder: (BuildContext context, MainIndexModel value, Widget child) {
            switch (value.currentIndex) {
              case 0:
                return HomePage();
              case 1:
                return MinePage();
              default:
                throw ArgumentError("错误的主页索引-${value.currentIndex}");
            }
          },
        ),
      ),
      bottomNavigationBar: Consumer<MainIndexModel>(
        builder: (BuildContext context, MainIndexModel value, Widget child) {
          return BottomNavigationBar(
            currentIndex: value.currentIndex,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), title: Text("主页")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), title: Text("我的"))
            ],
            onTap: (index) {
              value.currentIndex = index;
            },
          );
        },
      ),
    );
  }
}

class FlexStatusBar extends SingleChildRenderObjectWidget {
  const FlexStatusBar(
      {Key key, @required this.maxHeight, this.scrollFactor: 5.0, Widget child})
      : assert(maxHeight != null && maxHeight >= 0.0),
        assert(scrollFactor != null && scrollFactor >= 1.0),
        super(key: key);

  //我们自己定义的变量。最大高度和滚动的因子
  final double maxHeight;
  final double scrollFactor;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return FlexStatusBarRenderObject(
        maxHeight: maxHeight, scrollFactor: scrollFactor);
  }

  //更新RenderObject
  @override
  void updateRenderObject(
      BuildContext context, FlexStatusBarRenderObject renderObject) {
    //这里就是级联的语法，改变状态
    renderObject
      ..maxHeight = maxHeight
      ..scrollFactor = scrollFactor;
  }

//这里是因为了debug模式下,能看到属性，所以写的方法
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(new DoubleProperty('maxHeight', maxHeight));
    description.add(new DoubleProperty('scrollFactor', scrollFactor));
  }
}

class FlexStatusBarRenderObject extends RenderSliver {
  FlexStatusBarRenderObject({
    @required double maxHeight,
    @required double scrollFactor,
  })  : assert(maxHeight != null && maxHeight >= 0.0),
        assert(scrollFactor != null && scrollFactor >= 1.0),
        _maxHeight = maxHeight,
        _scrollFactor = scrollFactor;

  //提供get 和set方法。set方法每次更新时，如果值发生变化了。就需要调用markNeedsLayout，使其重新布局
  // The height of the status bar
  double _maxHeight;

  double get maxHeight => _maxHeight;

  set maxHeight(double newValue) {
    assert(newValue != null && newValue >= 0.0);
    if (_maxHeight == newValue) {
      return;
    }
    _maxHeight = newValue;
    markNeedsLayout();
  }

  // That rate at which this renderer's height shrinks when the scroll
  // offset changes.
  double get scrollFactor => _scrollFactor;
  double _scrollFactor;

  set scrollFactor(double value) {
    assert(scrollFactor != null && scrollFactor >= 1.0);
    if (_scrollFactor == value) return;
    _scrollFactor = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    //最大高度 - 滚动距离
    final double height = (maxHeight - constraints.scrollOffset / scrollFactor)
        .clamp(0.0, maxHeight);
    this.geometry = SliverGeometry(
      paintExtent: math.min(height, constraints.remainingPaintExtent),
      scrollExtent: maxHeight,
      maxPaintExtent: maxHeight,
    );
  }
}

class _SliverAppPersistenceHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return null;
  }

  @override
  double get maxExtent => null;

  @override
  double get minExtent => null;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return null;
  }
}
