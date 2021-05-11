import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prep4exam/services/auth.dart';

class Quizdatabase{
  
  AuthServices authServices = new AuthServices();
  String useremail;
  String marks;

//Create Quiz
    Future<void> addQuizData(Map quizData, String quizId) async {
    await Firestore.instance
        .collection("Quiz")
        .document(quizId)
        .setData(quizData)
        .catchError((e) {
     
    });
  }

//Quiz Questions 
  Future<void> addQuestionData(Map questionData, String quizId) async {
    await Firestore.instance
        .collection("Quiz")
        .document(quizId)
        .collection("QNA")
        .add(questionData)
        .catchError((e) {
     
    });
  }

//Quiz Start Flag 
  Future<void> startQuiz(String quizId) async {
    await Firestore.instance
        .collection("Quiz")
        .document(quizId)
        .updateData({"flag": true}).catchError((e) {
     
    });
  }

//Add Quiz Marks for Particular ID In JoinQuiz Collection
  Future<void> quizMarks(String quizId, String marks) async {
    await Firestore.instance
        .collection("JoinQuiz")
        .document(quizId)
        .updateData({"score": marks}).catchError((e) {
     
    });
  }

//Get Marks
  Future getquizMarks(String quizId) async {
    try {
      await authServices.getcurrentuser().then((val) {
        useremail = val;
      });
      await Firestore.instance
          .collection("JoinQuiz")
          .where('email', isEqualTo: useremail)
          .where('quizId', isEqualTo: quizId)
          .getDocuments()
          .then((value) {
        value.documents.forEach((documentSnapshot) {
          marks = documentSnapshot["score"].toString();
        });
      });

      if (marks != null) {
        return marks;
      } else {
        return "0";
      }
    } catch (e) {
      return "0";
    }
  }

//Get Joined Quiz IDs
  Future<List> getQuizezData() async {
    authServices.getcurrentuser().then((val) {
      useremail = val;
    });
  
    QuerySnapshot questionSnapshot =
        await Firestore.instance.collection("JoinQuiz").getDocuments();
    var list = [];

    for (int i = 0; i < questionSnapshot.documents.length; i++) {
 
      if (questionSnapshot.documents[i].data["email"] == useremail) {
        list.add(questionSnapshot.documents[i].data["quizId"].toString());
      }
    }

    return list;
  }

//Get Score and Marks For Result For Quiz
  Future<List> getScore(String quizId) async {
    List<Map<String, String>> listOfColumns = [];
    QuerySnapshot questionSnapshot =
        await Firestore.instance.collection("JoinQuiz").getDocuments();
    for (int i = 0; i < questionSnapshot.documents.length; i++) {
      if (questionSnapshot.documents[i].data["quizId"] == quizId) {
        listOfColumns.add({
          "Email": questionSnapshot.documents[i].data["email"],
          "Score": questionSnapshot.documents[i].data["score"].toString(),
        });
      }
    }

    return listOfColumns;
  }


//Fetch current Joined User
  getCurrentlyJoinedUser(String quizId) async {
    return Firestore.instance
        .collection("JoinQuiz")
        .where('quizId', isEqualTo: quizId)
        .snapshots();
  }

//Fetch quizez created By Admin
  getQuizezDataCreateBy() async {
    return Firestore.instance.collection("Quiz").snapshots();
  }

//quiz question To Quiz
  getQuizData(String quizId) async {
    return await Firestore.instance
        .collection("Quiz")
        .document(quizId)
        .collection("QNA")
        .getDocuments();
  }

//Fetch Quiz Data by Id
  Future<Map<String, dynamic>> getQuizDataById(String quizId) async {
    String useremail = "";

    await authServices.getcurrentuser().then((value) {
      useremail = value;
    });

    Map<String, dynamic> quizData = {};

    await Firestore.instance
        .collection("JoinQuiz")
        .where('quizId', isEqualTo: quizId)
        .where('email', isEqualTo: useremail)
        .getDocuments()
        .then((value) {
      value.documents.forEach((documentSnapshot) {
        quizData = Map<String, dynamic>.from(documentSnapshot.data);
      });
    });
    return quizData;
  }

//Fetch Quiz Time
  Future gettime(String quizId) async {
    try {
      int time = 0;
      
      await Firestore.instance
          .collection("Quiz")
          .document(quizId)
          .get()
          .then((value) {
        time = value.data["timer"];
      });
      if (time != 0) {
        return time;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

//Fetch join quiz
  Future joinQuiz(Map data, String quizId) async {
    await Firestore.instance.collection("JoinQuiz").add(data).catchError((e) {
     
    });
  }
}