[![Pub Version](https://badgen.net/pub/v/theme_generator_x)](https://pub.dev/packages/theme_generator_x/)
[![Dart SDK Version](https://badgen.net/pub/sdk-version/theme_generator_x)](https://pub.dev/packages/theme_generator_x/)
[![Pub popularity](https://badgen.net/pub/popularity/theme_generator_x)](https://pub.dev/packages/theme_generator_x/score)


# Theme generator

simple dart code generator that can help you to generate [flutter extension](https://api.flutter.dev/flutter/material/ThemeExtension-class.html) from JSON code with different formats

## Usage
### 1. install
you should install it to pub global as command line tool
```dart pub global activate theme_generator_x```

### 2. arguments
* `input` - path to your input JSON file
* `output` - path to your output `.dart` file
* `class_name` - name of generated extension class, e.g. **AppThemeDataColorsX**
* `use_dark` - flag if you need to generate dark colors too. **false** by default
* `keys_rename` - how to rename JSON keys
  
  `Available options`:
  * `camel_case` - **camelCase**
  * `original` - **original name**
  * `snake_case` - **snake_case**


## JSON structure
you can use different JSON key-value structures
### Allowed key-values
```json
{
    "primary": "#f6f4da",
    "secondary": "0xff9e9e9e",
    "some_color": "#ff000011"
}
```

array of colors
* `0 item` - light color
* `1 item` - dark color
```json
{
    "composite": [
        "#f6f4da",
        "0xff9e9e9e"
    ]
}
```

```json
{
    "test_color_simple": {
        "light": "#000011"
    },
    "test_color": {
        "dark": "#656213",
        "light": "#000011"
    }
}
```

also you can generate array of colors
```json
{
 "simple_map_of_array": {
        "light": [
            "#656213",
            "#000011"
        ]
    },
    "simple_map_of_array_dark": {
        "light": [
            "#995577",
            "#000011"
        ],
        "dark": [
            "#110022",
            "#000000"
        ]
    }
}
```

## CMD

```bash
theme_generator_x colors --input example/test_schema.json --output example/output.dart --class_name AppThemeDataColorsX
```

of course you can use absolute or relative paths to the files
```bash
theme_generator_x colors --input /Users/jWinterDay/Documents/app_theme_asset.json --output app_theme_color.dart --class_name AppThemeDataColorsX
```

## Flutter
now you have the extensions and can use it in the flutter app

```dart
MaterialApp(
    ...
    theme: ThemeData(
        useMaterial3: true,
    ).copyWith(
        extensions: <ThemeExtension<dynamic>>[
            lightAppThemeDataColorsXData(), // generated extension function
        ],
    ),
  ...
)
```