import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:pim/constants.dart';

upload(File imageFile, String imgName) async {
  var uri = Uri.parse(link + '/add_group_image');

  var request = new http.MultipartRequest("POST", uri);

  var multipartFile = new http.MultipartFile.fromBytes(
    'imgName',
    await imageFile.readAsBytes(),
    filename: imgName,
    contentType: MediaType.parse("image/jpeg"),
  );

  request.files.add(multipartFile);

  var response = await request.send();
  print(response.statusCode);

  response.stream.transform(utf8.decoder).listen((value) {
    print(value);
  });
}
