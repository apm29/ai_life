import 'package:flutter/foundation.dart';

class HomeEndScrollModel extends ChangeNotifier{

  bool _atHomeEnd = false;

  set atHomeEnd(bool newValue){
    if(newValue == _atHomeEnd){
      return;
    }
    _atHomeEnd = newValue;
    notifyListeners();
  }

  bool get atHomeEnd => _atHomeEnd;


}