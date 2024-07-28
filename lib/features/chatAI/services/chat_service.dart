import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_project/variables.dart';

class ChatService {
  Future<String> sendMessage(String userInput) async {
    try {
      final response = await http.post(
        Uri.parse('${ipaddr}/node/chat'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'userInput': userInput}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['response'];
      } else {
        // Handle error
        return 'Error: Unable to send message';
      }
    } catch (e) {
      rethrow;
    }
  }
}
