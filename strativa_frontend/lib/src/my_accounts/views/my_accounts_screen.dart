import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:strativa_frontend/common/const/app_theme/custom_text_styles.dart';
import 'package:strativa_frontend/common/const/kcolors.dart';
import 'package:strativa_frontend/common/const/kconstants.dart';
import 'package:strativa_frontend/common/const/kicons.dart';
import 'package:strativa_frontend/common/const/kroutes.dart';
import 'package:strativa_frontend/common/const/kstrings.dart';
import 'package:strativa_frontend/common/temp_model.dart';
import 'package:strativa_frontend/common/utils/date.dart';
import 'package:strativa_frontend/src/my_accounts/widgets/detailed_card_widget.dart';
import 'package:strativa_frontend/src/my_accounts/widgets/top_bar_widget.dart';
import 'package:strativa_frontend/src/transaction_history/widgets/transaction_history_widget.dart';
import 'package:strativa_frontend/src/my_accounts/widgets/wallet_cards_widget.dart';

class MyAccountsScreen extends StatelessWidget {
  const MyAccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppConstants.kAppPadding,
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 10.h),
      
            TopBarWidget(),
      
            SizedBox(height: 10.h),

            DetailedCardWidget(),
            
            SizedBox(height: 30.h),
            
            WalletCardsWidget(),
      
            SizedBox(height: 20.h),
      
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppText.kTransactionHeader,
                      style: CustomTextStyles(context).smallStyle.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
      
                    SizedBox(height: 5.h),
      
                    Text(
                      daysPastSinceDate(DateTime.parse(userData['recent_transaction_date'])),
                      style: CustomTextStyles(context).smallerStyle.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ]
                ),
      
                InkWell(
                  onTap: () {
                    context.push(AppRoutes.kTransactionHistoryScreen);
                  },
                  borderRadius: BorderRadius.circular(AppConstants.kAppBorderRadius),
                  child: Ink(
                    padding: AppConstants.kIconPadding,
                    child: Theme.of(context).brightness == Brightness.dark
                    ? Image(
                      image: AppIcons.kExpandIcon.image,
                      height: AppIcons.kExpandIcon.height,
                      color: ColorsCommon.kWhite,
                    )
                    : AppIcons.kExpandIcon,
                  ),
                ),
              ]
            ),
      
            SizedBox(height: 10.h),
      
            TransactionHistoryWidget(
              length: 3,
            ),
          ],
        ),
      ),
    );
  }
}