import 'package:flutter_login_application/utils/constants.dart';
import 'package:http/http.dart' as http;

class ProductService {
  Future<http.Response> getProducts() async {
    var response = await http.get(Constants.HOST + '/products');
    return response;
  }

  Future<http.Response> post(
    String url,
    dynamic body,
    Map<String, String> headers,
  ) async {
    var response = await http.post(
      url,
      body: body,
      headers: headers,
    );
    return response;
  }

  Future<http.Response> createProduct(
    String url,
    dynamic body,
    Map<String, String> headers,
  ) async {
    var response = await this.post(url, body, headers);

    return response;
  }

  Future<http.Response> removeProduct(String id) async {
    return await http.delete(Constants.HOST + '/products/$id',
        headers: Constants.CONTENT_TYPE);
  }
}
