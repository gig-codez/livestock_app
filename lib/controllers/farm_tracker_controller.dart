import 'dart:async';

import '../models/farm_model.dart';
import '/exports/exports.dart';

class CattleTracker with ChangeNotifier {
  Farm? farm;
  List<LatLng> cattleLocations = [];
  StreamSubscription<Position>? _positionStream;

  void setFarm(LatLngBounds farmBounds) {
    farm = Farm(farmBounds: farmBounds);
    notifyListeners();
  }

  void addCattle(LatLng location) {
    if (farm != null && farm!.isWithinFarmBounds(location)) {
      cattleLocations.add(location);
      notifyListeners();
    }
  }

  // Add the following getter to the CattleTracker class
  LatLng _currentLocation = LatLng(0, 0);
  LatLng get currentLocation {
    _setCurrentLocation();
    return _currentLocation;
  }

  void _setCurrentLocation() {
    Geolocator.getPositionStream().listen((Position position) {
      _currentLocation = LatLng(position.latitude, position.longitude);
      notifyListeners();
    });
  }

  void startTrackingCattle() {
    _positionStream =
        Geolocator.getPositionStream().listen((Position position) {
      _currentLocation = LatLng(position.latitude, position.longitude);
      notifyListeners();
      if (farm != null) {
        for (final cattle in cattleLocations) {
          if (!farm!.isWithinFarmBounds(cattle)) {
            // Trigger notification for cattle outside farm bounds
            print('Cattle at $cattle has left the farm bounds!');
          }
        }
      }
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
