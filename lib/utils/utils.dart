import 'package:ai_life/model/main_index_model.dart';
import 'package:ai_life/page/web_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Type _getType<T>() => T;

Future toWeb(BuildContext context, String indexId,
    {Map<String, dynamic> params}) async {
  return Provider.of<MainIndexModel>(context, listen: false)
      .getIndex()
      .then((list) {
    params = params ?? {};
    for (var index in list) {
      var menuItem = index.menu.firstWhere((menu) {
        return menu.id == indexId;
      }, orElse: () => null);
      if (menuItem != null) {
        params['url'] = menuItem.url;
        return Navigator.of(context)
            .pushNamed(WebPage.routeName, arguments: params);
      }
    }
    return Navigator.of(context).pushNamed(indexId, arguments: params);
  });
}
