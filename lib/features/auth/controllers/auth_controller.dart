import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:innodify_cust_app/features/home/pages/onboard_page.dart';
import 'package:innodify_cust_app/models/customer_model.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../commons/widgets/custom_snackbar.dart';
import '../../../constants/colors.dart';
import '../../../constants/strings.dart';
import '../pages/login_page.dart';
import '../pages/splash_page.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  RxBool isLoading = false.obs;
  RxBool isSplashing = true.obs;

  late Rx<User?> _userPersist;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  UserCredential? credential;

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxString verificationCodeEntered = ''.obs;
  RxString verificationCodeSentToUser = ''.obs;
  int verificationCodeLength = 6;

  RxString currentUserUID = ''.obs;
  RxString currentPhoneNumber = ''.obs;
  RxString currentUsername = ''.obs;
  RxString currentEmail = ''.obs;
  RxString currentProfilePic = ''.obs;

  Future<void> getOTP() async {
    isLoading.value = true;
    if (emailController.text.isNotEmpty &&
        phoneNumberController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        usernameController.text.isNotEmpty) {
      // Get.to(() => OTPPage());
      verifyOTP(); // is set here instead of the upper line of code
    } else {
      return;
    }
  }

  Future<void> verifyOTP() async {
    // TODO: write code for verification then...
    isLoading.value = true;
    await checkIfUserExistsAndSign();
  }

  Future<void> resendOTP() async {}

  // USER STATE PERSISTENCE
  @override
  void onReady() {
    super.onReady();
    _userPersist = Rx<User?>(firebaseAuth.currentUser);
    _userPersist.bindStream(firebaseAuth.authStateChanges());
    ever(_userPersist, _setInitialRoute);
  }

  _setInitialRoute(User? user) {
    if (user == null) {
      Get.to(() => const SplashPage());
      Future.delayed(const Duration(seconds: 2)); // check for problems
      Get.offAll(() => LoginPage());
    } else {
      Get.to(() => const SplashPage());
      setInitialVariables();
    }
  }

  void setInitialVariables() {
    try {
      firestore
          .collection('customers')
          .doc(firebaseAuth.currentUser!.uid)
          .snapshots()
          .listen(
        (DocumentSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.exists) {
            currentUserUID.value = FirebaseAuth.instance.currentUser!.uid;
            currentUsername.value = snapshot.data()?['username'] ?? '';
            currentEmail.value = snapshot.data()?['email'] ?? '';
            currentPhoneNumber.value = snapshot.data()?['phoneNumber'] ?? '';
            currentProfilePic.value = snapshot.data()?['profilePic'] ?? '';
            // currentHashedPassword.value = snapshot.data()?['hashedPassword'] ?? ''; // TODO : Hashed password is not made,
            Get.offAll(() => OnboardPage());
          } else {
            Get.offAll(() => OnboardPage());
          }
        },
      );

      isSplashing.value = false;
      Get.offAll(() => OnboardPage());
    } catch (e) {
      CustomSnackbar.show('', '"Error occured while loading details"');
    } finally {
      isLoading.value = false;
    }
  }

  // Sign Up / Registration

  Future<void> signUpUser() async {
    try {
      if (emailController.text.isNotEmpty &&
          phoneNumberController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          usernameController.text.isNotEmpty) {
        credential = await firebaseAuth.createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim());
        currentUserUID.value = credential!.user!.uid;

        CustomerModel customerModel = CustomerModel(
          username: usernameController.text,
          email: emailController.text.trim(),
          profilePic: '',
          uid: currentUserUID.value,
          phoneNumber: phoneNumberController.text,
        );

        await FirebaseFirestore.instance
            .collection("customers")
            .doc(currentUserUID.value)
            .set(customerModel.toJson());

        CustomSnackbar.show("Account Created",
            "Wassup ${currentUsername.value}, have a great time here!");
        Get.offAll(() => OnboardPage(), transition: Transition.circularReveal);
      } else {
        CustomSnackbar.show("Failed Creating Account",
            "Please make sure you have filled all the details");
      }
    } catch (e) {
      CustomSnackbar.show("Error Creating Account",
          "Please make sure you have filled all the details");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkIfUserExistsAndSign() async {
    await firestore
        .collection('customers')
        .where('username', isEqualTo: usernameController.text)
        .where('phoneNumber', isEqualTo: phoneNumberController.text)
        .where('email', isEqualTo: emailController.text)
        .get()
        .then((QuerySnapshot snapshot) {
      if (snapshot.docs.isNotEmpty) {
        signInUser();
      } else {
        signUpUser();
      }
    }).catchError((e) {
      CustomSnackbar.show('Error', "Failed to fetch details $e");
    });
  }

  // Sign in / Log in
  Future<void> signInUser() async {
    isLoading.value = true;
    try {
      if (emailController.text.isNotEmpty &&
          usernameController.text.isNotEmpty &&
          phoneNumberController.text.isNotEmpty &&
          passwordController.text.isNotEmpty) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim());

        CustomSnackbar.show("Success", "Logged in successfully");
        Get.offAll(() => OnboardPage(), transition: Transition.circularReveal);
      } else {
        CustomSnackbar.show(
            "Error Logging in", "Please fill up all the blocks");
      }
    } catch (e) {
      CustomSnackbar.show("Error Logging in", '');
    } finally {
      isLoading.value = false;
    }
  }

  void showTermsAndConditions(BuildContext context, {bool showLogout = false}) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.arrow_back_ios).onTap(() {
                      Get.back();
                    }),
                    "Terms & Conditions and Privacy Policy"
                        .text
                        .bold
                        .size(14)
                        .make(),
                    ''.text.make(),
                  ],
                ),
                15.heightBox,
                const Text(termsAndConditionsString),
                showLogout
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: "Logout"
                                .text
                                .bold
                                .size(20)
                                .color(darkPinkColor)
                                .make()
                                .onTap(() async {
                              await FirebaseAuth.instance.signOut();
                            }),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: "Delete Account"
                                .text
                                .bold
                                .size(18)
                                .color(redColor)
                                .make()
                                .onTap(() async {
                              deleteAcc(context);
                            }),
                          )
                        ],
                      )
                    : Container()
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> deleteAcc(BuildContext context) async {
    try {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              20.heightBox,
              "Do you want to delete this account for sure?\nThis will delete all your credentials, and\nyou can re-use your phone number to\ncreate a new account."
                  .text
                  .bold
                  .make(),
              20.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  "No"
                      .text
                      .color(darkPinkColor.withOpacity(0.5))
                      .make()
                      .onTap(() {
                    Get.back();
                  }),
                  "Yes".text.color(redColor).make().onTap(() async {
                    var uid = currentUserUID.value;
                    await FirebaseAuth.instance.signOut();
                    firestore.collection('users').doc(uid).delete();
                    CustomSnackbar.show(
                        'Success', 'Account deleted successfully');
                  }),
                ],
              ),
              20.heightBox,
            ],
          );
        },
      );
    } catch (e) {
      CustomSnackbar.show('error', e.toString());
    }
  }
}
