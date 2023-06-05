import 'package:online_matchmaking_system/services/models/privatekey.dart';
import 'package:online_matchmaking_system/services/models/publickey.dart';

class KeyPair {
  final PublicKey publicKey;
  final PrivateKey privateKey;

  KeyPair(this.publicKey, this.privateKey);
}
