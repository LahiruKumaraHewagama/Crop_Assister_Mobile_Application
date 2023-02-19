import 'dart:async';
import 'package:crop_damage_assessment_app/screens/admin/officer_profile.dart';
import 'package:flutter/material.dart';
import 'package:crop_damage_assessment_app/models/officer.dart';
// import 'package:crop_damage_assessment_app/screens/farmer/home/officer_panel.dart';

class OfficerTile extends StatelessWidget {
  final String? uid;
  final Officer? officer;

  const OfficerTile({Key? key, required this.uid, required this.officer})
      : super(key: key);

  Future<Widget> getImage() async {
    final Completer<Widget> completer = Completer();
    var url = officer!.profile_url;
    var image = NetworkImage(url);
    final load = image.resolve(const ImageConfiguration());

    final listener = ImageStreamListener((ImageInfo info, isSync) async {
      if (info.image.width == 80 && info.image.height == 160) {
        completer.complete(const Text('No Image'));
      } else {
        completer.complete(Image(
          image: image,
          width: 400,
        ));
      }
    });

    load.addListener(listener);
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SizedBox(
        height: 100,
        child: Card(
          elevation: 5,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              ListTile(
                isThreeLine: true,
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(officer!.profile_url),
                  radius: 25,
                ),
                title: Text(officer!.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 0, 0, 0))),
                subtitle: Text(
                  officer!.phone_no +
                      "\n" +
                      officer!.agrarian_division +
                      "\n" +
                      officer!.email,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 15.0, color: Color.fromARGB(255, 0, 0, 0)),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OfficerProfile(
                            uid: uid, officer_uid: officer!.uid)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
