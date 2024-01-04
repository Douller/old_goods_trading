class Address {
  String type;
  List<double> query;
  List<Feature> features;
  String attribution;

  Address({
    required this.type,
    required this.query,
    required this.features,
    required this.attribution,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      type: json['type'],
      query: List<double>.from(json['query'].map((value) => value.toDouble())),
      features: List<Feature>.from(json['features'].map((feature) => Feature.fromJson(feature))),
      attribution: json['attribution'],
    );
  }
}

class Feature {
  String id;
  String type;
  List<String> placeType;
  double relevance;
  Properties properties;
  String textEn;
  String placeNameEn;
  String text;
  String placeName;
  List<double> bbox;
  List<double> center;
  Geometry geometry;
  List<Context> context;

  Feature({
    required this.id,
    required this.type,
    required this.placeType,
    required this.relevance,
    required this.properties,
    required this.textEn,
    required this.placeNameEn,
    required this.text,
    required this.placeName,
    required this.bbox,
    required this.center,
    required this.geometry,
    required this.context,
  });

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      id: json['id'],
      type: json['type'],
      placeType: List<String>.from(json['place_type'].map((value) => value)),
      relevance: json['relevance'].toDouble(),
      properties: Properties.fromJson(json['properties']),
      textEn: json['text_en'],
      placeNameEn: json['place_name_en'],
      text: json['text'],
      placeName: json['place_name'],
      bbox: List<double>.from(json['bbox'].map((value) => value.toDouble())),
      center: List<double>.from(json['center'].map((value) => value.toDouble())),
      geometry: Geometry.fromJson(json['geometry']),
      context: List<Context>.from(json['context'].map((context) => Context.fromJson(context))),
    );
  }
}

class Properties {
  String? foursquare;
  bool? landmark;
  String? address;
  String? category;
  String? maki;

  Properties({
    this.foursquare,
    this.landmark,
    this.address,
    this.category,
    this.maki,
  });

  factory Properties.fromJson(Map<String, dynamic> json) {
    return Properties(
      foursquare: json['foursquare'],
      landmark: json['landmark'],
      address: json['address'],
      category: json['category'],
      maki: json['maki'],
    );
  }
}

class Geometry {
  String type;
  List<double> coordinates;

  Geometry({
    required this.type,
    required this.coordinates,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      type: json['type'],
      coordinates: List<double>.from(json['coordinates'].map((value) => value.toDouble())),
    );
  }
}

class Context {
  String id;
  String mapboxId;
  String? wikidata;
  String textEn;
  String text;
  String? languageEn;
  String? language;

  Context({
    required this.id,
    required this.mapboxId,
    this.wikidata,
    required this.textEn,
    required this.text,
    this.languageEn,
    this.language,
  });

  factory Context.fromJson(Map<String, dynamic> json) {
    return Context(
      id: json['id'],
      mapboxId: json['mapbox_id'],
      wikidata: json['wikidata'],
      textEn: json['text_en'],
      text: json['text'],
      languageEn: json['language_en'],
      language: json['language'],
    );
  }
}
