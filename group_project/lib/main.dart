import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Uncomment when Firebase is set up
  // await Firebase.initializeApp();
  runApp(const SourceZeroApp());
}