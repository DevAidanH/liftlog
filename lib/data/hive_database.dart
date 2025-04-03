import 'package:workout_tracker/datetime/datetime.dart';
import 'package:workout_tracker/models/exercise.dart';
import 'package:workout_tracker/models/workout.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDatabase {
  //Ref hive box
  final _myBox = Hive.box("workout_database3");

  //Check if data stored
  bool previousDataExists(){
    if(_myBox.isEmpty){
      _myBox.put("START_DATE", todaysDateYYYYMMDD());
      _myBox.put("LAST_LOGIN", todaysDateYYYYMMDD());
      return false;
    }
    else{
      return true;
    }
  }

  //Return start date
  String getStartDate(){
    return _myBox.get("START_DATE");
  }

  //Return last login
  String getLastLogin(){
    return _myBox.get("LAST_LOGIN");
  }

  //Update last login
  void updateLastLogin(lastLogin){
    _myBox.put("LAST_LOGIN", lastLogin);
  }

  //Write data
  void saveToDatabase(List<Workout> workouts){
    //Convert objects into strings to store
    final workoutList = convertObjectToWorkoutLi(workouts);
    final exerciseList = convertObjectToExerciseList(workouts);

    //Check if any exercises are set to completed
    //Will put 0 or 1 for each date a workout is completed 
    if (exerciseCompleted(workouts) > 0){
      _myBox.put("COMPLETION_STATUS_${todaysDateYYYYMMDD()}", exerciseCompleted(workouts));
    }
    else{
      _myBox.put("COMPLETION_STATUS_${todaysDateYYYYMMDD()}", 0);
    }

    //Save into hive
    _myBox.put("WORKOUTS", workoutList);
    _myBox.put("EXERCISES", exerciseList);
  }

  //Read data
  List<Workout> readFromDatabase(){
    List<Workout> mySavedWorkouts = [];

    List<String> workoutNames = _myBox.get("WORKOUTS");
    final exerciseDetails = _myBox.get("EXERCISES");

    for (int i=0; i<workoutNames.length; i++){
      List<Exercise> exerciesInEachWorkout = [];

      for(int j =0; j<exerciseDetails[i].length; j++){
        exerciesInEachWorkout.add(
          Exercise(
            name: exerciseDetails[i][j][0], 
            weight: exerciseDetails[i][j][1], 
            reps: exerciseDetails[i][j][2], 
            sets: exerciseDetails[i][j][3],
            isCompleted: exerciseDetails[i][j][4] == "true" ? true : false,
          )
        );
      }
      Workout workout = Workout(name: workoutNames[i], exercises: exerciesInEachWorkout);

      mySavedWorkouts.add(workout);
    }

    return mySavedWorkouts;
  }

  //Check exercises done
  int exerciseCompleted(List<Workout> workouts){
    var c = 0;
    for (var workout in workouts){
      for (var exercise in workout.exercises){
        if (exercise.isCompleted){
          c++;
        }
      }
    }
    return c;
  }

  //Return completed status of given date
  int getCompletionStatus(String yyyymmdd){
    int completionStatus = _myBox.get("COMPLETION_STATUS_$yyyymmdd") ?? 0;
    return completionStatus;
  }

  //Convert workouts objects into lists
  List<String> convertObjectToWorkoutLi(List<Workout> workouts) {
    List<String> workoutList = [];

    for(int i = 0; i < workouts.length; i++){
      workoutList.add(workouts[i].name);
    }

    return workoutList;
  }
  //Convert exercies objects into lists 
List<List<List<String>>> convertObjectToExerciseList(List<Workout> workouts){
      List<List<List<String>>> exerciseList = [];

      for(int i = 0; i < workouts.length; i++){
        List<Exercise> exercisesInWorkout = workouts[i].exercises;

        List<List<String>> individualWorkout = [];

        for(int j = 0; j < exercisesInWorkout.length; j++){
          List<String> individualExercise =[];
          individualExercise.addAll([
              exercisesInWorkout[j].name,
              exercisesInWorkout[j].weight,
              exercisesInWorkout[j].reps,
              exercisesInWorkout[j].sets,
              exercisesInWorkout[j].isCompleted.toString()
          ]);
          individualWorkout.add(individualExercise);
        }
        exerciseList.add(individualWorkout);
      }
      return exerciseList;
    }
}