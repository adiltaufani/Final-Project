import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/features/payment/screens/transaction_screen.dart';
import 'package:flutter_project/features/reschedule/model/reschedule_view_model.dart';
import 'package:flutter_project/variables.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ReschedulePage extends StatefulWidget {
  static const String routeName = '/reschedule-page';
  final String id;
  final String booking_id;
  final String hotel_id;
  final String nama_penginapan;
  final String lokasi;
  final String hargaTotal;
  final String startDate;
  final String endDate;
  final String tipekamar;
  final String url_foto;

  const ReschedulePage({
    Key? key,
    required this.id,
    required this.hotel_id,
    required this.nama_penginapan,
    required this.lokasi,
    required this.url_foto,
    required this.hargaTotal,
    required this.startDate,
    required this.endDate,
    required this.tipekamar,
    required this.booking_id,
  }) : super(key: key);

  @override
  State<ReschedulePage> createState() => _ReschedulePageState();
}

List<String> options = ['option 1', 'option2'];
List<String> bookOption = ['option 1', 'option2'];
List<String> paymentOption = ['option 1', 'option2'];

class _ReschedulePageState extends State<ReschedulePage> {
  late RescheduleViewModel _viewModel;
  String selectedOption = options[0];
  String bookSelectedOption = bookOption[0];
  String paySelectedOption = paymentOption[0];
  final userbookform = GlobalKey<FormState>();
  String gendervalue = 'Mr.';
  bool isLoading = true;
  bool firstnameTrigger = true;
  bool rescheduleVis = true;
  DateTime? startDate;
  DateTime? endDate;
  String formattedStartDate = '';
  String formattedEndDate = '';
  String startdateNew = '';
  String enddateNew = '';
  int _selectedValueAdult = 0;
  int _selectedValueChild = 0;
  bool _isdatechoosed = false;
  bool _ispersonchoosed = false;
  bool isdateempty = true;

  DateTimeRange selectedDates = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );

  @override
  void initState() {
    super.initState();
    _viewModel = RescheduleViewModel(ipaddr);
    fetchData();
  }

  void _formatSelectedDates() {
    formattedStartDate = selectedDates.start.toIso8601String().substring(0, 10);
    formattedEndDate = selectedDates.end.toIso8601String().substring(0, 10);
    DateTime date = DateTime.parse(formattedStartDate);
    DateTime date2 = DateTime.parse(formattedEndDate);
    startdateNew = DateFormat('dd MMMM yyyy').format(date);
    enddateNew = DateFormat('dd MMMM yyyy').format(date2);
  }

  Future<void> fetchData() async {
    try {
      await _viewModel.fetchUserData();
      setState(() {
        isLoading = false;
        firstnameTrigger = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        firstnameTrigger = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          title: Text(
            'Reschedule / Cancellation',
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.black38),
              ),
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 167, 205, 239),
                  Color(0xFFFFFFFF),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: SafeArea(
                    child: buildContent(),
                  ),
                ),
          rescheduleVis
              ? Container()
              : Positioned(
                  bottom: 12,
                  left: 1,
                  right: 1,
                  child: Container(
                    margin:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        _viewModel.deleteBooking(widget.booking_id);
                        Navigator.pushNamed(
                            context, TransactionScreen.routeName);
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(double.infinity, 52),
                        elevation: 2,
                        backgroundColor: const Color(0xFF225B7B),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12.0), // Adjust as needed
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Cancel Book",
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
                  ),
                ),
        ],
      ),
    );
  }

  Widget buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 2,
                blurRadius: 2,
              ),
            ],
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: 226),
                margin: EdgeInsets.all(14),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.nama_penginapan,
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.6,
                        ),
                      ),
                    ),
                    Text(
                      widget.lokasi,
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.6,
                        ),
                      ),
                    ),
                    Text(
                      widget.tipekamar,
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.6,
                        ),
                      ),
                    ),
                    Text(
                      "jenis bed",
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.6,
                        ),
                      ),
                    ),
                    Text(
                      "kapasitas room",
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.6,
                        ),
                      ),
                    ),
                    Text(
                      "${widget.startDate} - ${widget.endDate}",
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.6,
                        ),
                      ),
                    ),
                    Text(
                      "much room and people",
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 94,
                height: 94,
                margin: const EdgeInsets.fromLTRB(8, 12, 12, 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  image: DecorationImage(
                    image: NetworkImage(widget.url_foto),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 12, left: 20, right: 20),
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 2,
                blurRadius: 2,
              ),
            ],
            borderRadius: BorderRadius.circular(6),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 226),
            margin: const EdgeInsets.all(14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payment Method',
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.4,
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 36,
                      child: RadioListTile(
                        title: Text(
                          'Reschedule',
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              color: Colors.black87,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.4,
                            ),
                          ),
                        ),
                        activeColor: const Color(0xFF225B7B),
                        value: options[0],
                        selected: false,
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value.toString();
                            rescheduleVis = true;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 44,
                      child: RadioListTile(
                        title: Text(
                          'Cancel Book',
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              color: Colors.black87,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.4,
                            ),
                          ),
                        ),
                        activeColor: const Color(0xFF225B7B),
                        value: options[1],
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value.toString();
                            rescheduleVis = false;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        rescheduleVis ? buildRescheduleContent() : buildCancellationContent(),
      ],
    );
  }

  Widget buildRescheduleContent() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 12, left: 20, right: 20),
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 2,
                blurRadius: 2,
              ),
            ],
            borderRadius: BorderRadius.circular(6),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 226),
            margin: const EdgeInsets.all(14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reason of Reschedule',
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.4,
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Enter reason here...',
                          hintStyle: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              color: Colors.black45,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.4,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFF225B7B),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black38,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        minLines: 3,
                        maxLines: 7,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        buildDatePicker(),
        buildPersonPicker(),
        buildBookingFor(),
        buildPaymentMethod(),
        buildRescheduleButton(),
      ],
    );
  }

  Widget buildCancellationContent() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 12, left: 20, right: 20),
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 2,
                blurRadius: 2,
              ),
            ],
            borderRadius: BorderRadius.circular(6),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 226),
            margin: const EdgeInsets.all(14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reason of Cancellation',
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.4,
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Enter reason here...',
                          hintStyle: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              color: Colors.black45,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.4,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFF225B7B),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black38,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        minLines: 3,
                        maxLines: 7,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 100,
        )
      ],
    );
  }

  Widget buildDatePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {});
          },
          child: GestureDetector(
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
                  _isdatechoosed = true;
                  isdateempty = false;
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
                  color: const Color(0xFF225B7B),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 2,
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.calendar_month_rounded,
                    color: Color(0xFF225B7B),
                  ),
                  const SizedBox(width: 4),
                  isdateempty
                      ? Text(
                          'start-end date',
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              color: Color(0xFF225B7B),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )
                      : Text(
                          '$formattedStartDate - $formattedEndDate',
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              color: Color(0xFF225B7B),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPersonPicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {});
          },
          child: GestureDetector(
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
            child: Container(
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF225B7B),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 2,
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 4),
                  Text(
                    '${_selectedValueAdult} Adult, ${_selectedValueChild} Child',
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        color: Color(0xFF225B7B),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBookingFor() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 2,
          ),
        ],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 226),
        margin: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'I\'m booking for',
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.4,
                ),
              ),
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  height: 36,
                  child: RadioListTile(
                    title: Text(
                      'Myself',
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          color: Colors.black87,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ),
                    activeColor: const Color(0xFF225B7B),
                    value: bookOption[0],
                    selected: false,
                    groupValue: bookSelectedOption,
                    onChanged: (value) {
                      setState(() {
                        bookSelectedOption = value.toString();
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 44,
                  child: RadioListTile(
                    title: Text(
                      'Someone Else',
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          color: Colors.black87,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ),
                    activeColor: const Color(0xFF225B7B),
                    value: bookOption[1],
                    groupValue: bookSelectedOption,
                    onChanged: (value) {
                      setState(() {
                        bookSelectedOption = value.toString();
                      });
                    },
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 6.0, right: 6, top: 12),
              child: Divider(
                color: Colors.black12,
              ),
            ),
            firstnameTrigger
                ? CircularProgressIndicator()
                : Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Form(
                      key: userbookform,
                      child: Column(
                        children: [
                          TextFormField(
                            initialValue: _viewModel.email,
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                              hintText: 'email',
                              hintStyle: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                  color: Colors.black26,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.4,
                                ),
                              ),
                              labelStyle: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                  color: Color(0xFF225B7B),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.4,
                                ),
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF225B7B)),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF225B7B)),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty ||
                                  !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                                return "Enter Correct username";
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      right: 6.0, top: 32),
                                  child: DropdownButton<String>(
                                    items: const [
                                      DropdownMenuItem<String>(
                                        value: 'Mr.',
                                        child: Text('Mr.'),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: 'Mrs.',
                                        child: Text('Mrs.'),
                                      ),
                                    ],
                                    onChanged: (String? value) {
                                      setState(() {
                                        gendervalue = value.toString();
                                      });
                                    },
                                    hint: Text(
                                      gendervalue,
                                      style: GoogleFonts.montserrat(
                                        textStyle: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: -0.4,
                                        ),
                                      ),
                                    ),
                                    underline: Container(
                                      height: 1,
                                      color: const Color(0xFF225B7B),
                                    ),
                                    icon: const Icon(
                                      Icons.arrow_drop_down_rounded,
                                      color: Color(0xFF225B7B),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  child: TextFormField(
                                    initialValue: _viewModel.firstname,
                                    decoration: InputDecoration(
                                      labelText: 'First Name',
                                      labelStyle: GoogleFonts.montserrat(
                                        textStyle: const TextStyle(
                                          color: Color(0xFF225B7B),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: -0.4,
                                        ),
                                      ),
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFF225B7B)),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFF225B7B)),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty ||
                                          !RegExp(r'^[a-z A-Z]+$')
                                              .hasMatch(value)) {
                                        return "Enter Correct username";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: TextFormField(
                                  initialValue: _viewModel.lastname,
                                  decoration: InputDecoration(
                                    labelText: 'Last Name',
                                    labelStyle: GoogleFonts.montserrat(
                                      textStyle: const TextStyle(
                                        color: Color(0xFF225B7B),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: -0.4,
                                      ),
                                    ),
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFF225B7B)),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFF225B7B)),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty ||
                                        !RegExp(r'^[a-z A-Z]+$')
                                            .hasMatch(value)) {
                                      return "Enter Correct username";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          TextFormField(
                            initialValue: _viewModel.number,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              labelStyle: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                  color: Color(0xFF225B7B),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.4,
                                ),
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF225B7B)),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF225B7B)),
                              ),
                            ),
                          ),
                          TextFormField(
                            initialValue: _viewModel.address,
                            decoration: InputDecoration(
                              labelText: 'City of Origin',
                              labelStyle: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                  color: Color(0xFF225B7B),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.4,
                                ),
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF225B7B)),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF225B7B)),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty ||
                                  !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                                return "Enter Correct username";
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          )
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget buildPaymentMethod() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 2,
          ),
        ],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 226),
        margin: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Method',
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.4,
                ),
              ),
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  height: 36,
                  child: RadioListTile(
                    title: Text(
                      'Pay Now',
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          color: Colors.black87,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ),
                    activeColor: const Color(0xFF225B7B),
                    value: paymentOption[0],
                    selected: false,
                    groupValue: paySelectedOption,
                    onChanged: (value) {
                      setState(() {
                        paySelectedOption = value.toString();
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 44,
                  child: RadioListTile(
                    title: Text(
                      'Pay on the Spot',
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          color: Colors.black87,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ),
                    activeColor: const Color(0xFF225B7B),
                    value: paymentOption[1],
                    groupValue: paySelectedOption,
                    onChanged: (value) {
                      setState(() {
                        paySelectedOption = value.toString();
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRescheduleButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: ElevatedButton(
        onPressed: () {
          _viewModel.updateBookingDate(
            widget.booking_id,
            formattedStartDate,
            formattedEndDate,
          );
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Berhasil Melakukan Reschedule'),
                  content: Text('Dicek lagi ya tanggal dan lokasinya :)'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(
                              context, TransactionScreen.routeName);
                        },
                        child: Text('ok'))
                  ],
                );
              });
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
              "Rp. ${widget.hargaTotal}",
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
              "Reschedule Now",
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
}
