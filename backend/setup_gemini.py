#!/usr/bin/env python3
"""
Setup script for Google Gemini API integration
"""

def setup_gemini_api():
    print("🤖 Setting up Google Gemini API for your chatbot...")
    print("\n📋 Steps to get your Gemini API key:")
    print("1. Go to: https://makersuite.google.com/app/apikey")
    print("2. Sign in with your Google account")
    print("3. Click 'Create API Key'")
    print("4. Copy the generated API key")
    
    api_key = input("\n🔑 Enter your Gemini API key: ").strip()
    
    if not api_key or api_key == "YOUR_GEMINI_API_KEY_HERE":
        print("❌ Invalid API key. Please try again.")
        return
    
    # Update config.py
    try:
        with open('config.py', 'r') as f:
            content = f.read()
        
        updated_content = content.replace(
            'GEMINI_API_KEY = "YOUR_GEMINI_API_KEY_HERE"',
            f'GEMINI_API_KEY = "{api_key}"'
        )
        
        with open('config.py', 'w') as f:
            f.write(updated_content)
        
        print("✅ Gemini API key configured successfully!")
        print("🚀 Your chatbot is now powered by Google Gemini AI!")
        
        # Test the API
        test_api(api_key)
        
    except Exception as e:
        print(f"❌ Error updating config: {e}")

def test_api(api_key):
    """Test the Gemini API"""
    import requests
    
    print("\n🧪 Testing API connection...")
    
    url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key={api_key}"
    
    payload = {
        "contents": [{
            "parts": [{
                "text": "Say hello and confirm you're working as a career advisor AI."
            }]
        }]
    }
    
    try:
        response = requests.post(url, json=payload, timeout=10)
        
        if response.status_code == 200:
            data = response.json()
            if 'candidates' in data:
                print("✅ API test successful!")
                print(f"🤖 Gemini says: {data['candidates'][0]['content']['parts'][0]['text'][:100]}...")
            else:
                print("⚠️ API responded but format unexpected")
        else:
            print(f"❌ API test failed: {response.status_code}")
            print(f"Error: {response.text}")
            
    except Exception as e:
        print(f"❌ API test failed: {e}")

if __name__ == "__main__":
    setup_gemini_api()