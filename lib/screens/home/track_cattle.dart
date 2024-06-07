import 'dart:async';

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
      body: SlidingUpPanel(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        body: Column(
          children: [
            StreamBuilder(
              stream: Geolocator.getPositionStream(),
              builder: (context, snapshot) {
                Position? dim = snapshot.data;
                return snapshot.hasData
                    ? Expanded(
                        // flex: 3,
                        child: GoogleMap(
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                          // onTap: _setFarmBounds,
                          // mapType: MapType.normal,
                          // markers: _getFarmMarkers(),
                          // circles: _getFarmCircles(),
                          initialCameraPosition: CameraPosition(
                            // bearing: 192.8334901395799,
                            target: dim != null
                                ? LatLng(dim.latitude, dim.longitude)
                                : LatLng(0, 0),
                            // tilt: 59.440717697143555,
                            // zoom: 19.151926040649414,
                          ),
                        ),
                      )
                    : const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 10,
                        ),
                      );
              },
            ),
          ],
        ),
        panel: Padding(
          padding: const EdgeInsets.fromLTRB(25, 15, 15, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\nCattle Tracker',
                style: Theme.of(context).textTheme.headlineLarge!.apply(
                      fontWeightDelta: 10,
                    ),
              ),
              const Space(
                space: 0.143,
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
                  // Provider.of<CattleTracker>(context, listen: false).stopTrackingCattle();
                },
                text: 'Stop Tracking',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
