import 'package:nullife_feeddo/widgets/category_widget/category_button.dart';
import 'package:nullife_feeddo/widgets/category_widget/category_header.dart';
import 'package:flutter/material.dart';
import 'package:nullife_feeddo/constants.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          heightFactor: 1.2,
          child: Column(
            children: [
              CategoryHeader(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.55,
                child: GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  children: <Widget>[
                    CategoryButton(
                      category: 'Study',
                      buttonColor: studyColor,
                    ),
                    CategoryButton(
                      category: 'Self Care',
                      buttonColor: selfCareColor,
                    ),
                    CategoryButton(
                      category: 'Sports',
                      buttonColor: sportColor,
                    ),
                    CategoryButton(
                      category: 'Family Time',
                      buttonColor: familyTimeColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
