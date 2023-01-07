import 'dart:async';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:crop_damage_assessment_app/models/claim.dart';
import 'package:crop_damage_assessment_app/screens/farmer/home/claim_panel.dart';

class ClaimTile extends StatelessWidget {
  final Claim? claim;

  const ClaimTile({Key? key, required this.claim}) : super(key: key);
  // var fifteenAgo = DateTime.now().subtract(const Duration(minutes: 15));

  Future<Widget> getImage() async {
    final Completer<Widget> completer = Completer();
    var url = claim!.claim_image_urls[0];
    var image = NetworkImage(url);
    // final config = await image.obtainKey();
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

  TextStyle getStatusCode(String? status) {
    switch (status) {
      case "Pending":
        return const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 198, 167, 11));

      case "Approve":
        return const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 14, 129, 81));

      case "Reject":
        return const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 193, 30, 30));

      default:
        return const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 198, 167, 11));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        elevation: 5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: 200,
              child: FutureBuilder<Widget>(
                future: getImage(),
                builder: (context, claim_snapshot) {
                  if (claim_snapshot.hasData) {
                    return claim_snapshot.requireData;
                  } else {
                    return const Text('Loading Image...');
                  }
                },
              ),
            ),
            ListTile(
              isThreeLine: true,
              title: Text(claim!.claim_name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Color.fromARGB(255, 0, 0, 0))),
              subtitle: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Crop Type - " +
                          claim!.crop_type +
                          "\nReason - " +
                          claim!.reason,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 15.0, color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      timeago.format(DateTime.fromMillisecondsSinceEpoch(
                          claim!.timestamp)),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 13.0,
                          color: Color.fromARGB(255, 109, 108, 108)),
                    ),
                  ),
                ],
              ),
              trailing: Text(
                claim!.status,
                style: getStatusCode(claim!.status),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ClaimPanel(claim: claim)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
