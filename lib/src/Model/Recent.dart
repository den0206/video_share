import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_share/src/Extension/FirebaseRef.dart';
import 'package:video_share/src/Model/FBUser.dart';

class Recent {
  Recent({
    this.id,
    this.userId,
    this.withUserId,
    this.chatroomId,
    this.lastMessae,
    this.counter,
    this.date,
  });

  String id;
  String userId;
  String withUserId;
  String chatroomId;
  String lastMessae;
  int counter;
  Timestamp date;

  FBUser withUser;

  Recent.fromDocument(DocumentSnapshot document) {
    id = document.id;
    userId = document[RecentKey.userId];
    withUserId = document[RecentKey.withUserId];
    chatroomId = document[RecentKey.chatRoomId];
    lastMessae = document[RecentKey.lastMessae];
    counter = document[RecentKey.counter];
    date = document[RecentKey.date] as Timestamp;
  }

  static Future<String> createPrivateCaht({
    String currentUID,
    String user2Id,
    List<FBUser> users,
  }) async {
    String chatRoomid = "";

    if (currentUID.hashCode <= user2Id.hashCode) {
      chatRoomid = currentUID + user2Id;
    } else {
      chatRoomid = user2Id + currentUID;
    }

    final List<String> userIds = [currentUID, user2Id];
    var tempMembers = userIds;

    QuerySnapshot query = await firebaseRef(FirebaseRef.recent)
        .where(RecentKey.chatRoomId, isEqualTo: chatRoomid)
        .get();

    if (query.docs.isNotEmpty) {
      for (QueryDocumentSnapshot recent in query.docs) {
        final currentRecent = recent.data();
        final String currentUid = currentRecent[RecentKey.userId] ?? "";

        if (userIds.contains(currentUid) && currentUid != "") {
          tempMembers.remove(currentUid);
        }
      }
    }

    print(tempMembers);
    for (String userId in tempMembers) {
      Recent.recentToFireStore(
        userId: userId,
        currentUID: currentUID,
        chatRoomId: chatRoomid,
        users: users,
      );
    }

    return chatRoomid;
  }

  static recentToFireStore({
    String userId,
    String currentUID,
    String chatRoomId,
    List<FBUser> users,
  }) {
    final ref = firebaseRef(FirebaseRef.recent).doc();
    final recentId = ref.id;

    FBUser withUser;
    if (userId == currentUID) {
      withUser = users.last;
    } else {
      withUser = users.first;
    }

    Map<String, dynamic> value = {
      RecentKey.id: recentId,
      RecentKey.userId: userId,
      RecentKey.chatRoomId: chatRoomId,
      RecentKey.withUserId: withUser.uid,
      RecentKey.lastMessae: "",
      RecentKey.counter: 0,
      RecentKey.date: Timestamp.now()
    };

    ref.set(value);
  }
}

class RecentKey {
  static final id = "id";
  static final userId = "userId";
  static final chatRoomId = "chatRoomId";
  static final withUserId = "withUserId";
  static final lastMessae = "lastMessae";
  static final counter = "counter";
  static final date = "date";
}
