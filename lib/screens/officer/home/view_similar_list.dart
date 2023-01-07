import 'package:crop_damage_assessment_app/models/claim.dart';
import 'package:crop_damage_assessment_app/screens/officer/home/similar_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crop_damage_assessment_app/models/officer.dart';
import 'package:crop_damage_assessment_app/components/loading.dart';
import 'package:crop_damage_assessment_app/screens/admin/officer_tile.dart';

class ViewSimilarList extends StatefulWidget {
  const ViewSimilarList({Key? key, required this.uid, required this.similer_claims}) : super(key: key);

  final String? uid;
  final List<Claim?> similer_claims;

  @override
  _ViewSimilarListState createState() => _ViewSimilarListState();
}

class _ViewSimilarListState extends State<ViewSimilarList> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {

    return loading
        ? const Loading()
        : Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
            child: widget.similer_claims.isNotEmpty ? 
              ListView.builder(
                itemCount: widget.similer_claims.length,
                itemBuilder: (context, index) {
                  return SimilarClaimTile(uid: widget.uid, claim: widget.similer_claims[index]);
                },
              )
            :
            const Align(
              alignment: Alignment.topCenter,
              child:Text(
                  "No similar claims",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Color.fromARGB(255, 80, 79, 79)),
                )  
            )
          );
  }
}
