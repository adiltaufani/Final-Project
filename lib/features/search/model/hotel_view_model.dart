// hotel_view_model.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class HotelViewModel {
  List<Hotel> hotels = [];

  Future<void> fetchHotels({
    String? table,
    String? kota,
    String? tanggal_checkin,
    String? tanggal_checkout,
    double? hargaMin,
    double? hargaMax,
    int? bintang,
    bool? wifi,
    bool? kolamRenang,
    bool? parkir,
    bool? restoran,
    bool? pusatKebugaran,
    bool? resepsionis24Jam,
  }) async {
    final url = Uri.parse(
        'https://projekta.seculab.space/ta_projek/crudtaprojek/tes_filter_new.php?');

    Map<String, dynamic> queryParams = {};
    if (table != null) queryParams['tipe'] = table.toString();
    if (kota != null) queryParams['kota'] = kota.toString();
    if (tanggal_checkin != null)
      queryParams['tanggal_checkin'] = tanggal_checkin.toString();
    if (tanggal_checkout != null)
      queryParams['tanggal_checkout'] = tanggal_checkout.toString();
    if (hargaMin != null) queryParams['harga_min'] = hargaMin.toString();
    if (hargaMax != null) queryParams['harga_max'] = hargaMax.toString();
    if (bintang != null) queryParams['rating'] = bintang.toString();
    if (wifi == true) queryParams['wifi'] = '1';
    if (kolamRenang == true) queryParams['kolam_renang'] = '1';
    if (parkir == true) queryParams['parkir'] = '1';
    if (restoran == true) queryParams['restoran'] = '1';
    if (pusatKebugaran == true) queryParams['pusat_kebugaran'] = '1';
    if (resepsionis24Jam == true) queryParams['resepsionis_24_jam'] = '1';

    final urlWithParams = url.replace(queryParameters: queryParams);

    final response = await http.get(urlWithParams);
    print(urlWithParams);

    if (response.statusCode == 200) {
      print(response.body);
      List<dynamic> data = json.decode(response.body);
      hotels = data.map((json) => Hotel.fromJson(json)).toList();
    } else {
      hotels.clear();
      throw Exception('Failed to load hotels');
    }
  }
}

class Hotel {
  final int id;
  final String url_foto;
  final String nama_penginapan;
  final int rating;
  final String jumlah_reviewer;
  final String alamat;
  final String latitude;
  final String longitude;
  final double harga;
  final String kota;
  final String tipe;
  final bool wifi;
  final bool kolamRenang;
  final bool parkir;
  final bool restoran;
  final bool pusatKebugaran;
  final bool resepsionis24Jam;

  Hotel({
    required this.id,
    required this.url_foto,
    required this.nama_penginapan,
    required this.rating,
    required this.jumlah_reviewer,
    required this.alamat,
    required this.latitude,
    required this.longitude,
    required this.harga,
    required this.kota,
    required this.tipe,
    required this.wifi,
    required this.kolamRenang,
    required this.parkir,
    required this.restoran,
    required this.pusatKebugaran,
    required this.resepsionis24Jam,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: int.parse(json['id']),
      url_foto: json['url_foto'],
      nama_penginapan: json['nama_penginapan'],
      rating: int.parse(json['rating']),
      jumlah_reviewer: json['jumlah_reviewer'],
      alamat: json['alamat'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      harga: double.parse(json['harga_termurah']),
      kota: json['kota'],
      tipe: json['tipe'],
      wifi: json['wifi'] == '1',
      kolamRenang: json['kolam_renang'] == '1',
      parkir: json['parkir'] == '1',
      restoran: json['restoran'] == '1',
      pusatKebugaran: json['pusat_kebugaran'] == '1',
      resepsionis24Jam: json['resepsionis_24_jam'] == '1',
    );
  }
}
