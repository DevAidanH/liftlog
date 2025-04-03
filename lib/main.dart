import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/data/workout_data.dart';
import 'package:workout_tracker/pages/login.dart';
import 'package:workout_tracker/themes/themes.dart';

void main() async {
  //Init HIve - local storage
  await Hive.initFlutter();
  
  //Open hive box
  await Hive.openBox("workout_database3");


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context) => WorkoutData(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Workout Tracker",
      theme: lightmode,
      home: login(),
    ),);
  }
}
