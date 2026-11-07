import 'package:flutter/foundation.dart';
import '../models/book.dart';

class CartItem {
  final Book book;
  int quantity;

  CartItem({required this.book, this.quantity = 1});
}

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get totalItems {
    return _items.values.fold(0, (sum, item) => sum + item.quantity);
  }

  double get totalPrice {
    return _items.values.fold(
      0.0,
      (sum, item) => sum + (item.book.price * item.quantity),
    );
  }

  void addItem(Book book) {
    if (_items.containsKey(book.id)) {
      _items.update(
        book.id,
        (existingItem) => CartItem(
          book: existingItem.book,
          quantity: existingItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        book.id,
        () => CartItem(book: book, quantity: 1),
      );
    }
    notifyListeners();
  }

  void removeItem(String bookId) {
    if (!_items.containsKey(bookId)) return;
    
    if (_items[bookId]!.quantity > 1) {
      _items.update(
        bookId,
        (existingItem) => CartItem(
          book: existingItem.book,
          quantity: existingItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(bookId);
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}