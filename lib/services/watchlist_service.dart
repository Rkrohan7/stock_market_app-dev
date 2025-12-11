import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/watchlist_model.dart';

class WatchlistService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all watchlists for user
  Future<List<WatchlistModel>> getWatchlists(String userId) async {
    try {
      // Query without ordering to avoid composite index requirement
      final snapshot = await _firestore
          .collection('watchlists')
          .where('userId', isEqualTo: userId)
          .get();

      final watchlists = snapshot.docs
          .map((doc) => WatchlistModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      // Sort locally by createdAt descending
      watchlists.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return watchlists;
    } catch (e) {
      // Return empty list on error
      return [];
    }
  }

  // Stream watchlists
  Stream<List<WatchlistModel>> streamWatchlists(String userId) {
    return _firestore
        .collection('watchlists')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final watchlists = snapshot.docs
              .map((doc) => WatchlistModel.fromJson({...doc.data(), 'id': doc.id}))
              .toList();
          // Sort locally by createdAt descending
          watchlists.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return watchlists;
        });
  }

  // Get single watchlist
  Future<WatchlistModel?> getWatchlist(String watchlistId) async {
    final doc = await _firestore.collection('watchlists').doc(watchlistId).get();
    if (doc.exists) {
      return WatchlistModel.fromJson({...doc.data()!, 'id': doc.id});
    }
    return null;
  }

  // Create new watchlist
  Future<String> createWatchlist(String odersId, String name) async {
    final docRef = await _firestore.collection('watchlists').add({
      'userId': odersId,
      'name': name,
      'items': [],
      'createdAt': Timestamp.now(),
    });
    return docRef.id;
  }

  // Delete watchlist
  Future<void> deleteWatchlist(String watchlistId) async {
    await _firestore.collection('watchlists').doc(watchlistId).delete();
  }

  // Rename watchlist
  Future<void> renameWatchlist(String watchlistId, String newName) async {
    await _firestore.collection('watchlists').doc(watchlistId).update({
      'name': newName,
      'updatedAt': Timestamp.now(),
    });
  }

  // Add stock to watchlist
  Future<void> addToWatchlist(String watchlistId, WatchlistItem item) async {
    await _firestore.collection('watchlists').doc(watchlistId).update({
      'items': FieldValue.arrayUnion([item.toJson()]),
      'updatedAt': Timestamp.now(),
    });
  }

  // Remove stock from watchlist
  Future<void> removeFromWatchlist(String watchlistId, String symbol) async {
    final doc = await _firestore.collection('watchlists').doc(watchlistId).get();
    if (!doc.exists) return;

    final items = (doc.data()?['items'] as List?) ?? [];
    items.removeWhere((item) => item['symbol'] == symbol);

    await _firestore.collection('watchlists').doc(watchlistId).update({
      'items': items,
      'updatedAt': Timestamp.now(),
    });
  }

  // Check if stock is in any watchlist
  Future<bool> isInWatchlist(String odersId, String symbol) async {
    final watchlists = await getWatchlists(odersId);
    for (final watchlist in watchlists) {
      if (watchlist.containsStock(symbol)) {
        return true;
      }
    }
    return false;
  }

  // Get default watchlist (create if not exists)
  Future<WatchlistModel> getOrCreateDefaultWatchlist(String odersId) async {
    final watchlists = await getWatchlists(odersId);

    if (watchlists.isNotEmpty) {
      return watchlists.first;
    }

    // Create default watchlist
    final id = await createWatchlist(odersId, 'My Watchlist');
    return WatchlistModel(
      id: id,
      userId: odersId,
      name: 'My Watchlist',
      items: [],
      createdAt: DateTime.now(),
    );
  }

  // Update watchlist item prices
  Future<void> updateWatchlistPrices(
    String watchlistId,
    Map<String, Map<String, double>> priceData,
  ) async {
    final doc = await _firestore.collection('watchlists').doc(watchlistId).get();
    if (!doc.exists) return;

    final items = (doc.data()?['items'] as List?) ?? [];
    final updatedItems = <Map<String, dynamic>>[];

    for (final item in items) {
      final symbol = item['symbol'] as String;
      final data = priceData[symbol];

      if (data != null) {
        updatedItems.add({
          ...item,
          'currentPrice': data['currentPrice'],
          'change': data['change'],
          'changePercent': data['changePercent'],
        });
      } else {
        updatedItems.add(item);
      }
    }

    await _firestore.collection('watchlists').doc(watchlistId).update({
      'items': updatedItems,
      'updatedAt': Timestamp.now(),
    });
  }
}
