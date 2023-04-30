import 'package:flutter/material.dart';

class PlayerTopBar extends StatelessWidget {
  final String title;
  final IconData? backButtonIcon;
  final Function()? onBackButtonPressed;

  const PlayerTopBar({
    super.key,
    required this.title,
    this.backButtonIcon,
    this.onBackButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.95),
            Colors.black.withOpacity(0.85),
            Colors.black.withOpacity(0.75),
            Colors.black.withOpacity(0.65),
            Colors.black.withOpacity(0.55),
            Colors.black.withOpacity(0.45),
            Colors.black.withOpacity(0.35),
            Colors.black.withOpacity(0.25),
            Colors.black.withOpacity(0.15),
            Colors.black.withOpacity(0.05),
            Colors.transparent,
          ],
          stops: const [
            0.0,
            0.1,
            0.2,
            0.3,
            0.4,
            0.5,
            0.6,
            0.7,
            0.8,
            0.9,
            1.0,
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.15,
              child: IconButton(
                color: Colors.white,
                icon: Icon(backButtonIcon),
                onPressed: onBackButtonPressed,
              )),
          Expanded(
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )),
          ),
        ],
      ),
    );
  }
}
