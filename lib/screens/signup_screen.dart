import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_insta_clone/resources/assets/images.dart';
import 'package:flutter_insta_clone/resources/auth_method.dart';
import 'package:flutter_insta_clone/screens/login_screen.dart';
import 'package:flutter_insta_clone/utils/colors.dart';
import 'package:flutter_insta_clone/utils/utils.dart';
import 'package:flutter_insta_clone/widgets/text_field_input.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../responsive/mobile_screen_laout.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/web_screen_layout.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
    _bioController.dispose();
    _userNameController.dispose();
  }

  void navigateToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  void signupUser() async {
    String res = "";
    setState(() {
      _isLoading = true;
    });

    try {
      res = await Authmethods().signUpuser(
          email: _emailController.text,
          password: _passController.text,
          userName: _userNameController.text,
          bio: _bioController.text,
          file: _image!);
    } catch (err) {
      setState(() {
        res = err.toString();
        if (res == "Null check operator used on a null value") {
          res = "Please upload profile pic";
        }
        _isLoading = false;
      });
    }
    print("res__ $res");

    if (res != 'success') {
      showScnackBar(res, context);
      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ResponsiveLayout(
              MobileScreenLayout: MobileScreenLayout(),
              WebScreenLayout: WebScreenLayout())));
    }
  }

  void selectImage() async {
    Uint8List im = await picImage(ImageSource.gallery);

    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 32,
                ),

                //svg image
                SvgPicture.asset(
                  instagramLogo,
                  color: primaryColor,
                  height: 64,
                ),
                SizedBox(
                  height: 64,
                ),
                //circular widget to accept and show our selected file
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(
                                "https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg"),
                          ),
                    Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: Icon(Icons.add_a_photo),
                        ))
                  ],
                ),
                SizedBox(
                  height: 24,
                ),

//text-field for username
                TextInputField(
                    textEditingController: _userNameController,
                    hintText: "Enter your username",
                    textInputType: TextInputType.text),

                const SizedBox(
                  height: 24,
                ),
                //text-field for email

                TextInputField(
                    textEditingController: _emailController,
                    hintText: "Enter your email",
                    textInputType: TextInputType.emailAddress),
                const SizedBox(
                  height: 24,
                ),
                //text-field for pass
                TextInputField(
                    textEditingController: _passController,
                    hintText: "Enter your pass",
                    isPass: true,
                    textInputType: TextInputType.emailAddress),
                const SizedBox(
                  height: 24,
                ),
                //text-field for bio

                TextInputField(
                    textEditingController: _bioController,
                    hintText: "Enter your bio",
                    textInputType: TextInputType.text),
                const SizedBox(
                  height: 24,
                ),
                //button SingUp
                InkWell(
                  onTap: signupUser,
                  child: Container(
                    child: _isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          )
                        : const Text("Sign up"),
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      color: blueColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 64,
                ),

                //transition to signing  up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text("I have account?"),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    GestureDetector(
                      onTap: navigateToLogin,
                      child: Container(
                        child: Text(
                          "Login.",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
