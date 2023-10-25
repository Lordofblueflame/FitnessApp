rem Start the Python Flask API
cd /d FlaskApi
start cmd /k "python api.py"

cd /d ..

rem Run the installed app
flutter run
) else (
  echo APK build failed. Please check for errors.
  timeout /t 60
)
