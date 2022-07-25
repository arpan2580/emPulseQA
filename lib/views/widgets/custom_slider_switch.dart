import 'package:flutter/material.dart';

class CustomSliderSwitch extends StatefulWidget {
  final dynamic controller;
  final Function(String) feedbackType;
  const CustomSliderSwitch({
    Key? key,
    required this.controller,
    required this.feedbackType,
  }) : super(key: key);

  @override
  State<CustomSliderSwitch> createState() => _CustomSliderSwitchState();
}

class _CustomSliderSwitchState extends State<CustomSliderSwitch> {
  Alignment pointerAlignment = Alignment.centerLeft;
  String pointerPosition = "left";
  String? value = "Observation";
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Observation",
          style: TextStyle(
            color: value == "Observation"
                ? Colors.green[700]
                : Theme.of(context).primaryColor.withOpacity(0.7),
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        SizedBox(
          width: 60,
          height: 30,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 30,
                  decoration: BoxDecoration(
                    color: pointerPosition == "middle"
                        ? Colors.grey.withOpacity(0.2)
                        : pointerPosition == "right"
                            ? const Color(0xff108ab3)
                            : Colors.green[700],
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              GestureDetector(
                onHorizontalDragUpdate: (v) {
                  if (v.delta.dx > 0.0) {
                    widget.feedbackType("2");
                    widget.controller.feedbackType.text = "2";
                    setState(() {
                      pointerAlignment = Alignment.centerRight;
                      pointerPosition = "right";
                      value = "Action";
                    });
                  } else {
                    widget.feedbackType("1");
                    widget.controller.feedbackType.text = "1";
                    setState(() {
                      pointerAlignment = Alignment.centerLeft;
                      pointerPosition = "left";
                      value = "Observation";
                    });
                  }
                },
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 200),
                  alignment: pointerAlignment,
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      width: 25,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Text(
          "Action",
          style: TextStyle(
            color: value == "Action"
                ? const Color(0xff108ab3)
                : Theme.of(context).primaryColor.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}
