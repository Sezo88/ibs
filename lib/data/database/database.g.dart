// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $IngredientsTable extends Ingredients
    with TableInfo<$IngredientsTable, Ingredient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IngredientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameNormalizedMeta = const VerificationMeta(
    'nameNormalized',
  );
  @override
  late final GeneratedColumn<String> nameNormalized = GeneratedColumn<String>(
    'name_normalized',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fodmapLevelMeta = const VerificationMeta(
    'fodmapLevel',
  );
  @override
  late final GeneratedColumn<String> fodmapLevel = GeneratedColumn<String>(
    'fodmap_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('unknown'),
  );
  static const VerificationMeta _isLactoseMeta = const VerificationMeta(
    'isLactose',
  );
  @override
  late final GeneratedColumn<bool> isLactose = GeneratedColumn<bool>(
    'is_lactose',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_lactose" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isGlutenMeta = const VerificationMeta(
    'isGluten',
  );
  @override
  late final GeneratedColumn<bool> isGluten = GeneratedColumn<bool>(
    'is_gluten',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_gluten" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isHighHistamineMeta = const VerificationMeta(
    'isHighHistamine',
  );
  @override
  late final GeneratedColumn<bool> isHighHistamine = GeneratedColumn<bool>(
    'is_high_histamine',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_high_histamine" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isCaffeineMeta = const VerificationMeta(
    'isCaffeine',
  );
  @override
  late final GeneratedColumn<bool> isCaffeine = GeneratedColumn<bool>(
    'is_caffeine',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_caffeine" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('diger'),
  );
  static const VerificationMeta _fodmapGroupMeta = const VerificationMeta(
    'fodmapGroup',
  );
  @override
  late final GeneratedColumn<String> fodmapGroup = GeneratedColumn<String>(
    'fodmap_group',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('builtin'),
  );
  static const VerificationMeta _offBarcodeMeta = const VerificationMeta(
    'offBarcode',
  );
  @override
  late final GeneratedColumn<String> offBarcode = GeneratedColumn<String>(
    'off_barcode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    nameNormalized,
    fodmapLevel,
    isLactose,
    isGluten,
    isHighHistamine,
    isCaffeine,
    category,
    fodmapGroup,
    source,
    offBarcode,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ingredients';
  @override
  VerificationContext validateIntegrity(
    Insertable<Ingredient> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_normalized')) {
      context.handle(
        _nameNormalizedMeta,
        nameNormalized.isAcceptableOrUnknown(
          data['name_normalized']!,
          _nameNormalizedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nameNormalizedMeta);
    }
    if (data.containsKey('fodmap_level')) {
      context.handle(
        _fodmapLevelMeta,
        fodmapLevel.isAcceptableOrUnknown(
          data['fodmap_level']!,
          _fodmapLevelMeta,
        ),
      );
    }
    if (data.containsKey('is_lactose')) {
      context.handle(
        _isLactoseMeta,
        isLactose.isAcceptableOrUnknown(data['is_lactose']!, _isLactoseMeta),
      );
    }
    if (data.containsKey('is_gluten')) {
      context.handle(
        _isGlutenMeta,
        isGluten.isAcceptableOrUnknown(data['is_gluten']!, _isGlutenMeta),
      );
    }
    if (data.containsKey('is_high_histamine')) {
      context.handle(
        _isHighHistamineMeta,
        isHighHistamine.isAcceptableOrUnknown(
          data['is_high_histamine']!,
          _isHighHistamineMeta,
        ),
      );
    }
    if (data.containsKey('is_caffeine')) {
      context.handle(
        _isCaffeineMeta,
        isCaffeine.isAcceptableOrUnknown(data['is_caffeine']!, _isCaffeineMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('fodmap_group')) {
      context.handle(
        _fodmapGroupMeta,
        fodmapGroup.isAcceptableOrUnknown(
          data['fodmap_group']!,
          _fodmapGroupMeta,
        ),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('off_barcode')) {
      context.handle(
        _offBarcodeMeta,
        offBarcode.isAcceptableOrUnknown(data['off_barcode']!, _offBarcodeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Ingredient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ingredient(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameNormalized: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_normalized'],
      )!,
      fodmapLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fodmap_level'],
      )!,
      isLactose: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_lactose'],
      )!,
      isGluten: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_gluten'],
      )!,
      isHighHistamine: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_high_histamine'],
      )!,
      isCaffeine: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_caffeine'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      fodmapGroup: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fodmap_group'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      offBarcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}off_barcode'],
      ),
    );
  }

  @override
  $IngredientsTable createAlias(String alias) {
    return $IngredientsTable(attachedDatabase, alias);
  }
}

class Ingredient extends DataClass implements Insertable<Ingredient> {
  final int id;
  final String name;
  final String nameNormalized;
  final String fodmapLevel;
  final bool isLactose;
  final bool isGluten;
  final bool isHighHistamine;
  final bool isCaffeine;
  final String category;
  final String? fodmapGroup;
  final String source;
  final String? offBarcode;
  const Ingredient({
    required this.id,
    required this.name,
    required this.nameNormalized,
    required this.fodmapLevel,
    required this.isLactose,
    required this.isGluten,
    required this.isHighHistamine,
    required this.isCaffeine,
    required this.category,
    this.fodmapGroup,
    required this.source,
    this.offBarcode,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['name_normalized'] = Variable<String>(nameNormalized);
    map['fodmap_level'] = Variable<String>(fodmapLevel);
    map['is_lactose'] = Variable<bool>(isLactose);
    map['is_gluten'] = Variable<bool>(isGluten);
    map['is_high_histamine'] = Variable<bool>(isHighHistamine);
    map['is_caffeine'] = Variable<bool>(isCaffeine);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || fodmapGroup != null) {
      map['fodmap_group'] = Variable<String>(fodmapGroup);
    }
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || offBarcode != null) {
      map['off_barcode'] = Variable<String>(offBarcode);
    }
    return map;
  }

  IngredientsCompanion toCompanion(bool nullToAbsent) {
    return IngredientsCompanion(
      id: Value(id),
      name: Value(name),
      nameNormalized: Value(nameNormalized),
      fodmapLevel: Value(fodmapLevel),
      isLactose: Value(isLactose),
      isGluten: Value(isGluten),
      isHighHistamine: Value(isHighHistamine),
      isCaffeine: Value(isCaffeine),
      category: Value(category),
      fodmapGroup: fodmapGroup == null && nullToAbsent
          ? const Value.absent()
          : Value(fodmapGroup),
      source: Value(source),
      offBarcode: offBarcode == null && nullToAbsent
          ? const Value.absent()
          : Value(offBarcode),
    );
  }

  factory Ingredient.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ingredient(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nameNormalized: serializer.fromJson<String>(json['nameNormalized']),
      fodmapLevel: serializer.fromJson<String>(json['fodmapLevel']),
      isLactose: serializer.fromJson<bool>(json['isLactose']),
      isGluten: serializer.fromJson<bool>(json['isGluten']),
      isHighHistamine: serializer.fromJson<bool>(json['isHighHistamine']),
      isCaffeine: serializer.fromJson<bool>(json['isCaffeine']),
      category: serializer.fromJson<String>(json['category']),
      fodmapGroup: serializer.fromJson<String?>(json['fodmapGroup']),
      source: serializer.fromJson<String>(json['source']),
      offBarcode: serializer.fromJson<String?>(json['offBarcode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'nameNormalized': serializer.toJson<String>(nameNormalized),
      'fodmapLevel': serializer.toJson<String>(fodmapLevel),
      'isLactose': serializer.toJson<bool>(isLactose),
      'isGluten': serializer.toJson<bool>(isGluten),
      'isHighHistamine': serializer.toJson<bool>(isHighHistamine),
      'isCaffeine': serializer.toJson<bool>(isCaffeine),
      'category': serializer.toJson<String>(category),
      'fodmapGroup': serializer.toJson<String?>(fodmapGroup),
      'source': serializer.toJson<String>(source),
      'offBarcode': serializer.toJson<String?>(offBarcode),
    };
  }

  Ingredient copyWith({
    int? id,
    String? name,
    String? nameNormalized,
    String? fodmapLevel,
    bool? isLactose,
    bool? isGluten,
    bool? isHighHistamine,
    bool? isCaffeine,
    String? category,
    Value<String?> fodmapGroup = const Value.absent(),
    String? source,
    Value<String?> offBarcode = const Value.absent(),
  }) => Ingredient(
    id: id ?? this.id,
    name: name ?? this.name,
    nameNormalized: nameNormalized ?? this.nameNormalized,
    fodmapLevel: fodmapLevel ?? this.fodmapLevel,
    isLactose: isLactose ?? this.isLactose,
    isGluten: isGluten ?? this.isGluten,
    isHighHistamine: isHighHistamine ?? this.isHighHistamine,
    isCaffeine: isCaffeine ?? this.isCaffeine,
    category: category ?? this.category,
    fodmapGroup: fodmapGroup.present ? fodmapGroup.value : this.fodmapGroup,
    source: source ?? this.source,
    offBarcode: offBarcode.present ? offBarcode.value : this.offBarcode,
  );
  Ingredient copyWithCompanion(IngredientsCompanion data) {
    return Ingredient(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nameNormalized: data.nameNormalized.present
          ? data.nameNormalized.value
          : this.nameNormalized,
      fodmapLevel: data.fodmapLevel.present
          ? data.fodmapLevel.value
          : this.fodmapLevel,
      isLactose: data.isLactose.present ? data.isLactose.value : this.isLactose,
      isGluten: data.isGluten.present ? data.isGluten.value : this.isGluten,
      isHighHistamine: data.isHighHistamine.present
          ? data.isHighHistamine.value
          : this.isHighHistamine,
      isCaffeine: data.isCaffeine.present
          ? data.isCaffeine.value
          : this.isCaffeine,
      category: data.category.present ? data.category.value : this.category,
      fodmapGroup: data.fodmapGroup.present
          ? data.fodmapGroup.value
          : this.fodmapGroup,
      source: data.source.present ? data.source.value : this.source,
      offBarcode: data.offBarcode.present
          ? data.offBarcode.value
          : this.offBarcode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ingredient(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameNormalized: $nameNormalized, ')
          ..write('fodmapLevel: $fodmapLevel, ')
          ..write('isLactose: $isLactose, ')
          ..write('isGluten: $isGluten, ')
          ..write('isHighHistamine: $isHighHistamine, ')
          ..write('isCaffeine: $isCaffeine, ')
          ..write('category: $category, ')
          ..write('fodmapGroup: $fodmapGroup, ')
          ..write('source: $source, ')
          ..write('offBarcode: $offBarcode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    nameNormalized,
    fodmapLevel,
    isLactose,
    isGluten,
    isHighHistamine,
    isCaffeine,
    category,
    fodmapGroup,
    source,
    offBarcode,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ingredient &&
          other.id == this.id &&
          other.name == this.name &&
          other.nameNormalized == this.nameNormalized &&
          other.fodmapLevel == this.fodmapLevel &&
          other.isLactose == this.isLactose &&
          other.isGluten == this.isGluten &&
          other.isHighHistamine == this.isHighHistamine &&
          other.isCaffeine == this.isCaffeine &&
          other.category == this.category &&
          other.fodmapGroup == this.fodmapGroup &&
          other.source == this.source &&
          other.offBarcode == this.offBarcode);
}

class IngredientsCompanion extends UpdateCompanion<Ingredient> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> nameNormalized;
  final Value<String> fodmapLevel;
  final Value<bool> isLactose;
  final Value<bool> isGluten;
  final Value<bool> isHighHistamine;
  final Value<bool> isCaffeine;
  final Value<String> category;
  final Value<String?> fodmapGroup;
  final Value<String> source;
  final Value<String?> offBarcode;
  const IngredientsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nameNormalized = const Value.absent(),
    this.fodmapLevel = const Value.absent(),
    this.isLactose = const Value.absent(),
    this.isGluten = const Value.absent(),
    this.isHighHistamine = const Value.absent(),
    this.isCaffeine = const Value.absent(),
    this.category = const Value.absent(),
    this.fodmapGroup = const Value.absent(),
    this.source = const Value.absent(),
    this.offBarcode = const Value.absent(),
  });
  IngredientsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String nameNormalized,
    this.fodmapLevel = const Value.absent(),
    this.isLactose = const Value.absent(),
    this.isGluten = const Value.absent(),
    this.isHighHistamine = const Value.absent(),
    this.isCaffeine = const Value.absent(),
    this.category = const Value.absent(),
    this.fodmapGroup = const Value.absent(),
    this.source = const Value.absent(),
    this.offBarcode = const Value.absent(),
  }) : name = Value(name),
       nameNormalized = Value(nameNormalized);
  static Insertable<Ingredient> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? nameNormalized,
    Expression<String>? fodmapLevel,
    Expression<bool>? isLactose,
    Expression<bool>? isGluten,
    Expression<bool>? isHighHistamine,
    Expression<bool>? isCaffeine,
    Expression<String>? category,
    Expression<String>? fodmapGroup,
    Expression<String>? source,
    Expression<String>? offBarcode,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nameNormalized != null) 'name_normalized': nameNormalized,
      if (fodmapLevel != null) 'fodmap_level': fodmapLevel,
      if (isLactose != null) 'is_lactose': isLactose,
      if (isGluten != null) 'is_gluten': isGluten,
      if (isHighHistamine != null) 'is_high_histamine': isHighHistamine,
      if (isCaffeine != null) 'is_caffeine': isCaffeine,
      if (category != null) 'category': category,
      if (fodmapGroup != null) 'fodmap_group': fodmapGroup,
      if (source != null) 'source': source,
      if (offBarcode != null) 'off_barcode': offBarcode,
    });
  }

  IngredientsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? nameNormalized,
    Value<String>? fodmapLevel,
    Value<bool>? isLactose,
    Value<bool>? isGluten,
    Value<bool>? isHighHistamine,
    Value<bool>? isCaffeine,
    Value<String>? category,
    Value<String?>? fodmapGroup,
    Value<String>? source,
    Value<String?>? offBarcode,
  }) {
    return IngredientsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nameNormalized: nameNormalized ?? this.nameNormalized,
      fodmapLevel: fodmapLevel ?? this.fodmapLevel,
      isLactose: isLactose ?? this.isLactose,
      isGluten: isGluten ?? this.isGluten,
      isHighHistamine: isHighHistamine ?? this.isHighHistamine,
      isCaffeine: isCaffeine ?? this.isCaffeine,
      category: category ?? this.category,
      fodmapGroup: fodmapGroup ?? this.fodmapGroup,
      source: source ?? this.source,
      offBarcode: offBarcode ?? this.offBarcode,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameNormalized.present) {
      map['name_normalized'] = Variable<String>(nameNormalized.value);
    }
    if (fodmapLevel.present) {
      map['fodmap_level'] = Variable<String>(fodmapLevel.value);
    }
    if (isLactose.present) {
      map['is_lactose'] = Variable<bool>(isLactose.value);
    }
    if (isGluten.present) {
      map['is_gluten'] = Variable<bool>(isGluten.value);
    }
    if (isHighHistamine.present) {
      map['is_high_histamine'] = Variable<bool>(isHighHistamine.value);
    }
    if (isCaffeine.present) {
      map['is_caffeine'] = Variable<bool>(isCaffeine.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (fodmapGroup.present) {
      map['fodmap_group'] = Variable<String>(fodmapGroup.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (offBarcode.present) {
      map['off_barcode'] = Variable<String>(offBarcode.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IngredientsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameNormalized: $nameNormalized, ')
          ..write('fodmapLevel: $fodmapLevel, ')
          ..write('isLactose: $isLactose, ')
          ..write('isGluten: $isGluten, ')
          ..write('isHighHistamine: $isHighHistamine, ')
          ..write('isCaffeine: $isCaffeine, ')
          ..write('category: $category, ')
          ..write('fodmapGroup: $fodmapGroup, ')
          ..write('source: $source, ')
          ..write('offBarcode: $offBarcode')
          ..write(')'))
        .toString();
  }
}

class $MealTemplatesTable extends MealTemplates
    with TableInfo<$MealTemplatesTable, MealTemplate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealTemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameNormalizedMeta = const VerificationMeta(
    'nameNormalized',
  );
  @override
  late final GeneratedColumn<String> nameNormalized = GeneratedColumn<String>(
    'name_normalized',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ingredientsJsonMeta = const VerificationMeta(
    'ingredientsJson',
  );
  @override
  late final GeneratedColumn<String> ingredientsJson = GeneratedColumn<String>(
    'ingredients_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isBuiltinMeta = const VerificationMeta(
    'isBuiltin',
  );
  @override
  late final GeneratedColumn<bool> isBuiltin = GeneratedColumn<bool>(
    'is_builtin',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_builtin" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    nameNormalized,
    ingredientsJson,
    isBuiltin,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<MealTemplate> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_normalized')) {
      context.handle(
        _nameNormalizedMeta,
        nameNormalized.isAcceptableOrUnknown(
          data['name_normalized']!,
          _nameNormalizedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nameNormalizedMeta);
    }
    if (data.containsKey('ingredients_json')) {
      context.handle(
        _ingredientsJsonMeta,
        ingredientsJson.isAcceptableOrUnknown(
          data['ingredients_json']!,
          _ingredientsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ingredientsJsonMeta);
    }
    if (data.containsKey('is_builtin')) {
      context.handle(
        _isBuiltinMeta,
        isBuiltin.isAcceptableOrUnknown(data['is_builtin']!, _isBuiltinMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealTemplate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealTemplate(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameNormalized: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_normalized'],
      )!,
      ingredientsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ingredients_json'],
      )!,
      isBuiltin: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_builtin'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MealTemplatesTable createAlias(String alias) {
    return $MealTemplatesTable(attachedDatabase, alias);
  }
}

class MealTemplate extends DataClass implements Insertable<MealTemplate> {
  final int id;
  final String name;
  final String nameNormalized;
  final String ingredientsJson;
  final bool isBuiltin;
  final DateTime createdAt;
  const MealTemplate({
    required this.id,
    required this.name,
    required this.nameNormalized,
    required this.ingredientsJson,
    required this.isBuiltin,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['name_normalized'] = Variable<String>(nameNormalized);
    map['ingredients_json'] = Variable<String>(ingredientsJson);
    map['is_builtin'] = Variable<bool>(isBuiltin);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MealTemplatesCompanion toCompanion(bool nullToAbsent) {
    return MealTemplatesCompanion(
      id: Value(id),
      name: Value(name),
      nameNormalized: Value(nameNormalized),
      ingredientsJson: Value(ingredientsJson),
      isBuiltin: Value(isBuiltin),
      createdAt: Value(createdAt),
    );
  }

  factory MealTemplate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealTemplate(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nameNormalized: serializer.fromJson<String>(json['nameNormalized']),
      ingredientsJson: serializer.fromJson<String>(json['ingredientsJson']),
      isBuiltin: serializer.fromJson<bool>(json['isBuiltin']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'nameNormalized': serializer.toJson<String>(nameNormalized),
      'ingredientsJson': serializer.toJson<String>(ingredientsJson),
      'isBuiltin': serializer.toJson<bool>(isBuiltin),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MealTemplate copyWith({
    int? id,
    String? name,
    String? nameNormalized,
    String? ingredientsJson,
    bool? isBuiltin,
    DateTime? createdAt,
  }) => MealTemplate(
    id: id ?? this.id,
    name: name ?? this.name,
    nameNormalized: nameNormalized ?? this.nameNormalized,
    ingredientsJson: ingredientsJson ?? this.ingredientsJson,
    isBuiltin: isBuiltin ?? this.isBuiltin,
    createdAt: createdAt ?? this.createdAt,
  );
  MealTemplate copyWithCompanion(MealTemplatesCompanion data) {
    return MealTemplate(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nameNormalized: data.nameNormalized.present
          ? data.nameNormalized.value
          : this.nameNormalized,
      ingredientsJson: data.ingredientsJson.present
          ? data.ingredientsJson.value
          : this.ingredientsJson,
      isBuiltin: data.isBuiltin.present ? data.isBuiltin.value : this.isBuiltin,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealTemplate(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameNormalized: $nameNormalized, ')
          ..write('ingredientsJson: $ingredientsJson, ')
          ..write('isBuiltin: $isBuiltin, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    nameNormalized,
    ingredientsJson,
    isBuiltin,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealTemplate &&
          other.id == this.id &&
          other.name == this.name &&
          other.nameNormalized == this.nameNormalized &&
          other.ingredientsJson == this.ingredientsJson &&
          other.isBuiltin == this.isBuiltin &&
          other.createdAt == this.createdAt);
}

class MealTemplatesCompanion extends UpdateCompanion<MealTemplate> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> nameNormalized;
  final Value<String> ingredientsJson;
  final Value<bool> isBuiltin;
  final Value<DateTime> createdAt;
  const MealTemplatesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nameNormalized = const Value.absent(),
    this.ingredientsJson = const Value.absent(),
    this.isBuiltin = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MealTemplatesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String nameNormalized,
    required String ingredientsJson,
    this.isBuiltin = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       nameNormalized = Value(nameNormalized),
       ingredientsJson = Value(ingredientsJson);
  static Insertable<MealTemplate> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? nameNormalized,
    Expression<String>? ingredientsJson,
    Expression<bool>? isBuiltin,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nameNormalized != null) 'name_normalized': nameNormalized,
      if (ingredientsJson != null) 'ingredients_json': ingredientsJson,
      if (isBuiltin != null) 'is_builtin': isBuiltin,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MealTemplatesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? nameNormalized,
    Value<String>? ingredientsJson,
    Value<bool>? isBuiltin,
    Value<DateTime>? createdAt,
  }) {
    return MealTemplatesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nameNormalized: nameNormalized ?? this.nameNormalized,
      ingredientsJson: ingredientsJson ?? this.ingredientsJson,
      isBuiltin: isBuiltin ?? this.isBuiltin,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameNormalized.present) {
      map['name_normalized'] = Variable<String>(nameNormalized.value);
    }
    if (ingredientsJson.present) {
      map['ingredients_json'] = Variable<String>(ingredientsJson.value);
    }
    if (isBuiltin.present) {
      map['is_builtin'] = Variable<bool>(isBuiltin.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameNormalized: $nameNormalized, ')
          ..write('ingredientsJson: $ingredientsJson, ')
          ..write('isBuiltin: $isBuiltin, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $MealsTable extends Meals with TableInfo<$MealsTable, Meal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mealTypeMeta = const VerificationMeta(
    'mealType',
  );
  @override
  late final GeneratedColumn<String> mealType = GeneratedColumn<String>(
    'meal_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('aksam'),
  );
  static const VerificationMeta _eatenAtMeta = const VerificationMeta(
    'eatenAt',
  );
  @override
  late final GeneratedColumn<DateTime> eatenAt = GeneratedColumn<DateTime>(
    'eaten_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _portionSizeMeta = const VerificationMeta(
    'portionSize',
  );
  @override
  late final GeneratedColumn<String> portionSize = GeneratedColumn<String>(
    'portion_size',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('orta'),
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    mealType,
    eatenAt,
    portionSize,
    photoPath,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meals';
  @override
  VerificationContext validateIntegrity(
    Insertable<Meal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('meal_type')) {
      context.handle(
        _mealTypeMeta,
        mealType.isAcceptableOrUnknown(data['meal_type']!, _mealTypeMeta),
      );
    }
    if (data.containsKey('eaten_at')) {
      context.handle(
        _eatenAtMeta,
        eatenAt.isAcceptableOrUnknown(data['eaten_at']!, _eatenAtMeta),
      );
    }
    if (data.containsKey('portion_size')) {
      context.handle(
        _portionSizeMeta,
        portionSize.isAcceptableOrUnknown(
          data['portion_size']!,
          _portionSizeMeta,
        ),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Meal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Meal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      mealType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_type'],
      )!,
      eatenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}eaten_at'],
      )!,
      portionSize: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}portion_size'],
      )!,
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MealsTable createAlias(String alias) {
    return $MealsTable(attachedDatabase, alias);
  }
}

class Meal extends DataClass implements Insertable<Meal> {
  final int id;
  final String name;
  final String mealType;
  final DateTime eatenAt;
  final String portionSize;
  final String? photoPath;
  final String? notes;
  final DateTime createdAt;
  const Meal({
    required this.id,
    required this.name,
    required this.mealType,
    required this.eatenAt,
    required this.portionSize,
    this.photoPath,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['meal_type'] = Variable<String>(mealType);
    map['eaten_at'] = Variable<DateTime>(eatenAt);
    map['portion_size'] = Variable<String>(portionSize);
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MealsCompanion toCompanion(bool nullToAbsent) {
    return MealsCompanion(
      id: Value(id),
      name: Value(name),
      mealType: Value(mealType),
      eatenAt: Value(eatenAt),
      portionSize: Value(portionSize),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory Meal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Meal(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      mealType: serializer.fromJson<String>(json['mealType']),
      eatenAt: serializer.fromJson<DateTime>(json['eatenAt']),
      portionSize: serializer.fromJson<String>(json['portionSize']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'mealType': serializer.toJson<String>(mealType),
      'eatenAt': serializer.toJson<DateTime>(eatenAt),
      'portionSize': serializer.toJson<String>(portionSize),
      'photoPath': serializer.toJson<String?>(photoPath),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Meal copyWith({
    int? id,
    String? name,
    String? mealType,
    DateTime? eatenAt,
    String? portionSize,
    Value<String?> photoPath = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => Meal(
    id: id ?? this.id,
    name: name ?? this.name,
    mealType: mealType ?? this.mealType,
    eatenAt: eatenAt ?? this.eatenAt,
    portionSize: portionSize ?? this.portionSize,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  Meal copyWithCompanion(MealsCompanion data) {
    return Meal(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      mealType: data.mealType.present ? data.mealType.value : this.mealType,
      eatenAt: data.eatenAt.present ? data.eatenAt.value : this.eatenAt,
      portionSize: data.portionSize.present
          ? data.portionSize.value
          : this.portionSize,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Meal(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('mealType: $mealType, ')
          ..write('eatenAt: $eatenAt, ')
          ..write('portionSize: $portionSize, ')
          ..write('photoPath: $photoPath, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    mealType,
    eatenAt,
    portionSize,
    photoPath,
    notes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Meal &&
          other.id == this.id &&
          other.name == this.name &&
          other.mealType == this.mealType &&
          other.eatenAt == this.eatenAt &&
          other.portionSize == this.portionSize &&
          other.photoPath == this.photoPath &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class MealsCompanion extends UpdateCompanion<Meal> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> mealType;
  final Value<DateTime> eatenAt;
  final Value<String> portionSize;
  final Value<String?> photoPath;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const MealsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.mealType = const Value.absent(),
    this.eatenAt = const Value.absent(),
    this.portionSize = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MealsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.mealType = const Value.absent(),
    this.eatenAt = const Value.absent(),
    this.portionSize = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Meal> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? mealType,
    Expression<DateTime>? eatenAt,
    Expression<String>? portionSize,
    Expression<String>? photoPath,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (mealType != null) 'meal_type': mealType,
      if (eatenAt != null) 'eaten_at': eatenAt,
      if (portionSize != null) 'portion_size': portionSize,
      if (photoPath != null) 'photo_path': photoPath,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MealsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? mealType,
    Value<DateTime>? eatenAt,
    Value<String>? portionSize,
    Value<String?>? photoPath,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
  }) {
    return MealsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      mealType: mealType ?? this.mealType,
      eatenAt: eatenAt ?? this.eatenAt,
      portionSize: portionSize ?? this.portionSize,
      photoPath: photoPath ?? this.photoPath,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (mealType.present) {
      map['meal_type'] = Variable<String>(mealType.value);
    }
    if (eatenAt.present) {
      map['eaten_at'] = Variable<DateTime>(eatenAt.value);
    }
    if (portionSize.present) {
      map['portion_size'] = Variable<String>(portionSize.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('mealType: $mealType, ')
          ..write('eatenAt: $eatenAt, ')
          ..write('portionSize: $portionSize, ')
          ..write('photoPath: $photoPath, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $MealIngredientsTable extends MealIngredients
    with TableInfo<$MealIngredientsTable, MealIngredient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealIngredientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _mealIdMeta = const VerificationMeta('mealId');
  @override
  late final GeneratedColumn<int> mealId = GeneratedColumn<int>(
    'meal_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES meals (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _ingredientIdMeta = const VerificationMeta(
    'ingredientId',
  );
  @override
  late final GeneratedColumn<int> ingredientId = GeneratedColumn<int>(
    'ingredient_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ingredients (id)',
    ),
  );
  static const VerificationMeta _customNoteMeta = const VerificationMeta(
    'customNote',
  );
  @override
  late final GeneratedColumn<String> customNote = GeneratedColumn<String>(
    'custom_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, mealId, ingredientId, customNote];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_ingredients';
  @override
  VerificationContext validateIntegrity(
    Insertable<MealIngredient> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('meal_id')) {
      context.handle(
        _mealIdMeta,
        mealId.isAcceptableOrUnknown(data['meal_id']!, _mealIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mealIdMeta);
    }
    if (data.containsKey('ingredient_id')) {
      context.handle(
        _ingredientIdMeta,
        ingredientId.isAcceptableOrUnknown(
          data['ingredient_id']!,
          _ingredientIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ingredientIdMeta);
    }
    if (data.containsKey('custom_note')) {
      context.handle(
        _customNoteMeta,
        customNote.isAcceptableOrUnknown(data['custom_note']!, _customNoteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealIngredient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealIngredient(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      mealId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}meal_id'],
      )!,
      ingredientId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ingredient_id'],
      )!,
      customNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_note'],
      ),
    );
  }

  @override
  $MealIngredientsTable createAlias(String alias) {
    return $MealIngredientsTable(attachedDatabase, alias);
  }
}

class MealIngredient extends DataClass implements Insertable<MealIngredient> {
  final int id;
  final int mealId;
  final int ingredientId;
  final String? customNote;
  const MealIngredient({
    required this.id,
    required this.mealId,
    required this.ingredientId,
    this.customNote,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['meal_id'] = Variable<int>(mealId);
    map['ingredient_id'] = Variable<int>(ingredientId);
    if (!nullToAbsent || customNote != null) {
      map['custom_note'] = Variable<String>(customNote);
    }
    return map;
  }

  MealIngredientsCompanion toCompanion(bool nullToAbsent) {
    return MealIngredientsCompanion(
      id: Value(id),
      mealId: Value(mealId),
      ingredientId: Value(ingredientId),
      customNote: customNote == null && nullToAbsent
          ? const Value.absent()
          : Value(customNote),
    );
  }

  factory MealIngredient.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealIngredient(
      id: serializer.fromJson<int>(json['id']),
      mealId: serializer.fromJson<int>(json['mealId']),
      ingredientId: serializer.fromJson<int>(json['ingredientId']),
      customNote: serializer.fromJson<String?>(json['customNote']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mealId': serializer.toJson<int>(mealId),
      'ingredientId': serializer.toJson<int>(ingredientId),
      'customNote': serializer.toJson<String?>(customNote),
    };
  }

  MealIngredient copyWith({
    int? id,
    int? mealId,
    int? ingredientId,
    Value<String?> customNote = const Value.absent(),
  }) => MealIngredient(
    id: id ?? this.id,
    mealId: mealId ?? this.mealId,
    ingredientId: ingredientId ?? this.ingredientId,
    customNote: customNote.present ? customNote.value : this.customNote,
  );
  MealIngredient copyWithCompanion(MealIngredientsCompanion data) {
    return MealIngredient(
      id: data.id.present ? data.id.value : this.id,
      mealId: data.mealId.present ? data.mealId.value : this.mealId,
      ingredientId: data.ingredientId.present
          ? data.ingredientId.value
          : this.ingredientId,
      customNote: data.customNote.present
          ? data.customNote.value
          : this.customNote,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealIngredient(')
          ..write('id: $id, ')
          ..write('mealId: $mealId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('customNote: $customNote')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, mealId, ingredientId, customNote);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealIngredient &&
          other.id == this.id &&
          other.mealId == this.mealId &&
          other.ingredientId == this.ingredientId &&
          other.customNote == this.customNote);
}

class MealIngredientsCompanion extends UpdateCompanion<MealIngredient> {
  final Value<int> id;
  final Value<int> mealId;
  final Value<int> ingredientId;
  final Value<String?> customNote;
  const MealIngredientsCompanion({
    this.id = const Value.absent(),
    this.mealId = const Value.absent(),
    this.ingredientId = const Value.absent(),
    this.customNote = const Value.absent(),
  });
  MealIngredientsCompanion.insert({
    this.id = const Value.absent(),
    required int mealId,
    required int ingredientId,
    this.customNote = const Value.absent(),
  }) : mealId = Value(mealId),
       ingredientId = Value(ingredientId);
  static Insertable<MealIngredient> custom({
    Expression<int>? id,
    Expression<int>? mealId,
    Expression<int>? ingredientId,
    Expression<String>? customNote,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mealId != null) 'meal_id': mealId,
      if (ingredientId != null) 'ingredient_id': ingredientId,
      if (customNote != null) 'custom_note': customNote,
    });
  }

  MealIngredientsCompanion copyWith({
    Value<int>? id,
    Value<int>? mealId,
    Value<int>? ingredientId,
    Value<String?>? customNote,
  }) {
    return MealIngredientsCompanion(
      id: id ?? this.id,
      mealId: mealId ?? this.mealId,
      ingredientId: ingredientId ?? this.ingredientId,
      customNote: customNote ?? this.customNote,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mealId.present) {
      map['meal_id'] = Variable<int>(mealId.value);
    }
    if (ingredientId.present) {
      map['ingredient_id'] = Variable<int>(ingredientId.value);
    }
    if (customNote.present) {
      map['custom_note'] = Variable<String>(customNote.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealIngredientsCompanion(')
          ..write('id: $id, ')
          ..write('mealId: $mealId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('customNote: $customNote')
          ..write(')'))
        .toString();
  }
}

class $SymptomLogsTable extends SymptomLogs
    with TableInfo<$SymptomLogsTable, SymptomLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SymptomLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _loggedAtMeta = const VerificationMeta(
    'loggedAt',
  );
  @override
  late final GeneratedColumn<DateTime> loggedAt = GeneratedColumn<DateTime>(
    'logged_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _overallFeelingMeta = const VerificationMeta(
    'overallFeeling',
  );
  @override
  late final GeneratedColumn<double> overallFeeling = GeneratedColumn<double>(
    'overall_feeling',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    loggedAt,
    overallFeeling,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'symptom_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<SymptomLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('logged_at')) {
      context.handle(
        _loggedAtMeta,
        loggedAt.isAcceptableOrUnknown(data['logged_at']!, _loggedAtMeta),
      );
    }
    if (data.containsKey('overall_feeling')) {
      context.handle(
        _overallFeelingMeta,
        overallFeeling.isAcceptableOrUnknown(
          data['overall_feeling']!,
          _overallFeelingMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SymptomLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SymptomLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      loggedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}logged_at'],
      )!,
      overallFeeling: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}overall_feeling'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SymptomLogsTable createAlias(String alias) {
    return $SymptomLogsTable(attachedDatabase, alias);
  }
}

class SymptomLog extends DataClass implements Insertable<SymptomLog> {
  final int id;
  final DateTime loggedAt;
  final double? overallFeeling;
  final String? notes;
  final DateTime createdAt;
  const SymptomLog({
    required this.id,
    required this.loggedAt,
    this.overallFeeling,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['logged_at'] = Variable<DateTime>(loggedAt);
    if (!nullToAbsent || overallFeeling != null) {
      map['overall_feeling'] = Variable<double>(overallFeeling);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SymptomLogsCompanion toCompanion(bool nullToAbsent) {
    return SymptomLogsCompanion(
      id: Value(id),
      loggedAt: Value(loggedAt),
      overallFeeling: overallFeeling == null && nullToAbsent
          ? const Value.absent()
          : Value(overallFeeling),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory SymptomLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SymptomLog(
      id: serializer.fromJson<int>(json['id']),
      loggedAt: serializer.fromJson<DateTime>(json['loggedAt']),
      overallFeeling: serializer.fromJson<double?>(json['overallFeeling']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'loggedAt': serializer.toJson<DateTime>(loggedAt),
      'overallFeeling': serializer.toJson<double?>(overallFeeling),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SymptomLog copyWith({
    int? id,
    DateTime? loggedAt,
    Value<double?> overallFeeling = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => SymptomLog(
    id: id ?? this.id,
    loggedAt: loggedAt ?? this.loggedAt,
    overallFeeling: overallFeeling.present
        ? overallFeeling.value
        : this.overallFeeling,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  SymptomLog copyWithCompanion(SymptomLogsCompanion data) {
    return SymptomLog(
      id: data.id.present ? data.id.value : this.id,
      loggedAt: data.loggedAt.present ? data.loggedAt.value : this.loggedAt,
      overallFeeling: data.overallFeeling.present
          ? data.overallFeeling.value
          : this.overallFeeling,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SymptomLog(')
          ..write('id: $id, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('overallFeeling: $overallFeeling, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, loggedAt, overallFeeling, notes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SymptomLog &&
          other.id == this.id &&
          other.loggedAt == this.loggedAt &&
          other.overallFeeling == this.overallFeeling &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class SymptomLogsCompanion extends UpdateCompanion<SymptomLog> {
  final Value<int> id;
  final Value<DateTime> loggedAt;
  final Value<double?> overallFeeling;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const SymptomLogsCompanion({
    this.id = const Value.absent(),
    this.loggedAt = const Value.absent(),
    this.overallFeeling = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SymptomLogsCompanion.insert({
    this.id = const Value.absent(),
    this.loggedAt = const Value.absent(),
    this.overallFeeling = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  static Insertable<SymptomLog> custom({
    Expression<int>? id,
    Expression<DateTime>? loggedAt,
    Expression<double>? overallFeeling,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (loggedAt != null) 'logged_at': loggedAt,
      if (overallFeeling != null) 'overall_feeling': overallFeeling,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SymptomLogsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? loggedAt,
    Value<double?>? overallFeeling,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
  }) {
    return SymptomLogsCompanion(
      id: id ?? this.id,
      loggedAt: loggedAt ?? this.loggedAt,
      overallFeeling: overallFeeling ?? this.overallFeeling,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (loggedAt.present) {
      map['logged_at'] = Variable<DateTime>(loggedAt.value);
    }
    if (overallFeeling.present) {
      map['overall_feeling'] = Variable<double>(overallFeeling.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SymptomLogsCompanion(')
          ..write('id: $id, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('overallFeeling: $overallFeeling, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SymptomEntriesTable extends SymptomEntries
    with TableInfo<$SymptomEntriesTable, SymptomEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SymptomEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _symptomLogIdMeta = const VerificationMeta(
    'symptomLogId',
  );
  @override
  late final GeneratedColumn<int> symptomLogId = GeneratedColumn<int>(
    'symptom_log_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES symptom_logs (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _symptomTypeMeta = const VerificationMeta(
    'symptomType',
  );
  @override
  late final GeneratedColumn<String> symptomType = GeneratedColumn<String>(
    'symptom_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _severityMeta = const VerificationMeta(
    'severity',
  );
  @override
  late final GeneratedColumn<double> severity = GeneratedColumn<double>(
    'severity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    symptomLogId,
    symptomType,
    severity,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'symptom_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<SymptomEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('symptom_log_id')) {
      context.handle(
        _symptomLogIdMeta,
        symptomLogId.isAcceptableOrUnknown(
          data['symptom_log_id']!,
          _symptomLogIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_symptomLogIdMeta);
    }
    if (data.containsKey('symptom_type')) {
      context.handle(
        _symptomTypeMeta,
        symptomType.isAcceptableOrUnknown(
          data['symptom_type']!,
          _symptomTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_symptomTypeMeta);
    }
    if (data.containsKey('severity')) {
      context.handle(
        _severityMeta,
        severity.isAcceptableOrUnknown(data['severity']!, _severityMeta),
      );
    } else if (isInserting) {
      context.missing(_severityMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SymptomEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SymptomEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      symptomLogId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}symptom_log_id'],
      )!,
      symptomType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symptom_type'],
      )!,
      severity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}severity'],
      )!,
    );
  }

  @override
  $SymptomEntriesTable createAlias(String alias) {
    return $SymptomEntriesTable(attachedDatabase, alias);
  }
}

class SymptomEntry extends DataClass implements Insertable<SymptomEntry> {
  final int id;
  final int symptomLogId;
  final String symptomType;
  final double severity;
  const SymptomEntry({
    required this.id,
    required this.symptomLogId,
    required this.symptomType,
    required this.severity,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['symptom_log_id'] = Variable<int>(symptomLogId);
    map['symptom_type'] = Variable<String>(symptomType);
    map['severity'] = Variable<double>(severity);
    return map;
  }

  SymptomEntriesCompanion toCompanion(bool nullToAbsent) {
    return SymptomEntriesCompanion(
      id: Value(id),
      symptomLogId: Value(symptomLogId),
      symptomType: Value(symptomType),
      severity: Value(severity),
    );
  }

  factory SymptomEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SymptomEntry(
      id: serializer.fromJson<int>(json['id']),
      symptomLogId: serializer.fromJson<int>(json['symptomLogId']),
      symptomType: serializer.fromJson<String>(json['symptomType']),
      severity: serializer.fromJson<double>(json['severity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'symptomLogId': serializer.toJson<int>(symptomLogId),
      'symptomType': serializer.toJson<String>(symptomType),
      'severity': serializer.toJson<double>(severity),
    };
  }

  SymptomEntry copyWith({
    int? id,
    int? symptomLogId,
    String? symptomType,
    double? severity,
  }) => SymptomEntry(
    id: id ?? this.id,
    symptomLogId: symptomLogId ?? this.symptomLogId,
    symptomType: symptomType ?? this.symptomType,
    severity: severity ?? this.severity,
  );
  SymptomEntry copyWithCompanion(SymptomEntriesCompanion data) {
    return SymptomEntry(
      id: data.id.present ? data.id.value : this.id,
      symptomLogId: data.symptomLogId.present
          ? data.symptomLogId.value
          : this.symptomLogId,
      symptomType: data.symptomType.present
          ? data.symptomType.value
          : this.symptomType,
      severity: data.severity.present ? data.severity.value : this.severity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SymptomEntry(')
          ..write('id: $id, ')
          ..write('symptomLogId: $symptomLogId, ')
          ..write('symptomType: $symptomType, ')
          ..write('severity: $severity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, symptomLogId, symptomType, severity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SymptomEntry &&
          other.id == this.id &&
          other.symptomLogId == this.symptomLogId &&
          other.symptomType == this.symptomType &&
          other.severity == this.severity);
}

class SymptomEntriesCompanion extends UpdateCompanion<SymptomEntry> {
  final Value<int> id;
  final Value<int> symptomLogId;
  final Value<String> symptomType;
  final Value<double> severity;
  const SymptomEntriesCompanion({
    this.id = const Value.absent(),
    this.symptomLogId = const Value.absent(),
    this.symptomType = const Value.absent(),
    this.severity = const Value.absent(),
  });
  SymptomEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int symptomLogId,
    required String symptomType,
    required double severity,
  }) : symptomLogId = Value(symptomLogId),
       symptomType = Value(symptomType),
       severity = Value(severity);
  static Insertable<SymptomEntry> custom({
    Expression<int>? id,
    Expression<int>? symptomLogId,
    Expression<String>? symptomType,
    Expression<double>? severity,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (symptomLogId != null) 'symptom_log_id': symptomLogId,
      if (symptomType != null) 'symptom_type': symptomType,
      if (severity != null) 'severity': severity,
    });
  }

  SymptomEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? symptomLogId,
    Value<String>? symptomType,
    Value<double>? severity,
  }) {
    return SymptomEntriesCompanion(
      id: id ?? this.id,
      symptomLogId: symptomLogId ?? this.symptomLogId,
      symptomType: symptomType ?? this.symptomType,
      severity: severity ?? this.severity,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (symptomLogId.present) {
      map['symptom_log_id'] = Variable<int>(symptomLogId.value);
    }
    if (symptomType.present) {
      map['symptom_type'] = Variable<String>(symptomType.value);
    }
    if (severity.present) {
      map['severity'] = Variable<double>(severity.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SymptomEntriesCompanion(')
          ..write('id: $id, ')
          ..write('symptomLogId: $symptomLogId, ')
          ..write('symptomType: $symptomType, ')
          ..write('severity: $severity')
          ..write(')'))
        .toString();
  }
}

class $CorrelationCacheTable extends CorrelationCache
    with TableInfo<$CorrelationCacheTable, CorrelationCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CorrelationCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ingredientIdMeta = const VerificationMeta(
    'ingredientId',
  );
  @override
  late final GeneratedColumn<int> ingredientId = GeneratedColumn<int>(
    'ingredient_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ingredients (id)',
    ),
  );
  static const VerificationMeta _timeWindowHoursMeta = const VerificationMeta(
    'timeWindowHours',
  );
  @override
  late final GeneratedColumn<int> timeWindowHours = GeneratedColumn<int>(
    'time_window_hours',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurrenceCountMeta = const VerificationMeta(
    'occurrenceCount',
  );
  @override
  late final GeneratedColumn<int> occurrenceCount = GeneratedColumn<int>(
    'occurrence_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _symptomCountMeta = const VerificationMeta(
    'symptomCount',
  );
  @override
  late final GeneratedColumn<int> symptomCount = GeneratedColumn<int>(
    'symptom_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _symptomRateMeta = const VerificationMeta(
    'symptomRate',
  );
  @override
  late final GeneratedColumn<double> symptomRate = GeneratedColumn<double>(
    'symptom_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _suspicionScoreMeta = const VerificationMeta(
    'suspicionScore',
  );
  @override
  late final GeneratedColumn<double> suspicionScore = GeneratedColumn<double>(
    'suspicion_score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastCalculatedAtMeta = const VerificationMeta(
    'lastCalculatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastCalculatedAt =
      GeneratedColumn<DateTime>(
        'last_calculated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ingredientId,
    timeWindowHours,
    occurrenceCount,
    symptomCount,
    symptomRate,
    suspicionScore,
    lastCalculatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'correlation_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<CorrelationCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('ingredient_id')) {
      context.handle(
        _ingredientIdMeta,
        ingredientId.isAcceptableOrUnknown(
          data['ingredient_id']!,
          _ingredientIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ingredientIdMeta);
    }
    if (data.containsKey('time_window_hours')) {
      context.handle(
        _timeWindowHoursMeta,
        timeWindowHours.isAcceptableOrUnknown(
          data['time_window_hours']!,
          _timeWindowHoursMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_timeWindowHoursMeta);
    }
    if (data.containsKey('occurrence_count')) {
      context.handle(
        _occurrenceCountMeta,
        occurrenceCount.isAcceptableOrUnknown(
          data['occurrence_count']!,
          _occurrenceCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_occurrenceCountMeta);
    }
    if (data.containsKey('symptom_count')) {
      context.handle(
        _symptomCountMeta,
        symptomCount.isAcceptableOrUnknown(
          data['symptom_count']!,
          _symptomCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_symptomCountMeta);
    }
    if (data.containsKey('symptom_rate')) {
      context.handle(
        _symptomRateMeta,
        symptomRate.isAcceptableOrUnknown(
          data['symptom_rate']!,
          _symptomRateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_symptomRateMeta);
    }
    if (data.containsKey('suspicion_score')) {
      context.handle(
        _suspicionScoreMeta,
        suspicionScore.isAcceptableOrUnknown(
          data['suspicion_score']!,
          _suspicionScoreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_suspicionScoreMeta);
    }
    if (data.containsKey('last_calculated_at')) {
      context.handle(
        _lastCalculatedAtMeta,
        lastCalculatedAt.isAcceptableOrUnknown(
          data['last_calculated_at']!,
          _lastCalculatedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CorrelationCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CorrelationCacheData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ingredientId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ingredient_id'],
      )!,
      timeWindowHours: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time_window_hours'],
      )!,
      occurrenceCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}occurrence_count'],
      )!,
      symptomCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}symptom_count'],
      )!,
      symptomRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}symptom_rate'],
      )!,
      suspicionScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}suspicion_score'],
      )!,
      lastCalculatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_calculated_at'],
      )!,
    );
  }

  @override
  $CorrelationCacheTable createAlias(String alias) {
    return $CorrelationCacheTable(attachedDatabase, alias);
  }
}

class CorrelationCacheData extends DataClass
    implements Insertable<CorrelationCacheData> {
  final int id;
  final int ingredientId;
  final int timeWindowHours;
  final int occurrenceCount;
  final int symptomCount;
  final double symptomRate;
  final double suspicionScore;
  final DateTime lastCalculatedAt;
  const CorrelationCacheData({
    required this.id,
    required this.ingredientId,
    required this.timeWindowHours,
    required this.occurrenceCount,
    required this.symptomCount,
    required this.symptomRate,
    required this.suspicionScore,
    required this.lastCalculatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['ingredient_id'] = Variable<int>(ingredientId);
    map['time_window_hours'] = Variable<int>(timeWindowHours);
    map['occurrence_count'] = Variable<int>(occurrenceCount);
    map['symptom_count'] = Variable<int>(symptomCount);
    map['symptom_rate'] = Variable<double>(symptomRate);
    map['suspicion_score'] = Variable<double>(suspicionScore);
    map['last_calculated_at'] = Variable<DateTime>(lastCalculatedAt);
    return map;
  }

  CorrelationCacheCompanion toCompanion(bool nullToAbsent) {
    return CorrelationCacheCompanion(
      id: Value(id),
      ingredientId: Value(ingredientId),
      timeWindowHours: Value(timeWindowHours),
      occurrenceCount: Value(occurrenceCount),
      symptomCount: Value(symptomCount),
      symptomRate: Value(symptomRate),
      suspicionScore: Value(suspicionScore),
      lastCalculatedAt: Value(lastCalculatedAt),
    );
  }

  factory CorrelationCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CorrelationCacheData(
      id: serializer.fromJson<int>(json['id']),
      ingredientId: serializer.fromJson<int>(json['ingredientId']),
      timeWindowHours: serializer.fromJson<int>(json['timeWindowHours']),
      occurrenceCount: serializer.fromJson<int>(json['occurrenceCount']),
      symptomCount: serializer.fromJson<int>(json['symptomCount']),
      symptomRate: serializer.fromJson<double>(json['symptomRate']),
      suspicionScore: serializer.fromJson<double>(json['suspicionScore']),
      lastCalculatedAt: serializer.fromJson<DateTime>(json['lastCalculatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ingredientId': serializer.toJson<int>(ingredientId),
      'timeWindowHours': serializer.toJson<int>(timeWindowHours),
      'occurrenceCount': serializer.toJson<int>(occurrenceCount),
      'symptomCount': serializer.toJson<int>(symptomCount),
      'symptomRate': serializer.toJson<double>(symptomRate),
      'suspicionScore': serializer.toJson<double>(suspicionScore),
      'lastCalculatedAt': serializer.toJson<DateTime>(lastCalculatedAt),
    };
  }

  CorrelationCacheData copyWith({
    int? id,
    int? ingredientId,
    int? timeWindowHours,
    int? occurrenceCount,
    int? symptomCount,
    double? symptomRate,
    double? suspicionScore,
    DateTime? lastCalculatedAt,
  }) => CorrelationCacheData(
    id: id ?? this.id,
    ingredientId: ingredientId ?? this.ingredientId,
    timeWindowHours: timeWindowHours ?? this.timeWindowHours,
    occurrenceCount: occurrenceCount ?? this.occurrenceCount,
    symptomCount: symptomCount ?? this.symptomCount,
    symptomRate: symptomRate ?? this.symptomRate,
    suspicionScore: suspicionScore ?? this.suspicionScore,
    lastCalculatedAt: lastCalculatedAt ?? this.lastCalculatedAt,
  );
  CorrelationCacheData copyWithCompanion(CorrelationCacheCompanion data) {
    return CorrelationCacheData(
      id: data.id.present ? data.id.value : this.id,
      ingredientId: data.ingredientId.present
          ? data.ingredientId.value
          : this.ingredientId,
      timeWindowHours: data.timeWindowHours.present
          ? data.timeWindowHours.value
          : this.timeWindowHours,
      occurrenceCount: data.occurrenceCount.present
          ? data.occurrenceCount.value
          : this.occurrenceCount,
      symptomCount: data.symptomCount.present
          ? data.symptomCount.value
          : this.symptomCount,
      symptomRate: data.symptomRate.present
          ? data.symptomRate.value
          : this.symptomRate,
      suspicionScore: data.suspicionScore.present
          ? data.suspicionScore.value
          : this.suspicionScore,
      lastCalculatedAt: data.lastCalculatedAt.present
          ? data.lastCalculatedAt.value
          : this.lastCalculatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CorrelationCacheData(')
          ..write('id: $id, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('timeWindowHours: $timeWindowHours, ')
          ..write('occurrenceCount: $occurrenceCount, ')
          ..write('symptomCount: $symptomCount, ')
          ..write('symptomRate: $symptomRate, ')
          ..write('suspicionScore: $suspicionScore, ')
          ..write('lastCalculatedAt: $lastCalculatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ingredientId,
    timeWindowHours,
    occurrenceCount,
    symptomCount,
    symptomRate,
    suspicionScore,
    lastCalculatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CorrelationCacheData &&
          other.id == this.id &&
          other.ingredientId == this.ingredientId &&
          other.timeWindowHours == this.timeWindowHours &&
          other.occurrenceCount == this.occurrenceCount &&
          other.symptomCount == this.symptomCount &&
          other.symptomRate == this.symptomRate &&
          other.suspicionScore == this.suspicionScore &&
          other.lastCalculatedAt == this.lastCalculatedAt);
}

class CorrelationCacheCompanion extends UpdateCompanion<CorrelationCacheData> {
  final Value<int> id;
  final Value<int> ingredientId;
  final Value<int> timeWindowHours;
  final Value<int> occurrenceCount;
  final Value<int> symptomCount;
  final Value<double> symptomRate;
  final Value<double> suspicionScore;
  final Value<DateTime> lastCalculatedAt;
  const CorrelationCacheCompanion({
    this.id = const Value.absent(),
    this.ingredientId = const Value.absent(),
    this.timeWindowHours = const Value.absent(),
    this.occurrenceCount = const Value.absent(),
    this.symptomCount = const Value.absent(),
    this.symptomRate = const Value.absent(),
    this.suspicionScore = const Value.absent(),
    this.lastCalculatedAt = const Value.absent(),
  });
  CorrelationCacheCompanion.insert({
    this.id = const Value.absent(),
    required int ingredientId,
    required int timeWindowHours,
    required int occurrenceCount,
    required int symptomCount,
    required double symptomRate,
    required double suspicionScore,
    this.lastCalculatedAt = const Value.absent(),
  }) : ingredientId = Value(ingredientId),
       timeWindowHours = Value(timeWindowHours),
       occurrenceCount = Value(occurrenceCount),
       symptomCount = Value(symptomCount),
       symptomRate = Value(symptomRate),
       suspicionScore = Value(suspicionScore);
  static Insertable<CorrelationCacheData> custom({
    Expression<int>? id,
    Expression<int>? ingredientId,
    Expression<int>? timeWindowHours,
    Expression<int>? occurrenceCount,
    Expression<int>? symptomCount,
    Expression<double>? symptomRate,
    Expression<double>? suspicionScore,
    Expression<DateTime>? lastCalculatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ingredientId != null) 'ingredient_id': ingredientId,
      if (timeWindowHours != null) 'time_window_hours': timeWindowHours,
      if (occurrenceCount != null) 'occurrence_count': occurrenceCount,
      if (symptomCount != null) 'symptom_count': symptomCount,
      if (symptomRate != null) 'symptom_rate': symptomRate,
      if (suspicionScore != null) 'suspicion_score': suspicionScore,
      if (lastCalculatedAt != null) 'last_calculated_at': lastCalculatedAt,
    });
  }

  CorrelationCacheCompanion copyWith({
    Value<int>? id,
    Value<int>? ingredientId,
    Value<int>? timeWindowHours,
    Value<int>? occurrenceCount,
    Value<int>? symptomCount,
    Value<double>? symptomRate,
    Value<double>? suspicionScore,
    Value<DateTime>? lastCalculatedAt,
  }) {
    return CorrelationCacheCompanion(
      id: id ?? this.id,
      ingredientId: ingredientId ?? this.ingredientId,
      timeWindowHours: timeWindowHours ?? this.timeWindowHours,
      occurrenceCount: occurrenceCount ?? this.occurrenceCount,
      symptomCount: symptomCount ?? this.symptomCount,
      symptomRate: symptomRate ?? this.symptomRate,
      suspicionScore: suspicionScore ?? this.suspicionScore,
      lastCalculatedAt: lastCalculatedAt ?? this.lastCalculatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ingredientId.present) {
      map['ingredient_id'] = Variable<int>(ingredientId.value);
    }
    if (timeWindowHours.present) {
      map['time_window_hours'] = Variable<int>(timeWindowHours.value);
    }
    if (occurrenceCount.present) {
      map['occurrence_count'] = Variable<int>(occurrenceCount.value);
    }
    if (symptomCount.present) {
      map['symptom_count'] = Variable<int>(symptomCount.value);
    }
    if (symptomRate.present) {
      map['symptom_rate'] = Variable<double>(symptomRate.value);
    }
    if (suspicionScore.present) {
      map['suspicion_score'] = Variable<double>(suspicionScore.value);
    }
    if (lastCalculatedAt.present) {
      map['last_calculated_at'] = Variable<DateTime>(lastCalculatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CorrelationCacheCompanion(')
          ..write('id: $id, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('timeWindowHours: $timeWindowHours, ')
          ..write('occurrenceCount: $occurrenceCount, ')
          ..write('symptomCount: $symptomCount, ')
          ..write('symptomRate: $symptomRate, ')
          ..write('suspicionScore: $suspicionScore, ')
          ..write('lastCalculatedAt: $lastCalculatedAt')
          ..write(')'))
        .toString();
  }
}

class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, Reminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _hourMeta = const VerificationMeta('hour');
  @override
  late final GeneratedColumn<int> hour = GeneratedColumn<int>(
    'hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minuteMeta = const VerificationMeta('minute');
  @override
  late final GeneratedColumn<int> minute = GeneratedColumn<int>(
    'minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _daysOfWeekMeta = const VerificationMeta(
    'daysOfWeek',
  );
  @override
  late final GeneratedColumn<String> daysOfWeek = GeneratedColumn<String>(
    'days_of_week',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('1,2,3,4,5,6,7'),
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _reminderTypeMeta = const VerificationMeta(
    'reminderType',
  );
  @override
  late final GeneratedColumn<String> reminderType = GeneratedColumn<String>(
    'reminder_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('symptom'),
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Bugün nasıl hissediyorsun?'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    hour,
    minute,
    daysOfWeek,
    enabled,
    reminderType,
    message,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Reminder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('hour')) {
      context.handle(
        _hourMeta,
        hour.isAcceptableOrUnknown(data['hour']!, _hourMeta),
      );
    } else if (isInserting) {
      context.missing(_hourMeta);
    }
    if (data.containsKey('minute')) {
      context.handle(
        _minuteMeta,
        minute.isAcceptableOrUnknown(data['minute']!, _minuteMeta),
      );
    } else if (isInserting) {
      context.missing(_minuteMeta);
    }
    if (data.containsKey('days_of_week')) {
      context.handle(
        _daysOfWeekMeta,
        daysOfWeek.isAcceptableOrUnknown(
          data['days_of_week']!,
          _daysOfWeekMeta,
        ),
      );
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('reminder_type')) {
      context.handle(
        _reminderTypeMeta,
        reminderType.isAcceptableOrUnknown(
          data['reminder_type']!,
          _reminderTypeMeta,
        ),
      );
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reminder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      hour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hour'],
      )!,
      minute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minute'],
      )!,
      daysOfWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}days_of_week'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      reminderType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reminder_type'],
      )!,
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }
}

class Reminder extends DataClass implements Insertable<Reminder> {
  final int id;
  final int hour;
  final int minute;
  final String daysOfWeek;
  final bool enabled;
  final String reminderType;
  final String message;
  final DateTime createdAt;
  const Reminder({
    required this.id,
    required this.hour,
    required this.minute,
    required this.daysOfWeek,
    required this.enabled,
    required this.reminderType,
    required this.message,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['hour'] = Variable<int>(hour);
    map['minute'] = Variable<int>(minute);
    map['days_of_week'] = Variable<String>(daysOfWeek);
    map['enabled'] = Variable<bool>(enabled);
    map['reminder_type'] = Variable<String>(reminderType);
    map['message'] = Variable<String>(message);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      hour: Value(hour),
      minute: Value(minute),
      daysOfWeek: Value(daysOfWeek),
      enabled: Value(enabled),
      reminderType: Value(reminderType),
      message: Value(message),
      createdAt: Value(createdAt),
    );
  }

  factory Reminder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reminder(
      id: serializer.fromJson<int>(json['id']),
      hour: serializer.fromJson<int>(json['hour']),
      minute: serializer.fromJson<int>(json['minute']),
      daysOfWeek: serializer.fromJson<String>(json['daysOfWeek']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      reminderType: serializer.fromJson<String>(json['reminderType']),
      message: serializer.fromJson<String>(json['message']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'hour': serializer.toJson<int>(hour),
      'minute': serializer.toJson<int>(minute),
      'daysOfWeek': serializer.toJson<String>(daysOfWeek),
      'enabled': serializer.toJson<bool>(enabled),
      'reminderType': serializer.toJson<String>(reminderType),
      'message': serializer.toJson<String>(message),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Reminder copyWith({
    int? id,
    int? hour,
    int? minute,
    String? daysOfWeek,
    bool? enabled,
    String? reminderType,
    String? message,
    DateTime? createdAt,
  }) => Reminder(
    id: id ?? this.id,
    hour: hour ?? this.hour,
    minute: minute ?? this.minute,
    daysOfWeek: daysOfWeek ?? this.daysOfWeek,
    enabled: enabled ?? this.enabled,
    reminderType: reminderType ?? this.reminderType,
    message: message ?? this.message,
    createdAt: createdAt ?? this.createdAt,
  );
  Reminder copyWithCompanion(RemindersCompanion data) {
    return Reminder(
      id: data.id.present ? data.id.value : this.id,
      hour: data.hour.present ? data.hour.value : this.hour,
      minute: data.minute.present ? data.minute.value : this.minute,
      daysOfWeek: data.daysOfWeek.present
          ? data.daysOfWeek.value
          : this.daysOfWeek,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      reminderType: data.reminderType.present
          ? data.reminderType.value
          : this.reminderType,
      message: data.message.present ? data.message.value : this.message,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reminder(')
          ..write('id: $id, ')
          ..write('hour: $hour, ')
          ..write('minute: $minute, ')
          ..write('daysOfWeek: $daysOfWeek, ')
          ..write('enabled: $enabled, ')
          ..write('reminderType: $reminderType, ')
          ..write('message: $message, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    hour,
    minute,
    daysOfWeek,
    enabled,
    reminderType,
    message,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reminder &&
          other.id == this.id &&
          other.hour == this.hour &&
          other.minute == this.minute &&
          other.daysOfWeek == this.daysOfWeek &&
          other.enabled == this.enabled &&
          other.reminderType == this.reminderType &&
          other.message == this.message &&
          other.createdAt == this.createdAt);
}

class RemindersCompanion extends UpdateCompanion<Reminder> {
  final Value<int> id;
  final Value<int> hour;
  final Value<int> minute;
  final Value<String> daysOfWeek;
  final Value<bool> enabled;
  final Value<String> reminderType;
  final Value<String> message;
  final Value<DateTime> createdAt;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.hour = const Value.absent(),
    this.minute = const Value.absent(),
    this.daysOfWeek = const Value.absent(),
    this.enabled = const Value.absent(),
    this.reminderType = const Value.absent(),
    this.message = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  RemindersCompanion.insert({
    this.id = const Value.absent(),
    required int hour,
    required int minute,
    this.daysOfWeek = const Value.absent(),
    this.enabled = const Value.absent(),
    this.reminderType = const Value.absent(),
    this.message = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : hour = Value(hour),
       minute = Value(minute);
  static Insertable<Reminder> custom({
    Expression<int>? id,
    Expression<int>? hour,
    Expression<int>? minute,
    Expression<String>? daysOfWeek,
    Expression<bool>? enabled,
    Expression<String>? reminderType,
    Expression<String>? message,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (hour != null) 'hour': hour,
      if (minute != null) 'minute': minute,
      if (daysOfWeek != null) 'days_of_week': daysOfWeek,
      if (enabled != null) 'enabled': enabled,
      if (reminderType != null) 'reminder_type': reminderType,
      if (message != null) 'message': message,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  RemindersCompanion copyWith({
    Value<int>? id,
    Value<int>? hour,
    Value<int>? minute,
    Value<String>? daysOfWeek,
    Value<bool>? enabled,
    Value<String>? reminderType,
    Value<String>? message,
    Value<DateTime>? createdAt,
  }) {
    return RemindersCompanion(
      id: id ?? this.id,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      enabled: enabled ?? this.enabled,
      reminderType: reminderType ?? this.reminderType,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (hour.present) {
      map['hour'] = Variable<int>(hour.value);
    }
    if (minute.present) {
      map['minute'] = Variable<int>(minute.value);
    }
    if (daysOfWeek.present) {
      map['days_of_week'] = Variable<String>(daysOfWeek.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (reminderType.present) {
      map['reminder_type'] = Variable<String>(reminderType.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('hour: $hour, ')
          ..write('minute: $minute, ')
          ..write('daysOfWeek: $daysOfWeek, ')
          ..write('enabled: $enabled, ')
          ..write('reminderType: $reminderType, ')
          ..write('message: $message, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $IngredientsTable ingredients = $IngredientsTable(this);
  late final $MealTemplatesTable mealTemplates = $MealTemplatesTable(this);
  late final $MealsTable meals = $MealsTable(this);
  late final $MealIngredientsTable mealIngredients = $MealIngredientsTable(
    this,
  );
  late final $SymptomLogsTable symptomLogs = $SymptomLogsTable(this);
  late final $SymptomEntriesTable symptomEntries = $SymptomEntriesTable(this);
  late final $CorrelationCacheTable correlationCache = $CorrelationCacheTable(
    this,
  );
  late final $RemindersTable reminders = $RemindersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    ingredients,
    mealTemplates,
    meals,
    mealIngredients,
    symptomLogs,
    symptomEntries,
    correlationCache,
    reminders,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'meals',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('meal_ingredients', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'symptom_logs',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('symptom_entries', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$IngredientsTableCreateCompanionBuilder =
    IngredientsCompanion Function({
      Value<int> id,
      required String name,
      required String nameNormalized,
      Value<String> fodmapLevel,
      Value<bool> isLactose,
      Value<bool> isGluten,
      Value<bool> isHighHistamine,
      Value<bool> isCaffeine,
      Value<String> category,
      Value<String?> fodmapGroup,
      Value<String> source,
      Value<String?> offBarcode,
    });
typedef $$IngredientsTableUpdateCompanionBuilder =
    IngredientsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> nameNormalized,
      Value<String> fodmapLevel,
      Value<bool> isLactose,
      Value<bool> isGluten,
      Value<bool> isHighHistamine,
      Value<bool> isCaffeine,
      Value<String> category,
      Value<String?> fodmapGroup,
      Value<String> source,
      Value<String?> offBarcode,
    });

final class $$IngredientsTableReferences
    extends BaseReferences<_$AppDatabase, $IngredientsTable, Ingredient> {
  $$IngredientsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MealIngredientsTable, List<MealIngredient>>
  _mealIngredientsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.mealIngredients,
    aliasName: $_aliasNameGenerator(
      db.ingredients.id,
      db.mealIngredients.ingredientId,
    ),
  );

  $$MealIngredientsTableProcessedTableManager get mealIngredientsRefs {
    final manager = $$MealIngredientsTableTableManager(
      $_db,
      $_db.mealIngredients,
    ).filter((f) => f.ingredientId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _mealIngredientsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CorrelationCacheTable, List<CorrelationCacheData>>
  _correlationCacheRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.correlationCache,
    aliasName: $_aliasNameGenerator(
      db.ingredients.id,
      db.correlationCache.ingredientId,
    ),
  );

  $$CorrelationCacheTableProcessedTableManager get correlationCacheRefs {
    final manager = $$CorrelationCacheTableTableManager(
      $_db,
      $_db.correlationCache,
    ).filter((f) => f.ingredientId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _correlationCacheRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$IngredientsTableFilterComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameNormalized => $composableBuilder(
    column: $table.nameNormalized,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fodmapLevel => $composableBuilder(
    column: $table.fodmapLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLactose => $composableBuilder(
    column: $table.isLactose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isGluten => $composableBuilder(
    column: $table.isGluten,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isHighHistamine => $composableBuilder(
    column: $table.isHighHistamine,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCaffeine => $composableBuilder(
    column: $table.isCaffeine,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fodmapGroup => $composableBuilder(
    column: $table.fodmapGroup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get offBarcode => $composableBuilder(
    column: $table.offBarcode,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> mealIngredientsRefs(
    Expression<bool> Function($$MealIngredientsTableFilterComposer f) f,
  ) {
    final $$MealIngredientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealIngredients,
      getReferencedColumn: (t) => t.ingredientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealIngredientsTableFilterComposer(
            $db: $db,
            $table: $db.mealIngredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> correlationCacheRefs(
    Expression<bool> Function($$CorrelationCacheTableFilterComposer f) f,
  ) {
    final $$CorrelationCacheTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.correlationCache,
      getReferencedColumn: (t) => t.ingredientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CorrelationCacheTableFilterComposer(
            $db: $db,
            $table: $db.correlationCache,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IngredientsTableOrderingComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameNormalized => $composableBuilder(
    column: $table.nameNormalized,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fodmapLevel => $composableBuilder(
    column: $table.fodmapLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLactose => $composableBuilder(
    column: $table.isLactose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isGluten => $composableBuilder(
    column: $table.isGluten,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isHighHistamine => $composableBuilder(
    column: $table.isHighHistamine,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCaffeine => $composableBuilder(
    column: $table.isCaffeine,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fodmapGroup => $composableBuilder(
    column: $table.fodmapGroup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get offBarcode => $composableBuilder(
    column: $table.offBarcode,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$IngredientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameNormalized => $composableBuilder(
    column: $table.nameNormalized,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fodmapLevel => $composableBuilder(
    column: $table.fodmapLevel,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isLactose =>
      $composableBuilder(column: $table.isLactose, builder: (column) => column);

  GeneratedColumn<bool> get isGluten =>
      $composableBuilder(column: $table.isGluten, builder: (column) => column);

  GeneratedColumn<bool> get isHighHistamine => $composableBuilder(
    column: $table.isHighHistamine,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCaffeine => $composableBuilder(
    column: $table.isCaffeine,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get fodmapGroup => $composableBuilder(
    column: $table.fodmapGroup,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get offBarcode => $composableBuilder(
    column: $table.offBarcode,
    builder: (column) => column,
  );

  Expression<T> mealIngredientsRefs<T extends Object>(
    Expression<T> Function($$MealIngredientsTableAnnotationComposer a) f,
  ) {
    final $$MealIngredientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealIngredients,
      getReferencedColumn: (t) => t.ingredientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealIngredientsTableAnnotationComposer(
            $db: $db,
            $table: $db.mealIngredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> correlationCacheRefs<T extends Object>(
    Expression<T> Function($$CorrelationCacheTableAnnotationComposer a) f,
  ) {
    final $$CorrelationCacheTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.correlationCache,
      getReferencedColumn: (t) => t.ingredientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CorrelationCacheTableAnnotationComposer(
            $db: $db,
            $table: $db.correlationCache,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IngredientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IngredientsTable,
          Ingredient,
          $$IngredientsTableFilterComposer,
          $$IngredientsTableOrderingComposer,
          $$IngredientsTableAnnotationComposer,
          $$IngredientsTableCreateCompanionBuilder,
          $$IngredientsTableUpdateCompanionBuilder,
          (Ingredient, $$IngredientsTableReferences),
          Ingredient,
          PrefetchHooks Function({
            bool mealIngredientsRefs,
            bool correlationCacheRefs,
          })
        > {
  $$IngredientsTableTableManager(_$AppDatabase db, $IngredientsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IngredientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IngredientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IngredientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> nameNormalized = const Value.absent(),
                Value<String> fodmapLevel = const Value.absent(),
                Value<bool> isLactose = const Value.absent(),
                Value<bool> isGluten = const Value.absent(),
                Value<bool> isHighHistamine = const Value.absent(),
                Value<bool> isCaffeine = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> fodmapGroup = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> offBarcode = const Value.absent(),
              }) => IngredientsCompanion(
                id: id,
                name: name,
                nameNormalized: nameNormalized,
                fodmapLevel: fodmapLevel,
                isLactose: isLactose,
                isGluten: isGluten,
                isHighHistamine: isHighHistamine,
                isCaffeine: isCaffeine,
                category: category,
                fodmapGroup: fodmapGroup,
                source: source,
                offBarcode: offBarcode,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String nameNormalized,
                Value<String> fodmapLevel = const Value.absent(),
                Value<bool> isLactose = const Value.absent(),
                Value<bool> isGluten = const Value.absent(),
                Value<bool> isHighHistamine = const Value.absent(),
                Value<bool> isCaffeine = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> fodmapGroup = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> offBarcode = const Value.absent(),
              }) => IngredientsCompanion.insert(
                id: id,
                name: name,
                nameNormalized: nameNormalized,
                fodmapLevel: fodmapLevel,
                isLactose: isLactose,
                isGluten: isGluten,
                isHighHistamine: isHighHistamine,
                isCaffeine: isCaffeine,
                category: category,
                fodmapGroup: fodmapGroup,
                source: source,
                offBarcode: offBarcode,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IngredientsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({mealIngredientsRefs = false, correlationCacheRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (mealIngredientsRefs) db.mealIngredients,
                    if (correlationCacheRefs) db.correlationCache,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (mealIngredientsRefs)
                        await $_getPrefetchedData<
                          Ingredient,
                          $IngredientsTable,
                          MealIngredient
                        >(
                          currentTable: table,
                          referencedTable: $$IngredientsTableReferences
                              ._mealIngredientsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IngredientsTableReferences(
                                db,
                                table,
                                p0,
                              ).mealIngredientsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ingredientId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (correlationCacheRefs)
                        await $_getPrefetchedData<
                          Ingredient,
                          $IngredientsTable,
                          CorrelationCacheData
                        >(
                          currentTable: table,
                          referencedTable: $$IngredientsTableReferences
                              ._correlationCacheRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IngredientsTableReferences(
                                db,
                                table,
                                p0,
                              ).correlationCacheRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ingredientId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$IngredientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IngredientsTable,
      Ingredient,
      $$IngredientsTableFilterComposer,
      $$IngredientsTableOrderingComposer,
      $$IngredientsTableAnnotationComposer,
      $$IngredientsTableCreateCompanionBuilder,
      $$IngredientsTableUpdateCompanionBuilder,
      (Ingredient, $$IngredientsTableReferences),
      Ingredient,
      PrefetchHooks Function({
        bool mealIngredientsRefs,
        bool correlationCacheRefs,
      })
    >;
typedef $$MealTemplatesTableCreateCompanionBuilder =
    MealTemplatesCompanion Function({
      Value<int> id,
      required String name,
      required String nameNormalized,
      required String ingredientsJson,
      Value<bool> isBuiltin,
      Value<DateTime> createdAt,
    });
typedef $$MealTemplatesTableUpdateCompanionBuilder =
    MealTemplatesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> nameNormalized,
      Value<String> ingredientsJson,
      Value<bool> isBuiltin,
      Value<DateTime> createdAt,
    });

class $$MealTemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $MealTemplatesTable> {
  $$MealTemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameNormalized => $composableBuilder(
    column: $table.nameNormalized,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ingredientsJson => $composableBuilder(
    column: $table.ingredientsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isBuiltin => $composableBuilder(
    column: $table.isBuiltin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MealTemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $MealTemplatesTable> {
  $$MealTemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameNormalized => $composableBuilder(
    column: $table.nameNormalized,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ingredientsJson => $composableBuilder(
    column: $table.ingredientsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isBuiltin => $composableBuilder(
    column: $table.isBuiltin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MealTemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealTemplatesTable> {
  $$MealTemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameNormalized => $composableBuilder(
    column: $table.nameNormalized,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ingredientsJson => $composableBuilder(
    column: $table.ingredientsJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isBuiltin =>
      $composableBuilder(column: $table.isBuiltin, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$MealTemplatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealTemplatesTable,
          MealTemplate,
          $$MealTemplatesTableFilterComposer,
          $$MealTemplatesTableOrderingComposer,
          $$MealTemplatesTableAnnotationComposer,
          $$MealTemplatesTableCreateCompanionBuilder,
          $$MealTemplatesTableUpdateCompanionBuilder,
          (
            MealTemplate,
            BaseReferences<_$AppDatabase, $MealTemplatesTable, MealTemplate>,
          ),
          MealTemplate,
          PrefetchHooks Function()
        > {
  $$MealTemplatesTableTableManager(_$AppDatabase db, $MealTemplatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealTemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealTemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealTemplatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> nameNormalized = const Value.absent(),
                Value<String> ingredientsJson = const Value.absent(),
                Value<bool> isBuiltin = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MealTemplatesCompanion(
                id: id,
                name: name,
                nameNormalized: nameNormalized,
                ingredientsJson: ingredientsJson,
                isBuiltin: isBuiltin,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String nameNormalized,
                required String ingredientsJson,
                Value<bool> isBuiltin = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MealTemplatesCompanion.insert(
                id: id,
                name: name,
                nameNormalized: nameNormalized,
                ingredientsJson: ingredientsJson,
                isBuiltin: isBuiltin,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MealTemplatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealTemplatesTable,
      MealTemplate,
      $$MealTemplatesTableFilterComposer,
      $$MealTemplatesTableOrderingComposer,
      $$MealTemplatesTableAnnotationComposer,
      $$MealTemplatesTableCreateCompanionBuilder,
      $$MealTemplatesTableUpdateCompanionBuilder,
      (
        MealTemplate,
        BaseReferences<_$AppDatabase, $MealTemplatesTable, MealTemplate>,
      ),
      MealTemplate,
      PrefetchHooks Function()
    >;
typedef $$MealsTableCreateCompanionBuilder =
    MealsCompanion Function({
      Value<int> id,
      required String name,
      Value<String> mealType,
      Value<DateTime> eatenAt,
      Value<String> portionSize,
      Value<String?> photoPath,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });
typedef $$MealsTableUpdateCompanionBuilder =
    MealsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> mealType,
      Value<DateTime> eatenAt,
      Value<String> portionSize,
      Value<String?> photoPath,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });

final class $$MealsTableReferences
    extends BaseReferences<_$AppDatabase, $MealsTable, Meal> {
  $$MealsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MealIngredientsTable, List<MealIngredient>>
  _mealIngredientsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.mealIngredients,
    aliasName: $_aliasNameGenerator(db.meals.id, db.mealIngredients.mealId),
  );

  $$MealIngredientsTableProcessedTableManager get mealIngredientsRefs {
    final manager = $$MealIngredientsTableTableManager(
      $_db,
      $_db.mealIngredients,
    ).filter((f) => f.mealId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _mealIngredientsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MealsTableFilterComposer extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get eatenAt => $composableBuilder(
    column: $table.eatenAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get portionSize => $composableBuilder(
    column: $table.portionSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> mealIngredientsRefs(
    Expression<bool> Function($$MealIngredientsTableFilterComposer f) f,
  ) {
    final $$MealIngredientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealIngredients,
      getReferencedColumn: (t) => t.mealId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealIngredientsTableFilterComposer(
            $db: $db,
            $table: $db.mealIngredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MealsTableOrderingComposer
    extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get eatenAt => $composableBuilder(
    column: $table.eatenAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get portionSize => $composableBuilder(
    column: $table.portionSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MealsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get mealType =>
      $composableBuilder(column: $table.mealType, builder: (column) => column);

  GeneratedColumn<DateTime> get eatenAt =>
      $composableBuilder(column: $table.eatenAt, builder: (column) => column);

  GeneratedColumn<String> get portionSize => $composableBuilder(
    column: $table.portionSize,
    builder: (column) => column,
  );

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> mealIngredientsRefs<T extends Object>(
    Expression<T> Function($$MealIngredientsTableAnnotationComposer a) f,
  ) {
    final $$MealIngredientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealIngredients,
      getReferencedColumn: (t) => t.mealId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealIngredientsTableAnnotationComposer(
            $db: $db,
            $table: $db.mealIngredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MealsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealsTable,
          Meal,
          $$MealsTableFilterComposer,
          $$MealsTableOrderingComposer,
          $$MealsTableAnnotationComposer,
          $$MealsTableCreateCompanionBuilder,
          $$MealsTableUpdateCompanionBuilder,
          (Meal, $$MealsTableReferences),
          Meal,
          PrefetchHooks Function({bool mealIngredientsRefs})
        > {
  $$MealsTableTableManager(_$AppDatabase db, $MealsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> mealType = const Value.absent(),
                Value<DateTime> eatenAt = const Value.absent(),
                Value<String> portionSize = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MealsCompanion(
                id: id,
                name: name,
                mealType: mealType,
                eatenAt: eatenAt,
                portionSize: portionSize,
                photoPath: photoPath,
                notes: notes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String> mealType = const Value.absent(),
                Value<DateTime> eatenAt = const Value.absent(),
                Value<String> portionSize = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MealsCompanion.insert(
                id: id,
                name: name,
                mealType: mealType,
                eatenAt: eatenAt,
                portionSize: portionSize,
                photoPath: photoPath,
                notes: notes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$MealsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({mealIngredientsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (mealIngredientsRefs) db.mealIngredients,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (mealIngredientsRefs)
                    await $_getPrefetchedData<
                      Meal,
                      $MealsTable,
                      MealIngredient
                    >(
                      currentTable: table,
                      referencedTable: $$MealsTableReferences
                          ._mealIngredientsRefsTable(db),
                      managerFromTypedResult: (p0) => $$MealsTableReferences(
                        db,
                        table,
                        p0,
                      ).mealIngredientsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.mealId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$MealsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealsTable,
      Meal,
      $$MealsTableFilterComposer,
      $$MealsTableOrderingComposer,
      $$MealsTableAnnotationComposer,
      $$MealsTableCreateCompanionBuilder,
      $$MealsTableUpdateCompanionBuilder,
      (Meal, $$MealsTableReferences),
      Meal,
      PrefetchHooks Function({bool mealIngredientsRefs})
    >;
typedef $$MealIngredientsTableCreateCompanionBuilder =
    MealIngredientsCompanion Function({
      Value<int> id,
      required int mealId,
      required int ingredientId,
      Value<String?> customNote,
    });
typedef $$MealIngredientsTableUpdateCompanionBuilder =
    MealIngredientsCompanion Function({
      Value<int> id,
      Value<int> mealId,
      Value<int> ingredientId,
      Value<String?> customNote,
    });

final class $$MealIngredientsTableReferences
    extends
        BaseReferences<_$AppDatabase, $MealIngredientsTable, MealIngredient> {
  $$MealIngredientsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MealsTable _mealIdTable(_$AppDatabase db) => db.meals.createAlias(
    $_aliasNameGenerator(db.mealIngredients.mealId, db.meals.id),
  );

  $$MealsTableProcessedTableManager get mealId {
    final $_column = $_itemColumn<int>('meal_id')!;

    final manager = $$MealsTableTableManager(
      $_db,
      $_db.meals,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mealIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $IngredientsTable _ingredientIdTable(_$AppDatabase db) =>
      db.ingredients.createAlias(
        $_aliasNameGenerator(
          db.mealIngredients.ingredientId,
          db.ingredients.id,
        ),
      );

  $$IngredientsTableProcessedTableManager get ingredientId {
    final $_column = $_itemColumn<int>('ingredient_id')!;

    final manager = $$IngredientsTableTableManager(
      $_db,
      $_db.ingredients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ingredientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MealIngredientsTableFilterComposer
    extends Composer<_$AppDatabase, $MealIngredientsTable> {
  $$MealIngredientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customNote => $composableBuilder(
    column: $table.customNote,
    builder: (column) => ColumnFilters(column),
  );

  $$MealsTableFilterComposer get mealId {
    final $$MealsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealId,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealsTableFilterComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IngredientsTableFilterComposer get ingredientId {
    final $$IngredientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableFilterComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealIngredientsTableOrderingComposer
    extends Composer<_$AppDatabase, $MealIngredientsTable> {
  $$MealIngredientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customNote => $composableBuilder(
    column: $table.customNote,
    builder: (column) => ColumnOrderings(column),
  );

  $$MealsTableOrderingComposer get mealId {
    final $$MealsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealId,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealsTableOrderingComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IngredientsTableOrderingComposer get ingredientId {
    final $$IngredientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableOrderingComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealIngredientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealIngredientsTable> {
  $$MealIngredientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get customNote => $composableBuilder(
    column: $table.customNote,
    builder: (column) => column,
  );

  $$MealsTableAnnotationComposer get mealId {
    final $$MealsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealId,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealsTableAnnotationComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IngredientsTableAnnotationComposer get ingredientId {
    final $$IngredientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableAnnotationComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealIngredientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealIngredientsTable,
          MealIngredient,
          $$MealIngredientsTableFilterComposer,
          $$MealIngredientsTableOrderingComposer,
          $$MealIngredientsTableAnnotationComposer,
          $$MealIngredientsTableCreateCompanionBuilder,
          $$MealIngredientsTableUpdateCompanionBuilder,
          (MealIngredient, $$MealIngredientsTableReferences),
          MealIngredient,
          PrefetchHooks Function({bool mealId, bool ingredientId})
        > {
  $$MealIngredientsTableTableManager(
    _$AppDatabase db,
    $MealIngredientsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealIngredientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealIngredientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealIngredientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> mealId = const Value.absent(),
                Value<int> ingredientId = const Value.absent(),
                Value<String?> customNote = const Value.absent(),
              }) => MealIngredientsCompanion(
                id: id,
                mealId: mealId,
                ingredientId: ingredientId,
                customNote: customNote,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int mealId,
                required int ingredientId,
                Value<String?> customNote = const Value.absent(),
              }) => MealIngredientsCompanion.insert(
                id: id,
                mealId: mealId,
                ingredientId: ingredientId,
                customNote: customNote,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MealIngredientsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({mealId = false, ingredientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (mealId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.mealId,
                                referencedTable:
                                    $$MealIngredientsTableReferences
                                        ._mealIdTable(db),
                                referencedColumn:
                                    $$MealIngredientsTableReferences
                                        ._mealIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (ingredientId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ingredientId,
                                referencedTable:
                                    $$MealIngredientsTableReferences
                                        ._ingredientIdTable(db),
                                referencedColumn:
                                    $$MealIngredientsTableReferences
                                        ._ingredientIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MealIngredientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealIngredientsTable,
      MealIngredient,
      $$MealIngredientsTableFilterComposer,
      $$MealIngredientsTableOrderingComposer,
      $$MealIngredientsTableAnnotationComposer,
      $$MealIngredientsTableCreateCompanionBuilder,
      $$MealIngredientsTableUpdateCompanionBuilder,
      (MealIngredient, $$MealIngredientsTableReferences),
      MealIngredient,
      PrefetchHooks Function({bool mealId, bool ingredientId})
    >;
typedef $$SymptomLogsTableCreateCompanionBuilder =
    SymptomLogsCompanion Function({
      Value<int> id,
      Value<DateTime> loggedAt,
      Value<double?> overallFeeling,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });
typedef $$SymptomLogsTableUpdateCompanionBuilder =
    SymptomLogsCompanion Function({
      Value<int> id,
      Value<DateTime> loggedAt,
      Value<double?> overallFeeling,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });

final class $$SymptomLogsTableReferences
    extends BaseReferences<_$AppDatabase, $SymptomLogsTable, SymptomLog> {
  $$SymptomLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SymptomEntriesTable, List<SymptomEntry>>
  _symptomEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.symptomEntries,
    aliasName: $_aliasNameGenerator(
      db.symptomLogs.id,
      db.symptomEntries.symptomLogId,
    ),
  );

  $$SymptomEntriesTableProcessedTableManager get symptomEntriesRefs {
    final manager = $$SymptomEntriesTableTableManager(
      $_db,
      $_db.symptomEntries,
    ).filter((f) => f.symptomLogId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_symptomEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SymptomLogsTableFilterComposer
    extends Composer<_$AppDatabase, $SymptomLogsTable> {
  $$SymptomLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get overallFeeling => $composableBuilder(
    column: $table.overallFeeling,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> symptomEntriesRefs(
    Expression<bool> Function($$SymptomEntriesTableFilterComposer f) f,
  ) {
    final $$SymptomEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.symptomEntries,
      getReferencedColumn: (t) => t.symptomLogId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SymptomEntriesTableFilterComposer(
            $db: $db,
            $table: $db.symptomEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SymptomLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $SymptomLogsTable> {
  $$SymptomLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get overallFeeling => $composableBuilder(
    column: $table.overallFeeling,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SymptomLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SymptomLogsTable> {
  $$SymptomLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get loggedAt =>
      $composableBuilder(column: $table.loggedAt, builder: (column) => column);

  GeneratedColumn<double> get overallFeeling => $composableBuilder(
    column: $table.overallFeeling,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> symptomEntriesRefs<T extends Object>(
    Expression<T> Function($$SymptomEntriesTableAnnotationComposer a) f,
  ) {
    final $$SymptomEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.symptomEntries,
      getReferencedColumn: (t) => t.symptomLogId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SymptomEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.symptomEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SymptomLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SymptomLogsTable,
          SymptomLog,
          $$SymptomLogsTableFilterComposer,
          $$SymptomLogsTableOrderingComposer,
          $$SymptomLogsTableAnnotationComposer,
          $$SymptomLogsTableCreateCompanionBuilder,
          $$SymptomLogsTableUpdateCompanionBuilder,
          (SymptomLog, $$SymptomLogsTableReferences),
          SymptomLog,
          PrefetchHooks Function({bool symptomEntriesRefs})
        > {
  $$SymptomLogsTableTableManager(_$AppDatabase db, $SymptomLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SymptomLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SymptomLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SymptomLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> loggedAt = const Value.absent(),
                Value<double?> overallFeeling = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SymptomLogsCompanion(
                id: id,
                loggedAt: loggedAt,
                overallFeeling: overallFeeling,
                notes: notes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> loggedAt = const Value.absent(),
                Value<double?> overallFeeling = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SymptomLogsCompanion.insert(
                id: id,
                loggedAt: loggedAt,
                overallFeeling: overallFeeling,
                notes: notes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SymptomLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({symptomEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (symptomEntriesRefs) db.symptomEntries,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (symptomEntriesRefs)
                    await $_getPrefetchedData<
                      SymptomLog,
                      $SymptomLogsTable,
                      SymptomEntry
                    >(
                      currentTable: table,
                      referencedTable: $$SymptomLogsTableReferences
                          ._symptomEntriesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SymptomLogsTableReferences(
                            db,
                            table,
                            p0,
                          ).symptomEntriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.symptomLogId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SymptomLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SymptomLogsTable,
      SymptomLog,
      $$SymptomLogsTableFilterComposer,
      $$SymptomLogsTableOrderingComposer,
      $$SymptomLogsTableAnnotationComposer,
      $$SymptomLogsTableCreateCompanionBuilder,
      $$SymptomLogsTableUpdateCompanionBuilder,
      (SymptomLog, $$SymptomLogsTableReferences),
      SymptomLog,
      PrefetchHooks Function({bool symptomEntriesRefs})
    >;
typedef $$SymptomEntriesTableCreateCompanionBuilder =
    SymptomEntriesCompanion Function({
      Value<int> id,
      required int symptomLogId,
      required String symptomType,
      required double severity,
    });
typedef $$SymptomEntriesTableUpdateCompanionBuilder =
    SymptomEntriesCompanion Function({
      Value<int> id,
      Value<int> symptomLogId,
      Value<String> symptomType,
      Value<double> severity,
    });

final class $$SymptomEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $SymptomEntriesTable, SymptomEntry> {
  $$SymptomEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SymptomLogsTable _symptomLogIdTable(_$AppDatabase db) =>
      db.symptomLogs.createAlias(
        $_aliasNameGenerator(db.symptomEntries.symptomLogId, db.symptomLogs.id),
      );

  $$SymptomLogsTableProcessedTableManager get symptomLogId {
    final $_column = $_itemColumn<int>('symptom_log_id')!;

    final manager = $$SymptomLogsTableTableManager(
      $_db,
      $_db.symptomLogs,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_symptomLogIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SymptomEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $SymptomEntriesTable> {
  $$SymptomEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get symptomType => $composableBuilder(
    column: $table.symptomType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnFilters(column),
  );

  $$SymptomLogsTableFilterComposer get symptomLogId {
    final $$SymptomLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.symptomLogId,
      referencedTable: $db.symptomLogs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SymptomLogsTableFilterComposer(
            $db: $db,
            $table: $db.symptomLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SymptomEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SymptomEntriesTable> {
  $$SymptomEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get symptomType => $composableBuilder(
    column: $table.symptomType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnOrderings(column),
  );

  $$SymptomLogsTableOrderingComposer get symptomLogId {
    final $$SymptomLogsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.symptomLogId,
      referencedTable: $db.symptomLogs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SymptomLogsTableOrderingComposer(
            $db: $db,
            $table: $db.symptomLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SymptomEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SymptomEntriesTable> {
  $$SymptomEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get symptomType => $composableBuilder(
    column: $table.symptomType,
    builder: (column) => column,
  );

  GeneratedColumn<double> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  $$SymptomLogsTableAnnotationComposer get symptomLogId {
    final $$SymptomLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.symptomLogId,
      referencedTable: $db.symptomLogs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SymptomLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.symptomLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SymptomEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SymptomEntriesTable,
          SymptomEntry,
          $$SymptomEntriesTableFilterComposer,
          $$SymptomEntriesTableOrderingComposer,
          $$SymptomEntriesTableAnnotationComposer,
          $$SymptomEntriesTableCreateCompanionBuilder,
          $$SymptomEntriesTableUpdateCompanionBuilder,
          (SymptomEntry, $$SymptomEntriesTableReferences),
          SymptomEntry,
          PrefetchHooks Function({bool symptomLogId})
        > {
  $$SymptomEntriesTableTableManager(
    _$AppDatabase db,
    $SymptomEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SymptomEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SymptomEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SymptomEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> symptomLogId = const Value.absent(),
                Value<String> symptomType = const Value.absent(),
                Value<double> severity = const Value.absent(),
              }) => SymptomEntriesCompanion(
                id: id,
                symptomLogId: symptomLogId,
                symptomType: symptomType,
                severity: severity,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int symptomLogId,
                required String symptomType,
                required double severity,
              }) => SymptomEntriesCompanion.insert(
                id: id,
                symptomLogId: symptomLogId,
                symptomType: symptomType,
                severity: severity,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SymptomEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({symptomLogId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (symptomLogId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.symptomLogId,
                                referencedTable: $$SymptomEntriesTableReferences
                                    ._symptomLogIdTable(db),
                                referencedColumn:
                                    $$SymptomEntriesTableReferences
                                        ._symptomLogIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SymptomEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SymptomEntriesTable,
      SymptomEntry,
      $$SymptomEntriesTableFilterComposer,
      $$SymptomEntriesTableOrderingComposer,
      $$SymptomEntriesTableAnnotationComposer,
      $$SymptomEntriesTableCreateCompanionBuilder,
      $$SymptomEntriesTableUpdateCompanionBuilder,
      (SymptomEntry, $$SymptomEntriesTableReferences),
      SymptomEntry,
      PrefetchHooks Function({bool symptomLogId})
    >;
typedef $$CorrelationCacheTableCreateCompanionBuilder =
    CorrelationCacheCompanion Function({
      Value<int> id,
      required int ingredientId,
      required int timeWindowHours,
      required int occurrenceCount,
      required int symptomCount,
      required double symptomRate,
      required double suspicionScore,
      Value<DateTime> lastCalculatedAt,
    });
typedef $$CorrelationCacheTableUpdateCompanionBuilder =
    CorrelationCacheCompanion Function({
      Value<int> id,
      Value<int> ingredientId,
      Value<int> timeWindowHours,
      Value<int> occurrenceCount,
      Value<int> symptomCount,
      Value<double> symptomRate,
      Value<double> suspicionScore,
      Value<DateTime> lastCalculatedAt,
    });

final class $$CorrelationCacheTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CorrelationCacheTable,
          CorrelationCacheData
        > {
  $$CorrelationCacheTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $IngredientsTable _ingredientIdTable(_$AppDatabase db) =>
      db.ingredients.createAlias(
        $_aliasNameGenerator(
          db.correlationCache.ingredientId,
          db.ingredients.id,
        ),
      );

  $$IngredientsTableProcessedTableManager get ingredientId {
    final $_column = $_itemColumn<int>('ingredient_id')!;

    final manager = $$IngredientsTableTableManager(
      $_db,
      $_db.ingredients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ingredientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CorrelationCacheTableFilterComposer
    extends Composer<_$AppDatabase, $CorrelationCacheTable> {
  $$CorrelationCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timeWindowHours => $composableBuilder(
    column: $table.timeWindowHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get occurrenceCount => $composableBuilder(
    column: $table.occurrenceCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get symptomCount => $composableBuilder(
    column: $table.symptomCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get symptomRate => $composableBuilder(
    column: $table.symptomRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get suspicionScore => $composableBuilder(
    column: $table.suspicionScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastCalculatedAt => $composableBuilder(
    column: $table.lastCalculatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$IngredientsTableFilterComposer get ingredientId {
    final $$IngredientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableFilterComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CorrelationCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $CorrelationCacheTable> {
  $$CorrelationCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timeWindowHours => $composableBuilder(
    column: $table.timeWindowHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get occurrenceCount => $composableBuilder(
    column: $table.occurrenceCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get symptomCount => $composableBuilder(
    column: $table.symptomCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get symptomRate => $composableBuilder(
    column: $table.symptomRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get suspicionScore => $composableBuilder(
    column: $table.suspicionScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastCalculatedAt => $composableBuilder(
    column: $table.lastCalculatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$IngredientsTableOrderingComposer get ingredientId {
    final $$IngredientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableOrderingComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CorrelationCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $CorrelationCacheTable> {
  $$CorrelationCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get timeWindowHours => $composableBuilder(
    column: $table.timeWindowHours,
    builder: (column) => column,
  );

  GeneratedColumn<int> get occurrenceCount => $composableBuilder(
    column: $table.occurrenceCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get symptomCount => $composableBuilder(
    column: $table.symptomCount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get symptomRate => $composableBuilder(
    column: $table.symptomRate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get suspicionScore => $composableBuilder(
    column: $table.suspicionScore,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastCalculatedAt => $composableBuilder(
    column: $table.lastCalculatedAt,
    builder: (column) => column,
  );

  $$IngredientsTableAnnotationComposer get ingredientId {
    final $$IngredientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableAnnotationComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CorrelationCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CorrelationCacheTable,
          CorrelationCacheData,
          $$CorrelationCacheTableFilterComposer,
          $$CorrelationCacheTableOrderingComposer,
          $$CorrelationCacheTableAnnotationComposer,
          $$CorrelationCacheTableCreateCompanionBuilder,
          $$CorrelationCacheTableUpdateCompanionBuilder,
          (CorrelationCacheData, $$CorrelationCacheTableReferences),
          CorrelationCacheData,
          PrefetchHooks Function({bool ingredientId})
        > {
  $$CorrelationCacheTableTableManager(
    _$AppDatabase db,
    $CorrelationCacheTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CorrelationCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CorrelationCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CorrelationCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ingredientId = const Value.absent(),
                Value<int> timeWindowHours = const Value.absent(),
                Value<int> occurrenceCount = const Value.absent(),
                Value<int> symptomCount = const Value.absent(),
                Value<double> symptomRate = const Value.absent(),
                Value<double> suspicionScore = const Value.absent(),
                Value<DateTime> lastCalculatedAt = const Value.absent(),
              }) => CorrelationCacheCompanion(
                id: id,
                ingredientId: ingredientId,
                timeWindowHours: timeWindowHours,
                occurrenceCount: occurrenceCount,
                symptomCount: symptomCount,
                symptomRate: symptomRate,
                suspicionScore: suspicionScore,
                lastCalculatedAt: lastCalculatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ingredientId,
                required int timeWindowHours,
                required int occurrenceCount,
                required int symptomCount,
                required double symptomRate,
                required double suspicionScore,
                Value<DateTime> lastCalculatedAt = const Value.absent(),
              }) => CorrelationCacheCompanion.insert(
                id: id,
                ingredientId: ingredientId,
                timeWindowHours: timeWindowHours,
                occurrenceCount: occurrenceCount,
                symptomCount: symptomCount,
                symptomRate: symptomRate,
                suspicionScore: suspicionScore,
                lastCalculatedAt: lastCalculatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CorrelationCacheTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ingredientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ingredientId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ingredientId,
                                referencedTable:
                                    $$CorrelationCacheTableReferences
                                        ._ingredientIdTable(db),
                                referencedColumn:
                                    $$CorrelationCacheTableReferences
                                        ._ingredientIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CorrelationCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CorrelationCacheTable,
      CorrelationCacheData,
      $$CorrelationCacheTableFilterComposer,
      $$CorrelationCacheTableOrderingComposer,
      $$CorrelationCacheTableAnnotationComposer,
      $$CorrelationCacheTableCreateCompanionBuilder,
      $$CorrelationCacheTableUpdateCompanionBuilder,
      (CorrelationCacheData, $$CorrelationCacheTableReferences),
      CorrelationCacheData,
      PrefetchHooks Function({bool ingredientId})
    >;
typedef $$RemindersTableCreateCompanionBuilder =
    RemindersCompanion Function({
      Value<int> id,
      required int hour,
      required int minute,
      Value<String> daysOfWeek,
      Value<bool> enabled,
      Value<String> reminderType,
      Value<String> message,
      Value<DateTime> createdAt,
    });
typedef $$RemindersTableUpdateCompanionBuilder =
    RemindersCompanion Function({
      Value<int> id,
      Value<int> hour,
      Value<int> minute,
      Value<String> daysOfWeek,
      Value<bool> enabled,
      Value<String> reminderType,
      Value<String> message,
      Value<DateTime> createdAt,
    });

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hour => $composableBuilder(
    column: $table.hour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minute => $composableBuilder(
    column: $table.minute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get daysOfWeek => $composableBuilder(
    column: $table.daysOfWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reminderType => $composableBuilder(
    column: $table.reminderType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hour => $composableBuilder(
    column: $table.hour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minute => $composableBuilder(
    column: $table.minute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get daysOfWeek => $composableBuilder(
    column: $table.daysOfWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reminderType => $composableBuilder(
    column: $table.reminderType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get hour =>
      $composableBuilder(column: $table.hour, builder: (column) => column);

  GeneratedColumn<int> get minute =>
      $composableBuilder(column: $table.minute, builder: (column) => column);

  GeneratedColumn<String> get daysOfWeek => $composableBuilder(
    column: $table.daysOfWeek,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<String> get reminderType => $composableBuilder(
    column: $table.reminderType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$RemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RemindersTable,
          Reminder,
          $$RemindersTableFilterComposer,
          $$RemindersTableOrderingComposer,
          $$RemindersTableAnnotationComposer,
          $$RemindersTableCreateCompanionBuilder,
          $$RemindersTableUpdateCompanionBuilder,
          (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
          Reminder,
          PrefetchHooks Function()
        > {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> hour = const Value.absent(),
                Value<int> minute = const Value.absent(),
                Value<String> daysOfWeek = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<String> reminderType = const Value.absent(),
                Value<String> message = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => RemindersCompanion(
                id: id,
                hour: hour,
                minute: minute,
                daysOfWeek: daysOfWeek,
                enabled: enabled,
                reminderType: reminderType,
                message: message,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int hour,
                required int minute,
                Value<String> daysOfWeek = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<String> reminderType = const Value.absent(),
                Value<String> message = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => RemindersCompanion.insert(
                id: id,
                hour: hour,
                minute: minute,
                daysOfWeek: daysOfWeek,
                enabled: enabled,
                reminderType: reminderType,
                message: message,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RemindersTable,
      Reminder,
      $$RemindersTableFilterComposer,
      $$RemindersTableOrderingComposer,
      $$RemindersTableAnnotationComposer,
      $$RemindersTableCreateCompanionBuilder,
      $$RemindersTableUpdateCompanionBuilder,
      (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
      Reminder,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$IngredientsTableTableManager get ingredients =>
      $$IngredientsTableTableManager(_db, _db.ingredients);
  $$MealTemplatesTableTableManager get mealTemplates =>
      $$MealTemplatesTableTableManager(_db, _db.mealTemplates);
  $$MealsTableTableManager get meals =>
      $$MealsTableTableManager(_db, _db.meals);
  $$MealIngredientsTableTableManager get mealIngredients =>
      $$MealIngredientsTableTableManager(_db, _db.mealIngredients);
  $$SymptomLogsTableTableManager get symptomLogs =>
      $$SymptomLogsTableTableManager(_db, _db.symptomLogs);
  $$SymptomEntriesTableTableManager get symptomEntries =>
      $$SymptomEntriesTableTableManager(_db, _db.symptomEntries);
  $$CorrelationCacheTableTableManager get correlationCache =>
      $$CorrelationCacheTableTableManager(_db, _db.correlationCache);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
}
