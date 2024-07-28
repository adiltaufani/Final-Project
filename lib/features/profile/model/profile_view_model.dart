import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_project/variables.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ProfileViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String? _firstname;
  String? _lastname;
  String? _number;
  String? _birthdate;
  String? _address;
  String? _email;
  String? _id;
  String _uid = '';
  String pp = '';
  bool isDataAvail = false;

  String? get firstname => _firstname;
  String? get lastname => _lastname;
  String? get number => _number;
  String? get birthdate => _birthdate;
  String? get address => _address;
  String? get email => _email;
  String get uid => _uid;
  String get userId => _id ?? '';

  Future<void> fetchUserData() async {
    var user = _auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    var url = Uri.parse("${ipaddr}/ta_projek/crudtaprojek/view_data.php");
    _uid = user.uid;

    var response = await http.post(url, body: {
      "uid": _uid,
    });
    var data = json.decode(response.body);
    if (data != null) {
      _firstname = data['firstname'];
      _lastname = data['lastname'];
      _number = data['number'];
      _birthdate = data['birthdate'];
      _address = data['address'];
      _email = data['email'];
      _id = data['id'];
      pp = await getImageUrl('images/image_$_uid.jpg');
      isDataAvail = true;
    } else {
      throw Exception("Failed to fetch user data");
    }
  }

  Future<void> updateUserData(
      String name, String number, String birthdate, String address) async {
    var url = Uri.parse('${ipaddr}/ta_projek/crudtaprojek/updateusers.php');
    var response = await http.post(url, body: {
      'id': _id,
      'firstname': name,
      'number': number,
      'birthdate': birthdate,
      'address': address,
    });

    if (response.statusCode != 200) {
      throw Exception('Failed to update user data');
    }
  }

  Future<void> uploadFile() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      String fileName = 'image_${_uid}.jpg';
      Reference ref = _storage.ref().child("images/$fileName");
      UploadTask uploadTask = ref.putFile(File(file.path));

      await uploadTask.whenComplete(() => print("File uploaded successfully!"));
    } else {
      throw Exception("No file selected");
    }
  }

  Future<String> getImageUrl(String imagePath) async {
    try {
      Reference ref = _storage.ref().child(imagePath);
      String imageUrl = await ref.getDownloadURL();
      return imageUrl;
    } catch (error) {
      print("Error: $error");
      return "https://firebasestorage.googleapis.com/v0/b/loginsignupta-prototype.appspot.com/o/images%2Fdefault.webp?alt=media&token=0f99eb8a-be98-4f26-99b7-d71776562de9";
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
