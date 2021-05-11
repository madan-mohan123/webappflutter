import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prep4exam/models/User.dart';
import 'package:prep4exam/helper/functions.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthServices {
  FirebaseUser loginUser;

  final GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseAuth _auth = FirebaseAuth.instance;
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null
        ? User(uid: user.uid, email: user.email, name: user.displayName)
        : null;
  }

  Future signInEmailAndPass(String email, String pass) async {
    try {
      AuthResult authResult =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      FirebaseUser firebaseUser = authResult.user;
      _userFromFirebaseUser(firebaseUser);
      if (firebaseUser.isEmailVerified) {
        return "true";
      } else if (!firebaseUser.isEmailVerified) {
        return "false";
      } else {
        return "Invalid-Email";
      }
    } catch (e) {
      return "Error";
    }
  }

  Future signUpWithEmailAndPassword(
      String email, String pass, String userName) async {
    try {
      String check = "false";
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      FirebaseUser firebaseUser = authResult.user;
      await Firestore.instance
          .collection("Profile")
          .add({"email": firebaseUser.email, "name": userName, "picUrl": ""});

      _userFromFirebaseUser(firebaseUser);
      await authResult.user.sendEmailVerification().then((value) {
        check = "true";
      }).catchError((e) {
        check = "false";
      });
      return check;
    } catch (e) {
      return "Error";
    }
  }

  Future signinWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final AuthResult authResult =
          await _auth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;
      // assert(user.email != null);
      // assert(user.displayName != null);
      // assert(!user.isAnonymous);
      // assert(await user.getIdToken() != null);
      print(user.email);
    } catch (e) {
      print(e);
    }
  }

  Future forgetpassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email).then((value) {
        return true;
      }).catchError((e) {
        return false;
      });
    } catch (e) {
      return false;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }

  Future getcurrentuser() async {
    String userEmail = "";
    try {
      final user = await _auth.currentUser();

      if (user != null) {
        loginUser = user;
        return loginUser.email;
      } else {
        await HelperFunction.getLoggedEmail().then((value) {
          userEmail = value;
        });
        return userEmail;
      }
    } catch (e) {
     
      await HelperFunction.getLoggedEmail().then((value) {
        userEmail = value;
      });
      return userEmail;
    }
  }
}
