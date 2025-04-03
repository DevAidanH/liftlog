import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/components/heatmap.dart';
import 'package:workout_tracker/components/workout_tile.dart';
import 'package:workout_tracker/data/workout_data.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  @override
  void initState(){
    super.initState();

    Provider.of<WorkoutData>(context, listen: false).initalizeWorkoutList();
  }

  //Text controller to access user inputted text
  final newWorkoutNameController = TextEditingController();

  //Create new workout
  void createNewWorkout(){
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text("Create New Workout"),
        backgroundColor: Theme.of(context).colorScheme.surface,
        content: TextField( 
          controller: newWorkoutNameController,
          decoration: InputDecoration(border: UnderlineInputBorder(), labelText: "Enter workout name here..."),
        ),
        actions: [
          //Save button
          MaterialButton(
            onPressed: save, 
            child: Text("Save")
          ),
          //Cancel button
          MaterialButton(
            onPressed: cancel, 
            child: Text("Cancel"),
          )
        ],
        )
    );
  }

  //Save workout
  void save(){
    String newWorkoutName =newWorkoutNameController.text;
    Provider.of<WorkoutData>(context, listen: false).addWorkout(newWorkoutName);

    Navigator.pop(context);
    clear();
  }

  //Cancel workout
  void cancel(){
    Navigator.pop(context);
    clear();
  }

  //Clear controller
  void clear(){
    newWorkoutNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: createNewWorkout,
        shape: LinearBorder(),
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.surface),
      ),
      body: ListView(
        children: [
          //Heatmap
          myHeatmap(datasets: value.heatMapDataSet),

          //Workouts  
          ListView.builder(
            shrinkWrap: true, 
            padding: EdgeInsets.all(30),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: value.getWorkoutList().length,
            itemBuilder: (context, index) => WorkoutTile(workoutName: value.getWorkoutList()[index].name)
          ),
        ],
      )
    )
    );
  }
}