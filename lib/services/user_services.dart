import 'package:http/http.dart' as http;

class UserServices {
  Future<http.Response> post(
      String url, dynamic body, Map<String, String> headers) async {
    var response = await http.post(
      url,
      body: body,
      headers: headers,
    );
    return response;
  }
}
