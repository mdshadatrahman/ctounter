import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:intl/intl.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _collection = _firestore.collection('counters');

DateTime now = DateTime.now();
String onlyDate = DateFormat.yMMMd().format(now);

DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

class FirebaseCrud {
  Future<void> counterPlusPlus() async {
    AndroidDeviceInfo info = await deviceInfo.androidInfo;
    print(info.device);
    await _collection.add({onlyDate: info.device});
  }
}
