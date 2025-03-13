
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:canil_management_app/providers/theme_provider.dart';
import 'package:canil_management_app/providers/medication_provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'screens/pet_register_screen.dart';
import 'screens/cio_register_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/medication_screen.dart';

void main() {
  tz.initializeTimeZones();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => MedicationProvider()), // 🔥 Adicionando o Provider de Medicamentos
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
        '/': (context) => WelcomeScreen(),
        '/home': (context) => HomeScreen(),
        '/pet-register': (context) => PetRegisterScreen(),
        '/cio-register': (context) => CioRegisterScreen(),
        '/profile': (context) => ProfileScreen(),
        '/medicamentos': (context) => MedicationScreen(), // ✅ Rota corrigida
      },
    );
  }
}



/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:canil_management_app/providers/theme_provider.dart';
import 'package:canil_management_app/providers/medication_provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'screens/pet_register_screen.dart';
import 'screens/cio_register_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/medication_screen.dart';
import 'package:canil_management_app/screens/register_screen.dart'; // ✅ Importação corrigida


void main() {
  tz.initializeTimeZones(); // 🔥 Garante que os fusos horários sejam carregados corretamente

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => MedicationProvider()),
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
        '/': (context) => WelcomeScreen(),
        '/home': (context) => HomeScreen(),
        '/pet-register': (context) => PetRegisterScreen(),
        '/cio-register': (context) => CioRegisterScreen(),
        '/profile': (context) => ProfileScreen(),
        '/welcome': (context) => WelcomeScreen(),
        '/medicamentos': (context) => MedicationScreen(), // ✅ Nova tela adicionada
        '/register': (context) => RegisterScreen(), // ✅ Rota de cadastro do usuário adicionada

      },
      
    );
  }
}*/
