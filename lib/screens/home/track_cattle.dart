import 'dart:async';

import '/services/notification_service.dart';

import '/controllers/farm_tracker_controller.dart';

import '/exports/exports.dart';

class TrackCattle extends StatefulWidget {
  const TrackCattle({super.key});

  @override
  State<TrackCattle> createState() => _TrackCattleState();
}

class _TrackCattleState extends State<TrackCattle> {
  Completer<GoogleMapController> map_Controller =
      Completer<GoogleMapController>();
  LatLng? lat;
  @override
  void initState() {
    Geolocator.getPositionStream().listen((Position position) {
      if (mounted) {
        setState(() {
          lat = LatLng(position.latitude, position.longitude);
        });
      }
    });
    // print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<DataController>(builder: (context, dataController, x) {
        dataController.setData();
        return Consumer<CattleTracker>(builder: (context, controller, c) {
          // getting current location
          controller.computeFarmSize();
          controller.setCurrentLocation();

          return SlidingUpPanel(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            parallaxEnabled: true,
            parallaxOffset: 0.09,
            body: Column(
              children: [
                Expanded(
                  // flex: 3,
                  child: GoogleMap(
                    onMapCreated: (GoogleMapController mapController) {
                      // setState(() {
                      map_Controller.complete(mapController);
                      // });
                    },
                    // onTap: _setFarmBounds,
                    mapType: MapType.normal,
                    markers: {
                      Marker(
                        markerId: const MarkerId("value"),
                        position: controller.currentLocation,
                      ),
                      Marker(
                        markerId: const MarkerId('cattle_location'),
                        position: LatLng(
// 19:59:19.412 -> ----------- Done sending to server --------------------
                          //  -> ----------- Done sending to server --------------------
                          // 0.33220500946044921,
                          // 32.57048797607421
                          double.parse(dataController.data.field1),
                          double.parse(dataController.data.field2),
                        ),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueMagenta,
                        ),
                        onTap: () {
                          showAdaptiveDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog.adaptive(
                                title: const Text('Cattle Location'),
                                content: Text(
                                  'Latitude: ${dataController.data.field1}\nLongitude: ${dataController.data.field2}',
                                ),
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
                      ),
                    },
                    circles: {
                      ...controller.cattleLocations
                          .map(
                            (location) => Circle(
                              circleId: CircleId(location.toString()),
                              center: location,
                              strokeColor:
                                  Theme.of(context).colorScheme.primary,
                              radius: .42,
                            ),
                          )
                          .toSet(),
                    },
                    initialCameraPosition: CameraPosition(
                      bearing: 192.8334901395799,
                      target: lat ?? controller.currentLocation,
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    'Livestock Tracker',
                    style: Theme.of(context).textTheme.headlineMedium!.apply(
                          fontWeightDelta: 10,
                        ),
                  ),
                  //
                  ListTile(
                    title: Text(
                      'Farm size',
                      style: Theme.of(context).textTheme.bodyLarge!.apply(
                            fontWeightDelta: 10,
                          ),
                    ),
                    subtitle: Text(
                      '${controller.farmSize.toStringAsFixed(2)} metres',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),

                  ListTile(
                    title: Text(
                      'Animal Location',
                      style: Theme.of(context).textTheme.bodyLarge!.apply(
                            fontWeightDelta: 10,
                          ),
                    ),
                    subtitle: Text(
                      'Location: ${dataController.data.field1}, ${dataController.data.field2}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Distance covered by animal',
                      style: Theme.of(context).textTheme.bodyLarge!.apply(
                            fontWeightDelta: 10,
                          ),
                    ),
                    subtitle: Text(
                      'Distance: ${controller.cattleDistance}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const Space(
                    space: 0.1,
                  ),
                  CustomButton(
                    buttonColor: Theme.of(context).colorScheme.primary,
                    textColor: Colors.white,
                    onPress: () {
                      NotificationService.trackCattleMovements(
                        startLatitude: double.parse(dataController.data.field1),
                        startLongitude:
                            double.parse(dataController.data.field2),
                      );
                    },
                    text: 'Start Tracking',
                  ),
                  const Space(
                    space: 0.03,
                  ),

                  CustomButton(
                    textColor: Theme.of(context).colorScheme.primary,
                    onPress: () {
                      // controller.cattleLocations.clear();
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
                                  NotificationService.stopTrackingService();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    text: 'Stop Tracking',
                  ),
                ],
              ),
            ),
          );
        });
      }),
    );
  }
}
