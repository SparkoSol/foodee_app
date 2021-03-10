import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodee/src/base/constants.dart';
import 'package:foodee/src/base/theme.dart';
import 'package:foodee/src/ui/widgets/post_widget.dart';

class PostView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(bottom: PreferredSize(  child: Container(child: ListTile( title: Padding(
        padding: EdgeInsets.only(left: 7),
        child:ShaderMask(
          blendMode: BlendMode.srcATop,  // Add this
          shaderCallback: (Rect bounds) {
            return RadialGradient(
              center: Alignment.topLeft,
              radius: 1.0,
              colors: <Color>[AppTheme.primaryColor, AppTheme.secondaryColor],
              tileMode: TileMode.mirror,
            ).createShader(bounds);
          },
          child: const Text('Foodee',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
        ),
        //RichText(
        //   text: TextSpan(
        //     text: 'Foo',
        //     style: TextStyle(
        //       color: AppTheme.secondaryColor,
        //       fontWeight: FontWeight.bold,
        //  fontSize: 20    ),
        //     children: [
        //       TextSpan(
        //         text: 'd',
        //         style: TextStyle(
        //           color: AppTheme.primaryColor,
        //           fontWeight: FontWeight.bold,
        //  fontSize: 20       ),
        //       ),
        //       TextSpan(
        //         text: 'ee',
        //         style: TextStyle(
        //           color: AppTheme.secondaryColor,
        //           fontWeight: FontWeight.bold,
        //             fontSize: 20 ),
        //       ),
        //     ],
        //   ),
        // ),
      ),trailing:
      IconButton(
        icon: Icon(CupertinoIcons.bell,color: Colors.purple,),
        onPressed: () {},
      ),
      )
        ,),
        preferredSize: Size.fromHeight(10.0),
      ), elevation: 0,backgroundColor: Colors.white,



      ),

      body: ListView.builder(itemBuilder: (context, i) {
        return Hero(tag: kPostTag, child: PostWidget());
      }),
    );
    Column(
      children: [
        Expanded(
          child: Hero(
            tag: kPostTag,
            child: PostWidget(),
          ),
        ),
      ],
    );
  }
}
