import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'error_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> visitedPages = [
    "https://aarasheeddata.com.ng/app/"
  ]; // Initialize with the initial URL
  WebViewController? webViewController;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF3A57E8),
    ));
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              "",
            ),
          ),
          automaticallyImplyLeading: false,
          toolbarHeight: 1,
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: Stack(
          children: [
            WebView(
              initialUrl: "https://aarasheeddata.com.ng/app/",
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onPageStarted: (url) {
                setState(() {
                  _isLoading = true;
                  _hasError = false;
                  _errorMessage = '';
                });
                visitedPages.add(url);
                if (kDebugMode) {
                  print(visitedPages);
                }
              },
              onPageFinished: (url) {
                setState(() {
                  _isLoading = false;
                  _hasError = false;
                });
              },
              onWebResourceError: (error) {
                setState(() {
                  _isLoading = false;
                  _hasError = true;
                  _errorMessage =
                      'Error: ${error.errorCode} - ${error.description}';
                });

                if (_hasError) {
                  _redirectToErrorPage(context, _errorMessage);
                }
              },
            ),
            if (_isLoading)
              Center(
                child: Container(
                  color: Colors.white,
                  child: const SpinKitWave(
                    color: Color(0xFF3A57E8),
                    size: 30.0,
                  ),
                ),
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Handle the WhatsApp action here
            launchURL(Uri.parse('https://wa.me/2347036774566/?text=Hi'));
          }, // Customize the icon
          backgroundColor: Colors.green,
          child: const Icon(Icons.message,
              size: 30.0), // Customize the button's background color
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  Future<void> launchURL(Uri url) async {
    if (await launchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<bool> _onBackPressed() async {
    if (visitedPages.length > 1) {
      visitedPages.removeLast();
      final previousPage = visitedPages.last;
      //load the previous page if there is one
      webViewController?.loadUrl(previousPage); // Load the previous page
      //remove the last page from the list of visited pages
      visitedPages.removeLast();

      //if the current page is the initial page, exit the app

      if (previousPage == "https://aarasheeddata.com.ng/app/") {
        //show a dialog to confirm exit
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Confirm Exit"),
            content: const Text("Are you sure you want to exit the app?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // User confirmed exit
                },
                child: const Text("Yes"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // User canceled exit
                },
                child: const Text("No"),
              ),
            ],
          ),
        ).then((value) {
          if (value ?? false) {
            // Exit the app if user confirmed
            SystemNavigator.pop();
          }
        });
      }

      return false; // Do not exit the app
    } else {
      // Show a confirmation dialog before exiting the app
      bool confirmExit = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Confirm Exit"),
          content: const Text("Are you sure you want to exit the app?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User confirmed exit
              },
              child: const Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User canceled exit
              },
              child: const Text("No"),
            ),
          ],
        ),
      );

      return confirmExit; // Return true to exit if user confirms, or false if they cancel
    }
  }
}

void _redirectToErrorPage(BuildContext context, String errorMessage) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ErrorPage(errorMessage),
    ),
  ).then((_) {
    Navigator.pop(context); // Remove the HomePage from the navigation stack
  });
}
