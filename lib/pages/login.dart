import 'package:flutter/material.dart';
import 'package:workout_tracker/pages/homepage.dart';

class login extends StatelessWidget {
  const login({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 150),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Center(
              child: Image.asset("lib/Images/logoCut.png"),
            )
          ),
          Padding(padding: EdgeInsets.all(10), child: Text("LiftLog", style: Theme.of(context).textTheme.titleMedium,)),
          MaterialButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage()));
            },
            child: Container(
              color: Theme.of(context).colorScheme.primary,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Text("Get Started", style: Theme.of(context).textTheme.displayLarge,)
            )
          )
        ],
      ),
    );
  }
}