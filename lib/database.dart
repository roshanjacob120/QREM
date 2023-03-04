import 'package:cloud_firestore/cloud_firestore.dart';


  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData(String email) async {
    DocumentReference<Map<String, dynamic>> userDocRef = FirebaseFirestore.instance
        .collection('students')
        .doc('All')
        .collection('Data')
        .doc(email);
    return userDocRef.get();

  }

