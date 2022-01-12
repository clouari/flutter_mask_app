import 'package:flutter_mask_app/model/mask_stores.dart';

class MaskApi {
  int? count;
  List<MaskStores>? stores;

  MaskApi({this.count, this.stores});

  MaskApi.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['stores'] != null) {
      stores = <MaskStores>[];
      json['stores'].forEach((v) {
        stores!.add(MaskStores.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (stores != null) {
      data['stores'] = stores!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
