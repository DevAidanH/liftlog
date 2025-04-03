import 'package:flutter/material.dart';
import 'package:workout_tracker/data/hive_database.dart';
import 'package:workout_tracker/datetime/datetime.dart';
import 'package:workout_tracker/models/exercise.dart';

import '../models/workout.dart';

class WorkoutData extends ChangeNotifier {

  final db = HiveDatabase();

  //Default workout list
  List<Workout> workoutList = [
    Workout(
      name: "Upper Body", 
      exercises: [
        Exercise(
          name: "Bench Press", 
          weight: "85", 
          reps: "5", 
          sets: "3"
        ),
      ],
    ),
    Workout(
      name: "Lower Body", 
      exercises: [
        Exercise(
          name: "Squat", 
          weight: "95", 
          reps: "5", 
          sets: "3"
        ),
      ],
    )
  ];

  //If there is a HIVE box get data otherwise use default list
  void initalizeWorkoutList(){
    if(db.previousDataExists()){
      workoutList = db.readFromDatabase();
      String lastLogin = db.getLastLogin();
      if(lastLogin != todaysDateYYYYMMDD()){
        lastLogin = todaysDateYYYYMMDD();
        db.updateLastLogin(lastLogin);
        for(int i=0; i<workoutList.length; i++){
          for(int j=0; j<workoutList[i].exercises.length; j++){
            workoutList[i].exercises[j].isCompleted = false;
          }
        }
        db.saveToDatabase(workoutList);
      }
    }
    else{
      db.saveToDatabase(workoutList);
    }

    loadHeatMap();
  }

  //Get Workouts
  List<Workout> getWorkoutList(){
    return workoutList;
  }

  //Get length of workout
  int numberOfExerciseInWorkout(String workoutName){
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    return relevantWorkout.exercises.length;
  }

  // Add workout
  void addWorkout (String name){
    workoutList.add(Workout(name: name, exercises: []));

    notifyListeners();

    //Save to db
    db.saveToDatabase(workoutList);
  }

  //Delete workout
  void deleteWorkout (String name, context){
    Workout relevantWorkout = getRelevantWorkout(name);
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text("Are you sure you want to delete this workout?"),
        actions: [
          MaterialButton(
            onPressed: (){
              workoutList.remove(relevantWorkout);
              notifyListeners();
              db.saveToDatabase(workoutList);
              loadHeatMap();
              Navigator.pop(context);
            },
            child: Text("Delete"),
          ),
          MaterialButton(
            onPressed: (){Navigator.pop(context);},
            child: Text("Cancel"),
          )
        ],
      )
    );
  }

  void editworkout (String name, context){
    //Working in progress
    final editWorkoutNameController = TextEditingController(text: name);
    Workout relevantWorkout = getRelevantWorkout(name);

    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text("Edit Workout"),
        content: TextField(
          controller: editWorkoutNameController,
        ),
        actions: [
          MaterialButton(
            onPressed: (){
                  relevantWorkout.name = editWorkoutNameController.text;
                  notifyListeners();
                  db.saveToDatabase(workoutList);
                  loadHeatMap();
                  Navigator.pop(context);
            }, 
            child: Text("Save changes")
          ),
          MaterialButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            child: Text("Cancel"),
          )
        ],
        )
    );
  }

  // Add exercise to workout
  void addExercise(String workoutName, String exerciseName, String weight, String reps, String sets){
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    relevantWorkout.exercises.add(Exercise(name: exerciseName, weight: weight, reps: reps, sets: sets));

    notifyListeners();

    //save to database
    db.saveToDatabase(workoutList);
  }

  //Delete exercise
  void deleteExercise(String workoutName, String exerciseName, context){
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text("Are you sure you want to delete this exercise?"),
        actions: [
          MaterialButton(
            onPressed: (){
              relevantWorkout.exercises.remove(relevantExercise);
              notifyListeners();
              db.saveToDatabase(workoutList);
              loadHeatMap();
              Navigator.pop(context);
            },
            child: Text("Delete"),
          ),
          MaterialButton(
            onPressed: (){Navigator.pop(context);},
            child: Text("Cancel"),
          )
        ],
      )
    );
  }

  void editExercise(String workoutName, String exerciseName, context){
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);

      final exerciseNameController = TextEditingController(text: relevantExercise.name);
      final weightNameController = TextEditingController(text: relevantExercise.weight);
      final repsNameController = TextEditingController(text: relevantExercise.reps);
      final setsNameController = TextEditingController(text: relevantExercise.sets);

      showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: Text("Edit exercise"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: exerciseNameController,),
              TextField(controller: weightNameController,),
              TextField(controller: repsNameController,),
              TextField(controller: setsNameController,),
            ],
          ),
          actions: [
            MaterialButton(
              onPressed: (){
                relevantExercise.name = exerciseNameController.text;
                relevantExercise.weight = weightNameController.text;
                relevantExercise.reps = repsNameController.text;
                relevantExercise.sets = setsNameController.text;
                relevantExercise.isCompleted = false;
                
                notifyListeners();
                db.saveToDatabase(workoutList);
                loadHeatMap();
                Navigator.pop(context);
              },
              child: Text("Save changes"),
            ),
            MaterialButton(onPressed: (){Navigator.pop(context);},
              child: Text("Cancel"),
            )
          ],
        )
      );
  }

  //Update exercise list when reordered
  void updateWhenReorderedExerciseList(String workoutName, List<Exercise> excerises){
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    relevantWorkout.exercises = excerises;
    notifyListeners();
    db.saveToDatabase(workoutList);
  }

  //Check off exercise
  void checkOffExercise(String workoutName, String exerciseName){
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);

    relevantExercise.isCompleted = !relevantExercise.isCompleted;

    notifyListeners();

    //save to database
    db.saveToDatabase(workoutList);
    loadHeatMap();
  }

  //Returns relevant workout 
  Workout getRelevantWorkout(String workoutName){
    Workout relevantWorkout = workoutList.firstWhere((workout) => workout.name == workoutName);

    return relevantWorkout;
  }

  //Returns relevant exercise
  Exercise getRelevantExercise(String workoutName, String exerciseName){
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    Exercise relevantExercise = relevantWorkout.exercises.firstWhere((exercise) => exercise.name == exerciseName);

    return relevantExercise;
  }

  //Get start date
  String getStartDate(){
    return db.getStartDate();
  }

  //Heatmap dataset
  Map<DateTime, int> heatMapDataSet = {};

  //Load heatmap
  void loadHeatMap(){
    DateTime startDate = createDateTimeObject(getStartDate());

    int daysInBetween = DateTime.now().difference(startDate).inDays;

    //Get completed status
    for (int i = 0; i<daysInBetween+1; i++){
      String yyyymmdd = convertDateTimeToYYYYMMDD(startDate.add(Duration(days:i)));

      int completionStatus = db.getCompletionStatus(yyyymmdd);

      int year = startDate.add(Duration(days: i)).year;
      int month = startDate.add(Duration(days: i)).month;
      int day = startDate.add(Duration(days: i)).day;

      final percentForDay = <DateTime, int>{
        DateTime(year, month, day) : completionStatus
      };

      heatMapDataSet.addEntries(percentForDay.entries);
    }
  }

}