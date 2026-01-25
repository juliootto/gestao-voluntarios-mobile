import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/main_container_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

final _router = GoRouter(
  initialLocation: '/login', // <--- Começa no Login agora
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(), // Importe o arquivo!
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const MainContainerScreen(),
    ),
  ],
);

void main() async{
  // GARANTIA: Como a main agora é async, precisamos dessa linha para o Flutter não quebrar
  WidgetsFlutterBinding.ensureInitialized(); 
  // O ProviderScope é necessário para o Riverpod funcionar
  await initializeDateFormatting('pt_BR', null);
  runApp(const ProviderScope(child: MeuAppVoluntarios()));
}

class MeuAppVoluntarios extends StatelessWidget {
  const MeuAppVoluntarios({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Gestão de Voluntários',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
        // Usando Google Fonts para ficar bonito
        textTheme: GoogleFonts.latoTextTheme(),
      ),
      routerConfig: _router,
    );
  }
}

