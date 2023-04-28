import 'package:flutter/material.dart';

class PlayerNavBar extends StatelessWidget {
  final String title;
  final IconData? backButtonIcon;
  final Function()? onBackButtonPressed;

  const PlayerNavBar({
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
          stops: [0.5, 0.7],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (backButtonIcon != null && onBackButtonPressed != null)
            IconButton(
              color: Colors.white,
              icon: Icon(backButtonIcon),
              onPressed: onBackButtonPressed,
            )
          else
            const SizedBox(width: 48),
          Text(
            title,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
