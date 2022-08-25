// ignore_for_file: unused_local_variable

import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctounter/operations/firebase_crud.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseCrud firebaseCrud = FirebaseCrud();
  int initCount = 0;
  String date = formatDate(DateTime.now(), [dd, mm, yyyy]);
  final player = AudioPlayer();

  Future getDataLength() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('all_counters')
        .doc(date)
        .collection('shakti_counter')
        .get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    setState(() {
      initCount = allData.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    getDataLength();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: SizedBox(
            height: height,
            width: width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Counters(
                  date: date,
                  initCount: initCount,
                  firebaseCrud: firebaseCrud,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Counters extends StatelessWidget {
  const Counters({
    Key? key,
    required this.date,
    required this.initCount,
    required this.firebaseCrud,
  }) : super(key: key);

  final String date;
  final int initCount;
  final FirebaseCrud firebaseCrud;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('all_counters')
              .doc(date)
              .collection('shakti_counter')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return AutoSizeText(
                "${initCount}",
                maxLines: 1,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return AutoSizeText(
                "Please Wait",
                maxLines: 1,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              );
            } else {
              return AutoSizeText(
                "Something Wrong",
                maxLines: 1,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              );
            }
          },
        ),
        SizedBox(height: 10),
        GestureDetector(
          onTap: () async {
            firebaseCrud.shaktiCounter();
          },
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.red,
            ),
            child: Center(
              child: AutoSizeText(
                "Shakti Counter",
                maxLines: 1,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}


/**
 * 
 * Future getDataLength() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('shakti_counter').get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    setState(() {
      initCount = allData.length;
    });
  }

  Column counter_and_button({
    required VoidCallback onPress,
    required String buttonText,
    required Stream stream,
  }) {
    Stream collectionStream =
        FirebaseFirestore.instance.collection('shakti_counter').snapshots();
    return Column(
      children: [
        StreamBuilder(
          stream: collectionStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text("${initCount}");
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Please Wait");
            } else {
              return Text("0");
            }
          },
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: onPress,
          child: Text(
            buttonText,
          ),
        ),
      ],
    );
  }
 */