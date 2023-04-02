
// ignore_for_file: curly_braces_in_flow_control_structures

class Component {
  final int? id;
  final String title;
  final ComponentType type;
  final String description;
  final int cost;
  final String image;

  static const idC = 'id',
    titleC = 'title',
    typeC = 'type',
    descriptionC = 'description',
    costC = 'cost',
    imageC = 'image';

  const Component({
    this.id,
    required this.title,
    required this.type,
    required this.description,
    required this.cost,
    required this.image
  });

  factory Component.fromJson(Map<String, dynamic> json) => Component(
      id: json[idC],
      title: json[titleC],
      type: ComponentType.create(value: json[typeC])!,
      description: json[descriptionC],
      cost: json[costC],
      image: json[imageC]
  );

  @override
  bool operator ==(Object other) =>
    identical(this, other) || other is Component &&
      runtimeType == other.runtimeType &&
      id == other.id &&
      title == other.title &&
      type == other.type &&
      description == other.description &&
      cost == other.cost &&
      image == other.image;

  @override
  int get hashCode =>
    id.hashCode ^
    title.hashCode ^
    type.hashCode ^
    description.hashCode ^
    cost.hashCode ^
    image.hashCode;

  @override
  String toString() => 'Component{'
    'id: $id, '
    'title: $title, '
    'type: $type, '
    'description: $description, '
    'cost: $cost, '
    'image: $image}';
}

enum ComponentType {
  cpu (0, 'Processor', 'pc_cpu', 'CPU'),
  mb  (1, 'Motherboard', 'pc_mb', 'MB'),
  gpu (2, 'Graphics adapter', 'pc_gpu', 'GPU'),
  ram (3, 'Operating memory', 'pc_ram', 'RAM'),
  hdd (4, 'Hard drive', 'pc_hdd', 'HDD'),
  ssd (5, 'Solid state drive', 'pc_ssd', 'SSD'),
  psu (6, 'Power supply unit', 'pc_psu', 'PSU'),
  fan (7, 'Cooler', 'pc_fan', 'FAN'),
  ca$e(8, 'Case', 'pc_case', 'CASE');

  const ComponentType(this.id, this.title, this.icon, this.value);
  final int id;
  final String title;
  final String icon;
  final String value;
  static int amount = ComponentType.values.length;

  static ComponentType? create({int? id, String? value}) {
    assert((id != null) != (value != null));

    for (final ComponentType type in ComponentType.values)
      if (id != null && type.id == id || value != null && type.value == value)
        return type;

    return null;
  }

  static List<ComponentType> get types
  => [for (var i = 0; i < ComponentType.amount; i++) create(id: i)!];
}
