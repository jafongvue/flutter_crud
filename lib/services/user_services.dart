import 'dart:convert';

import 'package:flutter_basic_crud/services/api.dart';
import 'package:http/http.dart' as http;

class UserService {
  getAllUser() async {
    try {
      var request = http.Request('GET', Uri.parse('$APP_URL/v0/api/users'));
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        // print(await response.stream.bytesToString());
        var responseString = await response.stream.bytesToString();
        final decodeMap = json.decode(responseString);
        return decodeMap;
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print("error:$e");
    }
  }

  createNewUser(body) async {
    //function crete user
    try {
      var _result = await http.post(Uri.parse('$APP_URL/v0/api/create/user'),
          headers: {
            'Content-Type': 'application/json'
          }, //ຖ້າບໍ່ໄດ້ໃຫ້ໃຊ້ 'application/json;charset=utf-8'
          body: jsonEncode(body));
      return _result.statusCode;
    } catch (err) {
      print(err);
    }
  }

  updateUser(id, body) async {
    try {
      var _result = await http.put(Uri.parse('$APP_URL/v0/api/update/user/$id'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body));
      return _result.statusCode;
    } catch (err) {
      print(err);
    }
  }

  deleteUser(id) async {
    try {
      var _result = await http.delete(
        Uri.parse('$APP_URL/v0/api/delete/user/$id'),
        headers: {'Content-Type': 'application/json'},
      );
      return _result.statusCode;
    } catch (err) {
      print(err);
    }
  }
}
