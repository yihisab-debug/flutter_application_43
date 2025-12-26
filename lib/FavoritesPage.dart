import 'package:flutter/material.dart';
import 'main.dart';

class FavoritesPage extends StatelessWidget {
  final List<User> favorites;
  final Function(String) onRemove;

  const FavoritesPage({required this.favorites, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Избранное')),
      body: favorites.isEmpty
          ? Center(child: Text('Нет избранных рецептов'))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final user = favorites[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          user.name,
                          style: const TextStyle( fontSize: 16, fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          user.text,
                          style: const TextStyle(fontSize: 14),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          user.price,
                          style: const TextStyle( fontSize: 12, color: Colors.grey),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          user.quantity,
                          style: const TextStyle( fontSize: 12, color: Colors.grey),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          user.id,
                          style: const TextStyle( fontSize: 12, color: Colors.grey),
                        ),

                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.black),

                            onPressed: () {
                              onRemove(user.id);
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FavoritesPage( favorites: favorites, onRemove: onRemove)),
                              );
                            },

                          ),
                        ),

                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}