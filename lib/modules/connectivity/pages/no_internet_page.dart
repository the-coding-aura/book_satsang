import 'package:book_satsang/configs/components/app_flushbar.dart';
import 'package:book_satsang/configs/theme/app_colors.dart';
import 'package:book_satsang/dependency_injection/locator.dart';
import 'package:book_satsang/services/connectivity/connectivity_service.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';

/// Full-screen offline state shown when an API call cannot reach the internet.
///
/// [Check Again] re-runs [ConnectivityService.hasInternetConnection]. On success
/// the page is popped so the user returns to the previous screen; on failure an
/// error flushbar is shown and the page stays open.
class NoInternetPage extends StatefulWidget {
  /// Creates the no-internet connection page.
  const NoInternetPage({super.key});

  @override
  State<NoInternetPage> createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
  bool _isChecking = false;

  Future<void> _onCheckAgain() async {
    if (_isChecking) return;

    setState(() => _isChecking = true);

    final bool hasConnection =
        await getIt<ConnectivityService>().hasInternetConnection();

    if (!mounted) return;

    setState(() => _isChecking = false);

    if (hasConnection) {
      Navigator.of(context).pop();
      return;
    }

    AppFlushbar.error(
      context,
      message: 'Still no internet connection. Please try again.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.wp(8)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.wifi_off_rounded,
                size: context.sp(18),
                color: AppColors.primary,
              ),
              SizedBox(height: context.hp(3)),
              Text(
                'No Internet Connection',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: context.sp(5.5),
                  fontWeight: FontWeight.w700,
                  color: AppColors.labelColor,
                ),
              ),
              SizedBox(height: context.hp(1.5)),
              Text(
                'Please check your network settings and try again.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: context.sp(3.8),
                  color: AppColors.labelColor.withValues(alpha: 0.7),
                ),
              ),
              SizedBox(height: context.hp(4)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: Size(double.infinity, context.hp(6)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: _isChecking ? null : _onCheckAgain,
                child: Text(
                  _isChecking ? 'Checking...' : 'Check Again',
                  style: TextStyle(
                    fontSize: context.sp(4.5),
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
