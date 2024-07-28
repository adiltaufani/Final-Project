import 'dart:convert';
import 'package:flutter_project/features/landmark/model/landmark_model.dart';
import 'package:http/http.dart' as http;

class LandmarkViewModel {
  List<LandmarkModel> mainLandmarkList = [];
  bool isLoading = true;

  Future<void> getData(String ipaddr) async {
    isLoading = true;

    try {
      final response = await http.get(
        Uri.parse('$ipaddr/ta_projek/crudtaprojek/read_landmark.php'),
      );
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        List<LandmarkModel> landmarkList = jsonData.map((data) {
          return LandmarkModel(
            data['landmark_url'],
            data['landmark_name'],
            data['latitude'],
            data['longitude'],
          );
        }).toList();

        mainLandmarkList = landmarkList;
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
    }
  }
}
