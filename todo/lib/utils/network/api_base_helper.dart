import 'dart:convert';
import 'dart:io';
import 'package:todo/services/secure_storage_service.dart';
import 'package:todo/utils/constants.dart';
import 'package:todo/utils/network/app_exceptions.dart';
import 'package:http/http.dart' as http;

class ApiBaseHelper {
  final baseUrl = "https://flutter-amr.noviindus.in/api/";

  final SecureStorageService _storage = SecureStorageService();
  final authToken = "";

  //For all the GET requests
  Future<dynamic> get(String url) async {
    String? authToken = await _storage.getToken();
    var responseJson;
    try {
      final response = await http.get(
        Uri.parse(baseUrl + url),
        headers: {HttpHeaders.authorizationHeader: authToken.toString()},
      );
      print("the url is ${baseUrl + url}");
      responseJson = _returnResponse(response);
      print(responseJson);
      print("the url is ${baseUrl + url}");
      return responseJson;
    } on SocketException {
      throw FetchDataException(Constants.NO_INTERNET);
    }
  }

  //For all the POST form url encoded requests
  Future<dynamic>? formPost(String url, Map<String, String> body) async {
    var responseJson;
    print(baseUrl + url);
    print(body);
    try {
      final Uri uri = Uri.parse(baseUrl + url);
      final response = await http.post(
        uri,
        body: body,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        encoding: Encoding.getByName('utf-8'),
      );
      print(baseUrl + url);
      print(response);
      responseJson = _returnResponse(response);
      return responseJson;
    } on SocketException {
      throw FetchDataException(Constants.NO_INTERNET);
    }
  }

  //For all the POST requests
  Future<dynamic>? post(String url, Map<String, Object?> requestBody) async {
    var responseJson;
    try {
      final Uri uri = Uri.parse(baseUrl + url);
      print("url is ${baseUrl + url}");
      print("url is ${requestBody}");
      final response = await http.post(
        uri,
        body: jsonEncode(requestBody),
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: authToken,
        },
        encoding: Encoding.getByName('utf-8'),
      );
      responseJson = _returnResponse(response);
      print(responseJson);
      return responseJson;
    } on SocketException {
      throw FetchDataException(Constants.NO_INTERNET);
    }
  }

  //For all the PUT requests
  Future<dynamic>? put(String url, Map<String, Object?>? body) async {
    var responseJson;
    try {
      final Uri uri = Uri.parse(baseUrl + url);
      print("url is ${baseUrl + url}");
      final response = await http.put(
        uri,
        body: jsonEncode(body),
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: authToken,
        },
        encoding: Encoding.getByName('utf-8'),
      );
      responseJson = _returnResponse(response);
      print(responseJson);
      return responseJson;
    } on SocketException {
      throw FetchDataException(Constants.NO_INTERNET);
    }
  }

  //For all the DELETE requests
  Future<dynamic>? delete(String url) async {
    var responseJson;
    try {
      final Uri uri = Uri.parse(baseUrl + url);
      print("url is ${baseUrl + url}");
      final response = await http.delete(
        uri,
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: authToken,
        },
        encoding: Encoding.getByName('utf-8'),
      );
      responseJson = _returnResponse(response);
      print(responseJson);
      return responseJson;
    } on SocketException {
      throw FetchDataException(Constants.NO_INTERNET);
    }
  }

  //For all the DELETE requests
  Future<dynamic>? deleteWithBody(String url, Map<String, Object?> body) async {
    var responseJson;

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.deleteUrl(
      Uri.parse(baseUrl + url),
    );
    request.headers.set('content-type', 'application/json');
    request.headers.set('Authorization', authToken);
    request.add(utf8.encode(json.encode(body)));

    HttpClientResponse response = await request.close();
    responseJson = await response.transform(utf8.decoder).join();
    httpClient.close();
    print("result is " + responseJson);
    return responseJson.toString();
  }

  Future<dynamic> fileUpload(File file, String url) async {
    var request = http.MultipartRequest("POST", Uri.parse(baseUrl + url));
    //add text fields
    // request.fields["text_field"] = text;
    //create multipart using filepath, string or bytes
    print("the url is ${baseUrl + url}");
    var pic = await http.MultipartFile.fromPath("file", file.path);
    //add multipart to request
    request.files.add(pic);
    var response = await request.send();

    //Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    return jsonDecode(responseString);
    print(responseString);
  }

  //get with parameters:

  Future<dynamic> getwithparams(String url, Map<String, String> data) async {
    var responseJson;

    final uri = Uri.parse(baseUrl + url).replace(queryParameters: data);
    print("URI IS" + uri.toString());
    final response = await http.get(uri);
    responseJson = _returnResponse(response);
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = jsonDecode(utf8.decode(response.bodyBytes));
        return responseJson;
      case 400:
        throw BadRequestException(Constants.BAD_REQUEST);
      case 401:
        throw BadRequestException(Constants.INVALID_USER);
      case 403:
        throw UnAuthorisedException(Constants.INVALID_TOKEN, 403);
      case 404:
        throw ResourceNotFoundException(Constants.RESOURCE_NOT_FOUND);
      case 406:
        throw BadRequestException(Constants.USER_EXISTS);
      case 500:
      default:
        throw FetchDataException(Constants.INTERNAL_SERVER);
    }
  }
}
