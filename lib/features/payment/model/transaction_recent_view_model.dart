import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_project/variables.dart';

class TransactionRecentViewModel {
  List<dynamic> listData = [];
  bool isLoading = true;
  double rating = 0;

  Future<void> getData(String userId) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${ipaddr}/ta_projek/crudtaprojek/transaction_recent.php?user_id=$userId'),
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

  Future<String?> fetchUserData() async {
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
    if (data != null) {
      return data['id'];
    } else {
      print("Gagal mendapatkan data pengguna");
      return null;
    }
  }

  Future<void> submitRating(double rating, String id) async {
    final response = await http.post(
      Uri.parse('${ipaddr}/ta_projek/crudtaprojek/add_rating.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'rating': rating,
        'house_id': id,
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['success'] != null) {
        print(responseBody['success']);
      } else {
        print(responseBody['error']);
      }
    } else {
      print('Failed to update rating');
    }
  }
}
