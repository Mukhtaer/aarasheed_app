import 'package:flutter/material.dart';

import 'home_screen.dart';

class ErrorPage extends StatelessWidget {
  final String errorMessage;
  const ErrorPage(this.errorMessage, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/Something Went Wrong.png",
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.10,
            left: MediaQuery.of(context).size.width * 0.15,
            right: MediaQuery.of(context).size.width * 0.15,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.15,
              height: 45.0,
              child: MaterialButton(
                color: const Color(0xFF3A57E8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  ).then((_) {
                    Navigator.pop(
                        context); // Remove the HomePage from the navigation stack
                  });
                },
                child: Text(
                  "Try Again".toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
