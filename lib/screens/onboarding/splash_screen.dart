import '/exports/exports.dart';
import 'onboarding.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  // Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    if (_controller != null) {
      _controller!.forward();
      Future.delayed(
        const Duration(seconds: 3),
        () {
          Routes.replacePage(
            const Onboarding(),
          );
        },
      );
    }
    // _animation = CurvedAnimation(
    //   parent: _controller!,
    //   curve: Curves.easeInOut,
    // );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RippleWave(
            waveCount: 3,
            color: Theme.of(context).primaryColor,
            repeat: true,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Hero(
                tag: "image",
                child: Image.asset(
                  "assets/pngs/image.png",
                  width: 150,
                  height: 150,
                ),
              ),
            ),
          ),
          const Space(
            space: 0.64,
          ),
          Text(
            "Livestock App",
            style: Theme.of(context).textTheme.headlineMedium!.apply(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeightDelta: 50,
                  fontFamily: 'Montserrat',
                ),
          ),
          const Space(
            space: 0.3,
          ),
        ],
      ),
    );
  }
}
