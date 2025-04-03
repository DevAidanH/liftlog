import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/components/exercise_tile.dart';
import 'package:workout_tracker/data/workout_data.dart';
import 'package:workout_tracker/models/exercise.dart';

class Workoutpage extends StatefulWidget {
  final String workoutName;
  const Workoutpage({super.key, required this.workoutName});

  @override
  State<Workoutpage> createState() => _WorkoutpageState();
}

class _WorkoutpageState extends State<Workoutpage> {
  //Checkbox change for completed workout
  void onCheckBoxChange(String workoutName, String exerciseName){
    Provider.of<WorkoutData>(context, listen: false).checkOffExercise(workoutName, exerciseName);
  }

  //Text controllers
  final exerciseNameController = TextEditingController();
  final weightNameController = TextEditingController();
  final repsNameController = TextEditingController();
  final setsNameController = TextEditingController();

  void save(){
    String newExerciseName = exerciseNameController.text;
    String newWeight = weightNameController.text;
    String newReps = repsNameController.text;
    String newSets = setsNameController.text;
    Provider.of<WorkoutData>(context, listen: false).addExercise(widget.workoutName, newExerciseName, newWeight, newReps, newSets);

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
    exerciseNameController.clear();
    weightNameController.clear();
    repsNameController.clear();
    setsNameController.clear();
  }

  //Adding a new exercise
  void newExercise (){
    showDialog(context: context, builder: (context) => SingleChildScrollView(
      child: AlertDialog(
        title: Text("Add new exercise"),
        backgroundColor: Theme.of(context).colorScheme.surface,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //Name
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: TextField(
                controller: exerciseNameController, 
                decoration: InputDecoration(border: UnderlineInputBorder(), labelText: "Enter the exercise name here..."),
              ),
            ),
            //Weight
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: TextField(
                controller: weightNameController,
                decoration: InputDecoration(border: UnderlineInputBorder(), labelText: "Enter the weight here..."),
              ),
            ),
            //Reps
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: TextField(
                controller: repsNameController,
                decoration: InputDecoration(border: UnderlineInputBorder(), labelText: "Enter how many reps here..."),
              ),
            ),
            //Sets
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: TextField(
                controller: setsNameController,
                decoration: InputDecoration(border: UnderlineInputBorder(), labelText: "Enter how many sets here..."),
              ),
            )
          ],
        ),
        actions: [
          //Save button
          MaterialButton(onPressed: save, child: Text("Save")),
          //Cancel button
          MaterialButton(onPressed: cancel, child: Text("Cancel"))
        ],
      ),
    ));
  }

  void updateList(int oldIndex, int newIndex){
    setState(() {
      if(oldIndex < newIndex){
        newIndex--;
      }

      List<Exercise> exerciseList = Provider.of<WorkoutData>(context, listen: false).getRelevantWorkout(widget.workoutName).exercises;

      final tile = exerciseList.removeAt(oldIndex);

      exerciseList.insert(newIndex, tile);

      Provider.of<WorkoutData>(context, listen: false).updateWhenReorderedExerciseList(widget.workoutName, exerciseList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(builder: (context, value, child) => Scaffold(
      appBar: AppBar(
        title: Text(widget.workoutName.toUpperCase(), style: Theme.of(context).textTheme.titleLarge,),
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => newExercise(),
        shape: LinearBorder(),
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.surface),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
        child: ReorderableListView.builder(
            onReorder: (oldIndex, newIndex) => updateList(oldIndex, newIndex),
            itemCount: value.numberOfExerciseInWorkout(widget.workoutName),
            itemBuilder: (context, index) => ExerciseTile(
              key:Key("$index"),
              exerciseName: value.getRelevantWorkout(widget.workoutName).exercises[index].name, 
              weight: value.getRelevantWorkout(widget.workoutName).exercises[index].weight, 
              reps: value.getRelevantWorkout(widget.workoutName).exercises[index].reps, 
              sets: value.getRelevantWorkout(widget.workoutName).exercises[index].sets, 
              isCompleted: value.getRelevantWorkout(widget.workoutName).exercises[index].isCompleted,
              onCheckboxChanged: (val) => onCheckBoxChange(widget.workoutName, value.getRelevantWorkout(widget.workoutName).exercises[index].name),
              workoutContainingExerciseName: widget.workoutName
            ),
            
            ),
      )
    )
    );
  }
}