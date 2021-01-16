import 'package:flutter_login_application/utils/constants.dart';
import 'package:http/http.dart' as http;

class UserServices {
  Future<http.Response> login(
      {dynamic body, Map<String, String> headers}) async {
    var response = await http.post(
      Constants.HOST + '/login',
      body: body,
      headers: headers,
    );
    return response;
  }
}
