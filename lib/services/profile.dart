import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prep4exam/services/auth.dart';

class ProfileDatabase {
 
    String useremail;
    String marks;
    AuthServices authServices = new AuthServices();

  Future updateProfile(String email, String imgUrl, String name) async {
    await Firestore.instance
        .collection("Profile")
        .where("email", isEqualTo: email)
        .getDocuments()
        .then((value) {
      value.documents.forEach((documentSnapshot) {
        documentSnapshot.reference.updateData({"picUrl": imgUrl, "name": name});
      });
    });
  }

  Future<Map<String, String>> getProfile() async {
    String email = "";
    await authServices.getcurrentuser().then((value) {
      email = value;
    });


    Map<String, String> data = {};
    await Firestore.instance
        .collection("Profile")
        .where("email", isEqualTo: email)
        .getDocuments()
        .then((value) {
      value.documents.forEach((documentSnapshot) {
        data = Map<String, String>.from(documentSnapshot.data);
      });
    });

    return data;
  }
}
