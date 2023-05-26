import 'package:ai_triad/models/travelModes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ai_triad/app/app.logger.dart';
import 'package:ai_triad/constants/app_keys.dart';
import 'package:ai_triad/models/appuser.dart';

import '../models/hotel.dart';
import '../models/trip.dart';

const tokenDocId = "doctor_token";

class FirestoreService {
  final log = getLogger('FirestoreApi');

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection(UsersFirestoreKey);
  final CollectionReference tokenCollection =
      FirebaseFirestore.instance.collection(TokenFirestoreKey);

  // final CollectionReference regionsCollection = FirebaseFirestore.instance.collection(RegionsFirestoreKey);

  Future<bool> createUser({required AppUser user, required keyword}) async {
    log.i('user:$user');
    try {
      final userDocument = usersCollection.doc(user.id);
      await userDocument.set(user.toJson(keyword));
      log.v('UserCreated at ${userDocument.path}');
      return true;
    } catch (error) {
      log.e("Error $error");
      return false;
    }
  }

  Future<AppUser?> getUser({required String userId}) async {
    log.i('userId:$userId');

    if (userId.isNotEmpty) {
      final userDoc = await usersCollection.doc(userId).get();
      if (!userDoc.exists) {
        log.v('We have no user with id $userId in our database');
        return null;
      }

      final userData = userDoc.data();
      log.v('User found. Data: $userData');

      return AppUser.fromData(userData! as Map<String, dynamic>);
    } else {
      log.e("Error no user");
      return null;
    }
  }

  final CollectionReference _hotelsCollectionRef =
      FirebaseFirestore.instance.collection('Hotels');

  Future<void> addHotelData(HotelData hotelData) async {
    try {
      await _hotelsCollectionRef.add(hotelData.toMap());
    } catch (e) {
      log.e(e);
      rethrow;
    }
  }

  final CollectionReference _travelModesCollectionRef =
      FirebaseFirestore.instance.collection('TravelModes');

  Future<void> addTravelModes(TravelMode travelMode) async {
    try {
      await _travelModesCollectionRef.add(travelMode.toMap());
    } catch (e) {
      log.e(e);
      rethrow;
    }
  }

  Future<List<HotelData>> queryHotels(
      {required String to, required String type}) async {
    try {
      QuerySnapshot querySnapshot = await _hotelsCollectionRef
          .where('state', isEqualTo: to)
          .where('type', isEqualTo: type)
          .get();

      if (querySnapshot.size == 0) {
        querySnapshot = await _hotelsCollectionRef
            .where('place', isEqualTo: to)
            .where('type', isEqualTo: type)
            .get();
      }

      return querySnapshot.docs.map((DocumentSnapshot doc) {
        return HotelData.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      // Handle the error
      log.e('Error querying hotels: $e');
      throw Exception('Failed to query hotels');
    }
  }

  Future<List<TravelMode>> queryTravelModes({
    required String from,
    required String to,
    required String type,
  }) async {
    try {
      QuerySnapshot querySnapshot = await _travelModesCollectionRef
          .where('fromState', isEqualTo: from)
          .where('toState', isEqualTo: to)
          .where('type', isEqualTo: type)
          .get();

      if (querySnapshot.size == 0) {
        querySnapshot = await _travelModesCollectionRef
            .where('fromState', isEqualTo: from)
            .where('place', isEqualTo: to)
            .where('type', isEqualTo: type)
            .get();
      }

      return querySnapshot.docs.map((DocumentSnapshot doc) {
        return TravelMode.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      // Handle the error
      log.e('Error querying travel modes: $e');
      throw Exception('Failed to query travel modes');
    }
  }

  final CollectionReference _tripsCollectionRef =
      FirebaseFirestore.instance.collection('trips');

  Future<void> addTrip(Trip trip) async {
    try {
      final tripMap = trip.toMap();
      await _tripsCollectionRef.add(tripMap);
      log.i('Trip document added to Firestore');
    } catch (e) {
      log.i('Error adding trip document to Firestore: $e');
      // Handle the error accordingly
    }
  }

  Future<List<Trip>> fetchUserTrips(String userId) async {
    try {
      final querySnapshot =
          await _tripsCollectionRef.where('userId', isEqualTo: userId).get();

      final trips = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Trip.fromMap(doc.id, data as Map<String, dynamic>);
      }).toList();

      return trips;
    } catch (e) {
      // Handle any errors that occurred during the fetch
      log.e('Error fetching user trips: $e');
      return [];
    }
  }
}
