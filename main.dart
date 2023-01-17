import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() => runApp( ProviderScope(child: MyApp()));
// ignore: prefer_function_declarations_over_variables, use_function_type_syntax_for_parameters
final tasksProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier(tasks: [
    const Task(id: 1, label: "Load rocket with supplies"),
    const Task(id: 2, label: "Launch rocket"),
    const Task(id: 3, label: "Circle the home planet"),
    const Task(id: 4, label: "Head out the first moon"),
    const Task(id: 5, label: 'Launch moon lander'),
  ]);
});

@immutable
class Task {
  final int id;
  final String label;
  final bool completed;
  const Task({required this.id, required this.label, this.completed = false});
  Task copyWith({int? id, String? label, bool? completed}) {
    return Task(
        id: id ?? this.id,
        label: label ?? this.label,
        completed: completed ?? this.completed);
  }
}

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier({tasks}) : super(tasks);
  void add(Task task) {
    state = [...state, task];
  }

  void toggle(int taskId) {
    state = [
      for (final item in state)
        if (taskId == item.id)
          item.copyWith(completed: !item.completed)
        else
          item
    ];
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exploration',
      theme: ThemeData(primarySwatch:Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Space Exploration Planner!"),
      ),
      body: Column(
        children: const [
          Progress(),
          TaskList(),
          TextField(
  decoration: InputDecoration(
    border: OutlineInputBorder(),
    hintText: 'Enter Your Name',
  ),
),
ElevatedButton(onPressed: null, child: Text("Submit"))
        ],
      ),
    );
  }
}

class Progress extends ConsumerWidget {
  const Progress({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var tasks = ref.watch(tasksProvider);
    var numCompletedTasks = tasks.where((task) {
      return task.completed == true;
    }).length;
    return Column(
      children: [
        const Text("You are this far away from exploring the whole universe",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
        LinearProgressIndicator(value: numCompletedTasks / tasks.length,color:Colors.blueGrey[800]),
      ],
    );
  }
}

class TaskList extends ConsumerWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var tasks = ref.watch(tasksProvider);
    return Column(
      children: tasks
          .map(
            (task) => TaskItem(task: task),
          )
          .toList(),
    );
  }
}

class TaskItem extends ConsumerWidget {
  final Task task;

  const TaskItem({Key? key, required this.task}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Checkbox(
            value: task.completed,
            onChanged: (newValue) =>
                ref.read(tasksProvider.notifier).toggle(task.id)),
        Text(task.label),
      ],
    );
  }
}

