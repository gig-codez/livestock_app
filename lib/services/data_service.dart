import 'package:livestock/models/cordinates_model.dart';

import '/exports/exports.dart';

class DataService {
  Future<Feed> getData() async {
    try {
      var request = Request(
          'GET',
          Uri.parse(
              'https://api.thingspeak.com/channels/2566267/feeds.json?results=1'));

      StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String? result = (await response.stream.bytesToString());
        return cordinatesFromJson(result).feeds.first;
      } else {
        return Future.error(response.reasonPhrase ?? "Invalid response");
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
