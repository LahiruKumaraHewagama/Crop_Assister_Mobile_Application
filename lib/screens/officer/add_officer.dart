import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crop_damage_assessment_app/services/auth.dart';
import 'package:crop_damage_assessment_app/screens/wrapper.dart';
import 'package:crop_damage_assessment_app/services/database.dart';
import 'package:crop_damage_assessment_app/components/loading.dart';
import 'package:crop_damage_assessment_app/components/decoration.dart';
import 'package:crop_damage_assessment_app/screens/farmer/sign_up_farmer.dart';

class OfficerAddData extends StatefulWidget {
  const OfficerAddData({Key? key, required this.uid, required this.phone_no}) : super(key: key);

  final String? uid;
  final String? phone_no;

  @override
  _OfficerAddDataState createState() => _OfficerAddDataState();
}

class _OfficerAddDataState extends State<OfficerAddData> {
  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();
  String error = "";
  bool loading = false;

  // text field state
  String name = "";
  String type = "officer_pending";
  String email = "";
  String agrarian_division = "";
  String province = "";
  String nic = "";
  String address = "";

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
      // profile_image = File(pickedFile!.path);
      profile_image = pickedFile;
    });
  }

  void triggerErrorAlert(BuildContext context) {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        title: 'Oops...',
        text: 'Sorry, something went wrong',
        loopAnimation: false,
        onCancelBtnTap: () => closeAlert(context));
  }

  void closeAlert(BuildContext context) async {
    await _auth.signoutUser(widget.key, context);
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: const Color.fromARGB(255, 242, 255, 243),
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: const Text('Officer - Registraion'),
              backgroundColor: const Color.fromARGB(255, 105, 184, 109),
              elevation: 0.0,
              actions: <Widget>[

                TextButton.icon(
                    icon: const Icon(Icons.person),
                    label: const Text('Farmer'),
                    style: TextButton.styleFrom(
                      primary: Colors.white, // foreground
                    ),
                    onPressed: () async {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute( builder: (context) => FarmerAddData(uid: widget.uid, phone_no: widget.phone_no))
                        );
                    }
                ),

                IconButton(
                  icon: const Icon(Icons.power_settings_new),
                  onPressed: () async {
                    await _auth.signoutUser(widget.key, context);
                  }
                ),

              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 20.0),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Officer Name'),
                      validator: (val) =>
                          val!.isEmpty ? 'Enter officer name' : null,
                      onChanged: (val) {
                        setState(() => name = val);
                        setState(() => error = "");
                      },
                    ),

                    const SizedBox(height: 20.0),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Officer Email'),
                      validator: (val) =>
                          val!.isEmpty ? 'Enter officer email' : null,
                      onChanged: (val) {
                        setState(() => email = val);
                        setState(() => error = "");
                      },
                    ),
                    const SizedBox(height: 20.0),
                    Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text == '') {
                        return const Iterable<String>.empty();
                      }
                      return _agrarianDivisionOptions.where((String option) {
                        return option
                            .contains(textEditingValue.text.toLowerCase());
                      });
                    }, fieldViewBuilder: (BuildContext context,
                            TextEditingController fieldTextEditingController,
                            FocusNode fieldFocusNode,
                            VoidCallback onFieldSubmitted) {
                      return TextFormField(
                        controller: fieldTextEditingController,
                        focusNode: fieldFocusNode,
                        keyboardType: TextInputType.text,
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Agrarian Division'),
                        validator: (val) => agrarian_division.isEmpty
                            ? 'Select officer agrarian division'
                            : null,
                        onChanged: (val) {
                          setState(() => agrarian_division = "");
                          setState(() => error = "");
                        },
                      );
                    }, onSelected: (String selection) {
                      setState(() => agrarian_division = selection);
                      setState(() => error = "");
                      // debugPrint('You just selected $selection');
                    }),

                    
                    const SizedBox(height: 20.0),
                    Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text == '') {
                        return const Iterable<String>.empty();
                      }
                      return _provinceOptions.where((String option) {
                        return option
                            .contains(textEditingValue.text.toLowerCase());
                      });
                    }, fieldViewBuilder: (BuildContext context,
                            TextEditingController fieldTextEditingController,
                            FocusNode fieldFocusNode,
                            VoidCallback onFieldSubmitted) {
                      return TextFormField(
                        controller: fieldTextEditingController,
                        focusNode: fieldFocusNode,
                        keyboardType: TextInputType.text,
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Province'),
                        validator: (val) =>
                            province.isEmpty ? 'Select officer province' : null,
                        onChanged: (val) {
                          setState(() => province = "");
                          setState(() => error = "");
                        },
                      );
                    }, onSelected: (String selection) {
                      setState(() => province = selection);
                      setState(() => error = "");
                      // debugPrint('You just selected $selection');
                    }),

                    const SizedBox(height: 20.0),
                    TextFormField(
                          keyboardType: TextInputType.text,
                          decoration:
                              textInputDecoration.copyWith(hintText: 'NIC'),
                          validator: (val) =>
                              val!.isEmpty ? 'Enter your nic' : null,
                          onChanged: (val) {
                            setState(() => nic = val);
                            setState(() => error = "");
                          },
                        ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                          keyboardType: TextInputType.streetAddress,
                          decoration:
                              textInputDecoration.copyWith(hintText: 'Address'),
                          validator: (val) =>
                              val!.isEmpty ? 'Enter your address' : null,
                          onChanged: (val) {
                            setState(() => address = val);
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          // ignore: unnecessary_null_comparison
                          child: profile_image != null
                              ? Image.file(File(profile_image!.path))
                              : TextButton(
                                  child: const Icon(
                                    Icons.add_a_photo,
                                    size: 50,
                                  ),
                                  onPressed: pickImage,
                                ),
                        ),

                    const SizedBox(height: 20.0),
                    ElevatedButton(
                        child: const Text('Submit'),
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromARGB(
                              255, 71, 143, 75), // background
                          onPrimary: Colors.white, // foreground
                        ),
                        onPressed: () async {
                          if (_formKey.currentState != null &&
                              _formKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });

                            DatabaseService db = DatabaseService(uid: widget.uid);
                            String profile_url = "";
                            // if (profile_image == null) {
                            //   profile_url = "https://firebasestorage.googleapis.com/v0/b/crop-assister.appspot.com/o/Crop%20assister%20app%20%20PNG.png?alt=media&token=e9067fd2-4eac-4df4-93be-185589e15833";
                            // } else {
                            //   profile_url = await db.uploadFileToFirebase( "profile", "profile_", profile_image);
                            // }
                            
                            var user_data = {
                              "uid": widget.uid,
                              "phone_no": widget.phone_no,
                              "name": name,
                              "email": email,
                              "type": type,
                              "agrarian_division": agrarian_division,
                              "nic": nic,
                              "address": address,
                              "province": province,
                              "profile_url": profile_url
                            };

                            bool isSuccess = await db.updateUserData(user_data);                              
                              setState(() {
                                loading = false;
                              });

                              if (isSuccess) {
                                Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) => Wrapper(key: widget.key)));
                              } else {
                                triggerErrorAlert(context);
                              }

                          }
                        }),
                    const SizedBox(height: 12.0),
                    Text(
                      error,
                      style: const TextStyle(color: Colors.red, fontSize: 14.0),
                    )
                  ],
                ),
              )
            )
          );
  }
}
