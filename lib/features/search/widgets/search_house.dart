// search_house_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_project/features/booking/screens/booking_page.dart';
import 'package:flutter_project/features/search/model/hotel_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class SearchHouse extends StatefulWidget {
  final String terusan;
  final String terusan2;
  String? tanggal_checkin;
  String? tanggal_checkout;
  double? hargaAwal;
  double? hargaAkhir;
  int? bintang;
  bool? wifi;
  bool? kolamRenang;
  bool? parkir;
  bool? restoran;
  bool? gym;
  bool? resepsionis24jam;

  SearchHouse({
    required this.terusan,
    required this.terusan2,
    this.tanggal_checkin,
    this.tanggal_checkout,
    this.hargaAkhir,
    this.hargaAwal,
    this.bintang,
    this.wifi,
    this.kolamRenang,
    this.parkir,
    this.restoran,
    this.gym,
    this.resepsionis24jam,
  });

  @override
  State<SearchHouse> createState() => _SearchHouseState();
}

class _SearchHouseState extends State<SearchHouse> {
  late HotelViewModel _viewModel;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _viewModel = HotelViewModel();
    _loadHotels();
  }

  Future<void> _loadHotels() async {
    try {
      await _viewModel.fetchHotels(
        table: widget.terusan,
        kota: widget.terusan2,
        tanggal_checkin: widget.tanggal_checkin,
        tanggal_checkout: widget.tanggal_checkout,
        hargaMin: widget.hargaAwal,
        hargaMax: widget.hargaAkhir,
        bintang: widget.bintang,
        wifi: widget.wifi,
        kolamRenang: widget.kolamRenang,
        parkir: widget.parkir,
        restoran: widget.restoran,
        pusatKebugaran: widget.gym,
        resepsionis24Jam: widget.resepsionis24jam,
      );
      setState(() {
        isLoading = false;
      });
      print('try load berhasil');
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Container(
              width: double.infinity,
              height: 570,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _viewModel.hotels.length,
                      itemBuilder: (BuildContext context, int index) {
                        String cleanedUrlFoto = _viewModel
                            .hotels[index].url_foto
                            .replaceAll('\\', '');
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookingPage(
                                  locationName:
                                      _viewModel.hotels[index].nama_penginapan,
                                  locationAddress:
                                      _viewModel.hotels[index].alamat,
                                  jumlah_reviewer:
                                      _viewModel.hotels[index].jumlah_reviewer,
                                  url_foto: cleanedUrlFoto,
                                  hotel_id:
                                      _viewModel.hotels[index].id.toString(),
                                  latitude: _viewModel.hotels[index].latitude,
                                  longitude: _viewModel.hotels[index].longitude,
                                  tanggalAwal: widget.tanggal_checkin,
                                  tanggalAkhir: widget.tanggal_checkout,
                                  sellersEmail: 'tes',
                                  sellersFoto:
                                      'https://th.bing.com/th/id/OIP.QjynegEfQVPq5kIEuX9fWQHaFj?w=263&h=197&c=7&r=0&o=5&pid=1.7',
                                  sellersName: 'tes',
                                  sellersUid: 'tes',
                                  sellersid: '4',
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.173,
                            margin: const EdgeInsets.only(
                              top: 15,
                              left: 20,
                              right: 20,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    image: DecorationImage(
                                      image: NetworkImage(cleanedUrlFoto),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 13),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              _viewModel.hotels[index]
                                                  .nama_penginapan,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.montserrat(
                                                textStyle: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: -0.5,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            Icons.save,
                                            size: 25,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(width: 0),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            _viewModel.hotels[index].rating
                                                .toString(),
                                            style: GoogleFonts.montserrat(
                                              textStyle: const TextStyle(
                                                color: Colors.blue,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            '/',
                                            style: GoogleFonts.montserrat(
                                              textStyle: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            '(',
                                            style: GoogleFonts.montserrat(
                                              textStyle: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            _viewModel
                                                .hotels[index].jumlah_reviewer
                                                .toString(),
                                            style: GoogleFonts.montserrat(
                                              textStyle: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            ')',
                                            style: GoogleFonts.montserrat(
                                              textStyle: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Icon(
                                            Icons.star,
                                            size: 15,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        _viewModel.hotels[index].alamat,
                                        style: GoogleFonts.montserrat(
                                          textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      Row(
                                        children: [
                                          Text(
                                            'Rp.',
                                            style: GoogleFonts.montserrat(
                                              textStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 8, 59, 134),
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            formatInteger(_viewModel
                                                .hotels[index].harga
                                                .toString()),
                                            style: GoogleFonts.montserrat(
                                              textStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 8, 59, 134),
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          );
  }
}

String formatInteger(String numberString) {
  double number = double.parse(numberString);
  NumberFormat formatter = NumberFormat("#,##0", "en_US");
  return formatter.format(number);
}
