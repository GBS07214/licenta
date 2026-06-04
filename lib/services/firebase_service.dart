import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/activity.dart';
import '../models/baby_profile.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signUp(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> saveBabyProfile(BabyProfile profile) async {
    final userId = currentUser?.uid;
    if (userId == null) throw Exception('User not logged in');
    await _firestore.collection('users').doc(userId).collection('profile').doc('baby').set(profile.toMap());
  }

  Future<BabyProfile?> getBabyProfile() async {
    final userId = currentUser?.uid;
    if (userId == null) return null;
    final doc = await _firestore.collection('users').doc(userId).collection('profile').doc('baby').get();
    if (!doc.exists) return null;
    return BabyProfile.fromMap('baby', doc.data()!);
  }

  Future<void> saveActivity(Activity activity) async {
    final userId = currentUser?.uid;
    if (userId == null) throw Exception('User not logged in');
    await _firestore.collection('users').doc(userId).collection('activities').add(activity.toMap());
  }

  Stream<List<Activity>> getActivitiesStream(int days) {
    final userId = currentUser?.uid;
    if (userId == null) return Stream.value([]);
    final startDate = DateTime.now().subtract(Duration(days: days));
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('activities')
        .where('timestamp', isGreaterThan: startDate.toIso8601String())
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Activity.fromMap(doc.id, doc.data())).toList());
  }

  Stream<List<Activity>> getActivitiesByType(ActivityType type, int days) {
    final userId = currentUser?.uid;
    if (userId == null) return Stream.value([]);
    final startDate = DateTime.now().subtract(Duration(days: days));
    final typeString = type.toString().split('.').last;
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('activities')
        .where('type', isEqualTo: typeString)
        .where('timestamp', isGreaterThan: startDate.toIso8601String())
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Activity.fromMap(doc.id, doc.data())).toList());
  }
}
