import 'package:flutter/material.dart'; //[1]
import 'counter_screen.dart';

void main(List<String> args) { //[2]
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {  //[3]
 
  const MyApp({super.key}); //[4]

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //[5]
      home: CounterScreen(),
    );
  }
}
