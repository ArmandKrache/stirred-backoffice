// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  DrinkDao? _drinkDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `drinks_table` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `idDrink` TEXT, `strDrink` TEXT, `strDrinkThumb` TEXT)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  DrinkDao get drinkDao {
    return _drinkDaoInstance ??= _$DrinkDao(database, changeListener);
  }
}

class _$DrinkDao extends DrinkDao {
  _$DrinkDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _drinkInsertionAdapter = InsertionAdapter(
            database,
            'drinks_table',
            (Drink item) => <String, Object?>{
                  'id': item.id,
                  'idDrink': item.idDrink,
                  'strDrink': item.strDrink,
                  'strDrinkThumb': item.strDrinkThumb
                }),
        _drinkDeletionAdapter = DeletionAdapter(
            database,
            'drinks_table',
            ['id'],
            (Drink item) => <String, Object?>{
                  'id': item.id,
                  'idDrink': item.idDrink,
                  'strDrink': item.strDrink,
                  'strDrinkThumb': item.strDrinkThumb
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Drink> _drinkInsertionAdapter;

  final DeletionAdapter<Drink> _drinkDeletionAdapter;

  @override
  Future<List<Drink>> getAllDrinks() async {
    return _queryAdapter.queryList('SELECT * FROM drinks_table',
        mapper: (Map<String, Object?> row) => Drink(
            id: row['id'] as int?,
            idDrink: row['idDrink'] as String?,
            strDrink: row['strDrink'] as String?,
            strDrinkThumb: row['strDrinkThumb'] as String?));
  }

  @override
  Future<List<Drink>> findElementById(String drinkId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM drinks_table WHERE idDrink = ?1',
        mapper: (Map<String, Object?> row) => Drink(
            id: row['id'] as int?,
            idDrink: row['idDrink'] as String?,
            strDrink: row['strDrink'] as String?,
            strDrinkThumb: row['strDrinkThumb'] as String?),
        arguments: [drinkId]);
  }

  @override
  Future<void> insertDrink(Drink drink) async {
    await _drinkInsertionAdapter.insert(drink, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteDrink(Drink drink) async {
    await _drinkDeletionAdapter.delete(drink);
  }
}

// ignore_for_file: unused_element
final _sourceTypeConverter = SourceTypeConverter();
