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

  Future<bool> updateToken({required String token}) async {
    log.i('token:$token');
    try {
      final tokenDocument = tokenCollection.doc(tokenDocId);
      await tokenDocument.set({"token": token});
      log.v('token added at ${tokenDocument.path}');
      return true;
    } catch (error) {
      log.e("Error $error");
      return false;
    }
  }

  Future<String?> getToken() async {
    final tokenDoc = await tokenCollection.doc(tokenDocId).get();
    if (!tokenDoc.exists) {
      log.v('We have no token in our database');
      return null;
    }

    final tokenData = tokenDoc.data();
    log.v('User found. Data: $tokenData');

    return (tokenData! as Map<String, dynamic>)['token'];
  }

  /// Saves the address passed in to the backend for the user and also sets
  /// the default address if the user doesn't have one set.
  /// Returns true if no errors occured
  /// Returns false for any error at any part of the process
  // Future<bool> saveAddress({
  //   required Address address,
  //   required User user,
  // }) async {
  //   log.i('address:$address');
  //
  //   try {
  //     final addressDoc = getAddressCollectionForUser(user.id).doc();
  //     final newAddressId = addressDoc.id;
  //     log.v('Address will be stored with id: $newAddressId');
  //
  //     await addressDoc.set(
  //       address.copyWith(id: newAddressId).toJson(),
  //     );
  //
  //     final hasDefaultAddress = user.hasAddress;
  //
  //     log.v('Address save complete. hasDefaultAddress:$hasDefaultAddress');
  //
  //     if (!hasDefaultAddress) {
  //       log.v(
  //           'This user has no default address. We need to set the current one as default');
  //
  //       await usersCollection.doc(user.id).set(
  //             user.copyWith(defaultAddress: newAddressId).toJson(),
  //           );
  //       log.v('User ${user.id} defaultAddress set to $newAddressId');
  //     }
  //
  //     return true;
  //   } on Exception catch (e) {
  //     log.e('we could not save the users address. $e');
  //     return false;
  //   }
  // }

  // Future<bool> isCityServiced({required String city}) async {
  //   log.i('city:$city');
  //   final cityDocument = await regionsCollection.doc(city).get();
  //   return cityDocument.exists;
  // }
  //
  // CollectionReference getAddressCollectionForUser(String userId) {
  //   return usersCollection.doc(userId).collection(AddressesFirestoreKey);
  // }

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
