import 'package:flutter/material.dart';
import 'package:flutter_project/features/booking/screens/booking_page.dart';
import 'package:flutter_project/features/chatAI/services/navigate_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_project/features/home/screens/home_screen.dart';

class AINavigateScreen extends StatefulWidget {
  final String namaKota;
  final String lokasiPage;
  final double latitude;
  final double longitude;
  const AINavigateScreen({
    super.key,
    required this.namaKota,
    required this.lokasiPage,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<AINavigateScreen> createState() => _AINavigateScreenState();
}

class _AINavigateScreenState extends State<AINavigateScreen> {
  List _listData = [];
  final TextEditingController _searchController = TextEditingController();
  bool isTextFieldFocused = false;
  DateTimeRange selectedDates = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );
  bool _isUp = false;

  @override
  void initState() {
    super.initState();
    _getData();
    print(widget.namaKota);
  }

  void _toggleImage() {
    setState(() {
      _isUp = !_isUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
          ),
          automaticallyImplyLeading: false,
          title: Container(
            width: double.infinity,
            height: 40.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: TextField(
                textAlignVertical: TextAlignVertical.top,
                controller: _searchController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.all(4.0),
                  hintText: 'Search..',
                  border: InputBorder.none,
                  alignLabelWithHint: true,
                  hintMaxLines: 1,
                ),
                onTap: () {
                  setState(() {
                    isTextFieldFocused = true;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    isTextFieldFocused = value.isNotEmpty;
                  });
                },
                onSubmitted: (value) {
                  setState(() {
                    isTextFieldFocused = false;
                  });
                },
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, HomeScreen.routeName);
              },
              padding: const EdgeInsets.only(right: 12),
              icon: const Icon(
                Icons.close,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 900,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Search for',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w300,
                            color: Color(0xFF757575),
                          ),
                        ),
                        Text(
                          'AI Recomended For You',
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Image.asset(
                      'assets/images/bookit.png',
                      height: 20.0,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _listData.length,
                  itemBuilder: (BuildContext context, int index) {
                    String cleanedUrlFoto =
                        _listData[index]['url_foto'].replaceAll('\\', '');
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingPage(
                              locationName: _listData[index]['nama_penginapan'],
                              locationAddress: _listData[index]['alamat'],
                              jumlah_reviewer: _listData[index]
                                  ['jumlah_reviewer'],
                              url_foto: cleanedUrlFoto,
                              hotel_id: _listData[index]['id'].toString(),
                              latitude: _listData[index]['latitude'],
                              longitude: _listData[index]['longitude'],
                              tanggalAwal: '2024-07-23',
                              tanggalAkhir: '2024-07-24',
                              sellersEmail: _listData[index]['email'],
                              sellersFoto: _listData[index]['sellers_foto'],
                              sellersName: _listData[index]['nama'],
                              sellersUid: _listData[index]['uid'],
                              sellersid: _listData[index]['sellers_id'],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.173,
                        margin:
                            const EdgeInsets.only(top: 15, left: 20, right: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 2),
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
                                    fit: BoxFit.cover),
                              ),
                            ),
                            const SizedBox(
                              width: 13,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        constraints:
                                            const BoxConstraints(maxWidth: 140),
                                        child: Text(
                                          _listData[index]['nama_penginapan'],
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
                                      InkWell(
                                        onTap: _toggleImage,
                                        borderRadius: BorderRadius.circular(8),
                                        child: AnimatedSwitcher(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          child: _isUp
                                              ? Icon(
                                                  Icons.bookmark_rounded,
                                                  color: Colors.black54,
                                                  size: 28,
                                                  key: UniqueKey(),
                                                )
                                              : Icon(
                                                  Icons
                                                      .bookmark_outline_rounded,
                                                  color: Colors.black54,
                                                  size: 28,
                                                  key: UniqueKey(),
                                                ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 0,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        _listData[index]['rating'],
                                        style: GoogleFonts.montserrat(
                                          textStyle: const TextStyle(
                                            color: Colors.blue,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '/',
                                        style: GoogleFonts.montserrat(
                                          textStyle: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
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
                                        _listData[index]['jumlah_reviewer'],
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
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Icon(
                                        Icons.star,
                                        size: 15,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    _listData[index]['alamat'],
                                    style: GoogleFonts.montserrat(
                                      textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Rp.',
                                        style: GoogleFonts.montserrat(
                                          textStyle: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 8, 59, 134),
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Text(
                                        '${_listData[index]['harga_termurah']}',
                                        style: GoogleFonts.montserrat(
                                          textStyle: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 8, 59, 134),
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
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
              const SizedBox(
                height: 120,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatInteger(String numberString) {
    int number = int.parse(numberString);
    NumberFormat formatter = NumberFormat("#,##0", "en_US");
    return formatter.format(number);
  }

  Future<void> _getData() async {
    List data = await NavigateService.getData(
        widget.namaKota, widget.latitude, widget.longitude);
    setState(() {
      _listData = data;
    });
  }
}
