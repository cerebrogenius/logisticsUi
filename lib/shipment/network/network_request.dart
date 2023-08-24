import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:my_bloc_app/shipment/models/user_model.dart';
import '../utilities/constants.dart';

class HttpRequest {
  var client = http.Client();
  String status = '';

  Future<String> registerNewUser({required UserModel user}) async {
    try {
      Response response = await client.post(
        headers: {'Content-type': 'application/json'},
        Uri.https(baseUrl, '/users/new'),
        body: jsonEncode(user.toMap(user)),
      );
      Map<String, dynamic> details = jsonDecode(response.body);
      if (response.statusCode == 200) {
        status = 'success';
      } else if (response.statusCode == 422) {
        Map<String, dynamic> error = details;
        status = error['detail'][0]['msg'];
      } else if (response.statusCode == 409) {
        Map<String, dynamic> msg = details;
        status = msg['detail'];
      }
    } catch (e) {
      return e.toString();
    }
    return status;
  }

  Future<List> loginUser(
      {required String email, required String password}) async {
    Map<String, dynamic> detail = {};
    String message = '';
    Response response = await client.post(
      headers: {'Content-type': 'application/json'},
      Uri.https(baseUrl, '/users/login'),
      body: jsonEncode({'email': email, 'password': password}),
    );
    detail = jsonDecode(response.body);
    if (response.statusCode == 200) {
      message = 'success';
    } else if (response.statusCode == 401) {
      message = 'incorrect details';
    } else if (response.statusCode == 422) {
      message = 'validation error';
    }
    return [message, detail];
  }

  Future<String> logoutUser(String accesstoken) async {
    Response response = await client.post(
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $accesstoken'
      },
      Uri.https(baseUrl, '/users/logout'),
    );
    if (response.statusCode == 200) {
      return 'success';
    }

    return 'error';
  }

  Future<UserModel> getUserDetailsFromNetwork(String accesstoken) async {
    UserModel userDetail = UserModel();
    Response response = await client.get(
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $accesstoken'
      },
      Uri.https(baseUrl, '/users/me'),
    );
    if (response.statusCode == 200) {
      UserModel user = UserModel();
      userDetail = user.getUser(
        jsonDecode(response.body),
      );
    }
    return userDetail;
  }
}
