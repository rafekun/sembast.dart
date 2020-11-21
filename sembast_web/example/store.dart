import 'dart:html';

import 'package:meta/meta.dart';
import 'package:sembast_web/sembast_web.dart';

import 'common.dart';

late Database db;
var factory = databaseFactoryWeb;

Future main() async {
  await run(dbName: 'sembast_web_example_store', store: null);
}

Future run({required String dbName, required String store}) async {
  var dateStore = StoreRef<int, String>(store);

  db = await factory.openDatabase(dbName);
  write('hello');

  dateStore.query().onSnapshots(db).listen((snapshots) {
    write('onSnapshots: ${snapshots?.length} item(s)');
    snapshots.forEach((snapshot) {
      write('[${snapshot.key}]: ${snapshot.value}');
    });
  });

  querySelector('#add')!.onClick.listen((_) async {
    var key = await dateStore.add(db, DateTime.now().toIso8601String());
    write('add now $key');
  });
  querySelector('#delete')!.onClick.listen((_) async {
    write('deleting...');
    await dateStore.delete(db);
  });
}
