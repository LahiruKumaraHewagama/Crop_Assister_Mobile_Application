import 'dart:io';
import 'package:crop_damage_assessment_app/models/farmer.dart';
import 'package:crop_damage_assessment_app/models/officer.dart';
import 'package:path/path.dart';
import 'package:latlng/latlng.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crop_damage_assessment_app/models/claim.dart';
import 'package:crop_damage_assessment_app/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../screens/farmer/home/farmer_dashboard.dart';

class DatabaseService {
  final String? uid;
  late String? select_uid;

  DatabaseService({required this.uid});

  set set_select_uid(String select_uid) {
    this.select_uid = select_uid;
  }

  // collection reference
  final CollectionReference user_collection =
      FirebaseFirestore.instance.collection('user');
  final CollectionReference claim_collection =
      FirebaseFirestore.instance.collection('claim');

  String getString(QueryDocumentSnapshot doc, String field) {
    return doc.data().toString().contains(field) ? doc.get(field) : "";
  }

  String getProfileUrl(QueryDocumentSnapshot doc, String field) {
    return doc.data().toString().contains(field)
        ? doc.get(field)
        : "https://firebasestorage.googleapis.com/v0/b/crop-assister.appspot.com/o/Crop%20assister%20app%20%20PNG.png?alt=media&token=e9067fd2-4eac-4df4-93be-185589e15833";
  }

  int getInt(QueryDocumentSnapshot doc, String field) {
    return doc.data().toString().contains(field) ? doc.get(field) : 0;
  }

  double getDouble(QueryDocumentSnapshot doc, String field) {
    return doc.data().toString().contains(field) ? doc.get(field) : 0.0;
  }

  // user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
    return UserData(
      uid: data['uid'],
      name: data['name'],
      email: data['email'],
      type: data['type'],
    );
  }

  // claim data from snapshots
  List<Claim?> _claimDataFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Claim(
        claim_id: doc.reference.id,
        uid: getString(doc, "uid"),
        status: getString(doc, "status"),
        timestamp: getInt(doc, "timestamp"),
        claim_name: getString(doc, "claim_name"),
        crop_type: getString(doc, "crop_type"),
        reason: getString(doc, "reason"),
        description: getString(doc, "description"),
        agrarian_division: getString(doc, "agrarian_division"),
        province: getString(doc, "province"),
        damage_date: getString(doc, "damage_date"),
        damage_area: getString(doc, "damage_area"),
        estimate: getString(doc, "estimate"),
        claim_image_urls: doc['claim_image_urls'] ?? [],
        claim_video_url: getString(doc, "claim_video_url"),
        claim_location: LatLng(
            doc['claim_location'].latitude, doc['claim_location'].longitude),
        comment: getString(doc, "comment"),
        approved_by: getString(doc, "approved_by"),
      );
    }).toList();
  }

  // officer data from snapshots
  List<Officer?> _officerDataFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Officer(
          uid: getString(doc, "uid"),
          phone_no: getString(doc, "phone_no"),
          name: getString(doc, "name"),
          email: getString(doc, "email"),
          type: getString(doc, "type"),
          agrarian_division: getString(doc, "agrarian_division"),
          province: getString(doc, "province"),
          nic: getString(doc, "nic"),
          address: getString(doc, "address"),
          profile_url: getProfileUrl(doc, "profile_url"));
    }).toList();
  }

  // get user doc stream
  Stream<UserData> get userData {
    print("search user");
    return user_collection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  Future updateUserData(var user_data) async {
    bool isSuccess = false;
    await user_collection
        .doc(uid)
        .set(user_data, SetOptions(merge: true))
        .then((value) {
      print("User Added/Updated");
      isSuccess = true;
    })
        // ignore: invalid_return_type_for_catch_error
        .catchError((error) => print("Failed to add user: $error"));
    return isSuccess;
  }

  Future updateOfficerData(String officer_uid, var user_data) async {
    bool isSuccess = false;
    await user_collection
        .doc(officer_uid)
        .set(user_data, SetOptions(merge: true))
        .then((value) {
      print("Officer Updated");
      isSuccess = true;
    })
        // ignore: invalid_return_type_for_catch_error
        .catchError((error) => print("Failed to update officer: $error"));
    return isSuccess;
  }

  Future<Farmer?> getFarmerData(String? select_uid) async {
    Farmer? user;
    await user_collection
        .doc(select_uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        user = Farmer(
            uid: data['uid'] ?? "",
            phone_no: data['phone_no'] ?? "",
            name: data['name'] ?? "",
            email: data['email'] ?? "",
            type: data['type'] ?? "",
            agrarian_division: data['agrarian_division'] ?? "",
            nic: data['nic'] ?? "",
            address: data['address'] ?? "",
            province: data['province'] ?? "",
            bank: data['bank'] ?? "",
            account_name: data['account_name'] ?? "",
            account_no: data['account_no'] ?? "",
            branch: data['branch'] ?? "",
            profile_url: data['profile_url'] ?? "");
      } else {
        print('User does not exist on the database');
      }
    });

    return user;
  }

  Future<Officer?> getOfficerData(String? select_uid) async {
    Officer? user;
    await user_collection
        .doc(select_uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        user = Officer(
            uid: data['uid'] ?? "",
            phone_no: data['phone_no'] ?? "",
            name: data['name'] ?? "",
            email: data['email'] ?? "",
            type: data['type'] ?? "",
            agrarian_division: data['agrarian_division'] ?? "",
            nic: data['nic'] ?? "",
            address: data['address'] ?? "",
            province: data['province'] ?? "",
            profile_url: data['profile_url'] ?? "");
      } else {
        print('User does not exist on the database');
      }
    });

    return user;
  }

  Future addClaimData(var claim_data) async {
    bool isSuccess = false;
    await claim_collection.add(claim_data).then((value) {
      print("Claim Added");
      print(claim_data);
      isSuccess = true;
      // ignore: invalid_return_type_for_catch_error
    }).catchError((error) => print("Failed to claim data - " + error));
    return isSuccess;
  }

  Future updateClaimData(String claim_id, var claim_data) async {
    bool isSuccess = false;
    await claim_collection
        .doc(claim_id)
        .set(claim_data, SetOptions(merge: true))
        .then((value) {
      print("Claim Updated");
      isSuccess = true;
    })
        // ignore: invalid_return_type_for_catch_error
        .catchError((error) => print("Failed to updaet claim: $error"));
    return isSuccess;
  }

  Future uploadFileToFirebase(
      String root, String referName, XFile? imageFile) async {
    String downloadURL = "";
    String fileName = referName +
        DateTime.now().millisecondsSinceEpoch.toString() +
        extension(imageFile!.path);
    String refer = '$root/$uid/$fileName';
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref(refer)
          .putFile(File(imageFile.path));
      downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref(refer)
          .getDownloadURL();
      return downloadURL;
    } catch (error) {
      print(error.toString());
      return downloadURL;
    }
  }

  Stream<List<Claim?>> farmerClaimList(String? select_claim_state) {
    return claim_collection
        .orderBy('timestamp', descending: true)
        .where('uid', isEqualTo: select_uid)
        .where('status', isEqualTo: select_claim_state)
        .snapshots()
        .map(_claimDataFromSnapshot);
  }

  Future<int> farmerClaimCount(String? select_claim_state) async {
    var respectsQuery = FirebaseFirestore.instance
        .collection('claim')
        .where('uid', isEqualTo: select_uid)
        .where('status', isEqualTo: select_claim_state);
    var querySnapshot = await respectsQuery.get();
    var totalEquals = querySnapshot.docs.length;
    // print(totalEquals);
    return totalEquals;
  }

  Stream<List<Claim?>> officerClaimList(
      String? select_claim_state, String? select_agrarian_division) {
    return claim_collection
        .orderBy('timestamp', descending: true)
        .where('status', isEqualTo: select_claim_state)
        .where('agrarian_division', isEqualTo: select_agrarian_division)
        .snapshots()
        .map(_claimDataFromSnapshot);
  }

  Future<List<Claim?>> similerClaimList(
      String claim_id, double latitude, double longitude) async {
    List<Claim?> claims = [];

    // ~1 mile of lat and lon in degrees
    double distance = 1.0;
    double lat = 0.0144927536231884;
    double lon = 0.0181818181818182;

    double latitude_min = latitude - (lat * distance);
    double longitude_min = longitude - (lon * distance);

    double latitude_max = latitude + (lat * distance);
    double longitude_max = longitude + (lon * distance);

    print(latitude_min.toString() +
        ":" +
        longitude_min.toString() +
        " - " +
        latitude_max.toString() +
        ":" +
        longitude_max.toString());

    await claim_collection
        // .orderBy('timestamp', descending: true)
        .where('claim_location',
            isGreaterThan: GeoPoint(latitude_min, longitude_min))
        .where('claim_location',
            isLessThan: GeoPoint(latitude_max, longitude_max))
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc.reference.id != claim_id) {
          claims.add(Claim(
            claim_id: doc.reference.id,
            uid: getString(doc, "uid"),
            status: getString(doc, "status"),
            timestamp: getInt(doc, "timestamp"),
            claim_name: getString(doc, "claim_name"),
            crop_type: getString(doc, "crop_type"),
            reason: getString(doc, "reason"),
            description: getString(doc, "description"),
            agrarian_division: getString(doc, "agrarian_division"),
            province: getString(doc, "province"),
            damage_date: getString(doc, "damage_date"),
            damage_area: getString(doc, "damage_area"),
            estimate: getString(doc, "estimate"),
            claim_image_urls: doc['claim_image_urls'] ?? [],
            claim_video_url: getString(doc, "claim_video_url"),
            claim_location: LatLng(doc['claim_location'].latitude,
                doc['claim_location'].longitude),
            comment: getString(doc, "comment"),
            approved_by: getString(doc, "approved_by"),
          ));
        }
      }
    });

    return claims;
  }

  Stream<List<Officer?>> get officerList {
    return user_collection
        .where('type', isGreaterThanOrEqualTo: "officer")
        // .where('type',arrayContainsAny: ['officer', 'officer_pending'])
        .snapshots()
        .map(_officerDataFromSnapshot);
  }
}
