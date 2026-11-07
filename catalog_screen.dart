import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../providers/cart_provider.dart';
import '../providers/theme_provider.dart';
import 'cart_screen.dart';

class CatalogScreen extends StatelessWidget {
   CatalogScreen({super.key});

  final List<Book> dummyBooks = [
    Book(
      id: '1',
      title: 'Pemrograman Flutter & Dart',
      author: 'Alfian',
      price: 120000,
      imageUrl: 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=300',
    ),
    Book(
      id: '2',
      title: 'Algoritma & Struktur Data',
      author: 'Tim IT Sukabumi',
      price: 95000,
      imageUrl: 'https://images.unsplash.com/photo-1516116216624-53e697fedbea?w=300',
    ),
    Book(
      id: '3',
      title: 'Sistem Administrasi SAP',
      author: 'Claudia Florita',
      price: 150000,
      imageUrl: 'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?w=300',
    ),
    Book(
      id: '4',
      title: 'Cloud Computing Dasar (AWS)',
      author: 'Cloud Academy',
      price: 135000,
      imageUrl: 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=300',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('NusaBookstore Katalog'),
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
          Consumer<CartProvider>(
            builder: (context, cart, child) => Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CartScreen()),
                    );
                  },
                ),
                if (cart.totalItems > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${cart.totalItems}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: dummyBooks.length,
        itemBuilder: (context, index) {
          final book = dummyBooks[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: Image.network(book.imageUrl, width: 50, fit: BoxFit.cover),
              title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${book.author}\nRp ${book.price.toStringAsFixed(0)}'),
              isThreeLine: true,
              trailing: ElevatedButton(
                onPressed: () {
                  context.read<CartProvider>().addItem(book);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${book.title} ditambahkan ke keranjang')),
                  );
                },
                child: const Text('Tambah'),
              ),
            ),
          );
        },
      ),
    );
  }
}