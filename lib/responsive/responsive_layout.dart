import 'package:flutter/material.dart';
import 'package:flutter_insta_clone/providers/user_provider.dart';
import 'package:flutter_insta_clone/utils/global_variable.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {

  final Widget WebScreenLayout;
  final Widget MobileScreenLayout;
  const ResponsiveLayout({super.key, required this.WebScreenLayout, required this.MobileScreenLayout});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    addData();
  }

  addData() async{
    UserProvider _userProvider=Provider.of(context,listen: false);

    await _userProvider.refreshUser();
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,constraint){

      if(constraint.maxWidth>webScreenSize){
        //webscreen
        return widget.WebScreenLayout;
      }

      //mobilescreen
      return widget.MobileScreenLayout;

    });
  }
}
