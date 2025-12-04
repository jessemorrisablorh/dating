import 'package:dating_app/Pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class UserDesktopFooterWidget extends StatefulWidget {
  const UserDesktopFooterWidget({super.key});

  @override
  State<UserDesktopFooterWidget> createState() =>
      _UserDesktopFooterWidgetState();
}

class _UserDesktopFooterWidgetState extends State<UserDesktopFooterWidget> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: 0.12 * height,
      width: width,
      color: Colors.white,
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 50.0, right: 50.0),
        child: Text(
          "${DateTime.now().year} ONLINE DATING. ALL RIGHTS RESERVED",
          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class UserMobileFooterWidget extends StatefulWidget {
  const UserMobileFooterWidget({super.key});

  @override
  State<UserMobileFooterWidget> createState() => _UserMobileFooterWidgetState();
}

class _UserMobileFooterWidgetState extends State<UserMobileFooterWidget> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: 0.15 * height,
      width: width,
      color: Colors.white,
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: Text(
          "${DateTime.now().year} ONLINE DATING. ALL RIGHTS RESERVED",
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: 0.098 * height,
      width: width,
      color: Colors.white,
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Get.offAll(
                  () => HomePage(),
                  transition: Transition.noTransition,
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ImageIcon(AssetImage("images/share.png"), size: 22),
                  Text(
                    "Connect",
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ImageIcon(AssetImage("images/gift.png"), size: 22),
                SizedBox(height: 8),
                Text(
                  "Gifts",
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ImageIcon(AssetImage("images/share.png"), size: 22),
                SizedBox(height: 8),
                Text(
                  "Premium",
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ImageIcon(AssetImage("images/user.png"), size: 22),
                SizedBox(height: 8),
                Text(
                  "Profile",
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ImageIcon(AssetImage("images/award.png"), size: 22),
                SizedBox(height: 8),
                Text(
                  "Premium",
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
