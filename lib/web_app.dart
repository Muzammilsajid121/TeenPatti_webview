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
  double progress = 0;

  @override
  void initState() {
    super.initState();
    widget.onLoad();
    checkInternetConnection();
  }

  Future<void> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => NoInternet(),
        ),
      );
    }
  }

  bool isInternalLink(String url) {
    // Define the logic to determine whether a URL is internal or external.
    // In this example, we assume all URLs under 'https://teenpattiapk.in/' are internal.
    return url.startsWith('https://teenpattiapk.in/');
  }

  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await _controller.canGoBack()) {
          _controller.goBack();
          return false;
        } else {
          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff5D0D0E),
          centerTitle: true,
          title: Text(
            'Teen Patti Master',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          leading: IconButton(
            onPressed: () async {
              if (await _controller.canGoBack()) {
                _controller.goBack();
              }
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                _controller.clearCache();
                CookieManager().clearCookies();
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                _controller.reload();
              },
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _refreshWebView,
          child: Stack(
            children: [
              Column(
                children: [
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
                      },
                      onPageStarted: (url) {
                        setState(() {
                          _isLoading = true;
                        });

                        if (!isInternalLink(url)) {
                          launchURL(url);
                          return;
                        }
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

                        if (progress >= 60) {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                      navigationDelegate: (NavigationRequest request) {
                        if (!isInternalLink(request.url)) {
                          launchURL(request.url);
                          return NavigationDecision.prevent;
                        }
                        return NavigationDecision.navigate;
                      },
                    ),
                  ),
                ],
              ),
              if (_isLoading)
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
