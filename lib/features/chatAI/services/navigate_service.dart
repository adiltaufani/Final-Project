import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_project/variables.dart';

class NavigateService {
  static Future<List> getData(
      String namaKota, double latitude, double longitude) async {
    List listData = [];
    if (namaKota == 'rating=&') {
      try {
        final response = await http.get(
          Uri.parse('${ipaddr}/ta_projek/crudtaprojek/ai_rating.php'),
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          listData = data;
        }
      } catch (e) {
        rethrow;
      }
    } else if (namaKota == 'kolam_renang=1' ||
        namaKota == 'pusat_kebugaran=1' ||
        namaKota == 'pusat_kebugaran=1&kolam_renang=1') {
      try {
        final response = await http.get(
          Uri.parse(
              '${ipaddr}/ta_projek/crudtaprojek/ai_fasilitas.php?user_latitude=$latitude&user_longitude=$longitude&$namaKota'),
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          listData = data;
        }
      } catch (e) {
        rethrow;
      }
    } else {
      try {
        final response = await http.get(
          Uri.parse('${ipaddr}/ta_projek/crudtaprojek/ai_fetch.php?$namaKota'),
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          listData = data;
        }
      } catch (e) {
        rethrow;
      }
    }
    return listData;
  }
}
