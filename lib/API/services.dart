// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tinpic/models/pics.dart'; 
import 'dart:io';

class ApiServices {
  final String _baseUrl = 'http://10.0.2.2:8000';  //AVD emu only

   // Get
  Future<List<Pics>> fetchImages() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/photos'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((img) => Pics.fromJson(img)).toList();
      } else {
        throw Exception('Failed to load images');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }


  // Post (upload)
  Future<Map<String, dynamic>> uploadImage(File image) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/upload'));
      request.files.add(await http.MultipartFile.fromPath('file', image.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        return jsonDecode(responseBody);
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      print('Error: $e');
      return {};
    }
  }

  // Delete 
  Future<void> deleteImage(int imageId) async {
    try {
      final response = await http.delete(Uri.parse('$_baseUrl/images/$imageId'));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete image');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
