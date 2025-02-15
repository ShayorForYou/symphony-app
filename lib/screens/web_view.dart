import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Web extends StatefulWidget {
  const Web({super.key});

  @override
  State<Web> createState() => _WebState();
}

class _WebState extends State<Web> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _hasError = false;
              _errorMessage = '';
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _hasError = true;
              _isLoading = false;
              _errorMessage = _getErrorMessage(error.errorCode);
            });
          },
        ),
      )
      ..loadRequest(Uri.parse('https://symphony-mobile.com/'));
  }

  String _getErrorMessage(int errorCode) {
    switch (errorCode) {
      case -2:
        return 'Failed to connect to the server. Please check your internet connection.';
      case -6:
        return 'Connection timed out. Please try again.';
      case -8:
        return 'Failed to load the webpage. Please check your internet connection.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  Future<void> _refreshPage() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });
    await _controller.reload();
  }

  Widget _buildErrorPage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .errorContainer
                    .withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.wifi_off_rounded,
                size: 50,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Oops!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _refreshPage,
              icon: const Icon(
                Icons.refresh_rounded,
                color: Colors.white,
              ),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Symphony Mobile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _refreshPage,
          ),
        ],
      ),
      body: _isLoading
          ?  Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: LoadingIndicator(
            indicatorType: Indicator.ballClipRotateMultiple,
            colors: [Theme.of(context).colorScheme.primary],
          ),
        ),
      )
          : _hasError
          ? _buildErrorPage()
          : Stack(
        children: [
          WebViewWidget(controller: _controller),
          Positioned.fill(
            child: IgnorePointer(
              ignoring:
              !_isLoading, // Only accept gestures when loading
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [SizedBox.shrink()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
