import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:canil_management_app/providers/theme_provider.dart';
import 'package:canil_management_app/providers/medication_provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'providers/pet_provider.dart'; 
import 'providers/cio_provider.dart'; 
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'screens/pet_register_screen.dart';
import 'screens/cio_register_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/medication_screen.dart';
import 'screens/maternity_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.web, // 🔥 Inicializa o Firebase para Web
  );

  tz.initializeTimeZones();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => MedicationProvider()),
        ChangeNotifierProvider(create: (context) => PetProvider()),
        ChangeNotifierProvider(create: (context) => CioProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Manduc Pet',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.themeMode,
      initialRoute: '/',
      routes: {
        '/welcome': (context) => WelcomeScreen(), // ✅ ESSA LINHA É FUNDAMENTAL
        '/': (context) => WelcomeScreen(),
        '/home': (context) => HomeScreen(),
        '/pet-register': (context) => PetRegisterScreen(),
        '/cio-register': (context) => CioRegisterScreen(),
        '/profile': (context) => ProfileScreen(),
        '/medicamentos': (context) => MedicationScreen(),
        '/maternity' : (context) => MaternityScreen()
      },
    );
  }
}