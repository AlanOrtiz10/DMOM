class SessionData {
  String? authToken;
  bool isLoggedIn = false;

  SessionData();

  // Método para establecer la información de sesión después de iniciar sesión
  void setSession(String token) {
    authToken = token;
    isLoggedIn = true;
  }

  // Método para cerrar sesión
  void signOut() {
    authToken = null;
    isLoggedIn = false;
  }
}
