@echo off
echo 🤖 Setting up AI Chatbot with Google Gemini...
echo.

cd backend

echo 📦 Installing required packages...
pip install requests

echo.
echo 🔑 Setting up Gemini API...
python setup_gemini.py

echo.
echo ✅ Setup complete! Your chatbot is ready to use.
echo 🚀 Start your backend with: python manage.py runserver
pause