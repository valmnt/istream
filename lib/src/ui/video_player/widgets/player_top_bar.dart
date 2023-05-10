import 'package:flutter/material.dart';

class PlayerTopBar extends StatelessWidget {
  final String title;
  final IconData backButtonIcon;
  final Function() onBackButtonPressed;

  const PlayerTopBar({
    super.key,
    required this.title,
    required this.backButtonIcon,
    required this.onBackButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
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
