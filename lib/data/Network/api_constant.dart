import 'dart:convert';
import 'package:http/http.dart' as http;

class FetchingData {
  //Production
  static String baseUrl = "palm.moh-dhs.com";

  static Future<http.Response> postData(
      String provideUrl, Map<String, dynamic> param) async {
    var url = Uri.https(baseUrl, provideUrl);
    final response = await http.post(url, body: param);
    return response;
  }

  static Future<http.Response> postHeader(String provideUrl,
      Map<String, String> param, Map<String, dynamic> parBody) async {
    var url = Uri.https(baseUrl, provideUrl);
    final response = await http.post(url, headers: param, body: parBody);
    return response;
  }

  static Future<http.Response> getHeader(
      String provideUrl, Map<String, String> param) async {
    var url = Uri.https(baseUrl, provideUrl);
    final response = await http.get(url, headers: param);
    return response;
  }

  static Future<http.Response> getData(
      String provideUrl, Map<String, String> param) async {
    var url = Uri.https(baseUrl, provideUrl);
    final response = await http.get(url, headers: param);
    return response;
  }

  static Future<http.Response> getAttendanceData(
      String provideUrl, Map<String, String> header) async {
    var url = Uri.https(
      baseUrl,
      provideUrl,
    );
    final response = await http.get(url, headers: header);
    return response;
  }

  static Future<http.Response> getLeaveData(
    String provideUrl,
    Map<String, String> header,
  ) async {
    var url = Uri.https(baseUrl, provideUrl);
    final response = await http.get(url, headers: header);
    return response;
  }

  static Future<http.Response> getApprovalData(
    String provideUrl,
    Map<String, String> header,
  ) async {
    var url = Uri.https(baseUrl, provideUrl);
    final response = await http.get(url, headers: header);
    return response;
  }

  static Future<http.Response> postAttendanceData(String provideUrl,
      Map<String, String> header, Map<dynamic, dynamic> parBody) async {
    var url = Uri.https(baseUrl, provideUrl);
    final response = await http.post(url, headers: header, body: parBody);
    return response;
  }

  static Future<http.Response> postLeave(String providerUrl,
      Map<String, String> header, Map<String, dynamic> body) async {
    var url = Uri.https(baseUrl, providerUrl);

    // Ensure Content-Type is set for JSON
    final headers = {
      'Content-Type': 'application/json',
      ...header,
    };

    final response =
        await http.post(url, headers: headers, body: jsonEncode(body));
    return response;
  }

  static Future<http.Response> postApprovalAction(String providerUrl,
      Map<String, String> header, Map<String, dynamic> body) async {
    var url = Uri.https(baseUrl, providerUrl);

    // Ensure Content-Type is set for JSON
    final headers = {
      'Content-Type': 'application/json',
      ...header,
    };

    final response =
        await http.post(url, headers: headers, body: jsonEncode(body));
    return response;
  }

  static Future<http.Response> deleteCart(String provideUrl,
      Map<String, dynamic> param, Map<String, String> header) async {
    var url = Uri.https(baseUrl, provideUrl, param);
    final response = await http.delete(url, headers: header);
    return response;
  }
}
