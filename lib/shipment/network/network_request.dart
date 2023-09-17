import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:my_bloc_app/shipment/models/item_model.dart';
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
    UserModel userDetail = const UserModel();
    Response response = await client.get(
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $accesstoken'
      },
      Uri.https(baseUrl, '/users/me'),
    );
    if (response.statusCode == 200) {
      UserModel user = const UserModel();
      userDetail = user.getUser(
        jsonDecode(response.body),
      );
    }
    return userDetail;
  }

  Future<String> postItem(
      {required Items item, required String accesstoken}) async {
    try {
      Response response = await client.post(
        Uri.https(baseUrl, '/items'),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $accesstoken'
        },
        body: jsonEncode(
          item.itemToMap(item: item),
        ),
      );
      if (response.statusCode == 200) {
        return 'success';
      } else {
      }
    } catch (e) {
      log(
        e.toString(),
      );
    }
    return 'error';
  }

  Future<String> confirmUser({required String accessToken}) async {
    try {
      Response response = await client.get(
        Uri.https(baseUrl, '/users/confirm?token=$accessToken'),
      );
      if (response.statusCode == 200) {
        return 'success';
      } else {
        return 'error';
      }
    } on Exception catch (e) {
      return e.toString();
    }
  }

  Future<List<Items>> getItemStream({required String accessToken}) async {
    try {
      Response response =
          await client.get(Uri.https(baseUrl, '/items/'), headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      });
      if (response.statusCode == 200) {
        List<dynamic> itemList = jsonDecode(response.body);
        return itemList.map((e) => Items.itemFromNetwork(e)).toList();
      } else {
        throw Exception('Expired Time');
      }
    } on Exception catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  Future<bool> deleteItem(String id, String accessToken) async {
    bool error = false;
    Response response = await client.delete(
      Uri.https(baseUrl, '/items/$id'),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      error = false;
    } else {}
    return !error;
  }

  Future<List> updateItem(String id, String accessToken, Items item) async {
    String error = '';
    List timeline = [];
    try {
      Response response = await client.put(
        Uri.https(baseUrl, '/items/$id'),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(
          item.updateToMap(item),
        ),
      );

      if (response.statusCode == 200) {
        error = 'success';
        final Map<String, dynamic> responses = jsonDecode(response.body);
        log(response.body);
        timeline = responses['timeline'];
      } else {
        error = 'failure';
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return [error, timeline];
  }
}
