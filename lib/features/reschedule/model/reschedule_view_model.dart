import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class RescheduleViewModel {
  String? firstname;
  String? lastname;
  String? number;
  String? birthdate;
  String? address;
  String? email;
  String ipaddr;

  RescheduleViewModel(this.ipaddr);

  Future<void> fetchUserData() async {
    var user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("Silakan login terlebih dahulu");
    }

    var url = Uri.parse("$ipaddr/ta_projek/crudtaprojek/view_data.php");
    String uid = user.uid;

    var response = await http.post(url, body: {
      "uid": uid,
    });

    var data = json.decode(response.body);
    if (data != null) {
      firstname = data['firstname'];
      lastname = data['lastname'];
      number = data['number'];
      birthdate = data['birthdate'];
      address = data['address'];
      email = data['email'];
    } else {
      throw Exception("Gagal mendapatkan data pengguna");
    }
  }

  Future<void> deleteBooking(String id) async {
    String url = '$ipaddr/ta_projek/crudtaprojek/deletedata.php?id=$id';

    try {
      final response = await http.post(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('Gagal menghapus data dengan ID $id');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<void> updateBookingDate(
      String idBooking, String newCheckinDate, String newCheckoutDate) async {
    var url = Uri.parse('$ipaddr/ta_projek/crudtaprojek/reschedule.php');
    var response = await http.post(url, body: {
      'id_booking': idBooking,
      'new_checkin_date': newCheckinDate,
      'new_checkout_date': newCheckoutDate,
    });

    if (response.statusCode != 200) {
      throw Exception('Error: ${response.reasonPhrase}');
    }
  }
}
