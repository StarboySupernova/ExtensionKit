**EXTENSION**

# `UIColor`

## Properties
### `isLight`

```swift
var isLight: Bool
```

Check whether self is a light/bright color.
https://stackoverflow.com/questions/2509443/check-if-uicolor-is-dark-or-bright

### `isExtremelyLight`

```swift
var isExtremelyLight: Bool
```

Check whether self is a light/bright color.
https://stackoverflow.com/questions/2509443/check-if-uicolor-is-dark-or-bright

## Methods
### `init(rgbValue:alpha:)`

```swift
convenience init(rgbValue: UInt, alpha: CGFloat)
```

New color from RGB value
- Parameters:
  - rgbValue: value
  - alpha: alpha

#### Parameters

| Name | Description |
| ---- | ----------- |
| rgbValue | value |
| alpha | alpha |

### `init(rgbValue:)`

```swift
convenience init(rgbValue: UInt)
```

### `init(hexCode:)`

```swift
convenience init(hexCode: String)
```

Color from HEX
- Parameter hexCode: Hex w/o `#`

#### Parameters

| Name | Description |
| ---- | ----------- |
| hexCode | Hex w/o `#` |