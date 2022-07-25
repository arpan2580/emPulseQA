// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:empulse/controllers/image_controller.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomOpenImage extends StatelessWidget {
  const CustomOpenImage({
    Key? key,
    required this.context,
    required ImageController controller,
  })  : _controller = controller,
        super(key: key);

  final BuildContext context;
  final _controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          Text(
            "Choose Image Source",
            style: TextStyle(
              fontSize: 16.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.camera_alt_rounded,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _controller.getImage(ImageSource.camera);
                    },
                  ),
                  Text(
                    "Camera",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.image_rounded,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _controller.getImage(ImageSource.gallery);
                    },
                  ),
                  Text(
                    "Gallery",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
