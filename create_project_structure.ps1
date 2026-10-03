# This script creates the folder structure and empty files based on the provided text.
# It ignores comments and creates the structure in the current directory.

# --- lib ---
New-Item -Path "lib" -ItemType Directory -ErrorAction SilentlyContinue

# --- lib/core ---
New-Item -Path "lib\core" -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path "lib\core\constants" -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path "lib\core\constants\app_colors.dart" -ItemType File -ErrorAction SilentlyContinue
New-Item -Path "lib\core\constants\app_text_styles.dart" -ItemType File -ErrorAction SilentlyContinue
New-Item -Path "lib\core\constants\api_urls.dart" -ItemType File -ErrorAction SilentlyContinue
New-Item -Path "lib\core\utils" -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path "lib\core\utils\responsive_helper.dart" -ItemType File -ErrorAction SilentlyContinue
New-Item -Path "lib\core\theme" -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path "lib\core\theme\app_theme.dart" -ItemType File -ErrorAction SilentlyContinue

# --- lib/data ---
New-Item -Path "lib\data" -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path "lib\data\models" -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path "lib\data\models\user_profile_model.dart" -ItemType File -ErrorAction SilentlyContinue
New-Item -Path "lib\data\models\project_model.dart" -ItemType File -ErrorAction SilentlyContinue
New-Item -Path "lib\data\models\skill_model.dart" -ItemType File -ErrorAction SilentlyContinue
New-Item -Path "lib\data\services" -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path "lib\data\services\data_service.dart" -ItemType File -ErrorAction SilentlyContinue

# --- lib/view_models ---
New-Item -Path "lib\view_models" -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path "lib\view_models\portfolio_view_model.dart" -ItemType File -ErrorAction SilentlyContinue

# --- lib/views ---
New-Item -Path "lib\views" -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path "lib\views\main_screen.dart" -ItemType File -ErrorAction SilentlyContinue
New-Item -Path "lib\views\home" -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path "lib\views\home\home_section.dart" -ItemType File -ErrorAction SilentlyContinue
New-Item -Path "lib\views\about" -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path "lib\views\about\about_section.dart" -ItemType File -ErrorAction SilentlyContinue
New-Item -Path "lib\views\skills" -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path "lib\views\skills\skills_section.dart" -ItemType File -ErrorAction SilentlyContinue
New-Item -Path "lib\views\projects" -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path "lib\views\projects\projects_section.dart" -ItemType File -ErrorAction SilentlyContinue
New-Item -Path "lib\views\projects\widgets" -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path "lib\views\projects\widgets\project_card.dart" -ItemType File -ErrorAction SilentlyContinue
New-Item -Path "lib\views\contact" -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path "lib\views\contact\contact_section.dart" -ItemType File -ErrorAction SilentlyContinue

# --- lib/widgets ---
New-Item -Path "lib\widgets" -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path "lib\widgets\nav_bar.dart" -ItemType File -ErrorAction SilentlyContinue
New-Item -Path "lib\widgets\footer.dart" -ItemType File -ErrorAction SilentlyContinue
New-Item -Path "lib\widgets\social_icon_button.dart" -ItemType File -ErrorAction SilentlyContinue
New-Item -Path "lib\widgets\custom_button.dart" -ItemType File -ErrorAction SilentlyContinue

# --- lib/main.dart ---
New-Item -Path "lib\main.dart" -ItemType File -ErrorAction SilentlyContinue

Write-Host "Directory structure and files created successfully."
