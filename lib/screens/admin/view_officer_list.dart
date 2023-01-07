import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crop_damage_assessment_app/models/officer.dart';
import 'package:crop_damage_assessment_app/components/loading.dart';
import 'package:crop_damage_assessment_app/screens/admin/officer_tile.dart';

class ViewOfficerList extends StatefulWidget {
  const ViewOfficerList({Key? key, required this.uid, required this.officer_type}) : super(key: key);

  final String? uid;
  final String? officer_type;

  @override
  _ViewOfficerListState createState() => _ViewOfficerListState();
}

class _ViewOfficerListState extends State<ViewOfficerList> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final officers = Provider.of<List<Officer?>>(context);
    List filterOfficers = officers.where((officer) => officer!.type == widget.officer_type).toList();

    return loading
        ? const Loading()
        : Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
            child: filterOfficers.isNotEmpty ? 
              ListView.builder(
                itemCount: filterOfficers.length,
                itemBuilder: (context, index) {
                  return OfficerTile(uid: widget.uid, officer: filterOfficers[index]);
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
