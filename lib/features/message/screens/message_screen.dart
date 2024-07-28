import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/features/appbar_global.dart';
import 'package:flutter_project/common/firebase/services/firebase_auth_service.dart';
import 'package:flutter_project/features/auth/widgets/side_menu.dart';
import 'package:flutter_project/features/message/screens/message_chat_screen.dart';
import 'package:flutter_project/features/message/services/chat_service.dart';
import 'package:flutter_project/features/message/services/user_tile.dart';
import 'package:flutter_project/features/message/widgets/shimmer_chat.dart';
import 'package:flutter_project/features/notification/screens/notification_page.dart';
import 'package:flutter_project/features/profile/screens/setting_page.dart';
import 'package:flutter_project/features/search/widgets/search_page_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class MessageScreen extends StatefulWidget {
  static const String routeName = '/message-screen';
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final ChatService _chatService = ChatService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
            child: _buildSearchBar(),
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
            _buildProfileIcon(),
          ],
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _chatService.getUserStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading users'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Map<String, dynamic>> users = snapshot.data ?? [];
          return _buildUserList(users);
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
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
    );
  }

  Widget _buildProfileIcon() {
    return FutureBuilder<String?>(
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
          return const Text('No data');
        }
      },
    );
  }

  Widget _buildUserList(List<Map<String, dynamic>> users) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _getUsersWithLastMessageTime(users),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingShimmer();
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error loading messages'));
        }

        List<Map<String, dynamic>> sortedUsers = snapshot.data ?? [];
        return _buildMessageList(sortedUsers);
      },
    );
  }

  Widget _buildLoadingShimmer() {
    return Stack(
      children: [
        _buildGradientBackground(),
        SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              Container(
                margin: const EdgeInsets.fromLTRB(16, 10, 20, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/inbox.png',
                      height: 30,
                    ),
                    Text(
                      'Message',
                      style: GoogleFonts.raleway(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 700,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: ShimmerWidget.circular(width: 64, height: 64),
                      title: ShimmerWidget.rectangular(height: 16, width: 40),
                      subtitle: ShimmerWidget.rectangular(height: 14),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGradientBackground() {
    return Container(
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
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/bookit.png',
            height: 24,
          )
        ],
      ),
    );
  }

  Widget _buildMessageList(List<Map<String, dynamic>> sortedUsers) {
    return Stack(
      children: [
        _buildGradientBackground(),
        SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              Container(
                margin: const EdgeInsets.fromLTRB(16, 10, 20, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/inbox.png',
                      height: 30,
                    ),
                    Text(
                      'Message',
                      style: GoogleFonts.raleway(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 700,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: sortedUsers.length,
                  itemBuilder: (context, index) {
                    var user = sortedUsers[index];
                    return _buildUserTile(user);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserTile(Map<String, dynamic> user) {
    String senderUid = _authService.getCurrentUser()!.uid;
    List<String> ids = [user['uid'], senderUid];
    ids.sort();
    String chatRoomId = ids.join("-");
    return FutureBuilder<String?>(
      future: _chatService.getLastMessage(chatRoomId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          String? lastMessage = snapshot.data;
          if (lastMessage != null &&
              user['email'] != _authService.getCurrentUser()!.email) {
            return UserTile(
              email: user['email'],
              recieverUid: user['uid'],
              senderUid: senderUid,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MessageInboxScreen(
                      receiverEmail: user['email'],
                      receiverID: user['uid'],
                    ),
                  ),
                );
              },
            );
          } else {
            return Container();
          }
        }
      },
    );
  }

  Future<List<Map<String, dynamic>>> _getUsersWithLastMessageTime(
      List<Map<String, dynamic>> users) async {
    String senderUid = _authService.getCurrentUser()!.uid;

    for (var user in users) {
      List<String> ids = [user['uid'], senderUid];
      ids.sort();
      String chatRoomId = ids.join("-");
      var lastMessageData =
          await _chatService.getLastMessageWithTime(chatRoomId);
      user['lastMessageTime'] =
          lastMessageData?['timestamp'] ?? Timestamp(0, 0);
      user['lastMessage'] = lastMessageData?['message'] ?? '';
    }

    users.sort((a, b) => b['lastMessageTime'].compareTo(a['lastMessageTime']));
    return users;
  }
}
