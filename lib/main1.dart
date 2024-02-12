import 'package:flutter/material.dart';

void main() {
  runApp(ShoppingListApp());
}

class ShoppingListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ShoppingListScreen(),
    );
  }
}

class ShoppingListScreen extends StatefulWidget {
  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final List<ShoppingItem> _shoppingItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Мои покупки'),
      ),
      body: ListView.builder(
        itemCount: _shoppingItems.length,
        itemBuilder: (context, index) {
          final item = _shoppingItems[index];
          return ListTile(
            title: Text(item.name),
            trailing: Checkbox(
              value: item.isBought,
              onChanged: (value) {
                setState(() {
                  item.isBought = value!;
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addItem(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _addItem(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Добавить покупку'),
          content: TextField(
            controller: _textEditingController,
            decoration: InputDecoration(hintText: 'Введите название'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final itemName = _textEditingController.text.trim();
                if (itemName.isNotEmpty) {
                  setState(() {
                    _shoppingItems.add(ShoppingItem(name: itemName, isBought: false));
                  });
                  _textEditingController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: Text('Добавить'),
            ),
          ],
        );
      },
    );
  }
}

class ShoppingItem {
  final String name;
  bool isBought;

  ShoppingItem({required this.name, required this.isBought});
}