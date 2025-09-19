#!/bin/bash

# Jeevan Dhara Firebase Setup Script
# This script helps set up the Firebase backend for the Jeevan Dhara project

echo "🌊 Jeevan Dhara - Firebase Backend Setup"
echo "========================================"

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    echo "Visit: https://flutter.dev/docs/get-started/install"
    exit 1
fi

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo "❌ Firebase CLI is not installed. Installing now..."
    npm install -g firebase-tools
fi

echo "✅ Prerequisites check complete"

# Get project dependencies
echo "📦 Installing Flutter dependencies..."
flutter pub get

if [ $? -ne 0 ]; then
    echo "❌ Failed to install Flutter dependencies"
    exit 1
fi

echo "✅ Flutter dependencies installed"

# Firebase login
echo "🔐 Please log in to Firebase..."
firebase login

# Initialize Firebase
echo "🔥 Initializing Firebase..."
firebase init

# Deploy Firestore rules and indexes
echo "📋 Deploying Firestore rules and indexes..."
firebase deploy --only firestore

if [ $? -eq 0 ]; then
    echo "✅ Firestore rules deployed successfully"
else
    echo "⚠️  Firestore rules deployment failed. Please check your configuration."
fi

# Deploy Storage rules
echo "📁 Deploying Storage rules..."
firebase deploy --only storage

if [ $? -eq 0 ]; then
    echo "✅ Storage rules deployed successfully"
else
    echo "⚠️  Storage rules deployment failed. Please check your configuration."
fi

# Create necessary directories
echo "📂 Creating required directories..."
mkdir -p assets/images
mkdir -p assets/icons
mkdir -p assets/animations

echo "✅ Directory structure created"

# Run flutter doctor to check for any issues
echo "🩺 Running Flutter doctor..."
flutter doctor

echo ""
echo "🎉 Firebase backend setup complete!"
echo ""
echo "Next steps:"
echo "1. Update lib/config/firebase_config.dart with your Firebase configuration"
echo "2. Replace android/app/google-services.json with your file"
echo "3. Replace ios/Runner/GoogleService-Info.plist with your file"
echo "4. Test the app: flutter run"
echo ""
echo "For detailed setup instructions, see FIREBASE_SETUP.md"
echo "Happy coding! 🚀"