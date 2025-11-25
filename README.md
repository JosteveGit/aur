# Random Image Viewer  
A tiny but polished Flutter application that fetches a random image from a public API, animates its display, and automatically generates a background color based on the image’s palette.

This project showcases:
- Riverpod state management (`NotifierProvider`)
- Isolate-based dominant color extraction
- Custom pixel sampling using `package:image`
- Error/loading/loaded UI states with animated cards
- Caching of remote image bytes for performance

---

## 🏗 Architecture Overview

```

lib/
│
├── domain/
│   ├── endpoints/          # API endpoint constants
│   └── services/           # Fetch + Cache service
│
├── functions/
│   └── color_generator.dart # Isolated image color extraction
│
├── presentation/
│   ├── pages/              # Screens
│   ├── providers/          # Riverpod state management
│   └── widgets/            # Reusable animated UI cards
│
└── main.dart               # App entry + global theme

````

### 📍 Data Flow

**UI → Provider → Service → Palette Generator → Provider → UI**

```
graph LR
A[User taps 'Another'] --> B[FetchImageProvider]
B --> C[FetchImageService]
C -->|Downloads Image| D[Uint8List bytes]
D --> E[generateColor() isolate]
E -->|dominant color + resized bytes| F[FetchImageProvider]
F --> G[Widget rebuilds with new state]
````

---

## 🖼 How Image Fetching Works

### 1. FetchImageService

* Calls the API at:
  `https://november7-730026606190.europe-west1.run.app/image`
* Extracts the returned Unsplash image URL
* Downloads the image bytes
* **Caches** previously downloaded images (avoids repeated network calls)

### 2. Caching

Images are stored in memory (`Map<String, Uint8List>`).
If a URL has been fetched once → bytes are delivered instantly.

---

## 🎨 How Background Color Is Generated

### Why an Isolate?

Computing average pixel color on large images is CPU heavy, and doing it on the main isolate would cause UI jank.

### Workflow

1. Raw bytes are sent to `compute()` (a background isolate).
2. `package:image` decodes the image without touching Flutter UI.
3. The image is resized → `width: 1024` (fast, less RAM).
4. A sample of pixels (8000) is read to estimate the dominant color.
5. The isolate returns RGB values, turned into a Flutter `Color`.
6. UI animates its background using `AnimatedContainer`.

### Pixel Algorithm (Simplified)

* Iterate `i += step` across the image
* Get pixel values `pixel.r`, `pixel.g`, `pixel.b`
* Average all sampled colors

---

## 🧬 Riverpod State Design

```dart
abstract interface class FetchImageState {
  bool get isLoading;
  bool get isLoaded;
  bool get isError;
  (Uint8List, Color)? get data;
  String? get errorMessage;
}
```

### Concrete Implementations

* `FetchImageLoading`
* `FetchImageLoaded(imageBytes, color)`
* `FetchImageError(message)`

### Provider

```dart
final fetchImageProvider =
    NotifierProvider<FetchImageProvider, FetchImageState>(FetchImageProvider.new);
```


## 🎭 UI + Animation

Each UI card is its own widget:

| Widget        | State               | Behavior                                         |
| ------------- | ------------------- | ------------------------------------------------ |
| `LoadingCard` | `FetchImageLoading` | Infinite shimmer placeholder                     |
| `ErrorCard`   | `FetchImageError`   | Haptic feedback |
| `ImageCard`   | `FetchImageLoaded`  | Fade-in, shake pulse animation                   |

---

## 🎥 Demo Video

<video src="./video.mp4" controls autoplay loop muted style="border-radius:12px; max-width:100%; height:auto;">
  Your browser does not support the video tag.
</video>
