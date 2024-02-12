import 'dart:typed_data';

import 'package:firebase/shops_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(FirebaseApp());
}

class FirebaseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopping List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FirebaseAppScreen(),
    );
  }
}

class FirebaseAppScreen extends StatefulWidget {
  State<FirebaseAppScreen> createState() => _FirebaseAppScreenState();
}

class _FirebaseAppScreenState extends State<FirebaseAppScreen> {

  final storage = FirebaseStorage.instance;
  late CollectionReference<ShopsList> _shopsList;
  final _nameController = TextEditingController();
  final _costController = TextEditingController();

  Uint8List? backgroundImageBytes;

  @override
  void initState() {
    super.initState();
    loadImageFromFirebaseStorage();

    _shopsList = FirebaseFirestore.instance.collection('shops_list').withConverter<ShopsList>(
        fromFirestore: (snapshot, _) => ShopsList.fromJson(snapshot.data()!),
        toFirestore: (shop_list, _) => shop_list.toJson()
    );
  }

  Future<void> loadImageFromFirebaseStorage() async {
    try {
      final ref = FirebaseStorage.instance.ref().child('fon-v-stile-tekhno-5[1].webp');
      final downloadData = await ref.getData();
      setState(() {
        backgroundImageBytes = downloadData;
      });
    } catch (e) {
      print('Failed to load image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase: Мои покупки'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: MemoryImage(backgroundImageBytes!),
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder<List<ShopsList>>(
          stream: _shopsList.snapshots().map((e) => e.docs.map((e) => e.data()).toList()),
          builder: (context, snapshot) => ListView(
            children: snapshot.hasData
                ? snapshot.data!
                .map((e) => ListTile(
              leading: Text(e.name),
              trailing: Text('${e.cost}\$'),
            )).toList()
                : [],
          ),
        ),
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
          content: Container(
            height: 200,
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(hintText: 'Введите название'),
                ),
                TextField(
                  controller: _costController,
                  decoration: InputDecoration(hintText: 'Введите цену'),
                )
              ],
            ),
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
                _shopsList.add(
                  ShopsList(name: _nameController.text.trim(), cost: int.parse(_costController.text))
                );
                Navigator.of(context).pop();
              },
              child: Text('Добавить'),
            ),
          ],
        );
      },
    );
  }

}