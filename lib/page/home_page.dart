import 'package:ai_life/configs/configs.dart';
import 'package:ai_life/configs/themes.dart';
import 'package:ai_life/model/announcement_model.dart';
import 'package:ai_life/model/district_model.dart';
import 'package:ai_life/model/home_end_scroll_model.dart';
import 'package:ai_life/model/theme_model.dart';
import 'package:ai_life/model/user_model.dart';
import 'package:ai_life/page/web_page.dart';
import 'package:ai_life/remote/api.dart';
import 'package:ai_life/utils/utils.dart';
import 'package:ai_life/widget/ease_icon_button.dart';
import 'package:ai_life/widget/gradient_button.dart';
import 'package:ai_life/widget/location_switch_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          var model = Provider.of<HomeEndScrollModel>(context, listen: false);
          model.atHomeEnd = notification.metrics.maxScrollExtent <=
              (notification.metrics.pixels +
                  MediaQuery.of(context).size.height * 0.4);
          return false;
        },
        child: CustomScrollView(
          controller: _scrollController,
          key: PageStorageKey(113),
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: DecoratedBox(
                decoration: appDeco(context),
                child: SizedBox(
                  height: MediaQuery.of(context).padding.top,
                ),
              ),
            ),
            SliverAppBar(
              floating: true,
              forceElevated: true,
              snap: true,
              centerTitle: true,
              flexibleSpace: DecoratedBox(
                decoration: appDeco(context),
                child: Container(),
              ),
              title: Text(APP_NAME),
              actions: <Widget>[LocationSwitchWidget()],
            ),
            SliverToBoxAdapter(
              child: const HomeBannerWidget(
                key: PageStorageKey(11),
              ),
            ),
            Consumer<UserModel>(
              builder: (BuildContext context, UserModel value, Widget child) {
                return SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                    child: Material(
                      shadowColor: Colors.blue[200],
                      elevation: 2,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          EaseIconButton(0, "访客管理", () {
                            toWeb(context, "fkgl");
                          }, CupertinoIcons.person_solid),
                          EaseIconButton(1, "找物业", () {
                            toWeb(context, "zwy");
                          }, CupertinoIcons.padlock_solid),
                          EaseIconButton(2, "找社区", () {
                            toWeb(context, "zsq");
                          }, CupertinoIcons.group_solid),
                          EaseIconButton(3, "找警察", () {
                            toWeb(context, "zjc");
                          }, CupertinoIcons.phone_solid),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            Consumer<AnnouncementModel>(
              builder: (context, model, child) {
                if (model.announcements.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Container(
                      constraints: BoxConstraints(minHeight: 160),
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return buildAnnouncementTile(model, index);
                    },
                    childCount: model.announcements?.length ?? 0,
                  ),
                );
              },
            ),
            SliverToBoxAdapter(
              child: Consumer<AppThemeModel>(
                builder:
                    (BuildContext context, AppThemeModel value, Widget child) {
                  return FlatButton(
                      onPressed: () {
                        value.changeTheme();
                      },
                      child: Icon(Icons.cached));
                },
              ),
            ),
            SliverFillRemaining(
              child: Center(
                child: InkWell(
                  onTap: () {},
                  splashColor: Colors.lightGreen,
                  child: Container(
                    constraints: BoxConstraints.tight(Size(120, 120)),
                    decoration: BoxDecoration(
                      color: Color(0x77FF8F00),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.call,
                          color: Colors.red,
                        ),
                        Text(
                          "紧急呼叫",
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(72)),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Consumer<HomeEndScrollModel>(
        builder:
            (BuildContext context, HomeEndScrollModel value, Widget child) {
          return Offstage(
            offstage: value.atHomeEnd,
            child: FloatingActionButton(
              onPressed: () {
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: Duration(seconds: 2),
                  curve: Curves.fastLinearToSlowEaseIn,
                );
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.elliptical(16, 12))),
              mini: true,
              child: Icon(
                Icons.call,
                size: 16,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildAnnouncementTile(AnnouncementModel model, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6),
      constraints: BoxConstraints(minHeight: 56),
      child: Material(
        shadowColor: Colors.blue[200],
        elevation: 2,
        child: InkWell(
          onTap: () {
            Map<String, String> map = {
              "url":
                  "$BaseUrl#/contentDetails?contentId=${model.announcements[index].noticeId}"
            };
            Navigator.of(context).pushNamed(WebPage.routeName, arguments: map);
          },
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 16,
              ),
              Container(
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
                  gradient: model.bannerColor(index),
                  borderRadius: BorderRadius.all(
                    Radius.circular(72),
                  ),
                ),
              ),
              SizedBox(
                width: 6,
              ),
              Expanded(
                child: Text(
                  model.title(index),
                  style: TextStyle(color: Colors.blueGrey[800], fontSize: 14),
                ),
              ),
              SizedBox(
                width: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeBannerWidget extends StatefulWidget {
  const HomeBannerWidget({
    Key key,
  }) : super(key: key);

  @override
  _HomeBannerWidgetState createState() => _HomeBannerWidgetState();
}

class _HomeBannerWidgetState extends State<HomeBannerWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.48,
      child: Consumer<DistrictModel>(
        builder: (BuildContext context, DistrictModel model, Widget child) {
          if (model.allDistricts.length < 1) {
            return Center(child: CircularProgressIndicator());
          }
          return Swiper.list(
            key: PageStorageKey(model.getCurrentDistrictIndex()),
            onIndexChanged: (index) {
              model.currentDistrict = model.allDistricts[index];
            },
            controller: SwiperController(),
            control: SwiperPagination(),
            list: model.allDistricts,
            index: model.getCurrentDistrictIndex(),
            builder: (context, data, index) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Material(
                        type: MaterialType.card,
                        elevation: 4,
                        shadowColor: Theme.of(context).primaryColor,
                        clipBehavior: Clip.antiAlias,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        child: Consumer<DistrictModel>(
                          builder: (BuildContext context, DistrictModel model,
                              Widget child) {
                            return Image.network(
                              model.getDistrictPic(index),
                              fit: BoxFit.cover,
                              loadingBuilder: APP_DEFAULT_LOADING_BUILDER,
                            );
                          },
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        margin: EdgeInsets.all(12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 16,
                            ),
                            Text(
                              "${model.getDistrictName(index)}",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
