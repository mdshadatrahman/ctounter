// ignore_for_file: unused_local_variable

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctounter/operations/firebase_crud.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseCrud firebaseCrud = FirebaseCrud();
  int initCount = 0;

  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
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
                counter_and_button(
                  stream: FirebaseFirestore.instance
                      .collection('shakti_counter')
                      .snapshots(),
                  onPress: () async {
                    // await player.play(DeviceFileSource('audio/delicious.mp3'));
                    firebaseCrud.shaktiCounter();
                  },
                  buttonText: "Shakti Counter",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> getDataLength() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('').get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    final dataLenght = allData.length;
    print(allData);
    return dataLenght.toString();
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
              return Text("${getDataLength()}");
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
}
