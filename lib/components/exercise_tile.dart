import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/data/workout_data.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ExerciseTile extends StatelessWidget {
  final String exerciseName;
  final String weight;
  final String reps;
  final String sets;
  final bool isCompleted;
  final void Function(bool?)? onCheckboxChanged;
  final String workoutContainingExerciseName;

  const ExerciseTile({
    super.key, 
    required this.exerciseName, 
    required this.weight, 
    required this.reps, 
    required this.sets, 
    required this.isCompleted,
    required this. onCheckboxChanged,
    required this.workoutContainingExerciseName
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: isCompleted ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary,
            ),
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Slidable(
              endActionPane: ActionPane(
                motion: StretchMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context){
                      value.editExercise(workoutContainingExerciseName, exerciseName, context);
                    },
                    icon: Icons.edit,
                    backgroundColor: Color(0xFF3d3d3d),
                    foregroundColor: Theme.of(context).colorScheme.surface
                  ),
                  SlidableAction(
                    onPressed: (context){
                      value.deleteExercise(workoutContainingExerciseName, exerciseName, context);
                    },
                    icon: Icons.delete,
                    backgroundColor: Color(0xFFcf4742),
                    foregroundColor: Theme.of(context).colorScheme.surface,
                  )
                ]
              ),
              child: ListTile(
              onTap: () => onCheckboxChanged!(isCompleted),
              contentPadding: EdgeInsets.all(10),
              title: Text(exerciseName.toUpperCase(), style: Theme.of(context).textTheme.displayLarge),
                subtitle: Row(
                  children: [
                    Wrap( 
                      spacing: 10,
                      children: [
                        Chip(
                          label: Text("$weight kg", style: Theme.of(context).textTheme.displaySmall,), 
                          backgroundColor: Theme.of(context).colorScheme.tertiary,
                          padding: EdgeInsets.all(0),
                        ),
                        Chip(
                          label: Text("$reps reps", style: Theme.of(context).textTheme.displaySmall), 
                          backgroundColor: Theme.of(context).colorScheme.tertiary,
                          padding: EdgeInsets.all(0),
                        ),
                        Chip(
                          label: Text("$sets sets", style: Theme.of(context).textTheme.displaySmall), 
                          backgroundColor: Theme.of(context).colorScheme.tertiary,
                          padding: EdgeInsets.all(0),
                        )
                      ]
                    )
                  ],
                ),
              ),
            )
      ));
  }
}