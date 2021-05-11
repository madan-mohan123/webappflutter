import 'package:flutter/material.dart';
import 'package:prep4exam/helper/functions.dart';
import 'package:prep4exam/services/profile.dart';
import 'package:prep4exam/views/Breakpoints.dart';
import 'package:prep4exam/views/Homepage.dart';
import 'package:prep4exam/views/authentication/signin.dart';
import 'package:prep4exam/widgets/widgets.dart';
import 'package:prep4exam/services/auth.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  AuthServices authServices = new AuthServices();
  ProfileDatabase databaseService = new ProfileDatabase();
  String useremail = "";
  Map<String, String> profileData = {};
  bool _isloading = false;
  @override
  void initState() {
    authServices.getcurrentuser().then((value) {
      setState(() {
        useremail = value;
      });
    });

    databaseService.getProfile().then((value) {
      setState(() {
        profileData = value;
        _isloading = true;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return _isloading ? Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: appBar(context),
            backgroundColor: Colors.blueAccent,
            elevation: 0.0,
            brightness: Brightness.light,
          ),
          drawer: Drawer(
            child: Container(
              color: Colors.blueGrey[800],
              child: ListView(
                children: [
                  Container(
                    color: Colors.blue[800],
                    child: UserAccountsDrawerHeader(
                      accountName: Text(profileData["name"]),
                      accountEmail: Text(profileData["email"]),
                      currentAccountPicture: CircleAvatar(
                        backgroundColor: Colors.indigo[800],
                        child: Text(
                          useremail.substring(0, 1).toUpperCase(),
                          style: TextStyle(fontSize: 40.0),
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    height: 2.0,
                  ),
                  ListTile(
                    title: Text(
                      "Exam Portal",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    leading: Icon(Icons.save, color: Colors.deepOrange),
                    onTap: () {
                      Navigator.pushNamed(context, '/Exam');
                    },
                  ),
                  ListTile(
                    title: Text(
                      "Quizzez",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    leading: Icon(Icons.style_sharp, color: Colors.green),
                    onTap: () {
                      Navigator.pushNamed(context, '/Quiz');
                    },
                  ),
                  ListTile(
                    title: Text(
                      "Polls",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    leading: Icon(Icons.schedule_outlined, color: Colors.green),
                    onTap: () {
                      Navigator.pushNamed(context, '/Poll');
                    },
                  ),
                  ListTile(
                    title: Text(
                      "Forms",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    leading: Icon(Icons.stacked_line_chart_sharp,
                        color: Colors.green),
                    onTap: () {
                      Navigator.pushNamed(context, '/Form');
                    },
                  ),
                  ListTile(
                    title: Text(
                      "Go To Home",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    leading: Icon(Icons.bolt, color: Colors.red),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage(
                                    loggedIn: true,
                                  )));
                    },
                  ),
                  ListTile(
                    title: Text(
                      "LogOut",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    leading:
                        Icon(Icons.login_sharp, color: Colors.orangeAccent),
                    onTap: () async {
                      HelperFunction.clearStorage();
                      await authServices.signOut();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Signin()));
                    },
                  ),
                ],
              ),
            ),
          ),
          body: Center(
            child: Container(
              width: ResponsiveWidget.isLargeScreen(context) ||
                      ResponsiveWidget.isMediumScreen(context)
                  ? 800
                  : null,
              padding: new EdgeInsets.all(0.0),
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: ResponsiveWidget.isLargeScreen(context) ||
                            ResponsiveWidget.isMediumScreen(context)
                        ? 2
                        : 1,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                    childAspectRatio: 2),
                scrollDirection: Axis.vertical,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/Quiz');
                    },
                    child: Container(
                      height: 50.00,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Colors.cyan[600],
                        elevation: 10,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const ListTile(
                                leading: Icon(Icons.style_sharp,
                                    size: 60, color: Colors.orangeAccent),
                                title: Text('Quizzes',
                                    style: TextStyle(
                                        fontSize: 30.0, color: Colors.white)),
                                subtitle: Text('Create Quizzes',
                                    style: TextStyle(fontSize: 18.0)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/Poll');
                    },
                    child: Container(
                      height: 10.00,
                      child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Colors.yellow[800],
                          elevation: 10,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const ListTile(
                                  leading: Icon(Icons.school_outlined,
                                      size: 60, color: Colors.green),
                                  title: Text('Polls',
                                      style: TextStyle(
                                          fontSize: 30.0, color: Colors.white)),
                                  subtitle: Text('Create Polls',
                                      style: TextStyle(fontSize: 18.0)),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/Form');
                    },
                    child: Container(
                      height: 170.00,
                      child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Colors.deepOrange[700],
                          elevation: 10,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const ListTile(
                                  leading: Icon(Icons.stacked_line_chart_sharp,
                                      size: 60, color: Colors.blue),
                                  title: Text('Forms',
                                      style: TextStyle(
                                          fontSize: 30.0, color: Colors.white)),
                                  subtitle: Text('Create Your Froms',
                                      style: TextStyle(fontSize: 18.0)),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/Exam');
                      },
                      child: Container(
                        height: 170.00,
                        child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.blue[700],
                            elevation: 10,
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const ListTile(
                                    leading: Icon(Icons.eco, size: 60),
                                    title: Text('Exam Portal',
                                        style: TextStyle(
                                            fontSize: 30.0,
                                            color: Colors.white)),
                                    subtitle: Text('Work With Team',
                                        style: TextStyle(fontSize: 18.0)),
                                  ),
                                ],
                              ),
                            )),
                      )),
                ],
              ),
            ),
          )): Scaffold(
            body:Container(child:Center(child:CircularProgressIndicator(backgroundColor: Colors.amber,)))
          );
    } 
    catch (e) {
      return Scaffold(
          body: Center(
              child: Container(
        child: CircularProgressIndicator(backgroundColor: Colors.red,),
      )));
    }
  }
}
