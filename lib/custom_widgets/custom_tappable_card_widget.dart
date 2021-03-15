import 'package:flutter/material.dart';

class CustomTappableCard extends StatelessWidget {
  final Function onTap;
  final IconData icon;
  final String label;

  const CustomTappableCard({
    Key key,
    @required this.onTap,
    @required this.icon,
    @required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
            ),
            Text(
              label,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
