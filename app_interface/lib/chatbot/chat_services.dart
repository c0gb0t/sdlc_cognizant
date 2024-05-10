import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mhs_pred_app/chatbot/models/user_main.dart';
import 'package:mhs_pred_app/main.dart';
import './models/complaint_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

var _db = FirebaseFirestore.instance;
FirebaseStorage _storage = FirebaseStorage.instance;


Future<String> uploadAudioFile(String audioFilePath) async{

  File audioFile;
  if(audioFilePath.contains('http')) {
    audioFile = await DefaultCacheManager().getSingleFile(audioFilePath);
  }
  else {

    audioFile=File(audioFilePath);
  }
    //Create a reference to the location you want to upload to in firebase
    Reference reference = _storage.ref().child("fms_cognizant/audioFiles/${audioFilePath.split('/').last}.wav");

    //Upload the file to firebase
    UploadTask uploadTask = reference.putData(audioFile.readAsBytesSync() as Uint8List);

    // Waits till the file is uploaded then stores the download url
    String audioURL= await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
    print("upoalded file url=$audioURL");

    //returns the download url
    return audioURL;
  }


Stream<List<ComplaintModel>> streamComplaints(UserModel? user) {
  var ref = _db.collection(coll_name).doc(user?.uid).collection('pComplaints').orderBy('id',descending: true).limit(1);
  // int len=await ref.snapshots().length;
  // debugPrint(len);
  return ref.snapshots().map((list) => list.docs.map((doc) {
        debugPrint(doc.data().toString());
        return ComplaintModel.fromFirestore(
          doc,
        );
      }).toList());
//   return const Stream.empty();
}

Future<String> sendComplaint(UserModel user,{required String lang,String complaintText='', String audioURL='',String rType="1"}) async {
  ComplaintModel complaint = ComplaintModel(timestamp: Timestamp.now());
  complaint.id = Timestamp.now().millisecondsSinceEpoch.toString();
  complaint.senderId =
      rType == '0' ? "backend@red" : "${user.name?.split(' ')[0]}@red";
  // complaint.rType = rType;
  complaint.timestamp = Timestamp.now();
  complaint.lang=lang;
  complaint.complaintText = complaintText;
  complaint.audioURL= audioURL;

  _db
      .collection(coll_name)
      .doc(user.uid)
      .collection('rComplaints')
      .doc('complaint')
      .set(complaint.getMap());
  return complaint.id;


  // ----------------------from python api----------------
  //
  // final queryParameters = {
  //   'input': context,
  //   'instruction': txt,
  // };
  // print("-----------generating uri--------------");
  // final uri = Uri.http('127.0.0.1:5000', '/predict', queryParameters);
  // print("-----------calling api------------------");
  // final response = await http.get(
  //   uri,
  // );
  // print("-----------api call succesfull------------------");
  //
  //
  // txt = jsonDecode(response.body)['output'];
  //
  // // txt='chatbot respone.......';
  // complaint = ComplaintModel(timestamp: Timestamp.now());
  // complaint.senderId = 'chatbot' + "@red";
  // complaint.rType = rType;
  // complaint.timestamp = Timestamp.now();
  // complaint.complaint = txt;
  //
  // _db
  //     .collection(coll_name)
  //     .doc(user.uid)
  //     .collection('allcomplaints')
  //     .doc(complaint.timestamp.millisecondsSinceEpoch.toString())
  //     .set(complaint.getMap());
}
