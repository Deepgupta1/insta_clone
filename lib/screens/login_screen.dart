import 'package:flutter/material.dart';
import 'package:flutter_insta_clone/resources/assets/images.dart';
import 'package:flutter_insta_clone/resources/auth_method.dart';
import 'package:flutter_insta_clone/screens/signup_screen.dart';
import 'package:flutter_insta_clone/utils/colors.dart';
import 'package:flutter_insta_clone/utils/global_variable.dart';
import 'package:flutter_insta_clone/widgets/text_field_input.dart';
import 'package:flutter_svg/svg.dart';

import '../responsive/mobile_screen_laout.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool isLoading=false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
  }

  void navigateToSignup(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SignUpScreen()));
  }

  void loginUser() async {
    setState(() {
      isLoading=true;

    });
    String res = await Authmethods().loginUser(
        email: _emailController.text, password: _passController.text);

    if(res=="Success"){
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ResponsiveLayout(
              MobileScreenLayout: MobileScreenLayout(),
              WebScreenLayout: WebScreenLayout())));
    }else{
      showScnackBar(res,context);
    }
    setState(() {
      isLoading=false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding:MediaQuery.of(context).size.width>webScreenSize? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/3):
          const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(),
                flex: 2,
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
              TextInputField(
                  textEditingController: _emailController,
                  hintText: "Enter your email",
                  textInputType: TextInputType.emailAddress),
              //text-field for email
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
              //button login
              InkWell(
                onTap: loginUser,
                child: Container(
                  child: isLoading?Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  ):const Text("Log in"),
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
                height: 12,
              ),
              Flexible(
                child: Container(),
                flex: 2,
              ),
              //transition to signing  up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text("Don't have an account?"),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  GestureDetector(
                    onTap: navigateToSignup,
                    child: Container(
                      child: Text("Sign up.", style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
