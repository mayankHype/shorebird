import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimatedBottomBar extends StatelessWidget {



  final ValueChanged<int>? onTap;
 AnimatedBottomBar({
    Key? key,

    required this.onTap,

  }) : super(key: key);

  List<IconData> icons=[
Icons.home,
    Icons.search,
    Icons.add,
    Icons.person
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(40),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: icons
              .map(
                (icon) => GestureDetector(
         onTap: (){

         },
              child: AnimatedSize(
                duration: const Duration(milliseconds: 900),
                child: Icon(
                 Icons.add,
                  size: 26,
                  color:  Colors.black,
                ),
              ),
            ),
          )
              .toList(),
        ),
      ),
    );
  }
}