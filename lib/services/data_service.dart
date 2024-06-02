class DataService {
  Future<List<String>> getData() async {
    await Future.delayed(Duration(seconds: 2));
    return ['one', 'two', 'three'];
  }
}
