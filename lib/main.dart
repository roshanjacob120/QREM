import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home.dart';
import 'database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'teacher.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool("is_logged_in") ?? false;
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  MyApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: isLoggedIn ? HomePage() : LoginPage(),
    );
  }
}


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String _email="";
  String _password="";
  final auth=FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body:Stack(

        children:[
          Positioned(
            bottom: 590,
            left: 130,
            child: Image(
              image: AssetImage("asset/images/download (1).png"),
              height:150,
              width: 150,
            ),
          ),

     SafeArea(
        child:Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[

               Text('Q R E M',
                 style: GoogleFonts.sulphurPoint(
                   fontWeight: FontWeight.bold,
                   fontSize: 52,
                 ),
               ),

              Text('go fast go easy',
                style: GoogleFonts.habibi(
                  color:Colors.black,
                  fontStyle: FontStyle.italic ,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),

        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(

                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.black)),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your email';
                    }
                    if (!value!.endsWith('@mbcet.ac.in')) {
                      return 'Only @mbcet.ac.in emails are allowed';
                    }
                    return null;
                  },
                  onSaved: (value) => _email = value ?? '',
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Password'),
                  validator: (value) {
                    if (value?.isEmpty?? true) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onSaved: (value) => _password = value?? '',
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[900],
                      minimumSize: Size(10, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text('Login'),
                    onPressed: () async{
                      if (_formKey.currentState?.validate() == true) {
                        _formKey.currentState?.save();
                        try{
                          final FirebaseFirestore firestore = FirebaseFirestore.instance;
                          final CollectionReference staffCollection = firestore.collection('Staff');
                          final DocumentSnapshot staffSnapshot = await staffCollection.doc(_email).get();
                          if (staffSnapshot.exists) {
                            final String password = staffSnapshot.get('Password');
                           if(password==_password)
                            {
                              String teacherEmail =
                                  _email; // Replace with the teacher's email retrieved from Firebase Firestore
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString("teacher_email", teacherEmail);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TeacherRequestsScreen()),
                              );
                            }
                          } else {
                            final newuser=await auth.signInWithEmailAndPassword(email: _email, password: _password);
                            if(newuser!=null)
                            {
                              final SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.setBool("is_logged_in", true);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => HomePage()),
                              );
                            }
                          }
                        }
                        catch(e){
                          print(e);
                        }
                      }
                    },
                  ),
                ),
                TextButton(
                  child: Text('Register new user'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegistrationPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        ]
      ),
      ),
      ),
       ],
     ),
    );
  }
}