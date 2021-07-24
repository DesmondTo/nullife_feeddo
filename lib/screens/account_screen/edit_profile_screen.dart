import 'dart:async';
import 'dart:io';

import 'package:nullife_feeddo/models/user_profile.dart';
import 'package:nullife_feeddo/providers/userProfile_provider.dart';
import 'package:nullife_feeddo/screens/account_screen/change_password_screen.dart';
import 'package:nullife_feeddo/screens/select_pet_screen/select_pet_screen.dart';
import 'package:nullife_feeddo/uploadImage_firebase_api.dart';
import 'package:nullife_feeddo/widgets/user_profile_widget_folder/email_textForm_widget.dart';
import 'package:nullife_feeddo/widgets/user_profile_widget_folder/password_textForm_widget.dart';
import 'package:nullife_feeddo/widgets/user_profile_widget_folder/userName_textForm_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileEdittingScreen extends StatefulWidget {
  final UserProfile userProfile;

  const ProfileEdittingScreen({
    Key? key,
    required this.userProfile,
  }) : super(key: key);

  @override
  _ProfileEdittingScreenState createState() => _ProfileEdittingScreenState();
}

class _ProfileEdittingScreenState extends State<ProfileEdittingScreen> {
  final auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late String? userPhotoURL;
  late DateTime createdTime;
  bool isChanging = true;
  UploadTask? task;
  File? file;
  late Timer _timer;
  int _countDown = 300;
  bool showCountDown = false;
  late bool showChange;

  @override
  void initState() {
    super.initState();
    final UserProfile user = widget.userProfile;
    userNameController.text = user.userName;
    emailController.text = user.email;
    passwordController.text = '';
    userPhotoURL = user.userPhotoURL;
    isChanging = true;
    showCountDown = false;
    showChange =
        FirebaseAuth.instance.currentUser!.providerData.first.providerId !=
            'google.com';
  }

  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    _timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (!isChanging) {
            await FirebaseAuth.instance.currentUser!.updateEmail(
              widget.userProfile.email.toLowerCase(),
            );
          }
          Navigator.pop(context);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: CloseButton(
              onPressed: () async {
                if (!isChanging) {
                  await FirebaseAuth.instance.currentUser!.updateEmail(
                    widget.userProfile.email.toLowerCase(),
                  );
                }
                Navigator.pop(context);
              },
            ),
          ),
          extendBodyBehindAppBar: true,
          body: SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height,
              child: Flex(
                direction: Axis.vertical,
                children: [
                  Expanded(
                    child: buildUpperBackground(),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(top: 0.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            if (isChanging)
                              Text(
                                'Change UserName',
                                style: GoogleFonts.boogaloo(
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            if (isChanging)
                              UserNameTextFormWidget(
                                userNameController: userNameController,
                              ),
                            if (isChanging)
                              SizedBox(
                                height: 12,
                              ),
                            if (isChanging && showChange)
                              Text(
                                'Change Email',
                                style: GoogleFonts.boogaloo(
                                  fontSize: 18,
                                ),
                              ),
                            if (isChanging && showChange)
                              EmailTextFormWidget(
                                emailController: emailController,
                              ),
                            if (isChanging)
                              SizedBox(
                                height: 12,
                              ),
                            if (!isChanging)
                              Text(
                                'Provide your current password to verify',
                                style: GoogleFonts.boogaloo(
                                  fontSize: 18,
                                ),
                              ),
                            if (!isChanging)
                              PasswordTextFormWidget(
                                passwordController: passwordController,
                                hintText: 'Current password',
                              ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromRGBO(165, 145, 113, 0.6),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                              ),
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SelectPetScreen(
                                            user: widget.userProfile,
                                          ))),
                              child: Text(
                                'Change Pet',
                                style: GoogleFonts.boogaloo(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.075),
                              ),
                            ),
                            if ((isChanging ||
                                    widget.userProfile.email.toLowerCase() ==
                                        emailController.text.toLowerCase()) &&
                                showChange)
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Color.fromRGBO(165, 145, 113, 0.5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                ),
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ChangePasswordScreen(
                                              userProfile: widget.userProfile,
                                            ))),
                                child: Text(
                                  'Change Password',
                                  style: GoogleFonts.boogaloo(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.075),
                                ),
                              ),
                            SizedBox(
                              height: 12,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromRGBO(165, 145, 113, 1),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                              ),
                              onPressed: saveForm,
                              child: Text(
                                isChanging ? 'Save' : 'Confirm',
                                style: GoogleFonts.boogaloo(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.075,
                                ),
                              ),
                            ),
                            if (showCountDown && !isChanging)
                              Text(
                                'Verify your new email within $_countDown seconds.',
                                style: GoogleFonts.boogaloo(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                                textAlign: TextAlign.center,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

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

  Future selectAndUploadFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'png',
      ],
    );

    if (result == null) return;
    final String path = result.files.single.path!;
    setState(() {
      file = File(path);
    });
    uploadFile();
  }

  Future uploadFile() async {
    if (file == null) return;

    final fileName = baseName(file!.path);
    final destination = 'files/$fileName';

    task = UploadImageFirebaseApi.uploadFile(destination, file!);

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    setState(() {
      userPhotoURL = urlDownload;
    });

    print('Download-Link: $urlDownload');
  }

  String baseName(String path) {
    return path.replaceAll(
        '/data/user/0/com.example.feeddo/cache/file_picker/', "");
  }

  Future saveForm() async {
    final isValid = _formKey.currentState!.validate();
    final originalProfile = widget.userProfile;

    if (isChanging &&
        (originalProfile.email.toLowerCase() !=
            emailController.text.toLowerCase())) {
      setState(() {
        isChanging = false;
      });
      return;
    }

    if (isValid) {
      final provider = Provider.of<UserProfileProvider>(
        context,
        listen: false,
      );
      final userProfile = UserProfile(
        email: emailController.text.toLowerCase(),
        firestoreID: originalProfile.firestoreID,
        userID: originalProfile.userID,
        petID: originalProfile.petID,
        userName: userNameController.text,
        userPhotoURL:
            userPhotoURL == '' ? originalProfile.userPhotoURL : userPhotoURL!,
        categoryFieldList: originalProfile.categoryFieldList,
      );
      if (!isChanging) {
        try {
          await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(
            EmailAuthProvider.credential(
              email: originalProfile.email.toLowerCase(),
              password: passwordController.text,
            ),
          );

          await FirebaseAuth.instance.currentUser!.updateEmail(
            emailController.text.toLowerCase(),
          );

          FirebaseAuth.instance.currentUser!.sendEmailVerification();

          setState(() {
            showCountDown = true;
          });

          _timer = new Timer.periodic(
            Duration(seconds: 1),
            (Timer timer) async {
              if (_countDown == 0) {
                setState(() {
                  _timer.cancel();
                });
                if (!FirebaseAuth.instance.currentUser!.emailVerified) {
                  await FirebaseAuth.instance.currentUser!.updateEmail(
                    originalProfile.email.toLowerCase(),
                  );
                }
              } else {
                setState(() {
                  _countDown--;
                });
                User user = FirebaseAuth.instance.currentUser!;
                await user.reload();
                if (user.emailVerified) {
                  _timer.cancel();
                  await FirebaseAuth.instance
                      .signInWithCredential(EmailAuthProvider.credential(
                    email: emailController.text.toLowerCase(),
                    password: passwordController.text,
                  ));
                  provider.editUser(userProfile, originalProfile);
                  print('changed successfully!!!');
                  Navigator.pop(context);
                }
              }
            },
          );
        } on FirebaseAuthException catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.code),
              backgroundColor: Theme.of(context).errorColor,
            ),
          );
        }
      } else {
        provider.editUser(userProfile, originalProfile);
        Navigator.pop(context);
      }
    }
  }

  // Widget Starts Here
  Widget buildUpperBackground() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              color: Color.fromRGBO(165, 145, 113, 1),
            ),
            const Divider(
              thickness: 8,
              color: Color.fromRGBO(29, 20, 13, 1),
            ),
          ],
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.05,
          child: Text(
            'EDIT PROFILE',
            style: GoogleFonts.boogaloo(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.width * 0.25,
          left: MediaQuery.of(context).size.width * 0.25,
          child: Stack(
            children: [
              buildProfileImage(),
              Positioned(
                bottom: 0,
                right: 0,
                child: RawMaterialButton(
                  fillColor: Color.fromRGBO(165, 145, 113, 1),
                  splashColor: Color.fromRGBO(29, 20, 13, 1),
                  child: Icon(Icons.edit),
                  onPressed: selectAndUploadFile,
                  shape: CircleBorder(
                      side: BorderSide(
                          width: 3, color: Color.fromRGBO(29, 20, 13, 1))),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildProfileImage() {
    return Container(
      width: 200,
      height: 200,
      alignment: Alignment.center,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xff000000),
        image: new DecorationImage(image: NetworkImage(userPhotoURL!)),
        border: new Border.all(
          color: Color.fromRGBO(29, 20, 13, 1),
          width: 7.0,
        ),
      ),
    );
  }
}
