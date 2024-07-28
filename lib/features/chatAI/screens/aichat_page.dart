import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/features/chatAI/screens/ainavigate_screen.dart';
import 'package:flutter_project/features/chatAI/services/chat_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AIChatPage extends StatefulWidget {
  static const String routeName = '/aichat-page';
  const AIChatPage({super.key});

  @override
  State<AIChatPage> createState() => _AIChatPageState();
}

class _AIChatPageState extends State<AIChatPage> {
  final ChatService _chatService = ChatService();

  ChatUser currentUser = ChatUser(id: "0", firstName: "bian");
  ChatUser geminiUser = ChatUser(id: "1", firstName: "Tata");
  String kota = '';
  List<ChatMessage> messages = [];
  List<ChatUser> _typing = <ChatUser>[];

  @override
  void initState() {
    sendMessageInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text(
          'AI Assistant',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFD2E9FF),
            Color(0xFFFFFFFF),
          ],
        ),
      ),
      child: DashChat(
        inputOptions: InputOptions(
          trailing: [
            IconButton(
              onPressed: _sendMediaMessage,
              icon: const Icon(Icons.image),
            ),
          ],
        ),
        currentUser: currentUser,
        typingUsers: _typing,
        onSend: _sendMessage,
        messages: messages,
        messageOptions: MessageOptions(
          currentUserTextColor: Color(0xFF19465F),
          textColor: Colors.white,
          currentUserContainerColor: Color(0xFF92D5FB),
          containerColor: Colors.blue,
          messageTextBuilder: _customMessageTextBuilder,
        ),
      ),
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
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AINavigateScreen(
        namaKota: kota,
        lokasiPage: '',
        latitude: 2,
        longitude: 3,
      ),
    ));
  }

  void _handleNoButton(ChatMessage message) {
    // Handle the logic for "No" button press
  }

  void _sendMessage(ChatMessage chatMessage) async {
    _typing.add(geminiUser);
    setState(() {
      messages = [chatMessage, ...messages];
    });

    String responseText = await _chatService.sendMessage(chatMessage.text);
    ChatMessage geminiMessage = ChatMessage(
      user: geminiUser,
      createdAt: DateTime.now(),
      text: responseText,
    );

    setState(() {
      messages = [geminiMessage, ...messages];
    });
    _typing.remove(geminiUser);

    if (responseText.contains("=") || responseText.contains("&")) {
      kota = responseText;
      ChatMessage followUpMessage = ChatMessage(
        user: geminiUser,
        createdAt: DateTime.now(),
        text: 'Baiklah apakah anda ingin melihat lihat kamarnya?',
      );
      setState(() {
        messages = [followUpMessage, ...messages];
      });
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

  void sendMessageInit() async {
    _typing.add(geminiUser);
    String responseText = await _chatService.sendMessage('halo');
    ChatMessage geminiMessage = ChatMessage(
      user: geminiUser,
      createdAt: DateTime.now(),
      text: responseText,
    );

    setState(() {
      messages = [geminiMessage, ...messages];
    });
    _typing.remove(geminiUser);
  }
}
