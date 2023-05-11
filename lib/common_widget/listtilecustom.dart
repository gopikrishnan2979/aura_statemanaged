import 'package:flutter/material.dart';

class ListTileCustom extends StatelessWidget {
  final int index;
  final BuildContext context;
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing1;
  final Widget? trailing2;
  final Color? tilecolor;
  final bool isgradient;
  const ListTileCustom(
      {super.key,
      required this.index,
      required this.context,
      this.leading,
      this.title,
      this.subtitle,
      this.trailing1,
      this.trailing2,
      this.tilecolor,
      this.isgradient = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: tilecolor ?? Colors.white,
            gradient: isgradient
                ? const LinearGradient(colors: [
                    Color.fromARGB(255, 0, 0, 0),
                    Color.fromARGB(255, 10, 63, 148),
                  ])
                : null),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              leading != null
                  ? SizedBox(
                      width: 55,
                      height: 55,
                      child: leading,
                    )
                  : const SizedBox(
                      width: 50,
                      height: 50,
                    ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.55,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      title != null
                          ? SizedBox(
                              height: 23,
                              width: MediaQuery.of(context).size.width * 0.55,
                              child: title,
                            )
                          : const SizedBox(
                              height: 23,
                            ),
                      subtitle != null
                          ? SizedBox(
                              height: 23,
                              width: MediaQuery.of(context).size.width * 0.55,
                              child: subtitle,
                            )
                          : const SizedBox(
                              height: 23,
                            )
                    ],
                  ),
                ),
              ),
              trailing1 != null
                  ? Expanded(child: Center(child: trailing1))
                  : const SizedBox(),
              trailing2 != null
                  ? Expanded(
                      child: Center(
                      child: trailing2,
                    ))
                  : const Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}
