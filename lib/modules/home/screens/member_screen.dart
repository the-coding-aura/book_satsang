import 'package:flutter/material.dart';

/// Placeholder members tab on the home screen.
///
/// Reserved for future member directory or listing content.
class MemberScreen extends StatefulWidget {
  /// Creates a [MemberScreen].
  const MemberScreen({super.key});

  /// Creates the state for this widget.
  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Members"));
  }
}
