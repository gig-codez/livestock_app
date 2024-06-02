import '/exports/exports.dart';

class Space extends StatelessWidget {
  final double space;
  const Space({super.key, this.space = 0.03});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: MediaQuery.of(context).size.width * space,
    );
  }
}
