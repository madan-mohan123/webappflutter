// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io' as io;
// import 'package:firebase_storage/firebase_storage.dart';
// // import 'package:path/path.dart' as Path;
// import 'package:prep4exam/services/profile.dart';
// import 'package:image_picker_web/image_picker_web.dart';
// import 'package:prep4exam/views/Breakpoints.dart';
// // import 'dart:html' as html;

// class Profile extends StatefulWidget {
//   final String userEmail;
//   Profile({this.userEmail});
//   @override
//   _ProfileState createState() => _ProfileState();
// }

// class _ProfileState extends State<Profile> {
//   String imgUrl = "";
//   String editname = "";
//   Map<String, String> profdata = {};
//   Uint8List uploadedImage;
//   String imgselected;
//   final picker = ImagePicker();
//   html.File selimg;
//   io.File iopic;
//   ProfileDatabase databaseService = new ProfileDatabase();

//   Future getImage() async {
//     html.File fromPicker =
//         await ImagePickerWeb.getImage(outputType: ImageType.file);

//     if (fromPicker != null) {
//       final reader = html.FileReader();
//       reader.readAsDataUrl(fromPicker);
//       reader.onLoad.first.then((value) {
//         final encoded = reader.result as String;
//         final imageBase64 =
//             encoded.replaceFirst(RegExp(r'data:image[^;]+;base64,'), '');
//         iopic = io.File.fromRawPath(base64Decode(imageBase64));
//       });
//       setState(() {
//         selimg = fromPicker;
//       });
//     }
//     print('------------');
//   }

//   @override
//   void initState() {
//     databaseService.getProfile().then((value) {
//       setState(() {
//         profdata = value;
//         editname = profdata["name"];
//         imgUrl = profdata["picUrl"];
//       });
//     });
//     super.initState();
//   }

//   Future uploadImageToFirebase(BuildContext context) async {
//     String currentDate = DateTime.now().toString();
//     print('===========');
//     String fileName = currentDate;
//     StorageReference firebaseStorageRef =
//         FirebaseStorage.instance.ref().child('Profile/$fileName');
    
//     StorageUploadTask uploadTask = firebaseStorageRef.putFile(iopic);
//     print('===========ppppppppp');

//     StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
//     taskSnapshot.ref.getDownloadURL().then((value) => {
//           setState(() {
//             print('===========');
//             imgUrl = value.toString();
//           }),
//         });
//   }

//   String nameUpdate = "";

//   _showDialog() async {
//     AlertDialog alert = new AlertDialog(
//       contentPadding: const EdgeInsets.all(16.0),
//       content: Stack(children: [
//         Container(
//             child: SingleChildScrollView(
//                 scrollDirection: Axis.vertical,
//                 child: Column(
//                   children: <Widget>[
//                     new TextField(
//                       autofocus: true,
//                       decoration: new InputDecoration(
//                           labelText: 'Enter Name', hintText: 'eg. xxxxx'),
//                       onChanged: (val) {
//                         if (val != "") {
//                           setState(() {
//                             nameUpdate = val;
//                           });
//                         }
//                       },
//                     ),
//                     SizedBox(
//                       height: 10.0,
//                     ),
//                   ],
//                 )))
//       ]),
//       actions: <Widget>[
//         new ElevatedButton(
//             child: const Text('CANCEL'),
//             onPressed: () {
//               Navigator.pop(context);
//             }),
//         new ElevatedButton(
//             child: const Text('Ok'),
//             onPressed: () async {
//               setState(() {
//                 editname = nameUpdate;
//               });
//               Navigator.pop(context);
//             })
//       ],
//     );
//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     try {
//       return Scaffold(
//           backgroundColor: Colors.white,
//           appBar: AppBar(
//             title: Text("Profile"),
//             backgroundColor: Colors.blueAccent,
//             elevation: 0.0,
//             brightness: Brightness.light,
//           ),
//           body: Center(
//               child: Container(
//                   alignment: Alignment.topLeft,
//                   width: ResponsiveWidget.isLargeScreen(context) ||
//                           ResponsiveWidget.isMediumScreen(context)
//                       ? 800
//                       : null,
//                   child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Container(
//                             color: Colors.deepPurple,
//                             child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                     width: 120,
//                                     height: 120,
//                                     margin: EdgeInsets.fromLTRB(20, 20, 0, 20),
//                                     child: ClipOval(
//                                       child: CachedNetworkImage(
//                                         imageUrl: (imgUrl == "")
//                                             ? 'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png'
//                                             : imgUrl,
//                                         fit: BoxFit.fill,
//                                         width: 50.0,
//                                         height: 50.0,
//                                       ),
//                                     ),
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       border: Border.all(
//                                           color: const Color(0x33A6A6A6)),
//                                     ),
//                                   ),
//                                   Container(
//                                       alignment: Alignment.topRight,
//                                       child: GestureDetector(
//                                         onTap: () {
//                                           getImage();
//                                         },
//                                         child: Container(
//                                             alignment: Alignment.topRight,
//                                             width: 40,
//                                             height: 40,
//                                             margin: EdgeInsets.fromLTRB(
//                                                 0, 20, 20, 20),
//                                             decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               shape: BoxShape.circle,
//                                               border: Border.all(
//                                                   color:
//                                                       const Color(0x33A6A6A6)),
//                                               // image: DecorationImage(
//                                               //     image: false
//                                               //         // ? FileImage(_image)
//                                               //         ? AssetImage(
//                                               //             "assets/images/profile.png")
//                                               //         : AssetImage(
//                                               //             "assets/images/profile.png"), // picked file
//                                               //     fit: BoxFit.fill)),
//                                             )),
//                                       )),
//                                 ])),
//                         Container(
//                           margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
//                           child: Text("Account Information",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.blue,
//                                   fontSize: 20)),
//                         ),
//                         Divider(height: 5),
//                         Row(children: [
//                           Expanded(
//                             child: Container(
//                                 margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
//                                 child: RichText(
//                                     text: TextSpan(
//                                         style: TextStyle(fontSize: 15),
//                                         children: <TextSpan>[
//                                       TextSpan(
//                                           text: 'Name : ',
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.w500,
//                                               color: Colors.black54)),
//                                       TextSpan(
//                                           text: editname,
//                                           style: TextStyle(color: Colors.grey)),
//                                     ]))),
//                           ),
//                           IconButton(
//                               icon: Icon(Icons.edit),
//                               onPressed: () async {
//                                 _showDialog();
//                                 //  showAlertDialog(context);
//                               }),
//                         ]),
//                         Container(
//                             margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
//                             child: RichText(
//                                 text: TextSpan(
//                                     style: TextStyle(fontSize: 15),
//                                     children: <TextSpan>[
//                                   TextSpan(
//                                       text: 'Email : ',
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.w500,
//                                           color: Colors.black54)),
//                                   TextSpan(
//                                       text: profdata["email"],
//                                       style: TextStyle(color: Colors.grey)),
//                                 ]))),
//                         Expanded(
//                           child: Container(),
//                         ),
//                         Container(
//                             margin: EdgeInsets.all(20),
//                             child: ElevatedButton(
//                                 child: Text("Save"),
//                                 onPressed: () async {
//                                   if (true) {
//                                     await uploadImageToFirebase(context);
//                                   }
//                                   databaseService.updateProfile(
//                                       widget.userEmail, imgUrl, editname);
//                                   showAlertDialog(context);
//                                 }))
//                       ]))));
//     } catch (e) {
//       return Scaffold(
//           body: Center(
//               child: Container(
//         child: CircularProgressIndicator(),
//       )));
//     }
//   }

//   showAlertDialog(BuildContext context) async {
//     Widget continueButton = FlatButton(
//       child: Text("Ok"),
//       onPressed: () {
//         Navigator.of(context).pop();
//       },
//     );
//     // set up the AlertDialog
//     AlertDialog alert = AlertDialog(
//       title:
//           Text("Thanks", style: TextStyle(fontSize: 20.0, color: Colors.red)),
//       content: Icon(Icons.assignment_turned_in_outlined,
//           color: Colors.green, size: 60),
//       actions: [
//         continueButton,
//       ],
//     );
//     // show the dialog
//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }
// }
