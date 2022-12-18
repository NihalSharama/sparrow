// ignore: file_names
import 'package:localstore/localstore.dart';

class CacheStorage {
  final db = Localstore.instance;

  saveAuthCards(cards) {
    // auth cards contain token and refresh token
    db.collection('auth-cards').doc('auth-cards').set(cards);
  }

  getAuthCards() async {
    final authCards = await db.collection('auth-cards').doc('auth-cards').get();

    if (authCards == null) {
      return;
    }
    return authCards;
  }

  removeAuthCards() async {
    await db.collection('auth-cards').doc('auth-cards').delete();
  }
}
