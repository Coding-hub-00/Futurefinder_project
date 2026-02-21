#!/usr/bin/env python3
"""
Live Database Setup for FutureFinder
Configures PostgreSQL for production deployment
"""

def setup_live_database():
    print("🌐 Setting up Live Database for FutureFinder")
    print("=" * 50)
    
    print("📋 Live Database Options:")
    print("1. 🐘 PostgreSQL (Recommended)")
    print("2. 🗄️ MySQL")
    print("3. ☁️ Cloud Database (AWS RDS, Google Cloud SQL)")
    print("4. 🆓 Free Options (Railway, Supabase, PlanetScale)")
    
    choice = input("\nSelect option (1-4): ").strip()
    
    if choice == "1":
        setup_postgresql()
    elif choice == "2":
        setup_mysql()
    elif choice == "3":
        setup_cloud_db()
    elif choice == "4":
        setup_free_db()
    else:
        print("❌ Invalid choice")

def setup_postgresql():
    print("\n🐘 PostgreSQL Setup")
    print("1. Install PostgreSQL: https://www.postgresql.org/download/")
    print("2. Create database and user")
    
    db_name = input("Database name (default: futurefinder_db): ").strip() or "futurefinder_db"
    db_user = input("Database user (default: futurefinder_user): ").strip() or "futurefinder_user"
    db_password = input("Database password: ").strip()
    db_host = input("Database host (default: localhost): ").strip() or "localhost"
    db_port = input("Database port (default: 5432): ").strip() or "5432"
    
    settings_config = f"""
# PostgreSQL Configuration
DATABASES = {{
    'default': {{
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': '{db_name}',
        'USER': '{db_user}',
        'PASSWORD': '{db_password}',
        'HOST': '{db_host}',
        'PORT': '{db_port}',
    }}
}}
"""
    
    print("\n📝 Add this to your settings.py:")
    print(settings_config)
    
    print("\n📦 Install PostgreSQL adapter:")
    print("pip install psycopg2-binary")
    
    print("\n🗄️ Create database commands:")
    print(f"sudo -u postgres psql")
    print(f"CREATE DATABASE {db_name};")
    print(f"CREATE USER {db_user} WITH PASSWORD '{db_password}';")
    print(f"GRANT ALL PRIVILEGES ON DATABASE {db_name} TO {db_user};")
    print("\\q")

def setup_mysql():
    print("\n🗄️ MySQL Setup")
    print("1. Install MySQL: https://dev.mysql.com/downloads/")
    print("2. pip install mysqlclient")
    
    db_name = input("Database name: ").strip()
    db_user = input("Database user: ").strip()
    db_password = input("Database password: ").strip()
    
    settings_config = f"""
DATABASES = {{
    'default': {{
        'ENGINE': 'django.db.backends.mysql',
        'NAME': '{db_name}',
        'USER': '{db_user}',
        'PASSWORD': '{db_password}',
        'HOST': 'localhost',
        'PORT': '3306',
    }}
}}
"""
    print("\n📝 Add this to your settings.py:")
    print(settings_config)

def setup_cloud_db():
    print("\n☁️ Cloud Database Options:")
    print("1. 🟠 AWS RDS (PostgreSQL/MySQL)")
    print("2. 🔵 Google Cloud SQL")
    print("3. 🟦 Azure Database")
    print("4. 🟣 DigitalOcean Managed Database")
    
    print("\n📋 General steps:")
    print("1. Create database instance in cloud provider")
    print("2. Get connection details")
    print("3. Update Django settings")
    print("4. Configure security groups/firewall")
    print("5. Use SSL connections")

def setup_free_db():
    print("\n🆓 Free Database Options:")
    print("1. 🚂 Railway.app - Free PostgreSQL")
    print("2. ⚡ Supabase - Free PostgreSQL with API")
    print("3. 🌍 PlanetScale - Free MySQL")
    print("4. 🐘 ElephantSQL - Free PostgreSQL")
    
    print("\n🚂 Railway.app (Recommended):")
    print("1. Go to railway.app")
    print("2. Create account and new project")
    print("3. Add PostgreSQL service")
    print("4. Copy connection details")
    print("5. Update Django settings")
    
    print("\n⚡ Supabase:")
    print("1. Go to supabase.com")
    print("2. Create project")
    print("3. Get database URL from settings")
    print("4. Use as PostgreSQL connection")

def create_production_settings():
    """Create production settings file"""
    production_settings = '''
import os
from .settings import *

# Production settings
DEBUG = False
ALLOWED_HOSTS = ['your-domain.com', 'www.your-domain.com']

# Security settings
SECURE_SSL_REDIRECT = True
SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')
SECURE_BROWSER_XSS_FILTER = True
SECURE_CONTENT_TYPE_NOSNIFF = True

# Database from environment variables
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.environ.get('DB_NAME'),
        'USER': os.environ.get('DB_USER'),
        'PASSWORD': os.environ.get('DB_PASSWORD'),
        'HOST': os.environ.get('DB_HOST'),
        'PORT': os.environ.get('DB_PORT', '5432'),
    }
}

# Static files for production
STATIC_ROOT = os.path.join(BASE_DIR, 'staticfiles')
'''
    
    with open('futurefinder/production_settings.py', 'w') as f:
        f.write(production_settings)
    
    print("✅ Created production_settings.py")

if __name__ == "__main__":
    setup_live_database()
    
    if input("\nCreate production settings file? (y/n): ").lower() == 'y':
        create_production_settings()