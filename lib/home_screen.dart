// ignore_for_file: unused_local_variable

import 'package:audioplayers/audioplayers.dart';
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
                  onPress: () async {
                    await player.play(DeviceFileSource('audio/delicious.mp3'));
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

  Column counter_and_button({
    required VoidCallback onPress,
    required String buttonText,
  }) {
    return Column(
      children: [
        StreamBuilder(
            stream: null, //TODO: change stream
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text("");
              } else {
                return Text("0");
              }
            }),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            onPress;
          },
          child: Text(
            buttonText,
          ),
        ),
      ],
    );
  }
}
