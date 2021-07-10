// import 'package:feeddo/models/todo_model.dart';
// import 'package:feeddo/providers/todo_provider.dart';
// import 'package:feeddo/widgets/todos_widget_folder/todo_form_widget.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class AddTodoDialogWidget extends StatefulWidget {
//   @override
//   _AddTodoDialogWidgetState createState() => _AddTodoDialogWidgetState();
// }

// class _AddTodoDialogWidgetState extends State<AddTodoDialogWidget> {
//   final _formKey = GlobalKey<FormState>();
//   String userId = FirebaseAuth.instance.currentUser!.uid;
//   String title = '';
//   String description = '';

//   @override
//   Widget build(BuildContext context) => AlertDialog(
//         content: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Add Todo',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 22,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 TodoFormWidget(
//                   onChangedTitle: (title) => setState(() => this.title = title),
//                   onChangedDescription: (description) =>
//                       setState(() => this.description = description),
//                   onSavedTodo: addTodo,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );

//   void addTodo() {
//     final isValid = _formKey.currentState!.validate();

//     if (!isValid) {
//       return;
//     } else {
//       final todo = Todo(
//         userId: userId,
//         createdTime: DateTime.now(),
//         id: DateTime.now().toString(),
//         from: DateTime.now(), // Change this later !
//         to: DateTime.now(), // Change this later !
//         title: title,
//         description: description,
//       );

//       final provider = Provider.of<TodoProvider>(context, listen: false);
//       provider.addTodo(todo);

//       Navigator.of(context).pop();
//     }
//   }
// }
