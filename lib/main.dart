import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/cadastro_cliente_screen.dart';
import 'screens/cadastro_usuario_screen.dart';
import 'screens/cadastro_produto_screen.dart';
import 'screens/cadastro_pedido_screen.dart';
import 'screens/sincronia_screen.dart';
import 'screens/configuracao_screen.dart';
import 'services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar o banco de dados nativo
  await DatabaseService().initDatabase();
  
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Força de Vendas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/cadastro_cliente': (context) => const CadastroClienteScreen(),
        '/cadastro_usuario': (context) => const CadastroUsuarioScreen(),
        '/cadastro_produto': (context) => const CadastroProdutoScreen(),
        '/cadastro_pedido': (context) => const CadastroPedidoScreen(),
        '/sincronia': (context) => const SincroniaScreen(),
        '/configuracao': (context) => const ConfiguracaoScreen(),
      },
    );
  }
}
