import 'package:ai_life/configs/themes.dart';
import 'package:ai_life/model/announcement_model.dart';
import 'package:ai_life/model/user_model.dart';
import 'package:ai_life/remote/api.dart';
import 'package:ai_life/widget/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: DecoratedBox(
              decoration: APP_DEFAULT_DECO,
              child: SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
            ),
          ),
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).viewInsets.top,
            floating: true,
            forceElevated: true,
            snap: true,
            centerTitle: true,
            flexibleSpace: Consumer<UserModel>(
              builder: (context, UserModel model, child) {
                return DecoratedBox(
                  decoration: APP_DEFAULT_DECO,
                  child: Center(
                    child: Text(
                      "USER_ID:${model.userId ?? ""}",
                    ),
                  ),
                );
              },
            ),
            title: Text("Sliver标题"),
          ),
          Consumer<AnnouncementModel>(
            builder: (context, model, child) {
              if (model.announcements.isEmpty) {
                return SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()));
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return ListTile(
                      leading: Container(
                        constraints: BoxConstraints(minWidth: 72),
                        padding: EdgeInsets.all(3),
                        child: Text(
                          model.typeTitle(index),
                          style: TextStyle(color: Colors.white, fontSize: 12),
                          maxLines: 100,
                          textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                        decoration: BoxDecoration(
                            color: model.bannerColor(index),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                      title: Text(model.title(index)),
                    );
                  },
                  childCount: model.announcements?.length,
                ),
              );
            },
          ),
          SliverToBoxAdapter(
            child: Consumer<UserModel>(
              builder: (context, UserModel value, child) {
                return GradientButton(
                  Text(
                    value.isLogin ? "登出" : "登录",
                  ),
                  onPressed: () async {
                    return value.isLogin
                        ? value.logout()
                        : Api.login().then((resp) {
                            if (resp.success) {
                              value.login(resp.data?.userInfo, resp.token);
                            }
                            return;
                          });
                  },
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Text("123" * 100),
          ),
          SliverFillRemaining(
            child: Center(
              child: CircleAvatar(
                foregroundColor: Color(0xffffffff),
                child: Text("User"),
                backgroundImage: NetworkImage(
                  "http://files.ciih.net/M00/07/13/wKjIo10Sxv6ABEX1AAHpB8duvck468.jpg",
                ),
                backgroundColor: Colors.yellow[900],
                radius: 72,
              ),
            ),
          )
        ],
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
