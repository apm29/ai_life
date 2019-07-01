import '../index.dart';

class MainIndexModel extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  set currentIndex(int value) {
    _currentIndex = value;
    notifyListeners();
  }


  static MainIndexModel of(BuildContext context) {
    return Provider.of<MainIndexModel>(context, listen: false);
  }

}
