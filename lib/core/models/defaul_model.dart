// To parse this JSON data, do
//
//     final defaultModel = defaultModelFromJson(jsonString);
import 'dart:convert';
DefaultModel defaultModelFromJson(String str) => DefaultModel.fromJson(json.decode(str));
String defaultModelToJson(DefaultModel data) => json.encode(data.toJson());
class DefaultModel {
      dynamic? result;
    DefaultModel({
        this.result,
    });
    factory DefaultModel.fromJson(Map<String, dynamic> json) => DefaultModel(
          result: json["result"],
    );
    Map<String, dynamic> toJson() => {     
        "result": result,
    };
}
