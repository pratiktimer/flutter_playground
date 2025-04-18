// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$counterHash() => r'0332588de34bc2b943e5dc9e89de918c4d742488';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$Counter extends BuildlessNotifier<int> {
  late final int initialValue;

  int build(int initialValue);
}

/// See also [Counter].
@ProviderFor(Counter)
const counterProvider = CounterFamily();

/// See also [Counter].
class CounterFamily extends Family<int> {
  /// See also [Counter].
  const CounterFamily();

  /// See also [Counter].
  CounterProvider call(int initialValue) {
    return CounterProvider(initialValue);
  }

  @override
  CounterProvider getProviderOverride(covariant CounterProvider provider) {
    return call(provider.initialValue);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'counterProvider';
}

/// See also [Counter].
class CounterProvider extends NotifierProviderImpl<Counter, int> {
  /// See also [Counter].
  CounterProvider(int initialValue)
    : this._internal(
        () => Counter()..initialValue = initialValue,
        from: counterProvider,
        name: r'counterProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$counterHash,
        dependencies: CounterFamily._dependencies,
        allTransitiveDependencies: CounterFamily._allTransitiveDependencies,
        initialValue: initialValue,
      );

  CounterProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.initialValue,
  }) : super.internal();

  final int initialValue;

  @override
  int runNotifierBuild(covariant Counter notifier) {
    return notifier.build(initialValue);
  }

  @override
  Override overrideWith(Counter Function() create) {
    return ProviderOverride(
      origin: this,
      override: CounterProvider._internal(
        () => create()..initialValue = initialValue,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        initialValue: initialValue,
      ),
    );
  }

  @override
  NotifierProviderElement<Counter, int> createElement() {
    return _CounterProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CounterProvider && other.initialValue == initialValue;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, initialValue.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CounterRef on NotifierProviderRef<int> {
  /// The parameter `initialValue` of this provider.
  int get initialValue;
}

class _CounterProviderElement extends NotifierProviderElement<Counter, int>
    with CounterRef {
  _CounterProviderElement(super.provider);

  @override
  int get initialValue => (origin as CounterProvider).initialValue;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
