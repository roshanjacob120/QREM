import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';



class history extends StatefulWidget {
  final String teacherEmail;

  const history({required this.teacherEmail});
  @override
  _historyState createState() => _historyState();
}

class _historyState extends State<history> {
  String teacherDept = "";
  String teacherRole = "";
  String hod = "";
  String tname="";


  @override
  void initState() {
    super.initState();
    getTeacherDetails();
  }

  Future<void> getTeacherDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CollectionReference staffCollection =
    FirebaseFirestore.instance.collection('Staff');
    DocumentSnapshot staffDoc =
    await staffCollection.doc(widget.teacherEmail).get();
    if (staffDoc.exists) {
      print(widget.teacherEmail);
      Map<String, dynamic> data = staffDoc.data() as Map<String, dynamic>;
      String dept = data['Dept'];
      String role = data['Role'];
      String name=data['Name'];
      print(role);
      setState(() {
        teacherDept = dept;
        teacherRole = role;
        tname=name;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        actions: [
          IconButton(
            onPressed: () async {
              final SharedPreferences prefs =
              await SharedPreferences.getInstance();
              prefs.setBool("is_logged_in", false);
              prefs.setBool("teacher_logged_in", false);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                    (Route<dynamic> route) => false,
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Staff')
            .doc(widget.teacherEmail)
            .collection('history')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<DocumentSnapshot> requestDocs = snapshot.data?.docs ?? [];

          if (requestDocs.isEmpty) {
            return Center(
              child: Text('No requests found.'),
            );
          }
          return ListView.builder(
            itemCount: requestDocs.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> requestData =
              Map<String, dynamic>.from(requestDocs[index].data() as Map);
              String name = requestData['Name'];
              String reason = requestData['Reason'];
              String timeOut = requestData['Time'];
              String date=requestData['Date'];
              String dept = requestData['Dept'];
              String year = requestData['Year'];
              String id = requestDocs[index].id;
              String status = requestData['Status'];
              String category = requestData['Category'];
              String? advisor = requestData["Accepted by"]?.toString();
              print(advisor);
              return Card(
                margin: EdgeInsets.all(8.0),
                child: Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.sulphurPoint(
                            fontSize: 20.0, fontWeight: FontWeight.w900),
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Reason: $reason',
                            style: GoogleFonts.sulphurPoint(
                                fontSize: 18.0, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            'Time Out: $timeOut',
                            style: GoogleFonts.sulphurPoint(
                                fontSize: 18.0, fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Dept: $dept',
                            style: GoogleFonts.sulphurPoint(
                                fontSize: 18.0, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            'Year of Study: $year',
                            style: GoogleFonts.sulphurPoint(
                                fontSize: 18.0, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Category: $category',
                            style: GoogleFonts.sulphurPoint(
                                fontSize: 18.0, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            'Status: $status',
                            style: GoogleFonts.sulphurPoint(
                                fontSize: 18.0, fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
