import '/exports/exports.dart';

class DataController with ChangeNotifier {
  // data
  String _data = 'data';

  // getters
  String get data => _data;

  // setters
  void setData(String data) {
    _data = data;
    notifyListeners();
  }
}
