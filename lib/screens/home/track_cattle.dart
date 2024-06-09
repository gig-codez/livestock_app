import 'dart:async';

import '/controllers/farm_tracker_controller.dart';

import '/exports/exports.dart';

class TrackCattle extends StatefulWidget {
  const TrackCattle({super.key});

  @override
  State<TrackCattle> createState() => _TrackCattleState();
}

class _TrackCattleState extends State<TrackCattle> {
  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<CattleTracker>(builder: (context, controller, c) {
        // getting current location
        // controller.setCurrentLocation();
        // Create the PolyGeofence
        // poly.PolyGeofence(
        //   polygon: controller.cattleLocations,
        //   id: 'my_geofence',
        // );
        return SlidingUpPanel(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          body: Column(
            children: [
              Expanded(
                // flex: 3,
                child: GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  // onTap: _setFarmBounds,
                  mapType: MapType.normal,
                  markers: {
                    Marker(
                      markerId: const MarkerId("value"),
                      position: controller.currentLocation,
                    ),
                  },
                  circles: {
                    ...controller.cattleLocations
                        .map(
                          (location) => Circle(
                            circleId: CircleId(location.toString()),
                            center: location,
                            strokeColor: Theme.of(context).colorScheme.primary,
                            radius: .42,
                          ),
                        )
                        .toSet(),
                  },
                  initialCameraPosition: CameraPosition(
                    // bearing: 192.8334901395799,
                    target: controller.currentLocation,
                    tilt: 59.440717697143555,
                    zoom: 19.151926040649414,
                  ),

                  polygons: {
                    Polygon(
                      polygonId: const PolygonId('my_geofence'),
                      points: controller.cattleLocations,
                      strokeColor: Theme.of(context).colorScheme.primary,
                      strokeWidth: 2,
                      fillColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.3),
                    ),
                  },
                ),
              )
            ],
          ),
          panel: Padding(
            padding: const EdgeInsets.fromLTRB(25, 15, 15, 10),
            child: Column(
              children: [
                // const Row(
                const Row(
                  children: [
                    Divider(
                      thickness: 5,
                      height: 10,
                      // color: Colors.grey.shade500,
                    ),
                  ],
                ),
                Text(
                  '\nCattle Tracker',
                  style: Theme.of(context).textTheme.headlineMedium!.apply(
                        fontWeightDelta: 10,
                      ),
                ),

                const Space(
                  space: 0.13,
                ),
                CustomButton(
                  buttonColor: Theme.of(context).colorScheme.primary,
                  textColor: Colors.white,
                  onPress: () {
                    // Provider.of<CattleTracker>(context, listen: false).startTrackingCattle();
                  },
                  text: 'Start Tracking',
                ),
                const Space(
                  space: 0.03,
                ),

                CustomButton(
                  textColor: Theme.of(context).colorScheme.primary,
                  onPress: () {
                    controller.cattleLocations.clear();
                    showAdaptiveDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog.adaptive(
                          title: const Text('Cattle Locations Cleared'),
                          content: const Text(
                              'All cattle locations have been cleared.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  text: 'Clear Locations',
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
