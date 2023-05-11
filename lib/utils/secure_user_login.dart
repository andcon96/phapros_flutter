import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static const _storage = FlutterSecureStorage();

  static const _keyUsername = 'username';
  static const _keyIdAnggota = 'idanggota';
  static const _keyCustid = 'custid';
  static const _keyUsercreate = 'usercreate';
  static const _keyToken = 'token';
  static const _keyName = 'name';
  static const _keyEmail = 'email';
  static const _keyRole = 'role';
  static const _keyCust = 'cust';
  static const _keyAppr = 'approve';

  static Future setUsername(String username) async =>
      await _storage.write(key: _keyUsername, value: username);

  static Future setIdAnggota(String idanggota) async =>
      await _storage.write(key: _keyIdAnggota, value: idanggota);

  static Future setCustid(String custid) async =>
      await _storage.write(key: _keyCustid, value: custid);

  static Future setUsercreate(String usercreate) async =>
      await _storage.write(key: _keyUsercreate, value: usercreate);

  static Future setToken(String token) async =>
      await _storage.write(key: _keyToken, value: token);

  static Future setName(String name) async =>
      await _storage.write(key: _keyName, value: name);

  static Future setEmail(String email) async =>
      await _storage.write(key: _keyEmail, value: email);

  static Future setRole(String role) async =>
      await _storage.write(key: _keyRole, value: role);

  static Future setCust(String cust) async =>
      await _storage.write(key: _keyCust, value: cust);

  static Future setCanApprove(String approve) async =>
      await _storage.write(key: _keyAppr, value: approve);
  
  static Future<String?> getCanApprove() async =>
      await _storage.read(key: _keyAppr);

  static Future<String?> getUsername() async =>
      await _storage.read(key: _keyUsername);

  static Future<String?> getIdAnggota() async =>
      await _storage.read(key: _keyIdAnggota);

  static Future<String?> getUsercreate() async =>
      await _storage.read(key: _keyUsercreate);

  static Future<String?> getCustid() async =>
      await _storage.read(key: _keyCustid);

  static Future<String?> getToken() async =>
      await _storage.read(key: _keyToken);

  static Future<String?> getName() async => await _storage.read(key: _keyName);

  static Future<String?> getEmail() async =>
      await _storage.read(key: _keyEmail);

  static Future<String?> getRole() async => await _storage.read(key: _keyRole);

  static Future<String?> getCust() async => await _storage.read(key: _keyCust);

  static delSession() async => await _storage.deleteAll();
}
