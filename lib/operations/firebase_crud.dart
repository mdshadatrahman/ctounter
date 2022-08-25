import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:intl/intl.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

DateTime now = DateTime.now();
String onlyDate = DateFormat.yMMMd().format(now);

DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

class FirebaseCrud {
  Future shaktiCounter() async {
    print("Called0");

    final _collection =
        _firestore.collection('shakti_counter').doc(DateTime.now().toString());
    AndroidDeviceInfo info = await deviceInfo.androidInfo;
    final data = {
      onlyDate: {
        "device": info.device,
        "brand": info.brand,
        "manufacturer": info.manufacturer,
        "model": info.model,
        "id": info.id,
        "created_at": DateTime.now(),
      }
    };
    await _collection.set(data);
    print("Called");
  }

  Future<void> sokaleRannaKoreDeycounter() async {
    final CollectionReference _collection =
        _firestore.collection('ranna_counter');
    AndroidDeviceInfo info = await deviceInfo.androidInfo;
    await _collection.add({
      onlyDate: {
        "device": info.device,
        "brand": info.brand,
        "manufacturer": info.manufacturer,
        "model": info.model,
        "id": info.id,
        "version": info.version
      }
    });
  }
}
