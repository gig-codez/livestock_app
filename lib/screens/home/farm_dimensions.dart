// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:livestock/screens/home/track_cattle.dart';

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
    // Provider.of<CattleTracker>(context, listen: false).startTrackingCattle();
  }

  @override
  void dispose() {
    super.dispose();
    Provider.of<CattleTracker>(context, listen: false).dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<CattleTracker>(builder: (context, controller, c) {
        // getting current location
        controller.setCurrentLocation();
        print(controller.currentLocation.toString());
        return Column(
          children: [
            Expanded(
              flex: 4,
              child: GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                onTap: controller.addCattle,
                // mapType: MapType.satellite,
                markers: {
                  Marker(
                    markerId: MarkerId("value"),
                    position: controller.currentLocation,
                  ),
                  ..._getFarmMarkers(),
                },
                circles: _getFarmCircles(),
                initialCameraPosition: CameraPosition(
                  bearing: 192.8334901395799,
                  target: controller.currentLocation,
                  tilt: 59.440717697143555,
                  zoom: 19.151926040649414,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(8, 2, 8, 10),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text.rich(
                      TextSpan(
                        text: 'Farm Dimensions',
                        style: Theme.of(context).textTheme.bodyLarge!.apply(
                              fontWeightDelta: 10,
                            ),
                        children: [
                          TextSpan(
                            text:
                                '\n(We need just the farm diagonal i.e the south west of the farm and northeast of the farm.)',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                  ...List.generate(
                    controller.cattleLocations.length,
                    (index) => ListTile(
                      title: Text("$index"),
                      subtitle: Text("${controller.cattleLocations[index]}"),
                    ),
                  )
                  // Text('Selected Location: $_selectedLocation'),
                ],
              ),
            ),
          ],
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: CustomButton(
        width: MediaQuery.of(context).size.width * .93,
        onPress: () => Routes.pushPageWithRoute(
          const TrackCattle(),
        ),
        text: 'Track cattle',
        textColor: Colors.white,
        buttonColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  // void _setFarmBounds(LatLng location) {
  //   print("$location");
  //   Provider.of<CattleTracker>(context).addCattle(location);
  // }

  // void _addCattle() async {
  //   if (_selectedLocation != null && _farmBounds != null) {
  //     Provider.of<CattleTracker>(context, listen: false)
  //         .addCattle(_selectedLocation!);
  //     setState(() {
  //       _selectedLocation = null;
  //     });
  //   }
  // }

  Set<Marker> _getFarmMarkers() {
    final cattleTracker = Provider.of<CattleTracker>(context);
    return cattleTracker.cattleLocations
        .map(
          (location) => Marker(
            markerId: MarkerId(location.toString()),
            position: location,
          ),
        )
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
