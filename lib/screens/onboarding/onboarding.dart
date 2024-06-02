import 'package:livestock/screens/home/set_farm_zone.dart';

import '/exports/exports.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          image: const DecorationImage(
            image: AssetImage("assets/pngs/farmer.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black12,
                Colors.black54,
                Colors.black87,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Hero(
                    tag: "image",
                    child: Image.asset(
                      "assets/pngs/image.png",
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Space(space: .093),
                Text(
                  "Livestock",
                  style: Theme.of(context).textTheme.titleLarge!.apply(
                        fontFamily: 'Montserrat',
                        fontWeightDelta: 60,
                        fontSizeDelta: 8,
                        color: Colors.white,
                      ),
                ),
                Text(
                  "Keep track of animals on the farm",
                  style: Theme.of(context).textTheme.bodyLarge!.apply(
                        fontFamily: 'Montserrat',
                        fontWeightDelta: 2,
                        fontSizeDelta: 0.5,
                        color: Colors.white,
                      ),
                ),
                const Space(),
                CustomButton(
                  onPress: () {
                    Routes.replacePage(
                      const SetFarmZone(),
                    );
                  },
                  text: "Get Started",
                  textColor: Colors.white,
                  buttonColor: Theme.of(context).colorScheme.primary,
                ),
                const Space(space: 0.23),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// AIzaSyAr9WuNz5sTHtJ9sAZBwvX51NIXg1aHIfM
