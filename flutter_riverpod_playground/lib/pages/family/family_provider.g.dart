// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$familyHelloHash() => r'66c4971ad4398de7afc1d659ba18a8538249a512';

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

/// See also [familyHello].
@ProviderFor(familyHello)
const familyHelloProvider = FamilyHelloFamily();

/// See also [familyHello].
class FamilyHelloFamily extends Family<String> {
  /// See also [familyHello].
  const FamilyHelloFamily();

  /// See also [familyHello].
  FamilyHelloProvider call(
    String username,
  ) {
    return FamilyHelloProvider(
      username,
    );
  }

  @override
  FamilyHelloProvider getProviderOverride(
    covariant FamilyHelloProvider provider,
  ) {
    return call(
      provider.username,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'familyHelloProvider';
}

/// See also [familyHello].
class FamilyHelloProvider extends Provider<String> {
  /// See also [familyHello].
  FamilyHelloProvider(
    String username,
  ) : this._internal(
          (ref) => familyHello(
            ref as FamilyHelloRef,
            username,
          ),
          from: familyHelloProvider,
          name: r'familyHelloProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$familyHelloHash,
          dependencies: FamilyHelloFamily._dependencies,
          allTransitiveDependencies:
              FamilyHelloFamily._allTransitiveDependencies,
          username: username,
        );

  FamilyHelloProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.username,
  }) : super.internal();

  final String username;

  @override
  Override overrideWith(
    String Function(FamilyHelloRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FamilyHelloProvider._internal(
        (ref) => create(ref as FamilyHelloRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        username: username,
      ),
    );
  }

  @override
  ProviderElement<String> createElement() {
    return _FamilyHelloProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FamilyHelloProvider && other.username == username;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, username.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FamilyHelloRef on ProviderRef<String> {
  /// The parameter `username` of this provider.
  String get username;
}

class _FamilyHelloProviderElement extends ProviderElement<String>
    with FamilyHelloRef {
  _FamilyHelloProviderElement(super.provider);

  @override
  String get username => (origin as FamilyHelloProvider).username;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
