import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prep4exam/services/auth.dart';

class ExamDatabase{

    String useremail;
  String marks;
  

  AuthServices authServices = new AuthServices();

   Future<void> addExam(Map<String, dynamic> examData) async {
    await Firestore.instance.collection("Exams").add(examData).catchError((e) {
     
    });
  }

  Future<void> joinExam(Map<String, dynamic> examData) async {
    await Firestore.instance
        .collection("ExamJoin")
        .add(examData)
        .catchError((e) {
     
    });
  }

  Future showcreatedExam() async {
    return Firestore.instance.collection("Exams").snapshots();
  }

  Future<List> getjoinexamIds() async {
    await authServices.getcurrentuser().then((val) {
      useremail = val;
    });

    QuerySnapshot questionSnapshot =
        await Firestore.instance.collection("ExamJoin").getDocuments();
    List<String> list = [];

    for (int i = 0; i < questionSnapshot.documents.length; i++) {
      if (questionSnapshot.documents[i].data["email"] == useremail) {
        list.add(questionSnapshot.documents[i].data["examId"].toString());
      }
    }

    return list;
  }

  Future<Map<String, dynamic>> takeExam(String examId) async {
    Map<String, dynamic> examdata = {};

    await Firestore.instance
        .collection("Exams")
        .where("examid", isEqualTo: examId)
        .getDocuments()
        .then((value) {
      value.documents.forEach((documentSnapshot) {
        examdata = Map<String, dynamic>.from(documentSnapshot.data);
      
      });
    });

    return examdata;
  }

  Future<Map<String, dynamic>> copyPickForCheck(
      String examId, String email) async {
    Map<String, dynamic> examdata = {};
    await Firestore.instance
        .collection("ExamJoin")
        .where("examid", isEqualTo: examId)
        .where("email", isEqualTo: email)
        .getDocuments()
        .then((value) {
      value.documents.forEach((documentSnapshot) {
        examdata = Map<String, dynamic>.from(documentSnapshot.data);
      });
    });

    return examdata;
  }

  Future examParticipants(String examId) async {
    return Firestore.instance
        .collection("ExamJoin")
        .where('examId', isEqualTo: examId)
        .snapshots();
  }

  Future<List<Map<String, dynamic>>> copyLis(String examId) async {
    List<Map<String, dynamic>> examdata = [];
    await Firestore.instance
        .collection("ExamJoin")
        .where("examId", isEqualTo: examId)
        .getDocuments()
        .then((value) {
      value.documents.forEach((documentSnapshot) {
        examdata.add(Map<String, dynamic>.from(documentSnapshot.data));
      });
    });

    return examdata;
  }

  Future editExamInfo(String examId, String examName, String examDuration,
      DateTime examDate, DateTime examStartTime) async {
    await Firestore.instance
        .collection("Exams")
        .where("examid", isEqualTo: examId)
        .getDocuments()
        .then((value) {
      value.documents.forEach((documentSnapshot) {
        documentSnapshot.reference.updateData({
          "examname": examName,
          "examDuration": examDuration,
          "examDate": examDate,
          "examstartTime": examStartTime
        });
      });
    });
  }
}