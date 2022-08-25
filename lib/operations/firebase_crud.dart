import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:date_format/date_format.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

DateTime now = DateTime.now();

DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

class FirebaseCrud {
  Future shaktiCounter() async {
    AndroidDeviceInfo info = await deviceInfo.androidInfo;

    DateTime time = DateTime.now();
    String date = formatDate(time, [dd, mm, yyyy]);

    final _collection = _firestore
        .collection('all_counters')
        .doc(date)
        .collection('shakti_counter')
        .doc(DateTime.now().toString());
    final data = {
      date: {
        "device": info.device,
        "brand": info.brand,
        "manufacturer": info.manufacturer,
        "model": info.model,
        "id": info.id,
        "created_at": DateTime.now(),
      }
    };
    await _collection.set(data);
  }
}
