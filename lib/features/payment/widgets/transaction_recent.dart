import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_project/features/payment/model/transaction_recent_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shimmer/shimmer.dart';

class TransactionRecent extends StatefulWidget {
  @override
  _TransactionRecentState createState() => _TransactionRecentState();
}

class _TransactionRecentState extends State<TransactionRecent> {
  bool isLoading = true;
  String? userId;
  List<bool> booleanList = List<bool>.filled(10, false);
  List<bool> isUp = List<bool>.filled(10, false);
  List<bool> isConstScrolled = List<bool>.filled(10, false);

  final TransactionRecentViewModel _viewModel = TransactionRecentViewModel();

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    userId = await _viewModel.fetchUserData();
    if (userId != null) {
      await _viewModel.getData(userId!);
      setState(() {
        isLoading = _viewModel.isLoading;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? buildShimmer() : buildListView();
  }

  Widget buildShimmer() {
    return SizedBox(
      height: 400,
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 80,
                      height: 88,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      height: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      height: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 100,
                      height: 16,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildListView() {
    return ListView.builder(
      itemCount: _viewModel.listData.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        String cleanedUrlFoto =
            _viewModel.listData[index]['url_foto'].replaceAll('\\', '');
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                  height: isConstScrolled[index] ? 264 : 172,
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
                                width: 80,
                                height: 88,
                                margin:
                                    const EdgeInsets.fromLTRB(12, 12, 2, 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: NetworkImage(cleanedUrlFoto),
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
                                      mainAxisAlignment: MainAxisAlignment.end,
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
                                              _viewModel.listData[index]
                                                  ['nama_penginapan'],
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
                                                      vertical: 3.0),
                                              child: AnimatedSwitcher(
                                                  duration: const Duration(
                                                      milliseconds: 300),
                                                  child: booleanList[index]
                                                      ? SizedBox(
                                                          child: Container(
                                                            constraints:
                                                                const BoxConstraints(
                                                                    maxWidth:
                                                                        172),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  _viewModel.listData[
                                                                          index]
                                                                      [
                                                                      'alamat'],
                                                                  style: GoogleFonts
                                                                      .montserrat(
                                                                    textStyle:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .black54,
                                                                      fontSize:
                                                                          11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      letterSpacing:
                                                                          -0.6,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "${_viewModel.listData[index]['tanggal_checkin']} - ${_viewModel.listData[index]['tanggal_checkout']}\n",
                                                                  style: GoogleFonts
                                                                      .montserrat(
                                                                    textStyle:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .black54,
                                                                      fontSize:
                                                                          11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      letterSpacing:
                                                                          -0.6,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  _viewModel.listData[
                                                                          index]
                                                                      [
                                                                      'tipe_kamar'],
                                                                  style: GoogleFonts
                                                                      .montserrat(
                                                                    textStyle:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .black54,
                                                                      fontSize:
                                                                          11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      letterSpacing:
                                                                          -0.6,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "1 Room, 2 Adult, 2 Children\n",
                                                                  style: GoogleFonts
                                                                      .montserrat(
                                                                    textStyle:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .black54,
                                                                      fontSize:
                                                                          11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      letterSpacing:
                                                                          -0.6,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "Payment Method",
                                                                  style: GoogleFonts
                                                                      .montserrat(
                                                                    textStyle:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .black87,
                                                                      fontSize:
                                                                          11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      letterSpacing:
                                                                          -0.6,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "Pay On Destination\n",
                                                                  style: GoogleFonts
                                                                      .montserrat(
                                                                    textStyle:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .black54,
                                                                      fontSize:
                                                                          11,
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
                                                          ),
                                                        )
                                                      : Container(
                                                          child: Container(
                                                            constraints:
                                                                const BoxConstraints(
                                                                    maxWidth:
                                                                        172),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                SizedBox(
                                                                  height: 8,
                                                                ),
                                                                Text(
                                                                  "${_viewModel.listData[index]['tanggal_checkin']} - ${_viewModel.listData[index]['tanggal_checkout']}",
                                                                  style: GoogleFonts
                                                                      .montserrat(
                                                                    textStyle:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .black54,
                                                                      fontSize:
                                                                          11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      letterSpacing:
                                                                          -0.6,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  _viewModel.listData[
                                                                          index]
                                                                      [
                                                                      'tipe_kamar'],
                                                                  style: GoogleFonts
                                                                      .montserrat(
                                                                    textStyle:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .black54,
                                                                      fontSize:
                                                                          11,
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
                                                          ),
                                                        )),
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
                          InkWell(
                            onTap: () {
                              _toggleDetail(index);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: AnimatedSwitcher(
                                duration: Duration(milliseconds: 300),
                                child: isUp[index]
                                    ? Image.asset(
                                        'assets/images/arrow_up.png',
                                        height: 12,
                                        key: UniqueKey(),
                                      )
                                    : Image.asset(
                                        'assets/images/arrow_down.png',
                                        height: 12,
                                        key: UniqueKey(),
                                      ),
                              ),
                            ),
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
                                Text(
                                  'Rp. ${_viewModel.listData[index]['harga']}',
                                  style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                      color: Color(0xFF225B7B),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.6,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 8, 8),
                            child: Column(
                              children: [
                                AnimatedSwitcher(
                                  duration: Duration(seconds: 3),
                                  transitionBuilder: (Widget child,
                                      Animation<double> animation) {
                                    return FadeTransition(
                                        opacity: animation, child: child);
                                  },
                                  child: _viewModel.rating == 0
                                      ? Container(
                                          child: RatingBar(
                                            initialRating: 0,
                                            minRating: 1,
                                            ratingWidget: RatingWidget(
                                              full: Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              half: Icon(
                                                Icons.star,
                                              ),
                                              empty: Icon(
                                                Icons.star,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            itemSize: 20,
                                            updateOnDrag: true,
                                            glow: false,
                                            onRatingUpdate: (rating) {
                                              setState(() {
                                                _viewModel.rating = rating;
                                                print(_viewModel.rating);
                                              });
                                              _viewModel.submitRating(
                                                  rating,
                                                  _viewModel.listData[index]
                                                      ['hotel_id']);
                                            },
                                          ),
                                        )
                                      : Text(
                                          'Terimakasih atas review anda',
                                          key: ValueKey(2),
                                          style: TextStyle(fontSize: 13),
                                        ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _toggleDetail(int index) {
    setState(() {
      isUp[index] = !isUp[index];

      if (!booleanList[index]) {
        isConstScrolled[index] = !isConstScrolled[index];
        Timer(const Duration(milliseconds: 200), () {
          _textvis(index);
        });
      } else {
        booleanList[index] = !booleanList[index];
        Timer(const Duration(milliseconds: 0), () {
          _constvis(index);
        });
      }
    });
  }

  void _textvis(int index) {
    setState(() {
      booleanList[index] = !booleanList[index];
    });
  }

  void _constvis(int index) {
    setState(() {
      isConstScrolled[index] = !isConstScrolled[index];
    });
  }
}
