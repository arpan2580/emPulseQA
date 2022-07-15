import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomAboutDialog extends StatefulWidget {
  const CustomAboutDialog({Key? key}) : super(key: key);

  @override
  State<CustomAboutDialog> createState() => _CustomAboutDialogState();
}

class _CustomAboutDialogState extends State<CustomAboutDialog> {
  bool isLoading = true;
  final storedToken = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebView(
          javascriptMode: JavascriptMode.unrestricted,
          // initialUrl: 'https://www.itcinfotech.com/',
          initialUrl: storedToken.read("aboutAppUrl").toString(),
          onPageFinished: (finish) {
            setState(() {
              isLoading = false;
            });
          },
        ),
        isLoading
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : Container(),
      ],
    );
  }
}
