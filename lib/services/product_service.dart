import 'package:flutter_login_application/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';

HttpClientWithInterceptor client;

class ProductService {
  Future<http.Response> getProducts(
      {dynamic idUser, Map<String, String> headers}) async {
    var response =
        await http.get(Constants.HOST + '/products/$idUser', headers: headers);
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

  Future<http.Response> removeProduct(
      {dynamic id, Map<String, String> headers}) async {
    return await http.delete(
      Constants.HOST + '/products/$id',
      headers: headers,
    );
  }
}
