import 'package:flutter/material.dart';
import 'package:flutter_project/features/appbar_global.dart';
import 'package:flutter_project/features/auth/widgets/side_menu.dart';
import 'package:flutter_project/features/booking/screens/booking_page.dart';
import 'package:flutter_project/features/landmark/model/landmark_nav_view_model.dart';
import 'package:flutter_project/features/notification/screens/notification_page.dart';
import 'package:flutter_project/features/profile/screens/setting_page.dart';
import 'package:flutter_project/features/search/widgets/search_page_widget.dart';
import 'package:flutter_project/variables.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class LandmarkNav extends StatefulWidget {
  static const String routeName = '/landmark-nav';
  final String lmName;
  final String latitude;
  final String longitude;

  LandmarkNav({
    required this.lmName,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<LandmarkNav> createState() => _LandmarkNavState();
}

class _LandmarkNavState extends State<LandmarkNav> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late LandmarkNavViewModel landmarkNavViewModel;

  bool isTextFieldFocused = false;
  bool _isUp = false;

  void _toggleImage() {
    setState(() {
      _isUp = !_isUp;
    });
  }

  @override
  void initState() {
    super.initState();
    landmarkNavViewModel = LandmarkNavViewModel();
    _getDataNear();
  }

  Future<void> _getDataNear() async {
    await landmarkNavViewModel.getDataNear(
        widget.latitude, widget.longitude, ipaddr);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideMenu(),
      drawerScrimColor: Colors.black38,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
          ),
          title: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, SearchPageWidget.routeName);
            },
            child: Container(
              width: double.infinity,
              height: 40.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Icon(
                      Icons.search,
                      color: Colors.black26,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Search..',
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          color: Colors.black26,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          leading: IconButton(
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
              size: 30.0,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, NotificationPage.routeName);
              },
              icon: Image.asset(
                'assets/images/notification.png',
                height: 34.0,
              ),
            ),
            FutureBuilder<String?>(
                future: ProfileDataManager.getProfilePic(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, SettingPage.routeName);
                      },
                      icon: CircleAvatar(
                        radius: 26,
                        backgroundColor: Colors.white30,
                        backgroundImage: NetworkImage(snapshot.data!),
                      ),
                    );
                  } else {
                    return Text('no data');
                  }
                }),
          ],
        ),
      ),
      body: landmarkNavViewModel.isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFD2E9FF), // Warna gradient awal
                    Color(0xFFFFFFFF), // Warna gradient akhir
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Near From ${widget.lmName}',
                              style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
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
                      itemCount: landmarkNavViewModel.listDataNear.length,
                      itemBuilder: (BuildContext context, int index) {
                        String cleanedUrlFoto = landmarkNavViewModel
                            .listDataNear[index]['url_foto']
                            .replaceAll('\\', '');
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookingPage(
                                  locationName: landmarkNavViewModel
                                      .listDataNear[index]['nama_penginapan'],
                                  locationAddress: landmarkNavViewModel
                                      .listDataNear[index]['alamat'],
                                  jumlah_reviewer: landmarkNavViewModel
                                      .listDataNear[index]['jumlah_reviewer'],
                                  url_foto: cleanedUrlFoto,
                                  hotel_id: landmarkNavViewModel
                                      .listDataNear[index]['id']
                                      .toString(),
                                  latitude: widget.latitude,
                                  longitude: widget.longitude,
                                  tanggalAwal: '2024-07-23',
                                  tanggalAkhir: '2024-07-24',
                                  sellersEmail: landmarkNavViewModel
                                      .listDataNear[index]['email'],
                                  sellersFoto: landmarkNavViewModel
                                      .listDataNear[index]['sellers_foto'],
                                  sellersName: landmarkNavViewModel
                                      .listDataNear[index]['nama'],
                                  sellersUid: landmarkNavViewModel
                                      .listDataNear[index]['uid'],
                                  sellersid: landmarkNavViewModel
                                      .listDataNear[index]['sellers_id'],
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
                                right: 20), // Atur margin jika diperlukan
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            constraints: const BoxConstraints(
                                                maxWidth: 140),
                                            child: Text(
                                              landmarkNavViewModel
                                                      .listDataNear[index]
                                                  ['nama_penginapan'],
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
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: AnimatedSwitcher(
                                              duration: const Duration(
                                                  milliseconds: 300),
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
                                            landmarkNavViewModel
                                                .listDataNear[index]['rating'],
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
                                            landmarkNavViewModel
                                                .listDataNear[index]
                                                    ['jumlah_reviewer']
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
                                        landmarkNavViewModel.listDataNear[index]
                                            ['alamat'],
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
                                            formatInteger(landmarkNavViewModel
                                                .listDataNear[index]
                                                    ['harga_termurah']
                                                .toString()), // Mengonversi integer ke string sebelum memanggil formatInteger
                                            style: GoogleFonts.montserrat(
                                              textStyle: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 8, 59, 134),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
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
                ],
              ),
            ),
    );
  }

  String formatInteger(String numberString) {
    // Mengonversi string ke integer
    double number = double.parse(numberString);

    // Membuat objek NumberFormat untuk memformat angka
    NumberFormat formatter = NumberFormat("#,##0", "en_US");
    return formatter.format(number);
  }
}
