class AreaResponse {
  List<Area>? areas;

  AreaResponse({this.areas});

  AreaResponse.fromJson(Map<String, dynamic> json) {
    if (json['areas'] != null) {
      areas = <Area>[];
      json['areas'].forEach((v) {
        areas!.add(Area.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (areas != null) {
      data['areas'] = areas!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Area {
  String? idArea;
  String? strArea;
  String? strAreaDescription;
  String? strAreaThumb;

  Area({
    this.idArea,
    this.strArea,
    this.strAreaDescription,
    this.strAreaThumb,
  });

  Area.fromJson(Map<String, dynamic> json) {
    idArea = json['idArea'];
    strArea = json['strArea'];
    strAreaDescription = json['strAreaDescription'];
    strAreaThumb = json['strAreaThumb'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idArea'] = idArea;
    data['strArea'] = strArea;
    data['strAreaDescription'] = strAreaDescription;
    data['strAreaThumb'] = strAreaThumb;
    return data;
  }
}
