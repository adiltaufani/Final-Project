import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_project/features/appbar_global.dart';
import 'package:flutter_project/features/auth/widgets/side_menu.dart';
import 'package:flutter_project/features/coachmark/coachmark.dart';
import 'package:flutter_project/features/home/widgets/home_house.dart';
import 'package:flutter_project/features/search/widgets/search_page_widget.dart';
import 'package:flutter_project/features/profile/screens/setting_page.dart';
import 'package:flutter_project/features/notification/screens/notification_page.dart';
import 'package:flutter_project/fab/screens/floating_action_button.dart';
import 'package:flutter_project/features/home/services/home_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home-screen';
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  String firstname = '';
  String lastname = '';
  String email = '';
  String pp = '';
  bool isDataAvail = true;
  double latitude = 0.0;
  double longitude = 0.0;
  String kota = '';
  bool isData = false;

  TutorialCoachMark? tutorialCoachMark;
  List<TargetFocus> targets = [];

  GlobalKey profileKey = GlobalKey();
  GlobalKey notifKey = GlobalKey();
  GlobalKey AIKey = GlobalKey();
  GlobalKey sidebarKey = GlobalKey();
  GlobalKey searchKey = GlobalKey();
  GlobalKey nearKey = GlobalKey();
  GlobalKey bestKey = GlobalKey();
  GlobalKey tabKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    fetchUserData();
    runPHPCodeOnHomeScreen();
    getLocation();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    Future.delayed(const Duration(seconds: 1), () {
      _showTutorialCoach();
    });
  }

  void _showTutorialCoach() {
    _initTarget();
    tutorialCoachMark =
        TutorialCoachMark(targets: targets, colorShadow: Color(0xFFD2E9FF))
          ..show(context: context);
  }

  void _initTarget() {
    targets = [
      TargetFocus(
        identify: "profile-key",
        keyTarget: profileKey,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller) {
                return CoachMarkDesc(
                  text:
                      'Here you can manage your profile and personal information.',
                  onNext: () {
                    controller.next();
                  },
                  onSkip: () {
                    controller.skip();
                  },
                );
              })
        ],
      ),
      TargetFocus(
        identify: "notif-key",
        keyTarget: notifKey,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller) {
                return CoachMarkDesc(
                  text: 'Here you can see all of the notifications.',
                  onNext: () {
                    controller.next();
                  },
                  onSkip: () {
                    controller.skip();
                  },
                );
              })
        ],
      ),
      TargetFocus(
        identify: "search-key",
        keyTarget: searchKey,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller) {
                return CoachMarkDesc(
                  text: 'Here you can find the information you need',
                  onNext: () {
                    controller.next();
                  },
                  onSkip: () {
                    controller.skip();
                  },
                );
              })
        ],
      ),
      TargetFocus(
        identify: "side-key",
        keyTarget: sidebarKey,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller) {
                return CoachMarkDesc(
                  text:
                      'Here you can navigate the menu between application features',
                  onNext: () {
                    controller.next();
                  },
                  onSkip: () {
                    controller.skip();
                  },
                );
              })
        ],
      ),
      TargetFocus(
        identify: "tab-key",
        keyTarget: tabKey,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller) {
                return CoachMarkDesc(
                  text:
                      'Here you can select the type of property you are looking for',
                  onNext: () {
                    controller.next();
                  },
                  onSkip: () {
                    controller.skip();
                  },
                );
              })
        ],
      ),
      TargetFocus(
        identify: "bottom-right",
        targetPosition: TargetPosition(
          Size(40, 40),
          Offset(MediaQuery.of(context).size.width - 60,
              MediaQuery.of(context).size.height - 60),
        ),
        contents: [
          TargetContent(
              align: ContentAlign.top,
              builder: (context, controller) {
                return CoachMarkDesc(
                  text:
                      'Try our AI feature. You can find a hotel that suits your preferences with just one click..',
                  onNext: () {
                    controller.next();
                  },
                  onSkip: () {
                    controller.skip();
                  },
                );
              })
        ],
      ),
    ];
  }

  bool isTextFieldFocused = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);
    return Scaffold(
      floatingActionButton: AiFab(
        lokasi: 'homescreen',
        latitude: latitude,
        longitude: longitude,
      ),
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
                key: searchKey,
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
            key: sidebarKey,
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
              key: notifKey,
              onPressed: () {
                Navigator.pushNamed(context, NotificationPage.routeName);
              },
              icon: Image.asset(
                'assets/images/notification.png',
                height: 34.0,
              ),
            ),
            FutureBuilder<String?>(
              key: profileKey,
              future: ProfileDataManager.getProfilePic(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error ${snapshot.error}');
                } else {
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
                }
              },
            ),
          ],
        ),
      ),
      body: Material(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFD2E9FF),
                Color(0xFFFFFFFF),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Location',
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              color: Colors.black54,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.6,
                            ),
                          ),
                        ),
                        isData
                            ? Text(
                                kota,
                                style: GoogleFonts.montserrat(
                                  textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            : Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 150,
                                  height: 20,
                                  color: Colors.white,
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
              const Divider(
                color: Colors.black12,
                height: 0.5,
              ),
              Container(
                child: Align(
                  child: TabBar(
                    labelPadding: const EdgeInsets.only(left: 0, right: 40),
                    controller: _tabController,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.black26,
                    isScrollable: true,
                    indicatorSize: TabBarIndicatorSize.label,
                    padding: const EdgeInsets.only(bottom: 10),
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(color: Colors.blue, width: 4.6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    dividerColor: Colors.black12,
                    tabs: [
                      Tab(
                        key: tabKey,
                        child: Text(
                          'Apartement',
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Hotel',
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Villa',
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                key: bestKey,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    HomeHouse(
                      tipe: 'readapartement.php',
                      user_latitude: latitude,
                      user_longitude: longitude,
                    ),
                    HomeHouse(
                      tipe: 'readhotel.php',
                      user_latitude: latitude,
                      user_longitude: longitude,
                    ),
                    HomeHouse(
                      tipe: 'readvilla.php',
                      user_latitude: latitude,
                      user_longitude: longitude,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchUserData() async {
    var data = await HomeService.fetchUserData();
    if (data != null) {
      setState(() {
        firstname = data['firstname'];
        lastname = data['lastname'];
        email = data['email'];
        pp = data['profile_picture'].replaceAll('\\', '');
        isDataAvail = false;
      });
    } else {
      print("Gagal mendapatkan data pengguna");
    }
  }

  Future<void> runPHPCodeOnHomeScreen() async {
    bool success = await HomeService.runPHPCodeOnHomeScreen();
    if (success) {
      print('PHP code executed successfully.');
    } else {
      print('Failed to execute PHP code.');
    }
  }

  Future<void> getLocation() async {
    Position position = await HomeService.getLocation();
    latitude = position.latitude;
    longitude = position.longitude;
    if (latitude != 0) {
      getCityFromCoordinates(latitude, longitude);
    }
  }

  void getCityFromCoordinates(double latitude, double longitude) async {
    String city = await HomeService.getCityFromCoordinates(latitude, longitude);
    setState(() {
      kota = city;
      isData = true;
    });
  }
}

// ignore: must_be_immutable
class CircleTabIndicator extends Decoration {
  final Color color;
  double radius;
  CircleTabIndicator({
    required this.color,
    required this.radius,
  });
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CirclePainter(color: color, radius: radius);
  }
}

class _CirclePainter extends BoxPainter {
  final Color color;
  double radius;
  _CirclePainter({
    required this.color,
    required this.radius,
  });
  @override
  void paint(
    Canvas canvas,
    Offset offset,
    ImageConfiguration configuration,
  ) {
    Paint _paint = Paint();
    _paint.color = color;
    _paint.isAntiAlias = true;
    final Offset circleOffset = Offset(
        configuration.size!.width / 2, configuration.size!.height - radius);

    canvas.drawCircle(offset + circleOffset, radius, _paint);
  }
}
