import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {

    var stream = FirebaseFirestore.instance
        .collection("users")
        .doc('user1')
        .get();

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin'),
      ),
      body: FutureBuilder(
        future: stream,
    builder: (context, snapshot) {
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (context, index) {

        var obj = snapshot.data[index];
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Card(
                  child: Column(
                    children: [
                      Image.network(obj["image"]),
                      SizedBox(
                        height: 10,
                      ),
                      Text(obj["report"],
                        style: TextStyle(
                          fontSize: 18,
                        ),),

                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        );
      },
    );

  })
    );
}}
