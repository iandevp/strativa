import 'package:flutter/material.dart';
import 'package:strativa_frontend/common/const/kroutes.dart';
import 'package:go_router/go_router.dart';
import 'package:strativa_frontend/common/widgets/app_button_widget.dart';

class NameScreen extends StatelessWidget {
  const NameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firstNameController = TextEditingController();
    final middleNameController = TextEditingController();
    final lastNameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('Back'),),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What is your name?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            const Text("First Name"),
            const SizedBox(height: 5),
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(
                hintText: "Enter your first name",
                fillColor: const Color(0xFFEFF3F0),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Middle Name (optional)"),
            const SizedBox(height: 5),
            TextField(
              controller: middleNameController,
              decoration: InputDecoration(
                hintText: "Enter your middle name",
                fillColor: const Color(0xFFEFF3F0),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Last Name"),
            const SizedBox(height: 5),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(
                hintText: "Enter your last name",
                fillColor: const Color(0xFFEFF3F0),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const Spacer(),
            AppButtonWidget(text: 'Confirm', onTap: (){
              context.push(AppRoutes.kEmailVerify);
            },),
          ],
        ),
      ),
    );
  }
}