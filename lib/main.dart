import 'package:flutter/material.dart';

import 'main_with_flow.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomeFlow() ??
          const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final maxNumberOfItems = 4;
  final numberOfItems = 5;
  final itemRadius = 30.0;
  double get itemSize => itemRadius * 2;

  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final width = itemSize * numberOfItems - (itemRadius * (numberOfItems - 1));
    final height = itemSize * numberOfItems;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: SizedBox(
          height: height,
          width: width,
          //color: Colors.red,
          child: Stack(
            children: List.generate(numberOfItems, (index) {
              if (!expanded && index >= maxNumberOfItems) {
                return const SizedBox.shrink();
              }
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                top: expanded ? index * itemSize : 0,
                left: expanded ? 0 : index * itemSize - itemRadius * index,
                child: Container(
                  height: itemSize,
                  width: itemSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      'https://i.pravatar.cc/300?img=$index',
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(
            () {
              expanded = !expanded;
            },
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
