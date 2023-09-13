import 'package:firebase_auth/firebase_auth.dart';

class Trackers {
  final String trackingnum;
  final String pickuploc;
  final String deliveryloc;
  final String pickupmon;
  final String pickupday;
  final String pickupyr;
  final String pickuptime;
  final String delmon;
  final String delday;
  final String delyr;
  final String deltime;
  final String id;
  final String status;

  Trackers(
      {this.id = "",
      this.trackingnum = "",
      this.pickuploc = "",
      this.deliveryloc = "",
      this.pickupmon = "",
      this.pickupday = "",
      this.pickupyr = "",
      this.pickuptime = "",
      this.delmon = "",
      this.delday = "",
      this.delyr = "",
      this.deltime = "",
      this.status = ""});
}

class Users {
  final String id;
  final String firsname;
  final String lastname;
  final String email;
  final String phone;

  Users(
      {this.id = "",
      this.firsname = "",
      this.lastname = "",
      this.email = "",
      this.phone = ""});
}
