import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prep4exam/services/auth.dart';

class PollDatabase {
 
  String useremail;
  
  AuthServices authServices = new AuthServices();
  Future createPoll(Map polldata, String pollId) async {
    await Firestore.instance
        .collection("pollcreate")
        .document(pollId)
        .setData(polldata)
        .catchError((e) {
     
    });
  }

  // get poll data
  getPollData() async {
    return Firestore.instance.collection("pollcreate").snapshots();
  }

  getPollJoinList() async {
    authServices.getcurrentuser().then((val) {
      useremail = val;
    });
    QuerySnapshot questionSnapshot =
        await Firestore.instance.collection("JoinPoll").getDocuments();
    var list = [];

    for (int i = 0; i < questionSnapshot.documents.length; i++) {
      if (questionSnapshot.documents[i].data["email"] == useremail) {
        list.add(questionSnapshot.documents[i].data["pollId"]);
      }
    }

    return list;
  }

  Future<List> getpollvoting(String pollId) async {
    List<int> pollvoting = [];
    int total = 0;
    int voting = 0;
    QuerySnapshot questionSnapshot =
        await Firestore.instance.collection("JoinPoll").getDocuments();
    for (int i = 0; i < questionSnapshot.documents.length; i++) {
      if (questionSnapshot.documents[i].data["pollId"] == pollId) {
        total++;
        if (questionSnapshot.documents[i].data["voting"] != "") {
          voting++;
        }
      }
    }
    pollvoting.add(total);
    pollvoting.add(voting);
 

    return pollvoting;
  }

  getpollResult(String pollId) async {
    return Firestore.instance.collection("JoinPoll").snapshots();
  }
}