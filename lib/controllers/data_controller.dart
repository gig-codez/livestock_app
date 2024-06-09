import '/models/cordinates_model.dart';
import '/services/data_service.dart';

import '/exports/exports.dart';

class DataController with ChangeNotifier {
  // data
  Feed _data = Feed.fromJson({});

  // getters
  Feed get data => _data;

  // setters
  void setData() {
    DataService().getData().then((value) {
      _data = value;
      notifyListeners();
    });
    // notifyListeners();
  }
}
