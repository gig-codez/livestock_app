import '../screens/home/farm_dimensions.dart';
import '/exports/exports.dart';
import '/screens/home/home_screen.dart';
import '/screens/onboarding/splash_screen.dart';

class Routes {
  static String splash = "/splash";
  static String home = "/home";
  static String farmBounds = "/farmBounds";

  Map<String, Widget Function(BuildContext)> get routes {
    return {
      splash: (context) => SplashScreen(),
      home: (context) => const HomeScreen(),
      farmBounds: (context) => const FarmDimensions(),
    };
  }

  // routes methods
  static void popPage() {
    Navigator.of(context).pop();
  }

  static void pushPage(String route) {
    Navigator.of(context).pushNamed(route);
  }

  static void relacePageRoute(String route) {
    Navigator.of(context).pushReplacementNamed(route);
  }

  static void pushPageWithArguments(String route, dynamic arguments) {
    Navigator.of(context).pushNamed(route, arguments: arguments);
  }

  static void pushPageWithRoute(Widget route) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => route, fullscreenDialog: true),
    );
  }

  static void pushPageWithRouteAndResult(Widget route) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => route, fullscreenDialog: true),
    );
  }

  static void pushPageWithRouteAndAnimation(Widget route, {type = 'fade'}) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => type == 'scale'
            ? ScaleTransition(
                scale: animation,
                child: route,
              )
            : FadeTransition(
                opacity: animation,
                child: route,
              ),
      ),
    );
  }

  static void replacePage(Widget route) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => FadeTransition(
          opacity: animation,
          child: route,
        ),
      ),
    );
  }

  static void removePage(String route) {
    Navigator.of(context).popAndPushNamed(route);
  }

  static void removeUntilPage(String route) {
    Navigator.of(context).pushNamedAndRemoveUntil(route, (route) => false);
  }

  static void animateToPage(Widget page, {type = 'fade'}) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => type == 'scale'
            ? ScaleTransition(
                scale: animation,
                child: page,
              )
            : FadeTransition(
                opacity: animation,
                child: page,
              ),
      ),
    );
  }
}
