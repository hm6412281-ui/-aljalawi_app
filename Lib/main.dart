import 'package:flutter/material.dart';

void main() {
  runApp(AlJalawiApp());
}

class AlJalawiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'الجلوي للمنظفات',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: InventoryPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final List<Map<String, dynamic>> products = [];
  final nameController = TextEditingController();
  final buyPriceController = TextEditingController();
  final sellPriceController = TextEditingController();

  void addProduct() {
    final String name = nameController.text;
    final double buy = double.tryParse(buyPriceController.text) ?? 0;
    final double sell = double.tryParse(sellPriceController.text) ?? 0;

    if (name.isNotEmpty && buy > 0 && sell > 0) {
      setState(() {
        products.add({
          'name': name,
          'buy': buy,
          'sell': sell,
          'profit': sell - buy,
          'sold': 0,
        });
      });
      nameController.clear();
      buyPriceController.clear();
      sellPriceController.clear();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الجلوي للمنظفات'),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
      ),
      body: products.isEmpty
          ? Center(child: Text('لا توجد منتجات مضافة حالياً'))
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (ctx, index) {
                return Card(
                  margin: EdgeInsets.all(10),
                  elevation: 5,
                  child: ListTile(
                    title: Text(products[index]['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('شراء: ${products[index]['buy']} ج.م | بيع: ${products[index]['sell']} ج.م'),
                        Text('الربح: ${products[index]['profit']} ج.م', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          products[index]['sold']++;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('تم تسجيل بيع قطعة من ${products[index]['name']}')),
                        );
                      },
                      child: Text('بيع قطعة'),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProductDialog(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.blue[800],
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('إضافة منتج جديد'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: 'اسم المنتج')),
            TextField(controller: buyPriceController, decoration: InputDecoration(labelText: 'سعر الشراء'), keyboardType: TextInputType.number),
            TextField(controller: sellPriceController, decoration: InputDecoration(labelText: 'سعر البيع'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text('إلغاء')),
          ElevatedButton(onPressed: addProduct, child: Text('حفظ')),
        ],
      ),
    );
  }
}
