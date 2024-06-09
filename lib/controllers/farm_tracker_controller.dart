import 'dart:async';

import '../models/farm_model.dart';
import '/exports/exports.dart';

class CattleTracker with ChangeNotifier {
  CattleTracker() {
    setCurrentLocation();
  }
  Farm? farm;
  List<LatLng> _cattleLocations = [];
  List<LatLng> get cattleLocations => _cattleLocations;
  StreamSubscription<Position>? _positionStream;

  void setFarm(LatLngBounds farmBounds) {
    farm = Farm(farmBounds: farmBounds);
    notifyListeners();
  }

  void addCattle(LatLng location) {
    // if (farm != null && farm!.isWithinFarmBounds(location)) {
    _cattleLocations.add(location);
    notifyListeners();
    // }
  }

  // Add the following getter to the CattleTracker class
  LatLng _currentLocation = const LatLng(0, 0);
  LatLng get currentLocation {
    // _setCurrentLocation();
    return _currentLocation;
  }

  void setCurrentLocation() {
    Geolocator.getCurrentPosition().then((Position position) {
      _currentLocation = LatLng(position.latitude, position.longitude);
      notifyListeners();
    });
  }

  void stopTrackingCattle() {
    _positionStream?.cancel();
  }

  @override
  void dispose() {
    stopTrackingCattle();
    super.dispose();
  }
}
