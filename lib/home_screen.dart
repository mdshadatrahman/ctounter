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
  int shakti_counter = 0;
  int ruti_counter = 0;
  int riseup_counter = 0;
  String date = formatDate(DateTime.now(), [dd, mm, yyyy]);
  Future getShaktiCounterData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('all_counters')
        .doc(date)
        .collection('shakti_counter')
        .get();
    final counter = querySnapshot.docs.map((doc) => doc.data()).toList();
    setState(() {
      shakti_counter = counter.length;
    });
  }

  Future getRutiCounterData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('all_counters')
        .doc(date)
        .collection('ruti_counter')
        .get();
    final counter = querySnapshot.docs.map((doc) => doc.data()).toList();
    setState(() {
      ruti_counter = counter.length;
    });
  }

  Future getRiseUpCounterData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('all_counters')
        .doc(date)
        .collection('riseup_counter')
        .get();
    final counter = querySnapshot.docs.map((doc) => doc.data()).toList();
    setState(() {
      riseup_counter = counter.length;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getShaktiCounterData();
    getRutiCounterData();
    getRiseUpCounterData();
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Counters(
                  date: date,
                  firebaseCrud: firebaseCrud,
                  buttonColor: Colors.red,
                  buttonTextColor: Colors.white,
                  collectionName: 'shakti_counter',
                  counter: shakti_counter,
                  counterButtonText: 'Shakti Counter',
                  counterTextColor: Colors.black,
                ),
                Counters(
                  date: date,
                  firebaseCrud: firebaseCrud,
                  buttonColor: Colors.green,
                  buttonTextColor: Colors.white,
                  collectionName: 'ruti_counter',
                  counter: ruti_counter,
                  counterButtonText: 'Ruti Counter',
                  counterTextColor: Colors.black,
                ),
                Counters(
                  date: date,
                  firebaseCrud: firebaseCrud,
                  buttonColor: Colors.blue,
                  buttonTextColor: Colors.white,
                  collectionName: 'riseup_counter',
                  counter: riseup_counter,
                  counterButtonText: 'Riseup Counter',
                  counterTextColor: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Counters extends StatefulWidget {
  const Counters({
    Key? key,
    required this.date,
    required this.firebaseCrud,
    required this.buttonColor,
    required this.buttonTextColor,
    required this.collectionName,
    required this.counter,
    required this.counterButtonText,
    required this.counterTextColor,
  }) : super(key: key);

  final String date;
  final FirebaseCrud firebaseCrud;
  final String collectionName;
  final int counter;
  final String counterButtonText;
  final Color buttonColor;
  final Color buttonTextColor;
  final Color counterTextColor;

  @override
  State<Counters> createState() => _CountersState();
}

class _CountersState extends State<Counters> {
  final player = AudioCache();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('all_counters')
                  .doc(widget.date)
                  .collection(widget.collectionName)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return AutoSizeText(
                    "${widget.counter}",
                    maxLines: 1,
                    style: TextStyle(
                      color: widget.counterTextColor,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return AutoSizeText(
                    "Please Wait",
                    maxLines: 1,
                    style: TextStyle(
                      color: widget.buttonTextColor,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                } else {
                  return AutoSizeText(
                    "Something Wrong",
                    maxLines: 1,
                    style: TextStyle(
                      color: widget.buttonTextColor,
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
                widget.firebaseCrud.shaktiCounter(widget.collectionName);
                await player.play("ting.mp3");
              },
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: widget.buttonColor,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      spreadRadius: 5,
                      color: Color.fromARGB(255, 211, 211, 211),
                      offset: Offset(5, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: AutoSizeText(
                    widget.counterButtonText,
                    maxLines: 1,
                    style: TextStyle(
                      color: widget.buttonTextColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
