import 'h_error.dart';
import 'geo_point.dart';
import 'geo_polygon.dart';

class BaseRecord {
  Map record;
  String tableName;

  BaseRecord({this.tableName}) {
    recordValueInit();
  }

  void recordValueInit() {
    record = {
      '\$set': new Map<String, dynamic>(),
      '\$unset': new Map<String, dynamic>(),
    };
  }

  /// 给字段赋值
  /// 接收 [arg1] 为 Map<String, dynamic> 的参数。此为一次性赋值。
  /// 或接收 [arg1] 为字符串，[arg2] 为任意值作为参数。此为逐个赋值。
  void set(dynamic arg1, [dynamic arg2]) {
    if (arg2 == null) {
      if (arg1 is Map<String, dynamic>) {
        print('$arg1 is map type');
        record['\$set'] = arg1;
      } else {
        throw HError(605);
      }
    } else if (arg1 is String) {
      print('$arg1 is string type');

      if (arg2 is List<GeoPoint> || arg2 is List<GeoPolygon>) {
        record['\$set'][arg1] = arg2.map((geo) => geo.geoJSON).toList();
      } else if (arg2 is GeoPoint || arg2 is GeoPolygon) {
        record['\$set'][arg1] = arg2.geoJSON;
      } else {
        record['\$set'][arg1] = arg2;
      }
    } else {
      throw HError(605);
    }
  }
}
