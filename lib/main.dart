import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class User {
  final String name;
  final String text;
  final String price;
  final String quantity;
  final String id;

  User({
    required this.name,
    required this.text,
    required this.price,
    required this.quantity,
    required this.id,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      text: json['text'],
      price: json['price'],
      quantity: json['quantity'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'text': text,
      'price': price,
      'quantity': quantity,
      'id': id,
    };
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mock API Users',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: UserListScreen(),
    );
  }
}

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<User> users = [];
  List<User> favorites = [];
  bool isLoading = false;
  bool isAddingUser = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> fetchUsers() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(
        Uri.parse('https://6939834cc8d59937aa082275.mockapi.io/project'),
      );
      if (response.statusCode == 200) {
        setState(() {
          users = (json.decode(response.body) as List)
              .map((userJson) => User.fromJson(userJson))
              .toList();
        });
      } else {
        showErrorSnackBar("Ошибка при загрузке данных!");
      }
    } catch (e) {
      print("Ошибка загрузки: $e");
      showErrorSnackBar("Не удалось загрузить данные.");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addUser() async {
    setState(() {
      isAddingUser = true;
    });

    final newUser = User(
      name: _nameController.text,
      text: _textController.text,
      price: _priceController.text,
      quantity: _quantityController.text,
      id: '',
    );

    try {
      final response = await http.post(
        Uri.parse('https://6939834cc8d59937aa082275.mockapi.io/project'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(newUser.toJson()),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        setState(() {
          users.add(User.fromJson(json.decode(response.body)));
        });
        Navigator.pop(context);
        _nameController.clear();
        _textController.clear();
        _priceController.clear();
        _quantityController.clear();
      }
    } catch (e) {
      print("Ошибка добавления пользователя: $e");
      showErrorSnackBar("Ошибка при добавлении пользователя.");
    } finally {
      setState(() {
        isAddingUser = false;
      });
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('https://6939834cc8d59937aa082275.mockapi.io/project/$id'),
      );
      if (response.statusCode == 200) {
        fetchUsers();
      }
    } catch (e) {
      print("Ошибка удаления пользователя: $e");
      showErrorSnackBar("Ошибка при удалении пользователя.");
    }
  }

  void addToFavorites(User user) {
    setState(() {
      if (!favorites.any((fav) => fav.id == user.id)) {
        favorites.add(user);
      }
    });
  }

  void removeFromFavorites(String id) {
    setState(() {
      favorites.removeWhere((fav) => fav.id == id);
    });
  }

  void showAddRecipeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Добавить рецепт',
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 20),

                  TextField(
                    controller: _nameController,
                    cursorColor: Colors.black,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      labelText: 'Продукт',
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                    ),
                  ),

                  SizedBox(height: 10),
                  
                  TextField(
                    controller: _textController,
                    cursorColor: Colors.black,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      labelText: 'Описание',
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  TextField(
                    controller: _priceController,
                    cursorColor: Colors.black,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      labelText: 'Цена',
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  TextField(
                    controller: _quantityController,
                    cursorColor: Colors.black,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      labelText: 'Количество',
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Отмена',
                            style: TextStyle(color: Colors.black)),
                      ),

                      SizedBox(width: 10),

                      ElevatedButton(
                        onPressed: isAddingUser ? null : addUser,
                        child: isAddingUser
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text('Добавить'),
                      ),

                    ],
                  ),

                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: SingleChildScrollView(
        child: Column(
          children: [

            SizedBox(height: 50),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                ElevatedButton(
                  onPressed: showAddRecipeDialog,
                  child: Text('Добавить рецепт'),
                ),

                SizedBox(width: 20),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FavoritesPage(
                          favorites: favorites,
                          onRemove: removeFromFavorites,
                        ),
                      ),
                    );
                  },
                  child: Text('Избранное'),
                ),

              ],
            ),

            SizedBox(height: 20),

            Container(
              height: 800,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange),
              ),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return Card(
                          margin: const EdgeInsets.all(8),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [

                                      Text(
                                        user.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      Text(
                                        user.text,
                                        style: const TextStyle(fontSize: 12),
                                        maxLines: 5,
                                        overflow: TextOverflow.visible,
                                      ),

                                    ],
                                  ),
                                ),

                                const SizedBox(width: 30),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Row(
                                      children: [
                                        Text('Количество:',
                                            style: TextStyle(fontSize: 12)),

                                        const SizedBox(width: 10),

                                        Text(
                                          user.quantity,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black),
                                        ),

                                      ],
                                    ),

                                    const SizedBox(height: 4),

                                    Row(
                                      children: [
                                        Text('id:',
                                            style: TextStyle(fontSize: 12)),

                                        const SizedBox(width: 10),

                                        Text(
                                          user.id,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black),
                                        ),

                                      ],
                                    ),

                                    const SizedBox(height: 8),

                                    Row(
                                      children: [
                                        Text(
                                          '\$${user.price}',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),

                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [

                                        IconButton(
                                          icon: const Icon(Icons.favorite_border,
                                              size: 23),
                                          onPressed: () => addToFavorites(user),
                                        ),

                                        const SizedBox(width: 8),

                                        IconButton(
                                          icon: const Icon(Icons.delete, size: 23),
                                          onPressed: () => deleteUser(user.id),
                                        ),

                                      ],
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),

          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: fetchUsers,
        child: Icon(Icons.refresh),
      ),

    );
  }
}

class FavoritesPage extends StatelessWidget {
  final List<User> favorites;
  final Function(String) onRemove;

  const FavoritesPage({required this.favorites, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
        appBar: AppBar(
            backgroundColor: Colors.orange,
            elevation: 0,
            leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
            Navigator.pop(context);
            },
          ),
        ),
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(
                                user.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                user.text,
                                style: const TextStyle(fontSize: 12),
                                maxLines: 5,
                                overflow: TextOverflow.visible,
                              ),

                            ],
                          ),
                        ),

                        const SizedBox(width: 30),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Row(
                              children: [
                                Text('Количество:',
                                    style: TextStyle(fontSize: 12)),

                                const SizedBox(width: 10),

                                Text(
                                  user.quantity,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.black),
                                ),

                              ],
                            ),

                            const SizedBox(height: 4),

                            Row(
                              children: [

                                Text('id:', style: TextStyle(fontSize: 12)),

                                const SizedBox(width: 10),

                                Text(
                                  user.id,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.black),
                                ),

                              ],
                            ),

                            const SizedBox(height: 8),

                            Row(
                              children: [
                                Text(
                                  '\$${user.price}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),

                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                IconButton(
                                  icon: const Icon(Icons.delete, size: 23),
                                  onPressed: () => onRemove(user.id),
                                ),
                                
                              ],
                            ),

                          ],
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
