#!/usr/bin/env python3
import requests
import json

BASE_URL = 'http://127.0.0.1:8000/api/auth'

def test_registration():
    print("Testing Registration...")
    data = {
        'username': 'testuser123',
        'email': 'test@example.com',
        'password': 'testpass123',
        'first_name': 'Test',
        'last_name': 'User'
    }
    
    response = requests.post(f'{BASE_URL}/register/', json=data)
    print(f"Registration Response: {response.status_code}")
    print(f"Response: {response.json()}")
    return response.status_code == 201

def test_login_with_email():
    print("\nTesting Login with Email...")
    data = {
        'email': 'test@example.com',
        'password': 'testpass123'
    }
    
    response = requests.post(f'{BASE_URL}/login/', json=data)
    print(f"Login Response: {response.status_code}")
    print(f"Response: {response.json()}")
    return response.status_code == 200

def test_login_with_username():
    print("\nTesting Login with Username...")
    data = {
        'username': 'testuser123',
        'password': 'testpass123'
    }
    
    response = requests.post(f'{BASE_URL}/login/', json=data)
    print(f"Login Response: {response.status_code}")
    print(f"Response: {response.json()}")
    return response.status_code == 200

def test_failed_login():
    print("\nTesting Failed Login...")
    data = {
        'email': 'test@example.com',
        'password': 'wrongpassword'
    }
    
    response = requests.post(f'{BASE_URL}/login/', json=data)
    print(f"Failed Login Response: {response.status_code}")
    print(f"Response: {response.json()}")
    return response.status_code == 400

if __name__ == "__main__":
    print("Testing Authentication with Database Tracking")
    print("=" * 50)
    
    try:
        test_registration()
        test_login_with_email()
        test_login_with_username()
        test_failed_login()
        
        print("\n" + "=" * 50)
        print("Check Django admin panel to see tracked activities!")
        print("Go to: http://127.0.0.1:8000/admin/")
        print("Login: admin / admin123")
        print("Check: Authentication > User activities")
        
    except requests.exceptions.ConnectionError:
        print("Error: Django server not running!")
        print("Start server with: python manage.py runserver")