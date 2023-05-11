import 'package:flutter/material.dart';

class GradientAppBar extends StatelessWidget {
  final double barHeight = 50.0;
  final List<Widget> action;

  const GradientAppBar({super.key, required this.action});

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 75,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xFF020202), Color(0xFF0D1242)]),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 0, 0, 0),
              blurRadius: 5.0,
              spreadRadius: 0.5,
            )
          ]),
      child: Padding(
          padding:const  EdgeInsets.only(top: 10, left: 30, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                    size: 30,
                  )),
              Row(
                children: action,
              )
            ],
          )),
    );
  }
}
