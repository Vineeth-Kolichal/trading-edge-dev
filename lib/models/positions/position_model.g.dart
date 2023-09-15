// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'position_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PositionModelAdapter extends TypeAdapter<PositionModel> {
  @override
  final int typeId = 2;

  @override
  PositionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PositionModel(
      stockName: fields[0] as String,
      entryPrice: fields[1] as double,
      type: fields[2] as TradeType,
      currentUserId: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PositionModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.stockName)
      ..writeByte(1)
      ..write(obj.entryPrice)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.currentUserId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PositionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TradeTypeAdapter extends TypeAdapter<TradeType> {
  @override
  final int typeId = 1;

  @override
  TradeType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TradeType.buy;
      case 1:
        return TradeType.sell;
      default:
        return TradeType.buy;
    }
  }

  @override
  void write(BinaryWriter writer, TradeType obj) {
    switch (obj) {
      case TradeType.buy:
        writer.writeByte(0);
        break;
      case TradeType.sell:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TradeTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
