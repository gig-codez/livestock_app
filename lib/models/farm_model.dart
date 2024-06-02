import '/exports/exports.dart';

class Farm {
  LatLngBounds farmBounds;
  List<LatLng> cattleLocations = [];

  Farm({required this.farmBounds});

  bool isWithinFarmBounds(LatLng location) {
    return farmBounds.contains(location);
  }
}
