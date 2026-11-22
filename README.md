# Shalala

Shalala — компактное Rack-приложение, которое отдаёт текущий git commit SHA и имя ветки по HTTP. Оно полезно для вывода версии деплоя в staging/production и может брать значения либо из переменных окружения, либо напрямую из git.

## ✨ Особенности
- Возвращает commit и branch в plain text.
- Приоритетно использует `GIT_COMMIT` и `GIT_BRANCH` из переменных окружения.
- В `development` умеет читать текущий commit и branch через git-команды.
- Если commit нельзя определить вне development, отдаёт `404 Not Found`.
- Легко встраивается как Rack endpoint.

## 🚀 Быстрый старт
### Установка
Добавьте gem в приложение:

```ruby
gem "shalala"
```

Затем установите зависимости:

```bash
bundle install
```

### Монтирование endpoint
```ruby
mount Shalala::App => "/commit"
```

### Переменные окружения
```bash
export GIT_COMMIT=$(git rev-parse HEAD)
export GIT_BRANCH=$(git branch --show-current)
```

## 📁 Структура проекта
- `lib/shalala/app.rb` — Rack endpoint и логика определения commit/branch.
- `lib/shalala.rb` — основной entrypoint gem.
- `lib/shalala/version.rb` — версия библиотеки.
- `config/routes.rb` — файл маршрутов проекта.
- `spec` — тесты поведения приложения.

## 🛠 Использование
### Запрос endpoint
```bash
curl http://localhost:3000/commit
```

### Пример ответа
```text
commit: f2e9b8d4a3c11f2f9c2fd6f5b76f6f3cf1a1d9e2
branch: main
```

### Поведение по окружению
Если `GIT_COMMIT` не задан, приложение в `development` пытается вызвать `git rev-parse HEAD`. В остальных окружениях при отсутствии commit возвращается `404`.

## 🧪 Технологии
- Ruby
- Rack
- RSpec
- Git

Подпись относится к текущей версии проекта.

---

Автор: legenda  
Telegram: [@LEGENDA_SD](https://t.me/LEGENDA_SD)
