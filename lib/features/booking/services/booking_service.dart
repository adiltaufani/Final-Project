import 'dart:convert';
import 'package:flutter_project/features/booking/screens/booking_page.dart';
import 'package:flutter_project/features/wishlist/database/db_helper.dart';
import 'package:flutter_project/features/wishlist/model/wishlist_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_project/variables.dart';
import 'package:http/http.dart' as http;

class BookingService {
  static Future<List> fetchData(
      String hotelId, String? tanggalAwal, String? tanggalAkhir) async {
    List _Listdata = [];
    if (tanggalAwal != null && tanggalAkhir != null) {
      try {
        final response = await http.get(
          Uri.parse(
              '$ipaddr/ta_projek/crudtaprojek/get_rooms_byid.php?uid=$hotelId&tanggal_checkin=$tanggalAwal&tanggal_checkout=$tanggalAkhir'),
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          _Listdata = data;
        }
      } catch (e) {
        print(e);
      }
    } else {
      try {
        DateTime tanggal = DateTime.now();
        DateTime tanggalbesok = tanggal.add(Duration(days: 1));
        String formattedTanggal = tanggal.toIso8601String().substring(0, 10);
        String formattedTanggalbesok =
            tanggalbesok.toIso8601String().substring(0, 10);
        final response = await http.get(
          Uri.parse(
              '$ipaddr/ta_projek/crudtaprojek/get_rooms_byid.php?uid=$hotelId&tanggal_checkin=$formattedTanggal&tanggal_checkout=$formattedTanggalbesok'),
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          _Listdata = data;
        }
      } catch (e) {
        print(e);
      }
    }
    return _Listdata;
  }

  static void addToWishlist(BookingPage widget) {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    String user_id = user.uid;
    String nama_penginapan = widget.locationName;
    String hotel_id = widget.hotel_id;
    String alamat = widget.locationAddress;
    String url_foto = widget.url_foto;
    WishlistModel wishlistModel = WishlistModel(
        nama_penginapan: nama_penginapan,
        hotel_id: hotel_id,
        address: alamat,
        uid: user_id,
        url_foto: url_foto);
    WishlistDatabaseHelper.insertWishlist(wishlistModel);
  }
}
