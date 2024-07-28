import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class PaymentViewModel {
  List<dynamic> listData = [];
  bool isLoading = true;

  Future<void> getData(String ipaddr, String hotelId, String id) async {
    isLoading = true;
    try {
      final response = await http.get(
        Uri.parse(
            '$ipaddr/ta_projek/crudtaprojek/payment_rooms.php?uid=$hotelId&id=$id'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        listData = data;
        isLoading = false;
      }
    } catch (e) {
      print(e);
      isLoading = false;
    }
  }

  Future<void> addBooking(String ipaddr, String roomId, String userId,
      String sellersId, String startDate, String endDate) async {
    final String apiUrl = '$ipaddr/ta_projek/crudtaprojek/booking.php';
    try {
      Map<String, dynamic> data = {
        'room_id': roomId,
        'user_id': userId,
        'sellers_id': sellersId,
        'tanggal_checkin': startDate,
        'tanggal_checkout': endDate
      };
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        print('Data berhasil ditambahkan');
      } else {
        print('Gagal menambahkan data. Status code: ${response.statusCode}');
      }
    } catch (err) {
      print('Error: $err');
    }
  }

  Future<Map<String, dynamic>?> fetchUserData(String ipaddr) async {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("Silakan login terlebih dahulu");
      return null;
    }

    var url = Uri.parse("$ipaddr/ta_projek/crudtaprojek/view_data.php");
    var uid = user.uid;

    var response = await http.post(url, body: {
      "uid": uid,
    });

    var data = json.decode(response.body);
    if (data != null) {
      return data;
    } else {
      print("Gagal mendapatkan data pengguna");
      return null;
    }
  }
}
