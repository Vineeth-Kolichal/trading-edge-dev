// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sizing_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SizingModelAdapter extends TypeAdapter<SizingModel> {
  @override
  final int typeId = 0;

  @override
  SizingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SizingModel(
      targetAmount: fields[0] == null ? 0.0 : fields[0] as double,
      targetPercentage: fields[1] == null ? 0.0 : fields[1] as double,
      stoplossPercentage: fields[2] == null ? 0.0 : fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, SizingModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.targetAmount)
      ..writeByte(1)
      ..write(obj.targetPercentage)
      ..writeByte(2)
      ..write(obj.stoplossPercentage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SizingModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
