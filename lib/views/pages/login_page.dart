import 'package:empulse/controllers/base_controller.dart';
import 'package:empulse/controllers/login_controller.dart';
import 'package:empulse/views/pages/splash_page.dart';
import 'package:empulse/views/widgets/custom_button.dart';
import 'package:empulse/views/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final loginController = Get.put(LoginController());
  late String captchaUrl;
  int counter = 1;

  @override
  void initState() {
    super.initState();
    captchaUrl = BaseController.captchaUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: SafeArea(
        bottom: false,
        child: Container(
          height: Get.height,
          width: Get.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/Main_Background.jpg',
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const Positioned(
                    left: 0,
                    top: 20,
                    child: EmpulseLogo(
                      width: 200.0,
                    ),
                  ),
                  SingleChildScrollView(
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 77.w),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              SizedBox(height: 95.h),
                              Image(
                                image: const AssetImage(
                                    "assets/images/email_screen.png"),
                                height: 300.h,
                                width: 150.w,
                              ),
                              SizedBox(height: 15.h),
                              CustomTextfield(
                                hintText: "someone@itc.in",
                                hStyle: false,
                                tStyle: false,
                                textEditingController: loginController.txtEmail,
                                labelText: "E-mail Address",
                                keyboardType: TextInputType.emailAddress,
                                obsecureTxt: false,
                                suffixIcon: true,
                                fullBorder: false,
                                centerText: false,
                                maxLine: 1,
                                validation: () {
                                  loginController.txtEmail.text =
                                      loginController.txtEmail.text.trim();
                                  if (loginController.txtEmail.text.isEmpty) {
                                    return "Email ID is required for login";
                                  } else if (!loginController.txtEmail.text
                                          .contains('@') ||
                                      !loginController.txtEmail.text
                                          .contains('.in')) {
                                    return "Email id is not valid";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              SizedBox(height: 20.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.network(
                                    captchaUrl,
                                    frameBuilder:
                                        (_, image, loadingBuilder, __) {
                                      if (loadingBuilder == null) {
                                        return Container(
                                          height: 50,
                                          width: 150,
                                          color: Colors.black12,
                                        );
                                      }
                                      return image;
                                    },
                                    loadingBuilder: (BuildContext context,
                                        Widget image,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return image;
                                      return SizedBox(
                                        child: Center(
                                          child: CircularProgressIndicator
                                              .adaptive(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder: (_, __, ___) => Container(
                                      height: 50,
                                      width: 150,
                                      color: Colors.black12,
                                      child: const Icon(
                                        Icons.error_rounded,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        captchaUrl = BaseController.captchaUrl +
                                            '?v=$counter';
                                        counter += 1;
                                      });
                                    },
                                    child: Icon(
                                      Icons.refresh_rounded,
                                      size: 35.h,
                                    ),
                                  ),
                                ],
                              ),
                              CustomTextfield(
                                hintText: "Enter the captcha",
                                hStyle: false,
                                tStyle: false,
                                textEditingController:
                                    loginController.txtCaptcha,
                                keyboardType: TextInputType.number,
                                maxLength: 5,
                                counterText: " ",
                                obsecureTxt: false,
                                suffixIcon: true,
                                fullBorder: false,
                                maxLine: 1,
                                centerText: true,
                                validation: () {
                                  loginController.txtCaptcha.text =
                                      loginController.txtCaptcha.text.trim();
                                  if (loginController.txtCaptcha.text.isEmpty) {
                                    return "Enter captcha code to proceed";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              SizedBox(height: 29.h),
                              CustomButton(
                                formKey: _formKey,
                                btnText: "Login",
                                action: () {
                                  loginController
                                      .login()
                                      .then((value) => setState(() {
                                            captchaUrl =
                                                BaseController.captchaUrl +
                                                    '?v=$counter';
                                            counter += 1;
                                            // loginController.txtEmail.clear();
                                            loginController.txtCaptcha.clear();
                                          }));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
