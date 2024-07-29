import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkHelper {
  NetworkHelper(this.url);
  late String url;

  Future getData() async {
    try {
      Future<http.Response> fetchAlbum() async {
        return http.get(Uri.parse(url));
      }

      final data = await fetchAlbum();

      if (data.statusCode != 200) {
        print(data.statusCode);
      }

      return jsonDecode(data.body);
    } on Exception catch (e) {
      // TODO
      print(e);
    }
  }
}
