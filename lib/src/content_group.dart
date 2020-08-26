import 'package:dio/dio.dart';
import 'h_error.dart';
import 'request.dart';
import 'constants.dart';
import 'query.dart';
import 'where.dart';

class ContentGroup {
  int _contentGroupID;
  Map<String, dynamic> _data = {};

  ContentGroup(int contentGroupID) {
    _contentGroupID = contentGroupID;
  }

  ContentGroup.withInfo(this._data); // 获取内容库详情

  int get id => _data['id'];
  String get name => _data['name'];

  /// 获取内容库列表
  /// [withCount] 是否返回 total_count
  /// [offset] 偏移量
  /// [limit] 最大返回条数
  static Future<ContentList> find({
    bool withCount = true,
    int offset = 0,
    int limit = 20,
  }) async {
    Response response = await request(
      path: Api.contentGroupList,
      method: 'GET',
      data: {
        'offset': offset,
        'limit': limit,
        'return_total_count': withCount ? 1 : 0
      },
    );

    return ContentList(response.data);
  }

  /// 获取内容库详情
  /// [contentGroupID] 内容库 ID
  static Future<ContentGroup> get(int contentGroupID) async {
    Response response = await request(
      path: Api.contentGroupDetail,
      method: 'GET',
      params: {
        'contentGroupID': contentGroupID,
      },
    );

    return ContentGroup.withInfo(response.data);
  }

  /// 获取内容
  /// [richTextID] 内容 ID
  /// [select] 筛选字段
  /// [expand] 扩展字段
  Future<Content> getContent(
    int richTextID, {
    dynamic select,
    dynamic expand,
  }) async {
    Map<String, dynamic> data = {};

    if (select != null) {
      if (select is String) {
        data['keys'] = select;
      } else if (select is List<String>) {
        data['keys'] = select.join(',');
      } else {
        throw HError(605);
      }
    }

    if (expand != null) {
      if (expand is String) {
        data['expand'] = expand;
      } else if (expand is List<String>) {
        data['expand'] = expand.join(',');
      } else {
        throw HError(605);
      }
    }

    Response response = await request(
      path: Api.contentDetail,
      method: 'GET',
      params: {'richTextID': richTextID},
      data: data,
    );

    return Content(response.data);
  }

  /// 获取内容库列表
  /// [query] 查询条件
  /// [withCount] 是否返回 total_count
  Future<ContentList> query({
    Query query,
    bool withCount = false,
  }) async {
    Map<String, dynamic> data = {
      'return_total_count': withCount ? 1 : 0,
      'content_group_id': _contentGroupID,
    };

    if (query != null) {
      Map<String, dynamic> queryData = query.get();

      queryData.forEach((key, value) {
        if (value != null) {
          if (value is Where) {
            data[key] = value.get();
          } else {
            data[key] = value;
          }
        }
      });
    }

    Response response = await request(
      path: Api.contentList,
      method: 'GET',
      data: data,
    );

    return ContentList(response.data);
  }

  /// 获取数据记录数量
  /// [query] 查询条件
  Future<int> count({Query query}) async {
    query = query != null ? query : new Query();
    query.limit(1);
    ContentList data = await this.query(query: query, withCount: true);

    int count = data.totalCount;
    return count;
  }

  /// 获取分类详情
  /// [categoryID] 分类 ID
  Future<ContentCategory> getCategory(int categoryID) async {
    Where where = Where.compare('group_id', '=', _contentGroupID);

    Response response = await request(
      path: Api.contentCategoryDetail,
      method: 'GET',
      params: {
        'categoryID': categoryID,
      },
      data: {
        'where': where.get(),
      },
    );

    return ContentCategory(response.data);
  }

  /// 获取内容分类列表
  Future<ContentCategoryList> getCategoryList({bool withCount = false}) async {
    Response response = await request(
      path: Api.contentCategoryList,
      method: 'GET',
      data: {
        'content_group_id': _contentGroupID,
        'limit': 100,
        'return_total_count': withCount ? 1 : 0
      },
    );

    return ContentCategoryList(response.data);
  }
}

// 内容详情 get content 使用
class Content {
  Map<String, dynamic> _data;

  Content(this._data);

  List<int> get categories => _data['categories'];
  String get content => _data['content'];
  String get cover => _data['cover'];
  int get createdAt => _data['created_at'];
  int get createdBy => _data['created_by'];
  String get description => _data['description'];
  int get groupId => _data['group_id'];
  int get id => _data['id'];
  String get title => _data['title'];
  int get updateAt => _data['update_at'];
  int get visitCount => _data['visit_count'];
}

// 内容库列表
class ContentList {
  Map<String, dynamic> _data;
  ContentList(this._data);

  int get limit => _data['meta']['limit'];
  int get offset => _data['meta']['offset'];
  int get totalCount => _data['meta']['total_count'];
  String get next => _data['meta']['next'];
  String get revious => _data['meta']['previous'];
  List get contents => _data['objects'];
}

//
class ContentCategory {
  Map<String, dynamic> _data;
  ContentCategory(this._data);

  List get children => _data['children'];
  bool get haveChildren => _data['have_children'];
  int get id => _data['id'];
  String get name => _data['name'];
}

class ContentCategoryList extends ContentList {
  Map<String, dynamic> _data;
  ContentCategoryList(this._data):super(_data);
}
