import 'dart:convert';
import 'package:http/http.dart' as http;

class LandmarkNavViewModel {
  List<dynamic> listDataNear = [];
  bool isLoading = true;

  Future<void> getDataNear(
      String latitude, String longitude, String ipaddr) async {
    isLoading = true;
    try {
      final response = await http.get(
        Uri.parse(
            '$ipaddr/ta_projek/crudtaprojek/landmark_nav.php?user_latitude=$latitude&user_longitude=$longitude'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        listDataNear = data;
        print(listDataNear);
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
    }
  }
}
