import 'dart:async';
import 'package:crop_damage_assessment_app/screens/officer/home/claim_panel.dart';
import 'package:flutter/material.dart';
import 'package:crop_damage_assessment_app/models/claim.dart';

class SimilarClaimTile extends StatelessWidget {
  final String? uid;
  final Claim? claim;

  const SimilarClaimTile({Key? key, required this.uid , required this.claim}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        elevation: 5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            ListTile(
              isThreeLine : true,

              title: Text("claim name - " + claim!.claim_name, 
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Color.fromARGB(255, 0, 0, 0)
                        )
                      ),
              subtitle: Text(
                      "crop type - " + claim!.crop_type + "\n" +
                      "crop location - " + claim!.claim_location.latitude.toString() +
                        " : " +
                      claim!.claim_location.longitude.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 15.0,
                          color: Color.fromARGB(255, 0, 0, 0)),
                    ),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClaimPanel(uid: uid, claim: claim)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
