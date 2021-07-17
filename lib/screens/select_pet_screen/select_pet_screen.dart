import 'dart:math';

import 'package:nullife_feeddo/models/pet_model.dart';
import 'package:nullife_feeddo/models/user_profile.dart';
import 'package:nullife_feeddo/providers/email_signin_provider.dart';
import 'package:nullife_feeddo/providers/userProfile_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nullife_feeddo/screens/home_screen.dart';
import 'package:provider/provider.dart';

class SelectPetScreen extends StatefulWidget {
  final UserProfile? user;

  const SelectPetScreen({
    Key? key,
    this.user,
  }) : super(key: key);

  @override
  _SelectPetScreenState createState() => _SelectPetScreenState();
}

class _SelectPetScreenState extends State<SelectPetScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.user == null) {
          FirebaseAuth.instance.currentUser!.delete();
        }
        Navigator.pop(context);
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: CloseButton(
              onPressed: () => Navigator.pop(context),
            ),
          ),
          backgroundColor: Color.fromRGBO(180, 214, 193, 1),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.1,
                  left: 0,
                ),
                child: Text(
                  "SELECT A PET",
                  style: GoogleFonts.boogaloo(
                    letterSpacing: 1.3,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    height: 1.3,
                  ),
                ),
              ),
              Expanded(
                child: widget.user == null
                    ? PageViewWidget()
                    : PageViewWidget(user: widget.user),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PageViewWidget extends StatefulWidget {
  final UserProfile? user;
  const PageViewWidget({
    Key? key,
    this.user,
  }) : super(key: key);

  @override
  _PageViewWidgetState createState() => _PageViewWidgetState();
}

class _PageViewWidgetState extends State<PageViewWidget> {
  List<Pet> _petList = Pet.generatePetList();
  late PageController pageController;
  double viewPortFraction = 0.8;
  double? pageOffSet = 0;

  final String defaultPhotoURL =
      'https://mspgh.unimelb.edu.au/__data/assets/image/0011/3576098/Placeholder.jpg';
  final List<String> defaultList = [
    'Study:0xFFFF8B9C',
    'Self Care:0xFFB5C2A1',
    'Sports:0xFFF8B593',
    'Family Time:0xFFDEC183',
  ];
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();

    pageController = PageController(
      initialPage: 0,
      viewportFraction: viewPortFraction,
    )..addListener(() {
        setState(() {
          pageOffSet = pageController.page;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    final emailSignInProvider = Provider.of<EmailSignInProvider>(context);
    final userProfileProvider = Provider.of<UserProfileProvider>(
      context,
      listen: false,
    );

    return PageView.builder(
      controller: pageController,
      itemBuilder: (context, index) {
        double scale = max(viewPortFraction,
            (1 - (pageOffSet! - index).abs()) + viewPortFraction);
        double angle = (pageOffSet! - index).abs();

        if (angle > 0.5) {
          angle = 1 - angle;
        }

        return GestureDetector(
          onTap: () {
            if (widget.user == null) {
              final newUser = UserProfile(
                  userID: currentUser.uid,
                  petID: index,
                  email: (currentUser.email ?? emailSignInProvider.userEmail)
                      .toLowerCase(),
                  userName:
                      currentUser.displayName ?? emailSignInProvider.userName,
                  userPhotoURL: currentUser.photoURL ?? defaultPhotoURL,
                  categoryFieldList: defaultList);
              userProfileProvider.addUser(newUser);
            } else {
              final newUser = UserProfile(
                  firestoreID: widget.user!.firestoreID,
                  userID: widget.user!.userID,
                  petID: index,
                  email: widget.user!.email.toLowerCase(),
                  userName: widget.user!.userName,
                  userPhotoURL: widget.user!.userPhotoURL,
                  categoryFieldList: defaultList);
              userProfileProvider.editUser(newUser, widget.user!);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            }
          },
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(
                  right: 10,
                  left: 20,
                  top: 100 - scale * 30,
                  bottom: 100,
                ),
                child: Transform(
                  transform: Matrix4.identity()
                    ..setEntry(
                      3,
                      2,
                      0.001,
                    )
                    ..rotateY(angle),
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(223, 234, 226, 1),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                width: 5.0, color: const Color(0xFFFFFFFF))),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height / 10,
                        left: 20,
                        child: Image.asset(
                          _petList[index].petImagesName[0],
                          width: MediaQuery.of(context).size.width / 1.6,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 100 - scale * 20,
                left: MediaQuery.of(context).size.width / 10,
                child: Container(
                  height: 50,
                  width: 230,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(107, 175, 146, 1),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      width: 5.0,
                      color: const Color(0xFFFFFFFF),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 100 - scale * 15,
                left: MediaQuery.of(context).size.width / 3,
                child: Text(
                  _petList[index].petName,
                  style: GoogleFonts.boogaloo(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      itemCount: _petList.length,
    );
  }
}
