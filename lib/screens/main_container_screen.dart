import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'minhas_escalas_screen.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';

class MainContainerScreen extends StatefulWidget {
  const MainContainerScreen({super.key});

  @override
  State<MainContainerScreen> createState() => _MainContainerScreenState();
}

class _MainContainerScreenState extends State<MainContainerScreen> {
  int _currentIndex = 0;

  // Lista das telas disponíveis
  final List<Widget> _screens = const [
    HomeScreen(),
    MinhasEscalasScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão de Voluntários'),
        actions: [
          // Botão de Logout
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () async {
              // 1. Apaga o token do celular
              await AuthService().logout();
              
              // 2. Volta para a tela de login (e impede de voltar com o botão 'voltar' do Android)
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],
      
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Eventos',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Minhas Escalas',
          ),
        ],
      ),
    );
  }
}