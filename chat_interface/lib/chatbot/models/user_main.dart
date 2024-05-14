import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:qx_credit_reboot/utils/fetch_user.dart';

class UserModel {
  String uid;
  String? name;
  String? mail;
  String? wapp;
  String? img;
  String userNotificationToken;
  int todayTokens;
  Timestamp? firstPurchase;
  bool userBlocked;
  String userBlockedText;
  bool isDeleted;

  UserModel({
    this.uid='',
    this.name = 'redr0b0t',
    this.mail = '',
    this.wapp = '',
    this.img = '',
    this.userNotificationToken='',
    this.todayTokens = 0,
    this.firstPurchase ,
    this.userBlocked=false,
    this.userBlockedText="",
    this.isDeleted=false,
  });

  // factory UserModel.fromFirestore(DocumentSnapshot data) {
  //   Map<String,dynamic> mapData=data.data() as Map<String, dynamic>;
  //   return UserModel(
  //     uid:mapData['uid']??fUser!.uid,
  //     name: mapData['name'] ?? fUser!.displayName,
  //     mail: mapData['mail'] ?? fUser!.email,
  //     wapp: mapData['wapp'] ?? fUser!.phoneNumber,
  //     img: mapData['img'] ?? fUser!.photoURL,
  //     userNotificationToken: mapData['userNotificationToken']??'',
  //     todayTokens: mapData['todayTokens'] ?? 0,
  //     firstPurchase: mapData['firstPurchase'] ??
  //         Timestamp.fromDate(DateTime.parse("2000-01-07")),
  //     userBlocked: mapData['userBlocked']??false,
  //     userBlockedText: mapData['userBlockedText']??"Suspicious activity detected with your account.\nPlease contact support for clarification.",
  //     isDeleted: mapData['isDeleted']??false,
    
  //   );
  // }

  Map<String, dynamic> getMap() {
    return {
      'uid':uid,
      'name': name,
      'mail': mail,
      'wapp': wapp,
      'img': img,
      'userNotificationToken':userNotificationToken,
      'todayTokens': todayTokens,
      'firstPurchase': firstPurchase,
      'userBlocked':userBlocked,
      'userBlockedText':userBlockedText,
      'isDeleted':isDeleted,
    };
  }

  Map<String, dynamic> getBasicMap() {
    return {
      'uid':uid,
      'name': name,
      'mail': mail,
      'wapp': wapp,
      'img': img,
    };
  }
}