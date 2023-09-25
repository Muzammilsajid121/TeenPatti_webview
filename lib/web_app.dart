import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:connectivity/connectivity.dart';
import 'package:url_launcher/url_launcher.dart';

import 'no_internet.dart';

class WebApp extends StatefulWidget {
  final VoidCallback onLoad; // Callback function to start loading the web view

  const WebApp({Key? key, required this.onLoad}) : super(key: key);

  @override
  State<WebApp> createState() => _WebAppState();
}

class _WebAppState extends State<WebApp> {
  late WebViewController _controller;
  bool _isLoading = true;
  //progress bar variable
  double progress = 0;
  // bool _showCircularProgress =
  //     true; // Flag to control circular progress visibility

  @override
  void initState() {
    super.initState();
    widget
        .onLoad(); // Call the callback function to start loading the web view.
    checkInternetConnection(); // Check internet connection when the app starts
  }

  //////////////////////////////////
  Future<void> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      // No internet connection, show the NoInternet screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => NoInternet(),
        ),
      );
    }
  }

  ///

//
  bool shouldOpenInExternalBrowser(String url) {
    // Define the logic to determine whether a URL should be opened externally.
    // In this example, we open URLs not belonging to your app domain externally.
    final appDomain = 'https://nn5.pw/aw/ydehh';
    return !url.startsWith(appDomain);
  }

//
  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }

//

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //Wrapping Scaffold with willpopscope widget to do not
      //quit the app when android back button is pressed

      onWillPop: () async {
        if (await _controller.canGoBack()) {
          _controller.goBack();

          //Stay In App
          return false;
        } else {
          return false;
          //If always want to be in your app make above false
        }
      },

      child: Scaffold(
        //AppBar
        appBar: AppBar(
          backgroundColor: Color(0xff5D0D0E),
          centerTitle: true,
          title: Text(
            'Teen Patti Master', style: Theme.of(context).textTheme.bodyMedium,
            // style: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
          ),
          //
          leading:

              //BACK BUTTON
              IconButton(
                  onPressed: () async {
                    if (await _controller.canGoBack()) {
                      _controller.goBack();
                    }
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
          //
          actions: [
            //clear cache and cookies button
            IconButton(
                onPressed: () {
                  _controller.clearCache();
                  CookieManager().clearCookies();
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.white,
                )),

            //REFRESH Button
            IconButton(
                onPressed: () {
                  _controller.reload();
                },
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                ))
          ],
          //
        ),
        body: RefreshIndicator(
          onRefresh: _refreshWebView,
          child: Stack(
            children: [
              Column(
                children: [
                  // Progress Indicator at top
                  LinearProgressIndicator(
                    value: progress,
                    color: Color.fromARGB(255, 197, 18, 21),
                    backgroundColor: Colors.black,
                  ),
                  Expanded(
                    child: WebView(
                      initialUrl: 'https://teenpattiapk.in/',
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (WebViewController webViewController) {
                        _controller = webViewController;
                        // Set the navigationDelegate here
                        // _controller.navigationDelegate = _handleNavigation;

                        (NavigationRequest request) {
                          if (request.url.startsWith("https://")) {
                            return NavigationDecision.navigate;
                          } else {
                            launchURL(request.url);
                            return NavigationDecision.prevent;
                          }
                        };
                        //
                      },
                      //

                      //

                      //

                      //Progress bar on the top of screen
                      onPageStarted: (url) {
                        setState(() {
                          _isLoading = true;
                        });

                        // Check if the URL should be opened in the external browser
                        // if (shouldOpenInExternalBrowser(url)) {
                        //   launchURL(url); // Open the URL in the default browser
                        // }
                        //
                        launchURL(
                            url); // Always open the URL in the default browser
                      },
                      onPageFinished: (_) {
                        setState(() {
                          _isLoading = false;
                        });
                      },
                      onProgress: (progress) {
                        setState(() {
                          this.progress = progress / 100;
                        });

                        // Hide the circular progress indicator when progress reaches 40%
                        if (progress >= 60) {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              if (_isLoading) // Show the circular progress based on the flag
                const Center(
                  child: SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 243, 69, 72),
                      strokeWidth: 3,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refreshWebView() async {
    await _controller.reload();
  }
}
