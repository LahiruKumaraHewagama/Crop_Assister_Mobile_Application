import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crop_damage_assessment_app/models/farmer.dart';
import 'package:crop_damage_assessment_app/services/auth.dart';
import 'package:crop_damage_assessment_app/services/database.dart';
import 'package:crop_damage_assessment_app/components/loading.dart';
import 'package:crop_damage_assessment_app/components/decoration.dart';
import 'package:crop_damage_assessment_app/screens/farmer/home/claim_dashboard.dart';

import 'farmer_dashboard.dart';

Farmer? user;

class FarmerEditData extends StatefulWidget {
  const FarmerEditData({Key? key, required this.uid}) : super(key: key);

  final String? uid;

  @override
  _FarmerEditDataState createState() => _FarmerEditDataState();
}

class _FarmerEditDataState extends State<FarmerEditData> {
  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();
  String error = "";
  bool loading = true;

  // text field state
  String name = "";
  String phone_no = "";
  String type = "farmer";
  String email = "";

  String agrarian_division = "";
  String nic = "";
  String address = "";
  String province = "";

  String bank = "";
  String account_name = "";
  String account_no = "";
  String branch = "";

  String profile_network_image = "";
  XFile? profile_image;

  static const List<String> _agrarianDivisionOptions = <String>[
    'galle',
    'matara',
    'kandy'
  ];

  static const List<String> _provinceOptions = <String>[
    'southern',
    'western',
    'east',
    'north'
  ];

  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      profile_image = pickedFile;
    });
  }

  void getUserProfileData() async {
    final select_user =
        await DatabaseService(uid: widget.uid).getFarmerData(widget.uid);
    setState(() {
      user = select_user;
      name = select_user!.name;
      email = select_user.email;
      phone_no = select_user.phone_no;
      agrarian_division = select_user.agrarian_division;
      nic = select_user.nic;
      address = select_user.address;
      province = select_user.province;
      bank = select_user.bank;
      account_name = select_user.account_name;
      account_no = select_user.account_no;
      branch = select_user.branch;
      profile_network_image = select_user.profile_url;

      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserProfileData();
  }

  void triggerSuccessAlert() {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        text: 'Updated successfully!',
        autoCloseDuration: const Duration(seconds: 10),
        onConfirmBtnTap: () => closeAlert());
  }

  void triggerErrorAlert() {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        title: 'Oops...',
        text: 'Sorry, something went wrong',
        loopAnimation: false,
        onCancelBtnTap: () => closeAlert());
  }

  void closeAlert() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => FarmerDashboard(uid: widget.uid)));
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: const Color.fromARGB(255, 242, 255, 243),
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: const Text('Edit Profile'),
              backgroundColor: const Color.fromARGB(255, 105, 184, 109),
              elevation: 0.0,
              actions: <Widget>[
                TextButton.icon(
                    icon: const Icon(Icons.power_settings_new),
                    label: const Text('logout'),
                    style: TextButton.styleFrom(
                      primary: Colors.white, // foreground
                    ),
                    onPressed: () async {
                      await _auth.signoutUser(widget.key, context);
                    })
              ],
            ),
            body: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Peronal Details',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Color.fromARGB(255, 32, 196, 100)),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        decoration:
                            textInputDecoration.copyWith(border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 0, 129, 32)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 0, 129, 32)),
                                ),hintText: 'Name'),
                        initialValue: name,
                        validator: (val) =>
                            val!.isEmpty ? 'Enter your name' : null,
                        onChanged: (val) {
                          setState(() => name = val);
                          setState(() => error = "");
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration:
                            textInputDecoration.copyWith(border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 0, 129, 32)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 0, 129, 32)),
                                ),hintText: 'Email'),
                        initialValue: email,
                        validator: (val) =>
                            val!.isEmpty ? 'Enter your email' : null,
                        onChanged: (val) {
                          setState(() => email = val);
                          setState(() => error = "");
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        readOnly: true,
                        style: const TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 147, 148, 148)),
                        decoration: textInputDecoration.copyWith(border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 0, 129, 32)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 0, 129, 32)),
                                ),
                            hintText: 'Phone Number'),
                        initialValue: phone_no,
                        validator: (val) =>
                            val!.isEmpty ? 'Enter a Phone Number' : null,
                        onChanged: (val) {
                          setState(() => phone_no = val);
                          setState(() => error = "");
                        },
                      ),
                      const SizedBox(height: 20.0),
                      Autocomplete<String>(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text == '') {
                              return const Iterable<String>.empty();
                            }
                            return _agrarianDivisionOptions
                                .where((String option) {
                              return option.contains(
                                  textEditingValue.text.toLowerCase());
                            });
                          },
                          initialValue:
                              TextEditingValue(text: agrarian_division),
                          fieldViewBuilder: (BuildContext context,
                              TextEditingController fieldTextEditingController,
                              FocusNode fieldFocusNode,
                              VoidCallback onFieldSubmitted) {
                            return TextFormField(
                              controller: fieldTextEditingController,
                              focusNode: fieldFocusNode,
                              keyboardType: TextInputType.text,
                              decoration: textInputDecoration.copyWith(border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 0, 129, 32)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 0, 129, 32)),
                                ),
                                  hintText: 'Agrarian Division'),
                              validator: (val) => agrarian_division.isEmpty
                                  ? 'Select your agrarian division'
                                  : null,
                              onChanged: (val) {
                                setState(() => agrarian_division = "");
                                setState(() => error = "");
                              },
                            );
                          },
                          onSelected: (String selection) {
                            setState(() => agrarian_division = selection);
                            setState(() => error = "");
                            // debugPrint('You just selected $selection');
                          }),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration:
                            textInputDecoration.copyWith(border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 0, 129, 32)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 0, 129, 32)),
                                ),hintText: 'NIC'),
                        validator: (val) =>
                            val!.isEmpty ? 'Enter your nic' : null,
                        initialValue: nic,
                        onChanged: (val) {
                          setState(() => nic = val);
                          setState(() => error = "");
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        keyboardType: TextInputType.streetAddress,
                        decoration:
                            textInputDecoration.copyWith(border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 0, 129, 32)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 0, 129, 32)),
                                ),hintText: 'Address'),
                        initialValue: address,
                        validator: (val) =>
                            val!.isEmpty ? 'Enter your address' : null,
                        onChanged: (val) {
                          setState(() => address = val);
                          setState(() => error = "");
                        },
                      ),
                      const SizedBox(height: 20.0),
                      Autocomplete<String>(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text == '') {
                              return const Iterable<String>.empty();
                            }
                            return _provinceOptions.where((String option) {
                              return option.contains(
                                  textEditingValue.text.toLowerCase());
                            });
                          },
                          initialValue: TextEditingValue(text: province),
                          fieldViewBuilder: (BuildContext context,
                              TextEditingController fieldTextEditingController,
                              FocusNode fieldFocusNode,
                              VoidCallback onFieldSubmitted) {
                            return TextFormField(
                              controller: fieldTextEditingController,
                              focusNode: fieldFocusNode,
                              keyboardType: TextInputType.text,
                              decoration: textInputDecoration.copyWith(border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 0, 129, 32)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 0, 129, 32)),
                                ),
                                  hintText: 'Province'),
                              validator: (val) => province.isEmpty
                                  ? 'Select your province'
                                  : null,
                              onChanged: (val) {
                                setState(() => province = "");
                                setState(() => error = "");
                              },
                            );
                          },
                          onSelected: (String selection) {
                            setState(() => province = selection);
                            setState(() => error = "");
                            // debugPrint('You just selected $selection');
                          }),
                      const SizedBox(height: 40.0),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Bank Details',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Color.fromARGB(255, 32, 196, 100)),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration:
                            textInputDecoration.copyWith(border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 0, 129, 32)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 0, 129, 32)),
                                ),hintText: 'Bank Name'),
                        initialValue: account_name,
                        validator: (val) =>
                            val!.isEmpty ? 'Enter your bank name' : null,
                        onChanged: (val) {
                          setState(() => account_name = val);
                          setState(() => error = "");
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: textInputDecoration.copyWith(border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 0, 129, 32)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 0, 129, 32)),
                                ),
                            hintText: 'Name in Bank Account'),
                        initialValue: bank,
                        validator: (val) => val!.isEmpty
                            ? 'Enter your name in bank account'
                            : null,
                        onChanged: (val) {
                          setState(() => bank = val);
                          setState(() => error = "");
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: textInputDecoration.copyWith(border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 0, 129, 32)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 0, 129, 32)),
                                ),
                            hintText: 'Account No'),
                        initialValue: account_no,
                        validator: (val) =>
                            val!.isEmpty ? 'Enter your account no' : null,
                        onChanged: (val) {
                          setState(() => account_no = val);
                          setState(() => error = "");
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: textInputDecoration.copyWith(border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 0, 129, 32)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 0, 129, 32)),
                                ),
                            hintText: 'Branch Name'),
                        initialValue: branch,
                        validator: (val) =>
                            val!.isEmpty ? 'Enter your branch name' : null,
                        onChanged: (val) {
                          setState(() => branch = val);
                          setState(() => error = "");
                        },
                      ),
                      const SizedBox(height: 40.0),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Profile Image',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Color.fromARGB(255, 32, 196, 100)),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextButton(
                        child: const Icon(
                          Icons.add_a_photo,
                          size: 50,
                        ),
                        onPressed: pickImage,
                      ),
                      const SizedBox(height: 10.0),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          // ignore: unnecessary_null_comparison
                          child: profile_image != null
                              ? Image.file(File(profile_image!.path))
                              : Image(
                                  image: NetworkImage(profile_network_image))),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                          child: const Text('Update'),
                           style: ElevatedButton.styleFrom(
                                primary: const Color.fromARGB(
                                    255, 71, 143, 75), // background
                                onPrimary: Colors.white, // foreground
                                textStyle: const TextStyle(fontSize: 20),
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(20.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 50.0),
                              ),
                          onPressed: () async {
                            if (_formKey.currentState != null &&
                                _formKey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                              });

                              String profile_url = "";
                              DatabaseService db =
                                  DatabaseService(uid: widget.uid);

                              // if (profile_image == null) {
                              //   profile_url = profile_network_image;
                              // } else {
                              //   profile_url = await db.uploadFileToFirebase(
                              //       "profile", "profile_", profile_image);
                              // }

                              var user_data = {
                                "uid": widget.uid,
                                "name": name,
                                "email": email,
                                "type": type,
                                "phone_no": phone_no,
                                "agrarian_division": agrarian_division,
                                "nic": nic,
                                "address": address,
                                "province": province,
                                "bank": bank,
                                "account_name": account_name,
                                "account_no": account_no,
                                "branch": branch,
                                "profile_url": profile_url
                              };

                              bool isSuccess =
                                  await db.updateUserData(user_data);

                              setState(() {
                                loading = false;
                              });

                              if (isSuccess) {
                                triggerSuccessAlert();
                              } else {
                                triggerErrorAlert();
                              }
                            }
                          }),
                      const SizedBox(height: 12.0),
                      Text(
                        error,
                        style:
                            const TextStyle(color: Colors.red, fontSize: 14.0),
                      )
                    ],
                  ),
                )),
          );
  }
}
