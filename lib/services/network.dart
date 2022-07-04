import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpClient {
  String _formatEndpoint(String endpoint, Map? parameters) {
    if (parameters == null || parameters == {}) {
      return endpoint;
    } else {
      parameters.forEach((key, value) {
        String temp = "?$key=$value";
        endpoint += temp;
      });

      return endpoint;
    }
  }

  Future<String?> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('token');
  }

  Future<http.Response> get(String endpoint,
      {Map? parameters,
      Map<String, String>? headers,
      bool useToken = true}) async {
    String? token = await getToken();

    late Map<String, String> _headers;

    if (headers != null) {
      _headers = headers;
    } else {
      _headers = {};
    }
    if (useToken && token != null) {
      _headers['Authorization'] = "Token $token";
    }

    http.Response res = await http.get(
        Uri.parse(
          _formatEndpoint(endpoint, parameters),
        ),
        headers: _headers);

    return res;
  }

  Future<http.Response> post(String endpoint,
      {required Map<String, String> body,
      Map<String, String>? headers,
      Map<String, String>? parameters,
      XFile? file,
      bool useToken = true}) async {
    String? token = await getToken();
    late Map<String, String> _headers;

    if (headers != null) {
      _headers = headers;
    } else {
      _headers = {};
    }
    if (token != null && useToken) {
      _headers['Authorization'] = "Token $token";
    }
    if (file == null) {
      http.Response res = await http.post(
          Uri.parse(
            _formatEndpoint(endpoint, parameters),
          ),
          body: body,
          headers: _headers);
      return res;
    } else {
      var request = http.MultipartRequest("PUT", Uri.parse(endpoint));
      request.files.add(await http.MultipartFile.fromPath('image', file.path));
      request.fields.addAll(body);
      request.headers.addAll(_headers);
      var streamedResponse = await request.send();
      return http.Response.fromStream(streamedResponse);
    }
  }

  Future<http.Response> patch(String endpoint, Map body) async {
    String? token = await getToken();

    http.Response res = await http.patch(Uri.parse(endpoint),
        body: body, headers: {'Authorization': 'Token $token'});
    return res;
  }

  Future<http.Response> delete(String endpoint) async {
    String? token = await getToken();
    var res = await http.delete(Uri.parse(endpoint),
        headers: {'Authorization': 'Token $token'});

    return res;
  }
}
