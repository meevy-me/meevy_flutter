import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';

class HttpClient {
  String _formatEndpoint(String endpoint, Map<String, String>? parameters) {
    if (parameters == null || parameters == {}) {
      return endpoint;
    } else {
      return Uri.parse(endpoint)
          .replace(queryParameters: parameters)
          .toString();
    }
  }

  Future<String?> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('token');
  }

  Future<http.Response> get(String endpoint,
      {Map<String, String>? parameters,
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
      {required Map<String, dynamic>? body,
      Map<String, String>? headers,
      Map<String, String>? parameters,
      Map<String, String>? headersAdd,
      Object? bodyRaw,
      XFile? file,
      bool useToken = true}) async {
    String? token = await getToken();
    late Map<String, String> _headers;

    if (headers != null) {
      _headers = headers;
    } else {
      _headers = {};
    }
    if (headersAdd != null) {
      _headers.addAll(headersAdd);
    }
    if (token != null && useToken) {
      _headers['Authorization'] = "Token $token";
    }
    if (file == null) {
      http.Response res = await http.post(
          Uri.parse(
            _formatEndpoint(endpoint, parameters),
          ),
          body: bodyRaw ?? body,
          headers: _headers);

      return res;
    } else {
      var request = http.MultipartRequest("PUT", Uri.parse(endpoint));
      request.files.add(await http.MultipartFile.fromPath('image', file.path));
      var body_pass = body!.cast<String, String>();
      request.fields.addAll(body_pass  );
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

  Future<http.Response> put(String endpoint,
      {Map<String, dynamic>? body,
      Object? bodyRaw,
      Map<String, String>? parameters,
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

    http.Response res = await http.put(
        Uri.parse(
          _formatEndpoint(endpoint, parameters),
        ),
        headers: _headers,
        body: body ?? bodyRaw);

    return res;
  }
}

class SpotifyClient {
  HttpClient client = HttpClient();
  String basicAuth(String username, String password) {
    return 'Basic ' + base64Encode(utf8.encode('$username:$password'));
  }

  String get _clientSecret {
    return "edbd307b1b064e91a8974698bb9b0a8f";
  }

  Future<Map?> getTokens(String code) async {
    http.Response res =
        await client.post(spotifyTokenEndpoint, useToken: false, body: {
      'code': code,
      'clientId': clientId,
      'grant_type': 'authorization_code',
      'redirect_uri': 'souldate:/'
    }, headers: {
      'Content-type': 'application/x-www-form-urlencoded',
      'Authorization': basicAuth(clientId, _clientSecret)
    });

    if (res.statusCode <= 210) {
      return jsonDecode(res.body);
    } else {
      log(res.body, name: "SPOTIFY ERROR");
    }
    return null;
  }

  Future<bool> refreshAccessToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var spotRefresh = preferences.getString("spotify_refreshtoken");
    http.Response res =
        await client.post(spotifyTokenEndpoint, useToken: false, body: {
      'grant_type': 'refresh_token',
      'refresh_token': spotRefresh!,
      'redirect_uri': 'souldate:/',
    }, headers: {
      'Content-type': 'application/x-www-form-urlencoded',
      'Authorization': basicAuth(clientId, _clientSecret)
    });
    if (res.statusCode <= 210) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString(
          "spotify_accesstoken", json.decode(res.body)['access_token']);
      // accessToken = json.decode(res.body)['access_token'];
      return true;
    } else {
      log(res.body, name: "REFRESH TOKEN ERROR");
      return false;
    }
  }

  Future<http.Response> get(String endpoint,
      {Map<String, String>? parameters}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var accessToken = preferences.getString("spotify_accesstoken")!;
    var refreshToken = preferences.getString("spotify_refreshtoken")!;
    http.Response res = await client.get(endpoint,
        parameters: parameters,
        headers: {
          'Authorization': "Bearer $accessToken",
          "Content-Type": "application/json"
        },
        useToken: false);

    if (res.statusCode == 401 &&
        json.decode(res.body)['error']['message'] ==
            "The access token expired") {
      await refreshAccessToken();
      get(endpoint);
    }
    return res;
  }

  Future<http.Response> post(
    String endpoint, {
    required Map<String, String> body,
    Map<String, String>? headers,
    Map<String, String>? parameters,
  }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var accessToken = preferences.getString("spotify_accesstoken")!;
    var refreshToken = preferences.getString("spotify_refreshtoken")!;

    headers ??= {'Authorization': "Bearer $accessToken"};

    http.Response res = await client.post(endpoint,
        body: body, parameters: parameters, headers: headers, useToken: false);

    if (res.statusCode == 401 &&
        json.decode(res.body)['error']['message'] ==
            "The access token expired") {
      await refreshAccessToken();
      post(endpoint, body: body, headers: headers, parameters: parameters);
    }

    return res;
  }

  Future<http.Response> put(
    String endpoint, {
    Map<String, String>? body,
    Object? bodyRaw,
    Map<String, String>? headers,
    Map<String, String>? parameters,
  }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var accessToken = preferences.getString("spotify_accesstoken")!;
    // var refreshToken = preferences.getString("spotify_refreshtoken")!;

    headers ??= {
      'Authorization': "Bearer $accessToken",
      "Content-Type": "application/json"
    };

    http.Response res = await client.put(endpoint,
        body: body,
        bodyRaw: bodyRaw,
        headers: headers,
        parameters: parameters,
        useToken: false);

    if (res.statusCode == 401 &&
        json.decode(res.body)['error']['message'] ==
            "The access token expired") {
      await refreshAccessToken();
      put(
        endpoint,
        body: body,
        bodyRaw: bodyRaw,
        parameters: parameters,
        headers: headers,
      );
    }
    return res;
  }
}
