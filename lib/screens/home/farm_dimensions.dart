// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import '/controllers/farm_tracker_controller.dart';
import '/exports/exports.dart';

class FarmDimensions extends StatefulWidget {
  const FarmDimensions({super.key});

  @override
  _FarmDimensionsState createState() => _FarmDimensionsState();
}

class _FarmDimensionsState extends State<FarmDimensions> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? _selectedLocation;
  LatLngBounds? _farmBounds;

  @override
  void initState() {
    super.initState();
    Provider.of<CattleTracker>(context, listen: false).startTrackingCattle();
  }

  @override
  void dispose() {
    super.dispose();
    Provider.of<CattleTracker>(context, listen: false).dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farm Map'),
      ),
      body: Consumer<CattleTracker>(builder: (context, controller, s) {
        return Column(
          children: [
            Expanded(
              child: GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                onTap: _setFarmBounds,
                markers: _getFarmMarkers(),
                circles: _getFarmCircles(),
                initialCameraPosition: CameraPosition(
                  bearing: 192.8334901395799,
                  target: controller.currentLocation,
                  tilt: 59.440717697143555,
                  zoom: 19.151926040649414,
                ),
              ),
            ),
            // CustomButton(
            //   onPress: _addCattle,
            //   text: 'Add Cattle',
            //   textColor: Colors.white,
            // ),
          ],
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: CustomButton(
        width: 150,
        onPress: _addCattle,
        text: 'Add Cattle',
        textColor: Colors.white,
        buttonColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _setFarmBounds(LatLng location) {
    print("$location");
    setState(() {
      _selectedLocation = location;
    });
  }

  void _addCattle() async {
    if (_selectedLocation != null && _farmBounds != null) {
      Provider.of<CattleTracker>(context, listen: false)
          .addCattle(_selectedLocation!);
      setState(() {
        _selectedLocation = null;
      });
    }
  }

  Set<Marker> _getFarmMarkers() {
    final cattleTracker = Provider.of<CattleTracker>(context);
    return cattleTracker.cattleLocations
        .map((location) => Marker(
              markerId: MarkerId(location.toString()),
              position: location,
            ))
        .toSet();
  }

  Set<Circle> _getFarmCircles() {
    if (_farmBounds == null || _selectedLocation == null) {
      return {};
    }
    return {
      Circle(
        circleId: const CircleId('farm_bounds'),
        center: _farmBounds!.northeast,
        radius:
            _farmBounds!.northeast.latitude - _farmBounds!.southwest.latitude,
        fillColor: Colors.green.withOpacity(0.2),
        strokeColor: Colors.green,
        strokeWidth: 2,
      ),
      Circle(
        circleId: const CircleId('selection'),
        center: _selectedLocation!,
        radius: 50,
        fillColor: Colors.blue.withOpacity(0.2),
        strokeColor: Colors.blue,
        strokeWidth: 2,
      ),
    };
  }
}
