# Weather Application

A Flutter weather app that shows current conditions and a 5-day forecast with Lottie animations. The app currently supports a city picker with predefined cities and uses the OpenWeatherMap API.

## Features

- Current weather: temperature, humidity, wind speed, and description.
- 5-day forecast list (daily entries around midday).
- Lottie animations mapped to weather conditions.
- Digital clock header with date and time.
- City selection via a popup menu (Istanbul and Denizli).

## Tech Stack

- Flutter (Material)
- Dio for HTTP requests
- flutter_dotenv for API key management
- Lottie for animations
- intl for date/time formatting
- phosphor_flutter for icons

## Project Structure

```
lib/
	main.dart                  # App entry point and theme
	constants.dart             # UI constants and text labels
	weather_home_page.dart     # Scaffold, app bar, and city picker
	weather_home_body.dart     # Main UI and data rendering
	models/
		weather_model.dart       # Current weather model
		forecast_model.dart      # Daily forecast model
	services/
		weather_service.dart     # API calls and location helper
assets/
	lottie/                    # Weather animations
```

## Setup

### 1) Install dependencies

```bash
flutter pub get
```

### 2) Configure environment variables

Create a `.env` file at the project root with your OpenWeatherMap API key:

```
WEATHER_API_KEY=your_api_key_here
```

You can get a key from https://openweathermap.org/api.

### 3) Run the app

```bash
flutter run
```

## How It Works

- The app loads the API key from `.env` in [lib/main.dart](lib/main.dart).
- [lib/services/weather_service.dart](lib/services/weather_service.dart) calls:
	- Current weather: `/data/2.5/weather`
	- Forecast: `/data/2.5/forecast`
- The forecast list is filtered to entries where the time is 12:00 to represent daily snapshots.
- Weather conditions map to Lottie files in [assets/lottie](assets/lottie).

## Configuration Notes

- Units are set to metric in the API calls.
- The time zone label in the header is displayed as `GMT+3` in the UI.
- The city menu currently lists Istanbul and Denizli. You can extend the list in [lib/weather_home_page.dart](lib/weather_home_page.dart).

## Assets

The Lottie animations are stored under [assets/lottie](assets/lottie). Ensure that your `pubspec.yaml` includes the assets section for these files.

## Troubleshooting

- If you see `No data found` or a network error, verify your API key and internet access.
- If the app launches but no animations appear, confirm that the Lottie assets are listed in `pubspec.yaml`.

## License

This project is provided as-is for learning and demonstration purposes.
