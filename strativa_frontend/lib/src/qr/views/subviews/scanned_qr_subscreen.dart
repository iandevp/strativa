import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:strativa_frontend/common/const/app_theme/custom_text_styles.dart';
import 'package:strativa_frontend/common/const/global_keys.dart';
import 'package:strativa_frontend/common/const/kcolors.dart';
import 'package:strativa_frontend/common/const/kconstants.dart';
import 'package:strativa_frontend/common/const/kenums.dart';
import 'package:strativa_frontend/common/const/kroutes.dart';
import 'package:strativa_frontend/common/const/kstrings.dart';
import 'package:strativa_frontend/common/widgets/app_button_widget.dart';
import 'package:strativa_frontend/common/widgets/app_circular_progress_indicator_widget.dart';
import 'package:strativa_frontend/common/widgets/app_error_snack_bar_widget.dart';
import 'package:strativa_frontend/common/widgets/app_labeled_amount_note_field_widget.dart';
import 'package:strativa_frontend/common/widgets/app_transfer_receive/controllers/app_transfer_receive_widget_notifier.dart';
import 'package:strativa_frontend/common/widgets/otp/widgets/app_otp_modal_bottom_sheet.dart';
import 'package:strativa_frontend/src/qr/controllers/scan_qr_notifier.dart';
import 'package:strativa_frontend/src/qr/models/scanned_account_model.dart';
import 'package:strativa_frontend/src/qr/widgets/scanned_qr_details_widget.dart';
import 'package:strativa_frontend/src/transfer/controllers/transfer_notifier.dart';
import 'package:strativa_frontend/src/transfer/models/transfer_model.dart';

class ScannedQrSubscreen extends StatelessWidget {
  const ScannedQrSubscreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = AppGlobalKeys.scannedQrFormKey;
    TextEditingController amountController = TextEditingController();
    TextEditingController noteController = TextEditingController();
    String scannedQrData = context.read<ScanQrNotifier>().getScannedQrData;

    List dataSplit = scannedQrData.split(', ');
    
    ScannedAccountModel scannedAccount = ScannedAccountModel(
      fullname: dataSplit[0].toUpperCase(),
      accountType: dataSplit[1],
      accountNumber: dataSplit[2],
      amountRequested: dataSplit[3],
      bank: dataSplit[4]
    );
    
    void navigator() {
      context.read<ScanQrNotifier>().getScannerController.start();
      Navigator.of(context).pop();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransferNotifier>().checkIfAccountExists(context, scannedAccount.accountNumber);
    });

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder:(context) {
            return IconButton(
              onPressed: () {
                navigator();
              },
              icon: Icon(Icons.arrow_back),
            );
          },
        ),
        centerTitle: true,
        title: Text(
          AppText.kReview,
          style: CustomTextStyles(context).screenHeaderStyle.copyWith(
            color: ColorsCommon.kWhite,
          ),
        ),
        backgroundColor: ColorsCommon.kPrimaryL3,
        iconTheme: IconThemeData(
          color: ColorsCommon.kWhite,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: 0,
          left: AppConstants.kAppPadding.left,
          right: AppConstants.kAppPadding.right
        ),
        child: Consumer<TransferNotifier>(
          builder: (context, transferNotifier, child) {
            if (transferNotifier.getIsLoading) {
              return Center(
                child: AppCircularProgressIndicatorWidget()
              );
            }

            if (transferNotifier.getStatusCode == -1) {
              return Center(
                child: Padding(
                  padding: AppConstants.kAppPadding,
                  child: Text(
                    AppText.kTheUserDoesNotExist,
                    style: CustomTextStyles(context).biggestStyle
                  ),
                )
              );
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Scanned QR Details
                  ScannedQrDetailsWidget(
                    fullName: scannedAccount.fullname,
                    type: scannedAccount.accountType,
                    accountNumber: scannedAccount.accountNumber,
                    amountRequested: scannedAccount.amountRequested
                  ),

                  SizedBox(height: 50.h),

                  // Labeled Amount with Note Fields
                 scannedAccount.amountRequested.isEmpty
                    ? Column(
                      children: [
                        Form(
                          key: formKey,
                          child: AppLabeledAmountNoteFieldWidget(
                            text: AppText.kTransferTheAmountOf,
                            amountController: amountController,
                            addNote: true,
                            addNoteController: noteController
                          )
                        ),

                        SizedBox(height: 40.h)
                      ],
                    )
                    : Container(),

                  Consumer<AppTransferReceiveWidgetNotifier>(
                    builder: (context, appTransferReceiveWidgetNotifier, child) {
                      return AppButtonWidget(
                        onTap: () async {
                          // Check if there is no account to transfer from
                          if (appTransferReceiveWidgetNotifier.getFromAccount == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              appErrorSnackBarWidget(
                                context: context, 
                                text: AppText.kPleaseSelectAnAccountToTransferFrom
                              )
                            );
                            return;
                          }

                          // Check if both accounts to transfer from and to are the same
                          if (
                            appTransferReceiveWidgetNotifier.getFromAccount!.accountNumber == scannedAccount.accountNumber &&
                            appTransferReceiveWidgetNotifier.getFromAccount!.bank.bankName == scannedAccount.bank
                          ) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              appErrorSnackBarWidget(
                                context: context, 
                                text: AppText.kCantTransferToTheSameAccount
                              )
                            );

                            return;
                          }

                          // With no amount requested
                          if (scannedAccount.amountRequested.isEmpty) {
                            if (formKey.currentState!.validate()) {
                              TransferModel model = TransferModel(
                                transactionDetails: TransactionDetails(
                                  transactionType: TransactionTypes.transfers.name,
                                  amount: amountController.text, 
                                  note: noteController.text, 
                                  sender: User(
                                    accountNumber: appTransferReceiveWidgetNotifier.getFromAccount!.accountNumber,
                                    bank: appTransferReceiveWidgetNotifier.getFromAccount!.bank.bankName
                                  ),
                                  receiver: User(
                                    accountNumber: scannedAccount.accountNumber,
                                    bank: scannedAccount.bank
                                  )
                                )
                              );
                              String data = transferModelToJson(model);
                              int? statusCode = await showAppOtpModalBottomSheet(
                                context: context,
                                initialValue: appTransferReceiveWidgetNotifier.getFromAccount!.accountNumber,
                                sendOtp: true,
                                transactionDetails: data,
                                enabled: false,
                              );

                              if (statusCode == 200) {
                                if (context.mounted) {
                                  context.go(
                                    AppRoutes.kSuccessTransfer,
                                    extra: {
                                      "fromAccountType": appTransferReceiveWidgetNotifier.getFromAccount!.accountType.accountType,
                                      "fromAccountNumber": appTransferReceiveWidgetNotifier.getFromAccount!.accountNumber,
                                      "toAccountType": scannedAccount.accountType,
                                      "toAccountNumber": scannedAccount.accountNumber,
                                      "amount": amountController.text,
                                      "note": noteController.text
                                    }
                                  );
                                }
                              }
                            }
                          // With amount requested
                          } else {
                            TransferModel model = TransferModel(
                              transactionDetails: TransactionDetails(
                                transactionType: TransactionTypes.transfers.name, 
                                amount: scannedAccount.amountRequested, 
                                note: "", 
                                sender: User(
                                  accountNumber: appTransferReceiveWidgetNotifier.getFromAccount!.accountNumber,
                                  bank: appTransferReceiveWidgetNotifier.getFromAccount!.bank.bankName
                                ),
                                receiver: User(
                                  accountNumber: scannedAccount.accountNumber,
                                  bank: scannedAccount.bank
                                )
                              )
                            );
                            String data = transferModelToJson(model);

                            int? statusCode = await showAppOtpModalBottomSheet(
                              context: context,
                              initialValue: appTransferReceiveWidgetNotifier.getFromAccount!.accountNumber,
                              sendOtp: true,
                              transactionDetails: data,
                              enabled: false
                            );

                            if (statusCode == 200) {
                              if (context.mounted) {
                                context.go(
                                  AppRoutes.kSuccessTransfer,
                                  extra: {
                                    "fromAccountType": appTransferReceiveWidgetNotifier.getFromAccount!.accountType.accountType,
                                    "fromAccountNumber": appTransferReceiveWidgetNotifier.getFromAccount!.accountNumber,
                                    "toAccountType": scannedAccount.accountType,
                                    "toAccountNumber": scannedAccount.accountNumber,
                                    "amount": scannedAccount.amountRequested,
                                    "note": noteController.text
                                  }
                                );
                              }
                            }
                          }
                        }, 
                        text: AppText.kConfirm
                      );
                    }
                  ),

                  SizedBox(height: 5.h),

                  AppButtonWidget(
                    onTap: () {
                      navigator();
                    },
                    text: AppText.kCancel,
                    color: ColorsCommon.kPrimaryL3,
                    showBorder: true,
                    firstColor: Colors.transparent,
                    secondColor: Colors.transparent,
                  ),
                ]
              )
            );
          }
        )
      )
    );
  }
}