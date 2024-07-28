import 'dart:convert';
import 'dart:ffi';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_project/variables.dart';
import 'package:http/http.dart' as http;
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/features/chatAI/screens/ainavigate_screen.dart';
import 'package:image_picker/image_picker.dart';

class AiFab extends StatefulWidget {
  String lokasi;
  double latitude;
  double longitude;
  AiFab(
      {required this.lokasi, required this.latitude, required this.longitude});

  @override
  State<AiFab> createState() => _AiFabState();
}

class _AiFabState extends State<AiFab> {
  final Gemini gemini = Gemini.instance;
  final ValueNotifier<List<ChatMessage>> messagesNotifier =
      ValueNotifier<List<ChatMessage>>([]);

  ChatUser currentUser = ChatUser(id: "0", firstName: "bian");
  ChatUser geminiUser = ChatUser(id: "1", firstName: "Tata");
  String kota = '';
  List<ChatUser> _typing = <ChatUser>[];

  @override
  Widget build(BuildContext context) {
    return DraggableFab(
      child: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => buildSheet(context),
          );
        },
        child: Image.asset(
          'assets/images/chatai.png',
          height: 24,
          width: 24,
        ),
      ),
    );
  }

  @override
  void initState() {
    _sendMessageInit();
    super.initState();
  }

  Widget buildSheet(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: Color(0xFFD2E9FF)),
              child: Icon(
                Icons.arrow_upward,
                size: 24.0,
                color: Colors.blue, // Warna ikon
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFD2E9FF), // Warna gradient awal
                    Color(0xFFFFFFFF), // Warna gradient akhir
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              height: MediaQuery.of(context).size.height *
                  0.7, // Set height as needed
              child: _buildUI(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUI() {
    return ValueListenableBuilder<List<ChatMessage>>(
      valueListenable: messagesNotifier,
      builder: (context, messages, _) {
        return DashChat(
          inputOptions: InputOptions(
            trailing: [
              IconButton(
                onPressed: _sendMediaMessage,
                icon: const Icon(Icons.image),
              ),
            ],
          ),
          typingUsers: _typing,
          currentUser: currentUser,
          onSend: _sendMessage,
          messages: messages,
          messageOptions: MessageOptions(
            currentUserTextColor: Color(0xFF19465F),
            textColor: Colors.white,
            currentUserContainerColor: Color(0xFF92D5FB),
            containerColor: Colors.blue,
            messageTextBuilder: _customMessageTextBuilder,
          ),
        );
      },
    );
  }

  Widget _customMessageTextBuilder(ChatMessage message,
      ChatMessage? previousMessage, ChatMessage? nextMessage) {
    if (message.text == 'Baiklah apakah anda ingin melihat lihat kamarnya?') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message.text, style: TextStyle(color: Colors.white)),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  // Logic when "Ya" button is pressed
                  _handleYesButton(message);
                },
                child: Text('Ya'),
              ),
              TextButton(
                onPressed: () {
                  // Logic when "Tidak" button is pressed
                  _handleNoButton(message);
                },
                child: Text('Tidak'),
              ),
            ],
          ),
        ],
      );
    } else {
      return message.user.id == currentUser.id
          ? Text(
              message.text,
              style: TextStyle(color: Color(0xFF19465F)),
            )
          : Text(
              message.text,
              style: TextStyle(color: Colors.white),
            );
    }
  }

  void _handleYesButton(ChatMessage message) {
    // Handle the logic for "Yes" button press
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AINavigateScreen(
        namaKota: kota,
        lokasiPage: widget.lokasi,
        latitude: widget.latitude,
        longitude: widget.longitude,
      ),
    ));
  }

  void _handleNoButton(ChatMessage message) {
    // Handle the logic for "No" button press
  }

  void _sendMessage(ChatMessage chatMessage) async {
    _typing.add(geminiUser);
    messagesNotifier.value = [chatMessage, ...messagesNotifier.value];

    try {
      final response = await http.post(
        Uri.parse('${ipaddr}/node/chat'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'userInput': chatMessage.text}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        ChatMessage geminiMessage;
        if (responseData['response'].contains("=") ||
            responseData['response'].contains("&")) {
          String responseText2 = responseData['response'];
          kota = responseText2;
          geminiMessage = ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: 'Baiklah apakah anda ingin melihat lihat kamarnya?',
          );
        } else {
          String responseText = responseData['response'];
          geminiMessage = ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: responseText,
          );
        }

        messagesNotifier.value = [geminiMessage, ...messagesNotifier.value];
        _typing.remove(geminiUser);
      } else {
        // Handle error
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
      rethrow;
    }
  }

  void _sendMediaMessage() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (file != null) {
      ChatMessage chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: "Describe this picture!",
        medias: [
          ChatMedia(
            url: file.path,
            fileName: "",
            type: MediaType.image,
          ),
        ],
      );
      _sendMessage(chatMessage);
    }
  }

  void _sendMessageInit() async {
    _typing.add(geminiUser);
    try {
      final response = await http.post(
        Uri.parse('${ipaddr}/node/chat'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'userInput': 'halo'}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        ChatMessage geminiMessage;
        String responseText = responseData['response'];
        geminiMessage = ChatMessage(
          user: geminiUser,
          createdAt: DateTime.now(),
          text: responseText,
        );
        messagesNotifier.value = [geminiMessage, ...messagesNotifier.value];
        _typing.remove(geminiUser);
      } else {
        // Handle error
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
      rethrow;
    }
  }
}
