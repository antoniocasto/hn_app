library serializers;

import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'article.dart';

part 'package:hn_app/src/serializers.g.dart';

@SerializersFor(const [
  Article,
])
Serializers serializers = _$serializers;

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(new StandardJsonPlugin())).build();
