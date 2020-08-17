import 'where.dart';
import 'h_error.dart';

class Query {
  int _offset, _limit;
  String _orderBy;
  List<String> _keys, _expand;
  Where _where;

  Query() {
    _initQueryParams();
  }

  void _initQueryParams() {
    _limit = null;
    _offset = 0;
    _orderBy = null;
    _keys = null;
    _expand = null;
  }

  Query offset(int offset) {
    _offset = offset;
    return this;
  }

  Query limit(int limit) {
    _limit = limit;
    return this;
  }

  Query orderBy(String orderBy) {
    _orderBy = orderBy;
    return this;
  }

  Query where(Where where) {
    _where = where;
    return this;
  }

  /// 指定需要展开的 pointer 类型字段
  /// [key] 字段名称
  Query expand(dynamic key) {
    if (key is String) {
      _expand = [key];
    } else if (key is List<String>) {
      _expand = key;
    } else {
      throw HError(605);
    }
    return this;
  }

  Map<String, dynamic> get() {
    Map<String, dynamic> data = {};

    if (_offset != null) data.addAll({'offset': _offset});

    if (_limit != null) data.addAll({'limit': _limit});

    if (_orderBy != null) data.addAll({'order_by': _orderBy});

    if (_expand != null) data.addAll({'expand': _expand.join(',')});

    if (_keys != null) data.addAll({'keys': _keys.join(',')});

    if (_where != null) data.addAll({'where': _where});

    return data;
  }
}
