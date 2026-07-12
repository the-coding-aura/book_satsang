import 'package:book_satsang/modules/home/providers/home_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Provides convenient access to [HomePageProvider] from a [BuildContext].
extension HomePageProviderExtension on BuildContext {
  /// The [HomePageProvider] registered above this context.
  HomePageProvider get homePageProvider => read<HomePageProvider>();
}
