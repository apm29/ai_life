import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WebPageModel extends ChangeNotifier{
  String _title;

  String get title => _title;

  set title(String value) {
    _title = value;
    notifyListeners();
  }

  static WebPageModel of(BuildContext context) {
    return Provider.of<WebPageModel>(context,listen: false);
  }
}
