import 'package:flutter/material.dart';
import 'package:flutter_project/features/profile/model/profile_view_model.dart';
import 'package:flutter_project/features/profile/screens/profile_setting.dart';
import 'package:flutter_project/features/message/screens/message_screen.dart';
import 'package:flutter_project/features/payment/screens/transaction_screen.dart';
import 'package:flutter_project/features/profile/widgets/logout_dialog.dart';
import 'package:flutter_project/features/wishlist/screens/wishlist_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingPage extends StatefulWidget {
  static const String routeName = '/setting-page';
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final ProfileViewModel _viewModel = ProfileViewModel();

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    await _viewModel.fetchUserData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: const Center(child: Text('Settings')),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.home,
                color: Color(0x00ffffff),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 180,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 220, 237, 255)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, ProfileSetting.routeName);
                          },
                          child: Container(
                              margin: const EdgeInsets.only(left: 24),
                              height: 124,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF8F8F8),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  bottomLeft: Radius.circular(40),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: AspectRatio(
                                          aspectRatio: 1.0,
                                          child: _viewModel.isDataAvail
                                              ? CircleAvatar(
                                                  radius: 26,
                                                  backgroundColor:
                                                      Colors.white30,
                                                  backgroundImage: NetworkImage(
                                                      _viewModel.pp),
                                                )
                                              : CircularProgressIndicator()),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 18.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${_viewModel.firstname ?? 'Loading...'}',
                                            style: GoogleFonts.montserrat(
                                                textStyle: TextStyle(
                                              fontSize: 24,
                                              color: Colors.lightBlue[500],
                                              fontWeight: FontWeight.w800,
                                            )),
                                          ),
                                          Text(
                                            '${_viewModel.email ?? 'Loading...'}',
                                            style: GoogleFonts.montserrat(
                                                textStyle: TextStyle(
                                              fontSize: 14,
                                              color: Colors.lightBlue[400],
                                              fontWeight: FontWeight.w600,
                                            )),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 32,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Colors.lightBlue[500],
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            buildSettingOptions(),
          ],
        ),
      ),
    );
  }

  Widget buildSettingOptions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSectionTitle('Account'),
              const SizedBox(height: 16),
              buildAccountOption('Wishlist', 'assets/images/wishlist.png',
                  WishlistScreen.routeName),
              buildAccountOption('Pay Account', 'assets/images/wallet.png', ''),
              buildAccountOption('Change to Business Account',
                  'assets/images/workcase.png', ''),
              buildAccountOption(
                  'Inbox', 'assets/images/inbox.png', MessageScreen.routeName),
              buildAccountOption('Transaction', 'assets/images/transaction.png',
                  TransactionScreen.routeName),
            ],
          ),
        ),
        buildDivider(),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSectionTitle('Settings'),
              const SizedBox(height: 16),
              buildAccountOption('Language', 'assets/images/language.png', ''),
              buildAccountOption(
                  'Change Password', 'assets/images/lock.png', ''),
            ],
          ),
        ),
        buildDivider(),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSectionTitle('Support'),
              const SizedBox(height: 16),
              buildAccountOption(
                  'Contact Us', 'assets/images/contact_us.png', ''),
              buildAccountOption('FAQ', 'assets/images/faq.png', ''),
            ],
          ),
        ),
        buildDivider(),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              buildAccountOption('Logout', 'assets/images/logout.png', '',
                  isLogout: true),
            ],
          ),
        ),
        buildDivider(),
      ],
    );
  }

  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.montserrat(
          textStyle: const TextStyle(
        fontSize: 20,
        color: Colors.black87,
        fontWeight: FontWeight.w600,
      )),
    );
  }

  Widget buildAccountOption(String title, String asset, String routeName,
      {bool isLogout = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 4, bottom: 12),
      child: InkWell(
        onTap: () {
          if (isLogout) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return LogoutDialog(
                  onConfirmLogout: () {
                    _viewModel.signOut().then((_) {
                      Navigator.pop(context);
                      Navigator.pop(context); // Keluar dari setting page
                    });
                  },
                );
              },
            );
          } else if (routeName.isNotEmpty) {
            Navigator.pushNamed(context, routeName);
          }
        },
        child: Row(
          children: [
            Image.asset(asset),
            const SizedBox(width: 20),
            Text(
              title,
              style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              )),
            ),
            Expanded(
                child: Container(
              color: Colors.white10,
            )),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.black45,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDivider() {
    return Container(
      height: 6,
      color: Colors.black12,
    );
  }
}
