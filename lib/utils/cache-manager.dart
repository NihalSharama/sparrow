// ignore: file_names
import 'dart:convert';

import 'package:flutter/material.dart';
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

  saveChatConversations(conversations) {
    // auth cards contain token and refresh token
    db
        .collection('chat-conversations')
        .doc('chat-conversations')
        .set({'conversations': conversations});
  }

  getChatConversations() async {
    final authCards = await db
        .collection('chat-conversations')
        .doc('chat-conversations')
        .get();

    if (authCards == null) {
      return;
    }
    return authCards;
  }

  removeChatConversations() async {
    await db
        .collection('chat-conversations')
        .doc('chat-conversations')
        .delete();
  }

  getContacts() async {
    var constacts =
        await db.collection('user-contacts').doc('user-contacts').get();

    if (constacts == null) {
      return;
    }

    var constactsJson = json.encode(constacts['contacts']);

    return json.decode(constactsJson);
  }

  removeContacts() async {
    await db.collection('user-contacts').doc('user-contacts').delete();
  }

  saveContacts(contacts) {
    // auth cards contain token and refresh token
    db
        .collection('user-contacts')
        .doc('user-contacts')
        .set({'contacts': contacts});
  }
}
