import 'package:nullife_feeddo/models/menu_item.dart';
import 'package:nullife_feeddo/models/user_profile.dart';
import 'package:nullife_feeddo/providers/todo_provider.dart';
import 'package:nullife_feeddo/widgets/category_widget/delete_category_widget.dart';
import 'package:nullife_feeddo/widgets/category_widget/edit_category_widget.dart';
import 'package:nullife_feeddo/widgets/category_widget/menu_items.dart';
import 'package:nullife_feeddo/widgets/todos_widget_folder/todo_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CategoryButton extends StatefulWidget {
  final UserProfile userProfile;
  final int index;
  final String category;
  final Color buttonColor;

  CategoryButton({
    Key? key,
    required this.userProfile,
    required this.index,
    required this.category,
    required this.buttonColor,
  }) : super(key: key);

  @override
  _CategoryButtonState createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoProvider>(context);
    double completedPercentage =
        provider.completedPercentageByCategory(widget.category);

    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TodoListWidget(
                    category: this.widget.category,
                    bgColor: widget.buttonColor,
                  ))),
      child: Container(
        padding: const EdgeInsets.only(top: 0),
        margin: const EdgeInsets.only(bottom: 6.0),
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          '${widget.category}',
                          style: GoogleFonts.boogaloo(
                            fontSize: MediaQuery.of(context).size.height * 0.03,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: PopupMenuButton<MenuItem>(
                      icon: Icon(
                        Icons.more_horiz,
                        color: Colors.white,
                      ),
                      onSelected: (MenuItem item) => onSelected(context, item),
                      itemBuilder: (BuildContext context) => [
                        ...MenuItems.categoryMenu.map(buildItem).toList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: CircularPercentIndicator(
                  backgroundColor: Colors.transparent,
                  progressColor: autoColored(widget.buttonColor),
                  radius: MediaQuery.of(context).size.height * 0.1,
                  lineWidth: 7.5,
                  percent: completedPercentage / 100,
                  center: Text(
                    'Completed\n${completedPercentage.toStringAsFixed(1)}%',
                    style: GoogleFonts.boogaloo(
                      fontSize: MediaQuery.of(context).size.height * 0.015,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: widget.buttonColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 5.0,
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<MenuItem> buildItem(MenuItem item) => PopupMenuItem<MenuItem>(
        value: item,
        child: Row(
          children: [
            Icon(
              item.icon,
              color: Colors.black,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(item.text),
          ],
        ),
      );

  void onSelected(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.itemEdit:
        showDialog(
            context: context,
            builder: (context) => EditCategoryDialog(
                  userProfile: widget.userProfile,
                  index: widget.index,
                ));
        break;
      case MenuItems.itemDelete:
        showDialog(
          context: context,
          builder: (context) => DeleteCategoryDialog(
            category: widget.category,
            index: widget.index,
            userProfile: widget.userProfile,
          ),
        );
        break;
    }
  }

  Color autoColored(Color color) {
    double darkness = 1 -
        (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
    if (darkness < 0.5825) {
      return darken(color, 0.5825 - darkness); // It's a light color
    } else {
      return lighten(color, darkness - 0.5825); // It's a dark color
    }
  }

  Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}
