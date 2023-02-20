import 'package:crop_damage_assessment_app/models/user.dart';
import 'package:crop_damage_assessment_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crop_damage_assessment_app/models/claim.dart';
import 'package:crop_damage_assessment_app/components/loading.dart';
import 'package:crop_damage_assessment_app/screens/farmer/home/claim_tile.dart';

class ViewClaimList extends StatefulWidget {
  const ViewClaimList({Key? key, required this.uid}) : super(key: key);

  final String? uid;

  @override
  _ViewClaimListState createState() => _ViewClaimListState();
}

class _ViewClaimListState extends State<ViewClaimList> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final claims = Provider.of<List<Claim?>>(context);
    print(claims);

    return loading
        ? const Loading()
        : Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
            child: claims.isNotEmpty ? 
            
              ListView.builder(
                itemCount: claims.length,
                itemBuilder: (context, index) {
                  return ClaimTile(claim: claims[index]);
                },
              )
              :
              const Align(
                alignment: Alignment.topCenter,
                child:Text(
                    "Empty",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Color.fromARGB(255, 80, 79, 79)),
                  )  
              )

            );
  }
}
