import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/data/workout_data.dart';
import 'package:workout_tracker/pages/workoutpage.dart';

// ignore: must_be_immutable
class WorkoutTile extends StatelessWidget {
  String workoutName;
  
  WorkoutTile({required this.workoutName, super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer <WorkoutData>(
      builder: (context, value, child) => Card(
        color: Theme.of(context).colorScheme.primary,
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        child: Slidable(
          endActionPane: ActionPane(
            motion: StretchMotion(), 
            children: [
              SlidableAction(
                onPressed: (context){
                  value.editworkout(workoutName, context);
                },
                backgroundColor: Color(0xFF3d3d3d),
                icon: (Icons.edit),
                foregroundColor: Theme.of(context).colorScheme.surface,
              ),
              SlidableAction(
                onPressed: (context){
                  value.deleteWorkout(workoutName, context);
                },
                backgroundColor: Color(0xFFcf4742),
                icon: Icons.delete,
                foregroundColor: Theme.of(context).colorScheme.surface,
              ),
            ]
          ),
          child: ListTile(
          contentPadding: EdgeInsets.all(10),
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15), 
            child: Text(workoutName.toUpperCase(), style: Theme.of(context).textTheme.displayLarge)
          ),
          trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Workoutpage(workoutName: workoutName,)));
                  },
                  icon: Icon(Icons.arrow_forward_ios), color: Theme.of(context).colorScheme.surface,
                ), 
              ],
            ),
        )),
      )
    );
  }
}