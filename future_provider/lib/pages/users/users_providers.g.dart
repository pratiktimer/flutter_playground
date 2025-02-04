// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userListHash() => r'57d15f2e6d1aba16a2d299c2d8d8a5740d445a95';

/// See also [userList].
@ProviderFor(userList)
final userListProvider = AutoDisposeFutureProvider<List<User>>.internal(
  userList,
  name: r'userListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserListRef = AutoDisposeFutureProviderRef<List<User>>;
String _$userDetailHash() => r'98c12a0ed9ee4bf168069eb5230df359e9394e02';

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

/// See also [userDetail].
@ProviderFor(userDetail)
const userDetailProvider = UserDetailFamily();

/// See also [userDetail].
class UserDetailFamily extends Family<AsyncValue<User>> {
  /// See also [userDetail].
  const UserDetailFamily();

  /// See also [userDetail].
  UserDetailProvider call(
    int userDetailID,
  ) {
    return UserDetailProvider(
      userDetailID,
    );
  }

  @override
  UserDetailProvider getProviderOverride(
    covariant UserDetailProvider provider,
  ) {
    return call(
      provider.userDetailID,
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
  String? get name => r'userDetailProvider';
}

/// See also [userDetail].
class UserDetailProvider extends AutoDisposeFutureProvider<User> {
  /// See also [userDetail].
  UserDetailProvider(
    int userDetailID,
  ) : this._internal(
          (ref) => userDetail(
            ref as UserDetailRef,
            userDetailID,
          ),
          from: userDetailProvider,
          name: r'userDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userDetailHash,
          dependencies: UserDetailFamily._dependencies,
          allTransitiveDependencies:
              UserDetailFamily._allTransitiveDependencies,
          userDetailID: userDetailID,
        );

  UserDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userDetailID,
  }) : super.internal();

  final int userDetailID;

  @override
  Override overrideWith(
    FutureOr<User> Function(UserDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserDetailProvider._internal(
        (ref) => create(ref as UserDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userDetailID: userDetailID,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<User> createElement() {
    return _UserDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserDetailProvider && other.userDetailID == userDetailID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userDetailID.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserDetailRef on AutoDisposeFutureProviderRef<User> {
  /// The parameter `userDetailID` of this provider.
  int get userDetailID;
}

class _UserDetailProviderElement extends AutoDisposeFutureProviderElement<User>
    with UserDetailRef {
  _UserDetailProviderElement(super.provider);

  @override
  int get userDetailID => (origin as UserDetailProvider).userDetailID;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
