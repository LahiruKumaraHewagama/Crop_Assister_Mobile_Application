import 'dart:io';
// import 'dart:html' as html;
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:latlng/latlng.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crop_damage_assessment_app/services/auth.dart';
import 'package:crop_damage_assessment_app/services/database.dart';
import 'package:crop_damage_assessment_app/components/loading.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:crop_damage_assessment_app/components/decoration.dart';
import 'package:crop_damage_assessment_app/screens/farmer/home/claim_dashboard.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;

import 'farmer_dashboard.dart';

class AddClaim extends StatefulWidget {
  const AddClaim({Key? key, required this.uid}) : super(key: key);

  final String? uid;

  @override
  _AddClaimState createState() => _AddClaimState();
}

class _AddClaimState extends State<AddClaim> {
  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();
  String error = "";
  bool loading = false;
  bool isSubmit = false;
  bool isSubmitComplete = false;

  // text field state
  String claim_name = "";
  String crop_type = "";
  String reason = "";
  String description = "";
  String agrarian_division = "";
  String province = "";

  String damage_area = "";
  String estimate = "";

  String damage_date = DateFormat("yyyy-MM-dd").format(DateTime.now());

   XFile? video_file;
  List<XFile>? image_files = <XFile>[];

  late VideoPlayerController _videoPlayerController;

  List<LatLng> locations = <LatLng>[];
  bool isLocationEnabled = false;

  set _imageFile(XFile? value) {
    if (value != null) {
      if (image_files != null) {
        image_files?.addAll(<XFile>[value]);
      }
    }
  }

  set _locations(LatLng? value) {
    if (value != null) {
      locations.addAll(<LatLng>[value]);
    }
  }

  static const List<String> _cropOptions = <String>[
    'food',
    'feed',
    'fiber',
    'oil',
    'ornamental'
  ];

  static const List<String> _reasonOptions = <String>[
    'rain',
    'flood',
    'animal attack',
    'drought'
  ];

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

  Future getImage() async {
    try {
      await getUserLocation();

      if (isLocationEnabled) {
        var pickedFile = await picker.pickImage(source: ImageSource.camera);
        if (pickedFile != null) {
          setState(() {
            _imageFile = pickedFile;
          });
        } else {
          print("No image is selected.");
        }
      } else {
        triggerWarningAlert("Please enable location service to continue");
      }
    } catch (e) {
      print("error while picking file. " + e.toString());
      triggerWarningAlert(e.toString());
    }
  }

  Future getVideo() async {
    try {
      await getUserLocation();

      if (isLocationEnabled) {
        var pickedFile = await picker.pickVideo(source: ImageSource.camera);
        if (pickedFile != null) {
          setState(() {
            video_file = pickedFile;
          });
          // video_file = XFile(pickedFile.path);
          _videoPlayerController =
              VideoPlayerController.file(File(pickedFile.path))
                ..initialize().then((_) => {setState(() {})});

          _videoPlayerController.play();

          print("Video is selected.");
        } else {
          print("No video is selected.");
        }
      } else{
        triggerWarningAlert("Please enable location service to continue");
      }
    } catch (e) {
      print("error while picking video - " + e.toString());
      triggerWarningAlert(e.toString());
    }
  }

  bool _isImageFileEmpty() {
    return (image_files == null || image_files!.isEmpty) && isSubmit;
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        isLocationEnabled = false;
      });
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          isLocationEnabled = false;
        });
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        isLocationEnabled = false;
      });
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    setState(() {
      isLocationEnabled = true;
    });
    return await Geolocator.getCurrentPosition();
  }

  getUserLocation() async {
    Position currentLocation = await _determinePosition();
    setState(() {
      _locations = LatLng(currentLocation.latitude, currentLocation.longitude);
    });
  }

  void triggerSuccessAlert() {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        text: 'Submission completed successfully!',
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

  void triggerWarningAlert(var message) {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.warning,
        text: message,
        loopAnimation: false,
        onCancelBtnTap: () => closeWarningAlert());
  }

  void closeAlert() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute( builder: (context) => FarmerDashboard(uid: widget.uid))
    );
  }

  void closeWarningAlert() {
    return;
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 20.0),                  
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Claim Details',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Color.fromARGB(255, 32, 196, 100)),
                    )),
                      const SizedBox(height: 5.0),        
                  TextFormField(
                    keyboardType: TextInputType.name,
                    decoration: textInputDecoration.copyWith(
                      border: OutlineInputBorder(
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
                      
                      hintText: 'Claim Name'),
                    validator: (val) =>
                        val!.isEmpty ? 'Enter claim name' : null,
                    onChanged: (val) {
                      setState(() => claim_name = val);
                      setState(() => error = "");
                    },
                  ),
                  const SizedBox(height: 20.0),
                  Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      return const Iterable<String>.empty();
                    }
                    return _cropOptions.where((String option) {
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
                          textInputDecoration.copyWith(
                               border: OutlineInputBorder(
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
                                ),hintText: 'Crop Type'),
                      validator: (val) =>
                          crop_type.isEmpty ? 'Select crop type' : null,
                      onChanged: (val) {
                        setState(() => crop_type = "");
                        setState(() => error = "");
                      },
                    );
                  }, onSelected: (String selection) {
                    setState(() => crop_type = selection);
                    setState(() => error = "");
                    // debugPrint('You just selected $selection');
                  }),
                  const SizedBox(height: 20.0),
                  Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      return const Iterable<String>.empty();
                    }
                    return _reasonOptions.where((String option) {
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
                           border: OutlineInputBorder(
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
                          hintText: 'Reason for Damage'),
                      validator: (val) =>
                          reason.isEmpty ? 'Select the reason' : null,
                      onChanged: (val) {
                        setState(() => reason = "");
                        setState(() => error = "");
                      },
                    );
                  }, onSelected: (String selection) {
                    setState(() => reason = selection);
                    setState(() => error = "");
                    // debugPrint('You just selected $selection');
                  }),
                   const SizedBox(height: 30.0),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    minLines: 3,
                    maxLines: 6,
                    decoration:
                        textInputDecoration.copyWith(
                             border: OutlineInputBorder(
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
                                ),hintText: 'Description'),
                    validator: (val) =>
                        val!.isEmpty ? 'Enter description' : null,
                    onChanged: (val) {
                      setState(() => description = val);
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
                           border: OutlineInputBorder(
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
                          textInputDecoration.copyWith(
                               border: OutlineInputBorder(
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
                                ),hintText: 'Province'),
                      validator: (val) =>
                          province.isEmpty ? 'Select your province' : null,
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        elevation: 0,
                        side: const BorderSide(
                            color: Color.fromARGB(255, 151, 151, 151))),
                    onPressed: () {
                      DatePicker.showDatePicker(context,
                          theme: const DatePickerTheme(
                            containerHeight: 250.0,
                          ),
                          showTitleActions: true,
                          maxTime: DateTime.now(), onConfirm: (date) {
                        setState(() => damage_date =
                            '${date.year}-${date.month}-${date.day}');
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 60.0,
                      
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            "Damage Date",
                            style: TextStyle(
                                color: Color.fromARGB(255, 116, 115, 115),
                                fontSize: 15.0),
                          ),
                          Row(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    " $damage_date",
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 26, 130, 1),
                                        fontSize: 16.0),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: textInputDecoration.copyWith(
                         border: OutlineInputBorder(
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
                        hintText: 'Damaged Area (sqft)'),
                    validator: (val) =>
                        val!.isEmpty ? 'Enter damage area' : null,
                    onChanged: (val) {
                      setState(() => damage_area = val);
                      setState(() => error = "");
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: textInputDecoration.copyWith(
                         border: OutlineInputBorder(
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
                        hintText: 'Estimated Damage (LKR)'),
                    validator: (val) =>
                        val!.isEmpty ? 'Enter estimate damage' : null,
                    onChanged: (val) {
                      setState(() => estimate = val);
                      setState(() => error = "");
                    },
                  ),
                  const SizedBox(height: 40.0),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Evidence',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Color.fromARGB(255, 32, 196, 100)),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Turn on location while using camera',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.0,
                          color: Color.fromARGB(255, 104, 104, 104)),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: TextButton(
                      child: const Icon(
                        Icons.add_a_photo,
                        size: 40,
                      ),
                      style: TextButton.styleFrom(
                        primary: _isImageFileEmpty()
                            ? Colors.red
                            : const Color.fromARGB(255, 32, 196, 100),
                      ),
                      onPressed: getImage,
                    ),
                  ),
                  Visibility(
                    child: const Text(
                      "Upload Image",
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                    visible: _isImageFileEmpty(),
                  ),
                  const SizedBox(height: 20.0),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: image_files != null
                          ? Wrap(
                              children: image_files!.map((imageone) {
                                return Card(
                                  child: SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: Image.file(File(imageone.path)),
                                  ),
                                );
                              }).toList(),
                            )
                          : Container()),
                             const SizedBox(height: 10.0),
                           
                  const SizedBox(height: 10.0),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: video_file != null
                        ? _videoPlayerController.value.isInitialized
                            ? AspectRatio(
                                aspectRatio:
                                    _videoPlayerController.value.aspectRatio,
                                child: VideoPlayer(_videoPlayerController),
                              )
                            : Container()
                        : TextButton(
                            child: const Icon(
                              Icons.video_call_rounded,
                              size: 50,
                              color: const Color.fromARGB(255, 32, 196, 100),
                            ),
                            onPressed: getVideo,
                          ),
                  ),
                  const SizedBox(height: 10.0),
                               Container(
                        alignment: Alignment.centerLeft,
                          width: 300,
                          height:2 , 
                          color: Color.fromARGB(255, 98, 98, 98)  ),
                  const SizedBox(height: 10.0),
                  ElevatedButton(
                      child: const Text('Submit'),
                     style: ElevatedButton.styleFrom(
                              primary: const Color.fromARGB(
                                  255, 71, 143, 75), // background
                              onPrimary: Colors.white, // foreground
                              textStyle: const TextStyle(fontSize:15),
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 40.0),
                            ),
                      onPressed: isSubmitComplete
                          ? null
                          : () async {
                              setState(() => isSubmit = true);
                              if (_formKey.currentState != null && _formKey.currentState!.validate() && !_isImageFileEmpty()) {
                                setState(() {
                                  loading = true;
                                });

                                DatabaseService db = DatabaseService(uid: widget.uid);
                                List<String>? claim_image_urls = <String>[];
                                String claim_video_url = "";
                                var latitude_mean = 0.0;
                                var longitude_mean = 0.0;

                                latitude_mean = locations
                                        .map((location) => location.latitude)
                                        .reduce((a, b) => a + b) /
                                    locations.length;
                                longitude_mean = locations
                                        .map((location) => location.longitude)
                                        .reduce((a, b) => a + b) /
                                    locations.length;

                                 for (XFile? img in image_files!) {
                                  String claim_image_url = await db.uploadFileToFirebase( "claim_image", "claim_image_", img);
                                  claim_image_urls.add(claim_image_url);
                                }

                                if (video_file != null) {
                                  claim_video_url = await db.uploadFileToFirebase( "claim_video", "claim_video_", video_file);
                                }

                                var claim_data = {
                                  "uid": widget.uid,
                                  "status": "Pending",
                                  "timestamp": DateTime.now().millisecondsSinceEpoch,
                                  "claim_name": claim_name,
                                  "crop_type": crop_type,
                                  "reason": reason,
                                  "description": description,
                                  "agrarian_division": agrarian_division,
                                  "province": province,
                                  "damage_date": damage_date,
                                  "damage_area": damage_area,
                                  "estimate": estimate,
                                  "claim_image_urls": claim_image_urls,
                                  "claim_video_url": claim_video_url,
                                  "claim_location": GeoPoint(latitude_mean, longitude_mean),
                                  "approved_by": "",
                                  "comment": ""
                                };

                                bool isSuccess = await db.addClaimData(claim_data);

                                setState(() {
                                  isSubmitComplete = true;
                                  loading = false;
                                });

                                if (isSuccess) {
                                  setState(() {
                                    image_files = null;
                                    video_file = null;
                                    isSubmit = false;
                                  });
                                  triggerSuccessAlert();
                                } else {
                                  triggerErrorAlert();
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
            ));
  }
}
