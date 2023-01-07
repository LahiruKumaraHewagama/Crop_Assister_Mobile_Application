import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crop_damage_assessment_app/screens/officer/home/officer_dashboard.dart';
import 'package:crop_damage_assessment_app/screens/officer/home/view_similar_list.dart';
import 'package:crop_damage_assessment_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:video_player/video_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:crop_damage_assessment_app/models/claim.dart';
import 'package:crop_damage_assessment_app/models/notification.dart'
    as fnotification;
import 'package:crop_damage_assessment_app/components/loading.dart';
import 'package:crop_damage_assessment_app/components/decoration.dart';
import 'package:uuid/uuid.dart';
import '../../notification/notification.dart';

class ClaimView extends StatefulWidget {
  final Claim? claim;
  final String? uid;

  const ClaimView({Key? key, required this.uid, required this.claim})
      : super(key: key);

  @override
  _ClaimProfileState createState() => _ClaimProfileState();
}

class _ClaimProfileState extends State<ClaimView> {
  String comment = "";
  bool loading = false;
  late String currentState;
  late List<Widget> imageSliders = [];
  late List<dynamic> claim_image_urls_list = [];
  late VideoPlayerController _videoPlayerController;
  final NotificationService notificationservice = NotificationService();

  final List<String> claim_states = ['Pending', 'Approve', 'Reject'];

  void initClaimImages() async {

    setState(() {
      claim_image_urls_list = widget.claim!.claim_image_urls;
      imageSliders = widget.claim!.claim_image_urls
          .map((item) => Container(
                margin: const EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.network(item,
                            fit: BoxFit.fill, width: 2000.0, height: 1000),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(200, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Text(
                              'No. ${widget.claim!.claim_image_urls.indexOf(item) + 1} image',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ))
          .toList();

      loading = false;
    });

    if (widget.claim!.claim_video_url != "") {
      _videoPlayerController =
          VideoPlayerController.network(widget.claim!.claim_video_url)
            ..initialize().then((_) {
              setState(() {});
            });
      _videoPlayerController.setLooping(true);
      _videoPlayerController.initialize();
    }

    setState(() {
      currentState = widget.claim!.status;
      comment = widget.claim!.comment;
    });

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
            builder: (context) => OfficerDashboard(uid: widget.uid)));
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.claim!.claim_video_url != "") {
      _videoPlayerController.dispose();
    }
  }

  @override
  void initState() {
    super.initState();
    initClaimImages();
  }

  _addNotification(String action) async {
    String claim_id = widget.claim!.claim_id;
    String to = widget.claim!.uid;
    String from = widget.uid!;
    String state = "unread";
    String text = "";
    DateTime time = DateTime.now();
    String claimState = "";

    if (action == "Approve") {
      text = "Your claim ( claim id : $claim_id ) has been approved!";
      claimState = "Approved";
    } else if (action == "Reject") {
      text = "Your claim ( claim id : $claim_id ) has been rejected!";
      claimState = "Rejected";
    }

    String notificationid = Uuid().v4();
    final notification = fnotification.Notification(notificationid,
        from: from,
        to: to,
        message: text,
        status: state,
        claimState: claimState,
        date: time);

    notificationservice.addNotification(notification);

    print("Add notification");
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20.0),
                CarouselSlider(
                  options: CarouselOptions(
                    aspectRatio: 2.0,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    initialPage: 2,
                    autoPlay: true,
                  ),
                  items: imageSliders,
                ),
                const SizedBox(height: 30.0),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    widget.claim!.claim_name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                        color: Color.fromARGB(255, 32, 196, 100)),
                  ),
                ),
                const SizedBox(height: 20.0),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Claim Details",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Color.fromARGB(255, 146, 141, 85)),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.claim!.description,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Color.fromARGB(255, 80, 79, 79)),
                  ),
                ),
                const SizedBox(height: 30.0),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Crop type - " +
                        widget.claim!.crop_type +
                        "\nReason for Damage - " +
                        widget.claim!.reason +
                        "\nAgrarian Division - " +
                        widget.claim!.agrarian_division +
                        "\nProvice - " +
                        widget.claim!.province +
                        "\nDate of Damage - " +
                        widget.claim!.damage_date +
                        "\nDamage Area - " +
                        widget.claim!.damage_area +
                        "\nEstimated Damage - " +
                        widget.claim!.estimate +
                        "\nEstimated Location - " +
                        widget.claim!.claim_location.latitude.toString() +
                        " : " +
                        widget.claim!.claim_location.longitude.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Color.fromARGB(255, 80, 79, 79)),
                  ),
                ),
                const SizedBox(height: 30.0),
                Center(
                  child: widget.claim!.claim_video_url != ""
                      ? _videoPlayerController.value.isInitialized
                          ? AspectRatio(
                              aspectRatio:
                                  _videoPlayerController.value.aspectRatio,
                              child: VideoPlayer(_videoPlayerController),
                            )
                          : const Text('waiting for video to load')
                      : Container(),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: widget.claim!.claim_video_url != "" &&
                            _videoPlayerController.value.isInitialized
                        ? FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                _videoPlayerController.value.isPlaying
                                    ? _videoPlayerController.pause()
                                    : _videoPlayerController.play();
                              });
                            },
                            child: Icon(
                              _videoPlayerController.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                            ),
                          )
                        : Container()),


                // const SizedBox(height: 20.0),
                // const Align(
                //   alignment: Alignment.centerLeft,
                //   child: Text(
                //     "Similer Claim",
                //     overflow: TextOverflow.ellipsis,
                //     style: TextStyle(
                //         fontWeight: FontWeight.bold,
                //         fontSize: 20.0,
                //         color: Color.fromARGB(255, 146, 141, 85)),
                //   ),
                // ),

                // const SizedBox(height: 20.0),
                // similer_claims.isNotEmpty ?
                //   ViewSimilarList(uid: widget.uid, similer_claims: similer_claims)
                // :
                // const Text(
                //     "No similar claims",
                //     overflow: TextOverflow.ellipsis,
                //     style: TextStyle(
                //         fontWeight: FontWeight.bold,
                //         fontSize: 18.0,
                //         color: Color.fromARGB(255, 62, 62, 62)),
                //   ),



                const SizedBox(height: 20.0),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Claim Review",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Color.fromARGB(255, 146, 141, 85)),
                  ),
                ),
                const SizedBox(height: 40.0),
                TextFormField(
                  keyboardType: TextInputType.text,
                  minLines: 3,
                  maxLines: 6,
                  decoration: textInputDecoration.copyWith(hintText: 'Comment'),
                  initialValue: comment,
                  onChanged: (val) {
                    setState(() => comment = val);
                  },
                ),
                const SizedBox(height: 20.0),
                DropdownButtonFormField(
                  value: currentState,
                  decoration: textInputDecoration,
                  items: claim_states.map((claim_state_option) {
                    return DropdownMenuItem(
                      value: claim_state_option,
                      child: Text(claim_state_option),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      currentState = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });

                      var claim_data = {
                        "uid": widget.claim!.uid,
                        "timestamp": widget.claim!.timestamp,
                        "claim_name": widget.claim!.claim_name,
                        "crop_type": widget.claim!.crop_type,
                        "reason": widget.claim!.reason,
                        "description": widget.claim!.description,
                        "agrarian_division": widget.claim!.agrarian_division,
                        "province": widget.claim!.province,
                        "damage_date": widget.claim!.damage_date,
                        "damage_area": widget.claim!.damage_area,
                        "estimate": widget.claim!.estimate,
                        "claim_image_urls": widget.claim!.claim_image_urls,
                        "claim_video_url": widget.claim!.claim_video_url,
                        "claim_location": GeoPoint(
                            widget.claim!.claim_location.latitude,
                            widget.claim!.claim_location.longitude),
                        "status": currentState,
                        "approved_by": widget.uid,
                        "comment": comment
                      };

                      DatabaseService db = DatabaseService(uid: widget.uid);
                      bool isSuccess = await db.updateClaimData(
                          widget.claim!.claim_id, claim_data);

                      setState(() {
                        loading = false;
                      });

                      if (isSuccess) {
                        _addNotification(currentState);
                        triggerSuccessAlert();
                      } else {
                        triggerErrorAlert();
                      }
                    }),
              ],
            ),
          );
  }
}
