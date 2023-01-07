import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:crop_damage_assessment_app/models/claim.dart';
import 'package:crop_damage_assessment_app/models/officer.dart';
import 'package:crop_damage_assessment_app/services/database.dart';
import 'package:crop_damage_assessment_app/components/loading.dart';

Officer? officer;

class ClaimView extends StatefulWidget {
  final String? uid;
  final Claim? claim;

  const ClaimView({Key? key, required this.uid, required this.claim})
      : super(key: key);

  @override
  _ClaimViewState createState() => _ClaimViewState();
}

class _ClaimViewState extends State<ClaimView> {
  bool loading = true;
  late List<dynamic> claim_image_urls_list = [];
  late List<Widget> imageSliders = [];
  late VideoPlayerController _videoPlayerController;

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
  }

  void getOfficerProfileData(String officer_id) async {
    //use a Async-await function to get the data
    final select_officer =
        await DatabaseService(uid: widget.uid).getOfficerData(officer_id);
    setState(() {
      officer = select_officer;
      loading = false;
    });
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

    if (widget.claim!.approved_by == "") {
      setState(() {
        loading = false;
      });
    } else {
      getOfficerProfileData(widget.claim!.approved_by);
      // print("officer " + officer!.email);
    }
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
                        color: Color.fromARGB(255, 0, 0, 0)),
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
                    "Status - " +
                        widget.claim!.status +
                        "\nCrop type - " +
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
                    // overflow: TextOverflow.ellipsis,
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
                const SizedBox(height: 40.0),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Review",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),

                const SizedBox(height: 20.0),
                Align(
                  alignment: Alignment.centerLeft,
                  child: officer != null && widget.claim!.approved_by!= "" ?
                    Text(
                      "Review by - " + officer!.name +
                      "\nOfficer contact - " + officer!.phone_no +
                      "\nComment - " + widget.claim!.comment,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Color.fromARGB(255, 80, 79, 79)
                      ),
                  ) :
                  
                  const Text(
                      "Pending",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Color.fromARGB(255, 80, 79, 79)
                      ),
                  ) 
                  ,
                ),
              ],
            ),
          );
  }
}
