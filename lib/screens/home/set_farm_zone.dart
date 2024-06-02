import '/exports/exports.dart';

class SetFarmZone extends StatefulWidget {
  const SetFarmZone({super.key});

  @override
  State<SetFarmZone> createState() => _SetFarmZoneState();
}

class _SetFarmZoneState extends State<SetFarmZone> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Space(space: 0.1),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 25, 6, 1.0),
            child: Text(
              "Set Farm Zone",
              style: Theme.of(context).textTheme.titleLarge!.apply(
                    fontFamily: 'Montserrat',
                    fontSizeDelta: 11,
                    fontWeightDelta: 10,
                  ),
            ),
          ),
          const Spacer(
            flex: 2,
          ),
          RippleWave(
            color: Theme.of(context).primaryColor,
            waveCount: 3,
            child: InkWell(
              onTap: () {
                Routes.pushPage(Routes.farmBounds);
              },
              child: CircleAvatar(
                radius: 65,
                child: Text(
                  "Tap to Set",
                  style: Theme.of(context).textTheme.titleMedium!.apply(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeightDelta: 60,
                      ),
                ),
              ),
            ),
          ),
          const Spacer(
            flex: 2,
          ),
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
          //   child: CustomButton(
          //     onPress: () => ,
          //     text: "Continue",
          //     textColor: Colors.white,
          //     buttonColor: Theme.of(context).colorScheme.primary.withAlpha(180),
          //   ),
          // ),
          const Space(
            space: 0.2,
          )
        ],
      ),
    );
  }
}
