import 'dart:async';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:crop_damage_assessment_app/models/claim.dart';
import 'package:crop_damage_assessment_app/screens/officer/home/claim_panel.dart';

class ClaimTile extends StatelessWidget {
  final Claim? claim;
  final String? uid;

  const ClaimTile({Key? key, required this.uid, required this.claim})
      : super(key: key);

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
         
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        elevation: 5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 10.0),
                       ListTile(
                        leading: Icon(Icons.account_balance_wallet_rounded,color:claim!.status=="Pending"? Color.fromARGB(255, 198, 167, 11) :claim!.status=="Reject"? Color.fromARGB(255, 193, 30, 30) :Color.fromARGB(255, 0, 153, 8)),
                        title:Text(claim!.claim_name,style: const TextStyle(
                          fontSize: 15.0, color: Color.fromARGB(255, 9, 2, 2),fontWeight:FontWeight.bold)),
                        subtitle: Text(
                claim!.status,
                style: getStatusCode(claim!.status),
              )
                      ),
                       Container(
                        alignment: Alignment.centerLeft,
                          width: 300,
                          height:2 , 
                          color: Color.fromARGB(255, 98, 98, 98)  ),

                     Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment :CrossAxisAlignment.center,
                children: <Widget>[                   
                   const SizedBox(width: 5.0),                   
                  Align(
                    alignment: Alignment.center,                                        
                    child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment :CrossAxisAlignment.start,
                children: <Widget>[
                   
                   const SizedBox(height: 4.0),
                  
                  
                    Container(
                        alignment: Alignment.centerLeft,
                          width: 105,
                          height: 150,                        
                        child: FutureBuilder<Widget>(
                          future: getImage(),
                          builder: (context, claim_snapshot) {
                  if (claim_snapshot.hasData) {
                    return claim_snapshot.requireData;
                  } else {
                    return const Text('Loading Image...');
                  }
                }),
                      ) ,                              
                 
                ],
              ),            
                  ),

                  const SizedBox(width: 5.0),
                  Align(
                    alignment: Alignment.centerLeft,                                        
                    child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment :CrossAxisAlignment.start,
                children: <Widget>[
                   
                  // const SizedBox(height: 10.0),
                   
                 Align(
                    alignment: Alignment.topLeft,
                    child: Text( "Crop type is "+                  
                          claim!.crop_type,                       
                         
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 15.0, color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ),

  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(  "Damage by "+                
                           claim!.reason,                       
                         
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 12.0, color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ),
  Align(
                    alignment: Alignment.centerLeft,
                    child: Text( "RS : "+ claim!.estimate+".00",            
                         
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 12.0, color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ),
                   Align(
                    alignment: Alignment.centerLeft,
                    child: Text(claim!.damage_date,            
                         
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 10.0, color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ),
                  // const SizedBox(height: 10.0),
                                
                 
                ],
              ),            
                  ),


                                            
              
                     
        
                 
                ],
              ),
                    
                     Container(
                        alignment: Alignment.centerLeft,
                          width: 300,
                          height:1 , 
                          color: Color.fromARGB(255, 98, 98, 98)  ),
                      ButtonBarTheme ( // make buttons use the appropriate styles for cards
                        data: ButtonBarThemeData(),
                        child: ButtonBar(
                          children: <Widget>[
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
                         const SizedBox(width: 110.0), 

ElevatedButton(
                             child: const Text('More'),
                             style: ElevatedButton.styleFrom(
                              primary: const Color.fromARGB(
                                  255, 71, 143, 75), // background
                              onPrimary: Colors.white, // foreground
                              textStyle: const TextStyle(fontSize: 12),
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 30.0),
                            ), onPressed: () { 
                               Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                   ClaimPanel(uid: uid, claim: claim)),
                          );
                             },),


                                                 ],
                        ),
                      ),
                    ],
                  ),                
                )
    );
  }
}
