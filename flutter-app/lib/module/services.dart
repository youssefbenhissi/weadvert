// import 'package:dio/dio.dart';

// class Service {
//   Dio dio = new Dio();
//   login(name, password) async {
//     try {
//       FormData formData = new FormData.fromMap({
//         "password": password,
//         "email": name,
//       });
//       return await dio.post(
//         'http://192.168.1.3:1337/login',
//         data: formData,
//       );
//     } on DioError catch (e) {
//       print(e.response.data['msg']);
//     }
//   }
// }
import 'dart:convert';

import 'package:http/http.dart';

import '../constants.dart';

class service {
  makePostRequest(String email, String password) async {
    // set up POST request arguments
    String url = link + '/login';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"email": "' + email + '", "password": "' + password + '"}';
    // String json = '{"email": ' + email + ', "password": ' + password + ' }';
    // make POST request
    Response response = await post(url, headers: headers, body: json);
    // check the status code for the result
    //int statusCode = response.statusCode;

    /// print(statusCode);
    // this API passes back the id of the new item added to the body
    //String body = response.body;
    //print(body);
    //print(body);
    List<String> pairs = json.split(",");
    print(pairs);
    this._nom = pairs
        .elementAt(1)
        .split(":")
        .elementAt(1)
        .substring(2, pairs.elementAt(1).split(":").elementAt(1).length - 2);
    //print("waaaaa" + this._nom);
    //this._prenom = pairs.elementAt(2);
    //this._email = pairs.elementAt(3);
    return response;
    // {
    //   "title": "Hello",
    //   "body": "body text",
    //   "userId": 1,
    //   "id": 101
    // }
  }

  String _nom = "baha", _prenom = "baha", _email = "baha";
  registerUser(String email, String password) async {
    String url = link + '/register';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"email": "' + email + '", "password": "' + password + '"}';
    Response response = await post(url, headers: headers, body: json);

    return response;
  }

  registerUserBusiness(String email, String password) async {
    String url = link + '/registerbusiness';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"email": "' + email + '", "password": "' + password + '"}';
    Response response = await post(url, headers: headers, body: json);

    return response;
  }

  verifyUser(String email, String code) async {
    String url = link + '/verify_user';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"email": "' + email + '", "code": "' + code + '"}';
    Response response = await post(url, headers: headers, body: json);
    return response;
  }

  ajouterautomobiliste(String nom, String prenom, String email,
      String profession, String lieuCirculation, String numerotelephone) async {
    String url = 'http://192.168.1.15:1337/ajouterautomobilste';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"nom": "' +
        nom +
        '", "prenom": "' +
        prenom +
        '", "email": "' +
        email +
        '", "profession": "' +
        profession +
        '", "lieuCirculation": "' +
        lieuCirculation +
        '", "numerotelephone": "' +
        numerotelephone +
        '"}';
    Response response = await post(url, headers: headers, body: json);
    return response;
  }
}
