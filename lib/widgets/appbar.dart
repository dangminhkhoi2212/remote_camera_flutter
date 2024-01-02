import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:remote_camera/const/color_const.dart';
import 'package:remote_camera/provider/index_bar.dart';

class AppbarCustom extends StatelessWidget {
  const AppbarCustom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GNav(
      curve: Curves.easeInQuad,
      color: ColorConst.primary,
      backgroundColor: ColorConst.third,
      iconSize: 34,
      activeColor: ColorConst.primary,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      gap: 2,
      tabs: [
        GButton(
          icon: Icons.home_outlined,
          text: 'Home',
          onPressed: () {
            context.read<IndexBar>().changeIndex(1);
          },
        ),
        GButton(
          icon: Icons.image_outlined,
          text: 'Gellary',
          onPressed: () {
            context.read<IndexBar>().changeIndex(2);
          },
        ),
        GButton(
          icon: Icons.settings_outlined,
          text: 'Setting',
          onPressed: () {
            context.read<IndexBar>().changeIndex(3);
          },
        ),
      ],
    );
  }
}
