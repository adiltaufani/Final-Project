import 'package:flutter/material.dart';
import 'package:flutter_project/features/profile/model/profile_view_model.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileSetting extends StatefulWidget {
  static const String routeName = '/profile-setting';
  const ProfileSetting({super.key});

  @override
  State<ProfileSetting> createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _number = TextEditingController();
  final TextEditingController _birthdate = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ProfileViewModel _viewModel = ProfileViewModel();
  bool firstnameTrigger = false;
  bool isDataAvail = false;

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    await _viewModel.fetchUserData();
    setState(() {
      _name.text = _viewModel.firstname ?? '';
      _number.text = _viewModel.number ?? '';
      _birthdate.text = _viewModel.birthdate ?? '';
      _address.text = _viewModel.address ?? '';
      isDataAvail = true;
      firstnameTrigger = true;
    });
  }

  Future<void> _updateUserData() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await _viewModel.updateUserData(
          _name.text,
          _number.text,
          _birthdate.text,
          _address.text,
        );
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Data berhasil diperbarui'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: const Center(child: Text('Profile Settings')),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.home,
              color: Color(0x00ffffff),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 200,
                  color: Colors.lightBlue[600],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 124,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                children: [
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: AspectRatio(
                                          aspectRatio: 1.0,
                                          child: isDataAvail
                                              ? CircleAvatar(
                                                  radius: 40,
                                                  backgroundColor:
                                                      Colors.white30,
                                                  backgroundImage: NetworkImage(
                                                      _viewModel.pp),
                                                )
                                              : const CircularProgressIndicator(),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            _viewModel
                                                .uploadFile()
                                                .then((_) => fetchData());
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.blue,
                                            ),
                                            child: Icon(
                                              Icons.camera_alt,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 18),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _viewModel.firstname ?? 'Loading...',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 24,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      Text(
                                        _viewModel.email ?? 'Loading...',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 14,
                                          color: Colors.white54,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 32),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        color: Color(0xFFF8F8F8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        child: firstnameTrigger
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 18),
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      children: <Widget>[
                                        TextFormField(
                                          controller: _name,
                                          decoration: const InputDecoration(
                                              labelText: "Name"),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Please enter your name";
                                            }
                                            return null;
                                          },
                                        ),
                                        TextFormField(
                                          controller: _number,
                                          decoration: const InputDecoration(
                                              labelText: "Number"),
                                          keyboardType: TextInputType.phone,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Please enter your number";
                                            }
                                            return null;
                                          },
                                        ),
                                        TextFormField(
                                          controller: _birthdate,
                                          decoration: const InputDecoration(
                                              labelText: "Birth Date"),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Please enter your birth";
                                            }
                                            return null;
                                          },
                                        ),
                                        TextFormField(
                                          controller: _address,
                                          decoration: const InputDecoration(
                                              labelText: "Address"),
                                          maxLines: null,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Please enter your address";
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 26),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.blue),
                                            foregroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.white),
                                          ),
                                          onPressed: () {
                                            if (_formKey.currentState
                                                    ?.validate() ??
                                                false) {
                                              _updateUserData();
                                            }
                                          },
                                          child: Text(
                                            'Save Profile',
                                            style: GoogleFonts.montserrat(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : const Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
