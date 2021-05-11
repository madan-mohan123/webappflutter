import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prep4exam/services/auth.dart';

class FormDatabase{

  String useremail;
  AuthServices authServices = new AuthServices();

   Future<void> addForm(Map formData, String formId) async {
    await Firestore.instance.collection("Forms").add(formData).catchError((e) {
     
    });
  }

  getAllForms() async {
    return Firestore.instance.collection("Forms").snapshots();
  }

  Future<List> getFormIds() async {
    await authServices.getcurrentuser().then((val) {
      useremail = val;
    });

    QuerySnapshot questionSnapshot =
        await Firestore.instance.collection("FormJoin").getDocuments();
    List<String> list = [];

    for (int i = 0; i < questionSnapshot.documents.length; i++) {
      if (questionSnapshot.documents[i].data["email"] == useremail) {
        list.add(questionSnapshot.documents[i].data["formId"].toString());
      }
    }
   
    return list;
  }

  Future getForm(String formId) async {
    QuerySnapshot questionSnapshot =
        await Firestore.instance.collection("Forms").getDocuments();

    for (int i = 0; i < questionSnapshot.documents.length; i++) {
      if (questionSnapshot.documents[i].data["formId"] == formId) {
        return questionSnapshot.documents[i].data["formData"];
     
      }
    }
  }

  Future<void> saveFormResponse(Map formData, String email, String formid,
      String title, String formDesc) async {
    try {
      Map<String, dynamic> list = {};
      list.addAll(Map<String, dynamic>.from(formData));

     
      await Firestore.instance
          .collection("FormJoin")
          .where('email', isEqualTo: email)
          .where('formId', isEqualTo: formid)
          .getDocuments()
          .then((value) {
        value.documents.forEach((documentSnapshot) {
          documentSnapshot.reference.updateData(
              {"response": list, "formName": title, "formDesc": formDesc});
        });
      }).catchError((e) {
       
      });
    } catch (e) {
    
     
    }
  }

  Future<Map<String, dynamic>> getFormWithEmail(
      String formId, String email) async {
    Map<String, dynamic> map;

    QuerySnapshot questionSnapshot =
        await Firestore.instance.collection("FormJoin").getDocuments();

    for (int i = 0; i < questionSnapshot.documents.length; i++) {
      if (questionSnapshot.documents[i].data["formId"] == formId &&
          questionSnapshot.documents[i].data["email"] == email) {
        map.addAll(questionSnapshot.documents[i].data["response"]);
      }
    }
 
    return map;
  }

  Future<List<Map<String, dynamic>>> getJoinedForm(String formId) async {
    // Map<String, dynamic> map;
    List<Map<String, dynamic>> formlist = [];
    QuerySnapshot questionSnapshot =
        await Firestore.instance.collection("FormJoin").getDocuments();

    for (int i = 0; i < questionSnapshot.documents.length; i++) {
      if (questionSnapshot.documents[i].data["formId"] == formId) {
        formlist
            .add(Map<String, dynamic>.from(questionSnapshot.documents[i].data));
      }
    }

    return formlist;
  }
}