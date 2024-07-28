import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_project/variables.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class HomeService {
  String uid = '';
  static Future<Map<String, dynamic>?> fetchUserData() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("Silakan login terlebih dahulu");
      return null;
    }

    var url = Uri.parse("${ipaddr}/ta_projek/crudtaprojek/view_data.php");
    String uid = user.uid;
    var response = await http.post(url, body: {
      "uid": uid,
    });

    var data = json.decode(response.body);
    return data;
  }

  static Future<bool> runPHPCodeOnHomeScreen() async {
    final url = '${ipaddr}/ta_projek/crudtaprojek/update_harga_termurah.php';
    try {
      final response = await http.get(Uri.parse(url));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<Position> getLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception("Location permission denied");
    }
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return position;
  }

  static Future<String> getCityFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];
      return place.locality.toString();
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  static Future<bool> isTutorial() async {
    final url = '${ipaddr}/ta_projek/crudtaprojek/update_tutorial.php';
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("No user is currently logged in.");
      return false;
    }

    final uid = user.uid;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user_uid': uid,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  static Future<bool> checkTutorialStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("No user is currently logged in.");
      return false;
    }

    final uid = user.uid;
    final url = '${ipaddr}/ta_projek/crudtaprojek/tutorial_check.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user_uid': uid,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return data['is_tutorial'] == 1;
        } else {
          print("Error: ${data['message']}");
        }
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
    return false;
  }
}
