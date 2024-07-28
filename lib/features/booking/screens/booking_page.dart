import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_project/features/booking/widgets/futniture_widget.dart';
import 'package:flutter_project/features/message/screens/message_chat_screen.dart';
import 'package:flutter_project/features/payment/screens/payment_page.dart';
import 'package:flutter_project/features/booking/services/booking_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BookingPage extends StatefulWidget {
  static const String routeName = '/booking-page';
  BookingPage({
    Key? key,
    required this.locationName,
    required this.locationAddress,
    required this.jumlah_reviewer,
    required this.url_foto,
    required this.hotel_id,
    required this.latitude,
    required this.longitude,
    required this.sellersName,
    required this.sellersEmail,
    required this.sellersFoto,
    required this.sellersUid,
    required this.sellersid,
    this.tanggalAwal,
    this.tanggalAkhir,
  }) : super(key: key);

  final String locationName;
  final String locationAddress;
  final String jumlah_reviewer;
  final String url_foto;
  final String hotel_id;
  final String latitude;
  final String longitude;
  String? tanggalAwal;
  String? tanggalAkhir;
  final String sellersid;
  final String sellersName;
  final String sellersUid;
  final String sellersFoto;
  final String sellersEmail;

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTimeRange selectedDates = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );

  double lat = -6.975003032183382;
  double long = 107.64594257899627;
  String formattedTanggal = '';
  String formattedTanggalbesok = '';
  String tanggalAwal = '';
  String tanggalAkhir = '';
  late Future<Map<String, bool>> futureFurnitureData;

  List _Listdata = [];
  List<bool> booleanList = List<bool>.filled(10, true);

  bool _triggerList = false;
  bool _isdatechoosed = false;
  bool _ispersonchoosed = false;
  String hargaa = '';
  double totalHarga = 0;
  String hargaFix = '0';
  DateTime? startDate;
  DateTime? endDate;
  String formattedStartDate = '';
  String formattedEndDate = '';
  String startdateNew = '';
  String enddateNew = '';
  int _selectedValueAdult = 0;
  int _selectedValueChild = 0;
  List<String> selectedRoomIds = [];
  String roomsIds = '';

  @override
  void initState() {
    BookingService.fetchData(
            widget.hotel_id, widget.tanggalAwal, widget.tanggalAkhir)
        .then((data) {
      setState(() {
        _Listdata = data;
      });
    });
    print('hotel id ==== ${widget.hotel_id}');
    super.initState();
  }

  void _formatSelectedDates() {
    formattedStartDate = selectedDates.start.toIso8601String().substring(0, 10);
    formattedEndDate = selectedDates.end.toIso8601String().substring(0, 10);
    DateTime date = DateTime.parse(formattedStartDate);
    DateTime date2 = DateTime.parse(formattedEndDate);
    startdateNew = DateFormat('dd MMMM yyyy').format(date);
    enddateNew = DateFormat('dd MMMM yyyy').format(date2);

    DateTime tanggal = DateTime.now();
    DateTime tanggalbesok = tanggal.add(Duration(days: 1));
    formattedTanggal = tanggal.toIso8601String().substring(0, 10);
    formattedTanggalbesok = tanggalbesok.toIso8601String().substring(0, 10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 167, 205, 239), // Warna gradient awal
                  Color(0xFFFFFFFF), // Warna gradient akhir
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SingleChildScrollView(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageSlideshow(),
                  _buildLocationDetails(),
                  _buildHostDetails(),
                  _buildDescription(),
                  _buildFacilities(),
                  _buildLocationMap(),
                  _buildDateSelector(),
                  _buildGuestSelector(),
                  _buildRoomType(),
                  _buildRoomList(),
                  SizedBox(
                    height: 60,
                  ),
                ],
              ),
            ),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildImageSlideshow() {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(color: Colors.grey),
      child: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            child: ImageSlideshow(
              indicatorColor: const Color(0xFF0A8ED9),
              indicatorBackgroundColor: Colors.white60,
              autoPlayInterval: 5000,
              indicatorRadius: 4,
              isLoop: true,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                        image: NetworkImage(widget.url_foto),
                        fit: BoxFit.cover),
                  ),
                ),
                Image.asset(
                  'assets/images/im2.jpeg',
                  fit: BoxFit.cover,
                ),
                Image.asset(
                  'assets/images/im3.jpeg',
                  fit: BoxFit.cover,
                ),
                Image.asset(
                  'assets/images/im3.jpeg',
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
          Positioned(
            left: 10,
            top: 10,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.black38.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10)),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 332),
                child: Text(
                  widget.locationName,
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  BookingService.addToWishlist(widget);
                  setState(() {
                    _triggerList = !_triggerList;
                  });
                },
                child: _triggerList
                    ? Transform.scale(
                        scale: 1.5, // Besar ikon 1.5 kali lipat
                        child: Icon(
                          Icons.bookmark_rounded,
                          color: Colors.blueGrey,
                        ),
                      )
                    : Transform.scale(
                        scale: 1.5, // Besar ikon 1.5 kali lipat
                        child: Icon(
                          Icons.bookmark_rounded,
                          color: Colors.black12,
                        ),
                      ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.star, color: Color(0xFFDF9652)),
              const SizedBox(width: 6),
              Text(
                widget.jumlah_reviewer,
                style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: Color(0xFF00A5EC),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () {},
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 320),
                  child: Text(
                    widget.locationAddress,
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }

  Widget _buildHostDetails() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(widget.sellersFoto),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hosted by',
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Text(
                    widget.sellersName,
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MessageInboxScreen(
                    receiverEmail: widget.sellersEmail,
                    receiverID: widget.sellersUid,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.messenger_rounded,
                color: Colors.blue.withOpacity(0.4),
                size: 26,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.only(left: 14, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                color: Colors.black87,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: 6,
          ),
          Text(
            '${widget.locationName}Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam',
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFacilities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 14.0),
          child: Text(
            'Facilities',
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                color: Colors.black87,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [FurniturePage(id: widget.hotel_id)],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationMap() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 14.0),
          child: Text(
            'Location',
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                color: Colors.black87,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        const SizedBox(width: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 10),
            const Icon(
              Icons.location_on_outlined,
              color: Color(0xFF00A5EC),
            ),
            const SizedBox(width: 2),
            Padding(
              padding: const EdgeInsets.only(left: 6.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 320),
                child: Text(
                  widget.locationAddress,
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        Container(
          padding: EdgeInsets.only(left: 14),
          child: Material(
            color: Colors.transparent,
            child: ElevatedButton(
              onPressed: () {
                _openMap(lat, long);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A8ED9),
                fixedSize: const Size(120, 34),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                elevation: 2,
                padding:
                    const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                textStyle: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_pin,
                    color: Colors.white,
                    size: 15.0,
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    'View on Map',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text(
            'Date of Your Stay',
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                color: Colors.black87,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                final DateTimeRange? dateTimeRange = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(3000),
                );
                if (dateTimeRange != null) {
                  setState(() {
                    selectedDates = dateTimeRange;
                    startDate = dateTimeRange.start;
                    endDate = dateTimeRange.end;
                    _formatSelectedDates();
                    print('Tanggal Awal: $formattedStartDate');
                    print('Tanggal Akhir: $formattedEndDate');
                    _isdatechoosed = true;
                  });
                }
              },
              child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _isdatechoosed ? Colors.blue : Colors.black45,
                      width: 2,
                    ),
                  ),
                  child: _isdatechoosed
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.calendar_month_rounded,
                              color: Color(0xFF0A8ED9),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${startdateNew} / ${enddateNew}',
                              style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.calendar_month_rounded,
                              color: Color(0xFF0A8ED9),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${tanggalAwal} / ${tanggalAkhir}',
                              style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        )),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGuestSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              showCupertinoModalPopup(
                context: context,
                builder: (_) => SizedBox(
                  width: double.infinity,
                  height: 250,
                  child: Row(
                    children: [
                      Expanded(
                        child: CupertinoPicker(
                          backgroundColor: Colors.white,
                          itemExtent: 30,
                          scrollController: FixedExtentScrollController(
                            initialItem: 0,
                          ),
                          children: const [
                            Text('0 Adult'),
                            Text('1 Adult'),
                            Text('2 Adult'),
                            Text('3 Adult'),
                            Text('4 Adult'),
                            Text('5 Adult'),
                            Text('6 Adult'),
                          ],
                          onSelectedItemChanged: (int value) {
                            setState(() {
                              _selectedValueAdult = value;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: CupertinoPicker(
                          backgroundColor: Colors.white,
                          itemExtent: 30,
                          scrollController: FixedExtentScrollController(
                            initialItem: 0,
                          ),
                          children: const [
                            Text('0 Child'),
                            Text('1 Child'),
                            Text('2 Child'),
                            Text('3 Child'),
                            Text('4 Child'),
                            Text('5 Child'),
                            Text('6 Child'),
                          ],
                          onSelectedItemChanged: (int value) {
                            setState(() {
                              _selectedValueChild = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
              _ispersonchoosed = true;
            });
          },
          child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _ispersonchoosed ? Colors.blue : Colors.black45,
                  width: 2,
                ),
              ),
              child: _ispersonchoosed
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.group_sharp,
                          color: Color(0xFF0A8ED9),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${_selectedValueAdult} Adult, ${_selectedValueChild} Child',
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.group_sharp,
                          color: Colors.black45,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Add Guest\'s',
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              color: Colors.black45,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    )),
        ),
      ),
    );
  }

  Widget _buildRoomType() {
    return Padding(
      padding: const EdgeInsets.only(left: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'Room Type',
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomList() {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _Listdata.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.fromLTRB(24, 0, 24, 20),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(1, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                ClipRect(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 190,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 162,
                                  height: 102,
                                  margin:
                                      const EdgeInsets.fromLTRB(12, 12, 2, 10),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadiusDirectional.circular(10),
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/room.jpeg'),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(10, 12, 0, 10),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _Listdata[index]['tipe_kamar'],
                                                style: GoogleFonts.montserrat(
                                                  textStyle: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: -0.6,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 2.0),
                                                child: Container(
                                                  constraints:
                                                      const BoxConstraints(
                                                          maxWidth: 172),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const SizedBox(height: 8),
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                              Icons
                                                                  .king_bed_rounded,
                                                              color: Colors
                                                                  .black54,
                                                              size: 16),
                                                          const SizedBox(
                                                              width: 8),
                                                          Text(
                                                            "${_Listdata[index]['bedroom']} Bed",
                                                            style: GoogleFonts
                                                                .montserrat(
                                                              textStyle:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                letterSpacing:
                                                                    -0.6,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                              Icons
                                                                  .group_rounded,
                                                              color: Colors
                                                                  .black54,
                                                              size: 16),
                                                          const SizedBox(
                                                              width: 8),
                                                          Text(
                                                            "${_Listdata[index]['kapasitas']} Guest's/Room",
                                                            style: GoogleFonts
                                                                .montserrat(
                                                              textStyle:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                letterSpacing:
                                                                    -0.6,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12, 0, 0, 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Payment',
                                    style: GoogleFonts.montserrat(
                                      textStyle: const TextStyle(
                                        color: Colors.black45,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: -0.6,
                                      ),
                                    ),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                        text:
                                            'Rp ${_Listdata[index]['harga']}/',
                                        style: GoogleFonts.montserrat(
                                          textStyle: const TextStyle(
                                            color: Color(0xFF225B7B),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: -0.6,
                                          ),
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'Night',
                                            style: GoogleFonts.montserrat(
                                              textStyle: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          )
                                        ]),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 8, 8),
                              child: booleanList[index]
                                  ? ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          booleanList[index] = false;
                                          hargaa = _Listdata[index]['harga'];
                                          totalHarga += double.parse(hargaa);
                                          hargaFix = '$totalHarga';
                                          selectedRoomIds
                                              .add(_Listdata[index]['id']);
                                          roomsIds = _Listdata[index]['id'];
                                          print(
                                              '${totalHarga}, ${selectedRoomIds}');
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF225B7B),
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      child: Text(
                                        'Select',
                                        style: GoogleFonts.montserrat(
                                          textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: -0.6,
                                          ),
                                        ),
                                      ),
                                    )
                                  : ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          booleanList[index] = true;
                                          hargaa = _Listdata[index]['harga'];
                                          totalHarga -= double.parse(hargaa);
                                          hargaFix = '$totalHarga';
                                          selectedRoomIds
                                              .remove(_Listdata[index]['id']);
                                          roomsIds = '';
                                          print(
                                              '${totalHarga}, ${selectedRoomIds}');
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Colors.white.withOpacity(0.84),
                                        elevation: 2,
                                        side: BorderSide(
                                            color: const Color(0xFF225B7B),
                                            width: 1.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      child: Text(
                                        'Selected',
                                        style: GoogleFonts.montserrat(
                                          textStyle: const TextStyle(
                                            color: Color(0xFF225B7B),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: -0.6,
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _buildBottomButton() {
    return Positioned(
      bottom: 10,
      right: 10,
      left: 10,
      child: ElevatedButton(
        onPressed: () {
          if (_selectedValueAdult == 0 ||
              totalHarga == 0 ||
              startDate == null) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Input Tidak Sesuai'),
                    content: Text(
                        'Mohon piih tanggal, jumlah orang, dan pilih kamar'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('ok'))
                    ],
                  );
                });
          } else {
            if (widget.tanggalAwal == null && widget.tanggalAkhir == null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PaymentPage(
                    id: roomsIds,
                    hotel_id: widget.hotel_id,
                    url_foto: widget.url_foto,
                    nama_penginapan: widget.locationName,
                    lokasi: widget.locationAddress,
                    hargaTotal: hargaFix,
                    startDate: startdateNew,
                    endDate: enddateNew,
                    adultValue: _selectedValueAdult,
                    childValue: _selectedValueChild,
                    dbstartDate: formattedTanggal,
                    dbendDate: formattedTanggalbesok,
                    sellersid: widget.sellersid,
                  ),
                ),
              );
            } else {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PaymentPage(
                    id: roomsIds,
                    hotel_id: widget.hotel_id,
                    url_foto: widget.url_foto,
                    nama_penginapan: widget.locationName,
                    lokasi: widget.locationAddress,
                    hargaTotal: hargaFix,
                    startDate: startdateNew,
                    endDate: enddateNew,
                    adultValue: _selectedValueAdult,
                    childValue: _selectedValueChild,
                    dbstartDate: widget.tanggalAwal!,
                    dbendDate: widget.tanggalAkhir!,
                    sellersid: widget.sellersid,
                  ),
                ),
              );
            }
          }
        },
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(double.infinity, 52),
          elevation: 2,
          backgroundColor: const Color(0xFF225B7B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // Adjust as needed
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Rp.${hargaFix}',
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.6,
                ),
              ),
            ),
            Text(
              "Book Now",
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

<<<<<<< HEAD
  void _openMap(double lat, double long) async {
    // Membentuk URL Google Maps dengan koordinat yang diberikan
    String googleUrl =
=======
  Future<void> openMap(double lat, double long) async {
    String googleURL =
>>>>>>> 380cf9e95ab52cd7c281740e347ef1cbaca94308
        'https://www.google.com/maps/search/?api=1&query=$lat,$long';

    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  void _openMap(double lat, double long) async {
    String googleUrl = 'https://twitter.com';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
