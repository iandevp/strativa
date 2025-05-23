import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:strativa_frontend/common/const/app_theme/custom_text_styles.dart';
import 'package:strativa_frontend/common/const/kcolors.dart';
import 'package:strativa_frontend/common/const/kconstants.dart';
import 'package:strativa_frontend/common/const/kroutes.dart';
import 'package:strativa_frontend/common/const/kstrings.dart';
import 'package:strativa_frontend/common/widgets/app_button_widget.dart';
import 'package:strativa_frontend/common/widgets/app_logo_widget.dart';
import 'package:strativa_frontend/common/widgets/app_text_button_widget.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: AppConstants.kAppPadding,
        child: Column(
          spacing: 20,
          children: [
            SizedBox(
              height: ScreenUtil().screenHeight * 0.15,
            ),
        
            Align(
              alignment: Alignment.center,
              child: AppLogoWidget(
                logoHeight: 150,
                fontSize: 35,
                spacing: 35,
              ),
            ),

            SizedBox(height:20.h),
        
            AppButtonWidget(
              text: AppText.kOpenAccountButtonText,
              onTap: () {
                context.push(AppRoutes.kRegisterScreen);
              },
              firstColor: ColorsCommon.kPrimaryL1,
              secondColor: ColorsCommon.kPrimaryL4,
              radius: AppConstants.kAppBorderRadius,
            ),
        
            AppButtonWidget(
              text: AppText.kLoginButtonText,
              onTap: () {
                context.push(AppRoutes.kLoginScreen);
              },
              color: ColorsCommon.kPrimaryL4,
              fontWeight: FontWeight.w900,
              firstColor: Colors.transparent,
              secondColor: Colors.transparent,
              showBorder: true,
              radius: AppConstants.kAppBorderRadius,
            ),
        
            AppTextButtonWidget(
              text: AppText.kSignUpWithExistingAccount,
              style: CustomTextStyles(context).textButtonStyle.copyWith(
                fontWeight: FontWeight.w900,
                color: ColorsCommon.kPrimaryL4,
              ),
              onPressed: () {
                // TODO: push to login?
              }
            )
          ]
        ),
      ),
    );
  }
}