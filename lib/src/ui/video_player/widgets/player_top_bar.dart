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
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black, Colors.transparent],
          stops: [0.2, 0.6],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (backButtonIcon != null && onBackButtonPressed != null)
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.15,
                child: IconButton(
                  color: Colors.white,
                  icon: Icon(backButtonIcon),
                  onPressed: onBackButtonPressed,
                ))
          else
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
