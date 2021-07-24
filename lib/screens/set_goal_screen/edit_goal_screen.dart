import 'package:google_fonts/google_fonts.dart';
import 'package:nullife_feeddo/models/goal_model.dart';
import 'package:nullife_feeddo/providers/goal_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nullife_feeddo/widgets/goal/time_textForm_widget.dart';
import 'package:nullife_feeddo/widgets/login/login_widget.dart';
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
  bool allAdded = false;

  @override
  void initState() {
    super.initState();
    if (widget.categoryList!.isEmpty) allAdded = true;
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
        backgroundColor: Color.fromRGBO(190, 204, 168, 1),
        actions: allAdded ? null : buildEditingActions(),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              FittedBox(
                fit: BoxFit.contain,
                child: Padding(
                  padding: EdgeInsets.all(2),
                  child: Text(
                    "SELECT A CATEGORY",
                    style: GoogleFonts.boogaloo(
                      fontSize: 25,
                      color: Color.fromRGBO(134, 147, 114, 1),
                    ),
                  ),
                ),
              ),
              allAdded ? buildAddCategoryButton() : buildDropDownButton(),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Hour",
                      style: GoogleFonts.boogaloo(
                        fontSize: 28,
                        color: Color.fromRGBO(115, 126, 96, 1),
                      ),
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
                      style: GoogleFonts.boogaloo(
                        fontSize: 28,
                        color: Color.fromRGBO(115, 126, 96, 1),
                      ),
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

  ElevatedButton buildAddCategoryButton() => ElevatedButton.icon(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          side: BorderSide(
            color: Colors.white,
            width: 3,
          ),
        ),
        icon: CircleAvatar(
          radius: 15,
          backgroundColor: Color.fromRGBO(190, 204, 168, 1),
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        label: Text(
          'Add a category from category list!',
          style: GoogleFonts.boogaloo(
            fontSize: 20,
            color: Color.fromRGBO(134, 147, 114, 1),
          ),
        ),
      );

  DropdownButton<String> buildDropDownButton() => DropdownButton<String>(
        value: dropDownValue,
        disabledHint: Text('Please add a category in category page'),
        icon: CircleAvatar(
            radius: 15,
            backgroundColor: Color.fromRGBO(190, 204, 168, 1),
            child: Icon(
              Icons.arrow_downward,
              color: Colors.white,
            )),
        iconSize: 24,
        elevation: 16,
        style: GoogleFonts.boogaloo(
          fontSize: 20,
          color: Color.fromRGBO(134, 147, 114, 1),
        ),
        underline: Container(
          height: 3,
          color: Color.fromRGBO(190, 204, 168, 1),
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
    final isValid = _formKey.currentState!.validate();

    if (int.parse(hourController.text) * 60 +
            int.parse(minuteController.text) ==
        0) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text('Don\'t be lazy, make it longer!'),
          backgroundColor: Theme.of(context).hintColor,
          duration: Duration(
            seconds: 2,
          ),
        ));
      return;
    }

    if (dropDownValue == 'Add a category') {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text('Add a category from the category page first!'),
          backgroundColor: Theme.of(context).hintColor,
          duration: Duration(
            seconds: 2,
          ),
        ));
      return;
    }

    if (dropDownValue == 'Choose a category') {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text('Choose a category from the list please!'),
          backgroundColor: Theme.of(context).hintColor,
          duration: Duration(
            seconds: 2,
          ),
        ));
      return;
    }

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
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LogInWidget()));
    }
  }
}
