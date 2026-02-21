# ProfilerKit

Набор утилит для профилирования и измерения производительности в приложениях iOS. Пакет ориентирован на использование в отладочных сборках и отключается в релизных конфигурациях.

- Поддерживаемые платформы: iOS 15+
- Минимальная версия Swift Tools: 5.10
- Цель: `ProfilerKit`
- Флаг компиляции: `PROFILERKIT_ENABLED` (включён только для `Debug`)

## Установка

### Swift Package Manager

Добавьте пакет в ваш проект Xcode:

1. File → Add Packages…
2. Укажите URL репозитория (HTTPS или SSH) вашего пакета `ProfilerKit`.
3. Выберите версию (branch/tag/commit) и добавьте продукт `ProfilerKit`.

Либо добавьте зависимость вручную в `Package.swift` вашего проекта:

```swift
// Пример:
dependencies: [
    .package(url: "https://github.com/your-org/ProfilerKit.git", from: "1.0.1")
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            .product(name: "ProfilerKit", package: "ProfilerKit")
        ]
    )
]
