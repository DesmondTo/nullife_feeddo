import 'package:nullife_feeddo/models/goal_model.dart';
import 'package:nullife_feeddo/providers/goal_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nullife_feeddo/screens/home_screen.dart';
import 'package:nullife_feeddo/widgets/goal/time_textForm_widget.dart';
import 'package:provider/provider.dart';

class GoalEditingScreen extends StatefulWidget {
  final List<String>? categoryList;
  final Goal? goal;

  const GoalEditingScreen({
    Key? key,
    this.categoryList,
    this.goal,
  }) : super(key: key);

  @override
  _GoalEditingScreenState createState() => _GoalEditingScreenState();
}

class _GoalEditingScreenState extends State<GoalEditingScreen> {
  final _formKey = GlobalKey<FormState>();
  final categoryController = TextEditingController();
  final hourController = TextEditingController();
  final minuteController = TextEditingController();
  late String? dropDownValue;
  late List<String> dropDownList;
  late DateTime createdTime;

  @override
  void initState() {
    super.initState();

    if (widget.goal == null) {
      createdTime = DateTime.now();
      hourController.text = '2';
      minuteController.text = '0';
      dropDownValue = 'Choose a category';
      dropDownList = widget.categoryList!;
      dropDownList.add(dropDownValue!);
    } else {
      final goal = widget.goal!;
      categoryController.text = goal.category;
      hourController.text = goal.hour.toString();
      minuteController.text = goal.minute.toString();
      dropDownValue = goal.category;
      if (widget.categoryList!.isEmpty) {
        dropDownList = <String>[dropDownValue!];
      } else {
        widget.categoryList!.add(dropDownValue!);
        dropDownList = widget.categoryList!;
      }
    }
  }

  @override
  void dispose() {
    categoryController.dispose();
    hourController.dispose();
    minuteController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        actions: buildEditingActions(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildDropDownButton(),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Hour',
                    ),
                  ),
                  Expanded(
                    child: TimeTextFormWidget(
                      timeController: hourController,
                      unit: 'Hour',
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Minute',
                    ),
                  ),
                  Expanded(
                    child: TimeTextFormWidget(
                      timeController: minuteController,
                      unit: 'Minute',
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  DropdownButton<String> buildDropDownButton() => DropdownButton<String>(
        value: dropDownValue,
        disabledHint: Text('Please add a category in category page'),
        icon: const Icon(Icons.arrow_downward),
        iconSize: 24,
        elevation: 16,
        style: const TextStyle(color: Colors.deepPurple),
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        onChanged: (String? newValue) {
          setState(() {
            dropDownValue = newValue!;
          });
        },
        items: dropDownList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      );

  List<Widget> buildEditingActions() => [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          onPressed: saveForm,
          icon: Icon(
            Icons.done,
          ),
          label: Text(
            'SAVE',
          ),
        ),
      ];

  Future saveForm() async {
    final isValid = _formKey.currentState!.validate() &&
        dropDownValue != 'No existing category';

    if (isValid) {
      final goal = Goal(
        userId: widget.goal?.userId ?? FirebaseAuth.instance.currentUser!.uid,
        createdTime: widget.goal?.createdTime ?? DateTime.now(),
        category: dropDownValue!,
        id: widget.goal?.id ?? DateTime.now().toString(),
        hour: int.parse(hourController.text),
        minute: int.parse(minuteController.text),
      );

      final isEditing = widget.goal != null;
      final provider = Provider.of<GoalProvider>(
        context,
        listen: false,
      );
      if (isEditing) {
        provider.editGoal(goal, widget.goal!);
      } else {
        provider.addGoal(goal);
      }
      Navigator.pop(context);
    }
  }
}
