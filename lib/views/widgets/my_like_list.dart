import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomStatus extends StatelessWidget {
  final Color color;
  final String svgIcon;
  final bool isObservation;
  const CustomStatus({
    required this.color,
    required this.svgIcon,
    required this.isObservation,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 13,
      backgroundColor: color,
      child: SvgPicture.asset(
        'assets/icons/$svgIcon',
        height: (isObservation) ? 12 : 20,
        width: (isObservation) ? 12 : 20,
      ),
    );
  }
}
