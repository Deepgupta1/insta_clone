import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_insta_clone/resources/assets/images.dart';
import 'package:flutter_insta_clone/utils/colors.dart';
import 'package:flutter_insta_clone/widgets/post_card.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset(
          instagramLogo,
          color: primaryColor,
          height: 32,
        ),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.messenger_outline)),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('post').snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot){
          if(snapshot.connectionState ==ConnectionState.waiting){

            return Center(
              child: CircularProgressIndicator(),

            );
          }
          print("ddd ${snapshot.data!.docs.length}");
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context,index) => PostCard(
              snap:snapshot.data!.docs[index].data()
            ),);
        },
      ),
    );
  }
}
