import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innodify_cust_app/commons/widgets/custom_button.dart';
import 'package:innodify_cust_app/commons/widgets/custom_progress_indicator.dart';
import 'package:innodify_cust_app/commons/widgets/custom_text_field.dart';
import 'package:innodify_cust_app/confidential/vendor_options.dart';
import 'package:innodify_cust_app/constants/colors.dart';
import 'package:velocity_x/velocity_x.dart';
import '../controllers/auth_controller.dart';

// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  AuthController authController = Get.find(tag: 'auth-controller');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              20.heightBox,
              Image.asset(
                'assets/images/amico_png.png',
                scale: 4,
              ),
              50.heightBox,
              VendorOptions.vendorStoreName.text.size(35).semiBold.make(),
              50.heightBox,
              customTextField(
                  labelText: 'Name',
                  controller: authController.usernameController),
              20.heightBox,
              customTextField(
                  prefixText: '+91',
                  labelText: 'Phone Number',
                  textInputType: TextInputType.phone,
                  controller: authController.phoneNumberController),
              20.heightBox,
              customTextField(
                  labelText: 'Email',
                  textInputType: TextInputType.emailAddress,
                  controller: authController.emailController),
              20.heightBox,
              customTextField(
                  labelText: 'Password',
                  isObscured: true,
                  controller: authController.passwordController),
              35.heightBox,
              Obx(
                () => authController.isLoading.value
                    ? customProgressIndicator()
                    : CustomButton(
                        text: "Login Now",
                        trailingWidget: const Icon(
                          Icons.arrow_forward_ios,
                          color: whiteColor,
                        ),
                        onTap: () {
                          authController.getOTP();
                        },
                        color: pinkColor,
                      ),
              ),
              15.heightBox,
              Column(
                children: [
                  "By logging in, you accept to the".text.size(13).make(),
                  "Terms & Conditions and Privacy Policy"
                      .text
                      .bold
                      .color(darkPinkColor)
                      .size(13)
                      .make()
                      .onTap(() {
                    authController.showTermsAndConditions(context);
                  }),
                ],
              ),
              30.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}
