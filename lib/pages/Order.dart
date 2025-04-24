import 'package:flutter/material.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
   List<String> items=[];
  Future<void> _openListInputDialog() async {
    List<String> tempList = [];

    await showDialog(
      context: context,
      builder: (context) {
        TextEditingController tempController = TextEditingController();
        return AlertDialog(
          title: Text('Enter Items'),
          content: StatefulBuilder(
            builder: (context, setState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: tempController),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      tempList.add(tempController.text);
                      tempController.clear();
                    });
                  },
                  child: Text('Add'),
                ),
                SizedBox(height: 10),
                Wrap(
                  children: tempList.map((e) => Chip(label: Text(e))).toList(),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  items = tempList;
                });
              },
              child: Text('Done'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child:ElevatedButton(
          onPressed: _openListInputDialog,
          child: Text('Add List'),
        )
        ,
      ),
    );

  }
}
