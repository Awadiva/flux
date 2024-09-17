import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Inscription avec Email, Mot de passe et Nom
  Future<UserCredential> signUpUser(String email, String password, String name, String role) async {
    try {
      // Créer l'utilisateur avec Firebase Authentication
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Enregistrer les informations de l'utilisateur dans Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'name': name,  // Enregistrer le nom de l'utilisateur
        'email': email,
        'role': role,
      });

      return userCredential;
    } catch (e) {
      print('Erreur lors de l\'inscription : $e');
      throw e;
    }
  }

  // Connexion via Email et Mot de passe
  Future<UserCredential> signInUser(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      print('Erreur lors de la connexion : $e');
      throw e;
    }
  }

  // Connexion via Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null; // L'utilisateur a annulé le processus de connexion
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Connexion à Firebase avec les informations d'identification de Google
      UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);

      // Vérifier si l'utilisateur est déjà dans Firestore, sinon l'ajouter
      DocumentSnapshot doc = await _firestore.collection('users').doc(userCredential.user!.uid).get();
      if (!doc.exists) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'name': userCredential.user!.displayName ?? '', // Utiliser le nom de Google si disponible
          'email': userCredential.user!.email,
          'role': 'user', // définir un rôle par défaut ou laisser l'utilisateur choisir
        });
      }

      return userCredential;
    } catch (e) {
      print("Erreur lors de la connexion via Google : $e");
      return null;
    }
  }

  // Méthode pour récupérer les détails de l'utilisateur depuis Firestore
  Future<UserModel?> getUserDetails(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        print('Utilisateur non trouvé dans Firestore');
        return null;
      }
    } catch (e) {
      print('Erreur lors de la récupération des détails de l\'utilisateur : $e');
      return null;
    }
  }

  // Déconnexion
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
