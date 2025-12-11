import 'package:isar_community/isar.dart';

part 'processed_history_entity.g.dart';

@collection
class ProcessedHistory {
  Id id = Isar.autoIncrement;

  // Hash là duy nhất, nếu trùng sẽ thay thế (hoặc bỏ qua tùy logic check)
  @Index(unique: true, replace: true)
  late String fileHash;

  late String fileName;

  DateTime processedAt = DateTime.now(); // Thời điểm hoàn thành
}
