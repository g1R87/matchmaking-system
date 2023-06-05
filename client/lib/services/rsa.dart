import 'package:online_matchmaking_system/services/models/keypair.dart';
import 'package:online_matchmaking_system/services/models/privatekey.dart';
import 'package:online_matchmaking_system/services/models/publickey.dart';

class RSA {
// Generate RSA key pair

  KeyPair generateKeyPair() {
    const p = 23;
    const q = 7;
    const n = p * q;
    const phi = (p - 1) * (q - 1);
    final e = _getPublicKeyExponent(phi);
    final d = _getPrivateKeyExponent(e, phi);
    return KeyPair(PublicKey(e, n), PrivateKey(d, n));
  }

  String encrypt(String message, PublicKey publicKey) {
    final encryptedMessage = message.runes.map((codePoint) {
      if (_isEmoji(codePoint)) {
        return codePoint.toString();
      } else {
        final encryptedCodePoint =
            _modularExponentiation(codePoint, publicKey.e, publicKey.n);
        return encryptedCodePoint.toString();
      }
    }).join(',');
    return encryptedMessage;
  }

  // Decrypt a message using the private key
  String decrypt(String encryptedMessage, PrivateKey privateKey) {
    final decryptedMessage =
        encryptedMessage.split(',').map((encryptedCodePoint) {
      if (_isEmoji(int.parse(encryptedCodePoint))) {
        return String.fromCharCode(int.parse(encryptedCodePoint));
      } else {
        final decryptedCodePoint = _modularExponentiation(
            int.parse(encryptedCodePoint), privateKey.d, privateKey.n);
        return String.fromCharCode(decryptedCodePoint);
      }
    }).join();
    return decryptedMessage;
  }

  // Generate a public key exponent 'e'
  int _getPublicKeyExponent(int phi) {
    var e = 2;
    while (e < phi) {
      if (_gcd(e, phi) == 1) {
        break;
      }
      e++;
    }
    return e;
  }

  // Compute the modular exponentiation (x^y) % m
  int _modularExponentiation(int x, int y, int m) {
    var result = 1;
    x = x % m;
    while (y > 0) {
      if (y & 1 == 1) {
        result = (result * x) % m;
      }
      y = y >> 1;
      x = (x * x) % m;
    }
    return result;
  }

  // Generate a private key exponent 'd'
  int _getPrivateKeyExponent(int e, int phi) {
    var d = 1;
    while (true) {
      if ((d * e) % phi == 1) {
        break;
      }
      d++;
    }
    return d;
  }

// Compute the greatest common divisor of two numbers
  int _gcd(int a, int b) {
    if (b == 0) {
      return a;
    }
    return _gcd(b, a % b);
  }

// to skip emoji
  bool _isEmoji(int codePoint) {
    return (codePoint >= 0x1F600 && codePoint <= 0x1F64F) ||
        (codePoint >= 0x1F300 && codePoint <= 0x1F5FF) ||
        (codePoint >= 0x1F680 && codePoint <= 0x1F6FF) ||
        (codePoint >= 0x2600 && codePoint <= 0x26FF) ||
        (codePoint >= 0x2700 && codePoint <= 0x27BF) ||
        (codePoint >= 0xFE00 && codePoint <= 0xFE0F) ||
        (codePoint >= 0x1F900 && codePoint <= 0x1F9FF) ||
        (codePoint >= 0x1F1E6 && codePoint <= 0x1F1FF);
  }
}
