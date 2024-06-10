import 'dart:async';

import '../models/farm_model.dart';
import '/exports/exports.dart';
import 'package:geodesy/geodesy.dart' as geo;

class CattleTracker with ChangeNotifier {
  CattleTracker() {
    setCurrentLocation();
    // computeFarmSize();
  }
  // 32.570175,0.332078
  Farm? farm;
  List<LatLng> _cattleLocations = [];
  List<LatLng> get cattleLocations => _cattleLocations;
  StreamSubscription<Position>? _positionStream;

  void setFarm(LatLngBounds farmBounds) {
    farm = Farm(farmBounds: farmBounds);
    notifyListeners();
  }

  double _farmSize = 0;
  double get farmSize => _farmSize;

  void computeFarmSize() {
    final geo.Geodesy geodesy = geo.Geodesy();
    if (cattleLocations.isNotEmpty) {
      final List<geo.LatLng> polygonPoints = [];
      for (final LatLng point in cattleLocations) {
        polygonPoints.add(geo.LatLng(point.latitude, point.longitude));
      }
      final double area = geodesy.calculatePolyLineLength(polygonPoints);
      _farmSize = area;
      // notifyListeners();
    }
  }

  void addCattle(LatLng location) {
    // if (farm != null && farm!.isWithinFarmBounds(location)) {
    _cattleLocations.add(location);
    notifyListeners();
    // }
  }

  double _cattleDistance = 0.0;
  double get cattleDistance => _cattleDistance;
  set cattleDistance(double value) {
    _cattleDistance = value;
    notifyListeners();
  }

  // Add the following getter to the CattleTracker class
  LatLng _currentLocation = const LatLng(0.3454831, 32.5516712);
  LatLng get currentLocation {
    // _setCurrentLocation();
    return _currentLocation;
  }

  void setCurrentLocation() {
    Geolocator.getPositionStream().listen((Position position) {
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
