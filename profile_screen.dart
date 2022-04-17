// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:myapp/GamePage.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

int count = 0;
int count1 = 0;
int tries = 0;

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    String alphas = "abcdefghijklmnopqrstuvwxyz";
    List<Widget> myRowChildren = [];
    List<List<int>> numbers = [];
    List<int> columnNumbers = [];

    int z = 0;
    for (int i = 0; i <= 9; i++) {
      int maxColNr = 10;
      for (int y = 0; y <= maxColNr; y++) {
        int currentNumber = z + y;
        columnNumbers.add(currentNumber);
      }
      z += maxColNr;
      numbers.add(columnNumbers);
      columnNumbers = [];
    }

    myRowChildren = numbers
        .map(
          (columns) => Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: columns.map((nr) {
              int min = 0;
              int max = alphas.length;
              Random rnd = Random();
              int randomNumber = min + rnd.nextInt(max - min);
              return AnswerBox(randomNumber, "a");
            }).toList(),
          ),
        )
        .toList();

    return Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text("Whats The first Letter Of English Alphabet"),
      SizedBox(
        height: 25,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: myRowChildren,
      ),
    ]));
  }
}

class AnswerBox extends StatefulWidget {
  final int num;
  final String ans;
  bool _isPressed = true;
  AnswerBox(@required this.num, @required this.ans);
  @override
  _AnswerBoxState createState() => _AnswerBoxState();
}

class _AnswerBoxState extends State<AnswerBox> {
  @override
  Widget build(BuildContext context) {
    var disp = "abcdefghijklmnopqrstuvwxyz"[widget.num];
    if (disp == widget.ans) {
      count++;
      count1++;
    }
    return RawMaterialButton(
      onPressed: isAns,
      child: Text('$disp'),
    );
  }

  void isAns() {
    tries++;

    print(count);
    var disp = "abcdefghijklmnopqrstuvwxyz"[widget.num];
    if (disp == widget.ans) {
      if (widget._isPressed) {
        print("Correct num pressed ");
        count--;
        widget._isPressed = false;
        if (count == 0) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => GamePage()));
        }
      } else {
        print("Cant press same number again");
      }
    } else {
      print("Incorrect ans pressed");
    }
    if (tries > count1 + 5) {
//      tries = 0;
      tries = 0;
      count = 0;
      count1 = 0;

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ProfileScreen()));
    }
    if (count == 0) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => GamePage()));
    }
  }
}
