import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/bootstrap/app_bootstrap.dart';
import 'app/app.dart';

void main() async {
  // Setup global error handling
  AppBootstrap.setupErrorHandling();

  // Initialize all services
  await AppBootstrap.initialize();

  // Run app with Riverpod
  runApp(
    const ProviderScope(
      child: CareerPilotApp(),
    ),
  );
}