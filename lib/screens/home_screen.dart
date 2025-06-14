import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Força de Vendas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () => Navigator.pushNamed(context, '/sincronia'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/configuracao'),
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        children: [
          _buildMenuCard(
            context,
            'Clientes',
            Icons.people,
            () => Navigator.pushNamed(context, '/cadastro_cliente'),
          ),
          _buildMenuCard(
            context,
            'Usuários',
            Icons.person,
            () => Navigator.pushNamed(context, '/cadastro_usuario'),
          ),
          _buildMenuCard(
            context,
            'Produtos',
            Icons.inventory,
            () => Navigator.pushNamed(context, '/cadastro_produto'),
          ),
          _buildMenuCard(
            context,
            'Pedidos',
            Icons.shopping_cart,
            () => Navigator.pushNamed(context, '/cadastro_pedido'),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
} 