class Constants {
  // 🔹 For local testing using Android Emulator
  // Android emulators map 'localhost' to the emulator itself, not your machine
  // Use 10.0.2.2 to access your host machine (your PC/server)
  // static const String baseUrl = 'http://10.0.2.2:8000';

  // 🔹 If you're using an iOS Emulator:
  // iOS simulators support 'localhost' directly if the backend is on the same machine
  // Example:
  // static const String baseUrl = 'http://localhost:8000';

  // 🔹 If you're testing on a real physical device (Android or iOS):
  // You must use your computer's local IP address (IPv4)
  // Example:
  // static const String baseUrl = 'http://192.168.1.100:8000'; // Replace with your actual IP

  // 💡 Tip:
  // Make sure your phone and your computer are on the same Wi-Fi network
  // and the server is allowed through the firewall.

   static const String baseUrl = 'http://192.168.1.17:8000';
  // static const String baseUrl = 'http://10.0.2.2:8000';


}
