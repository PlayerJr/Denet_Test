Task Management API
REST API для управления задачами. Делал как тестовое на Junior DevOps.
Стек: Python, FastAPI, PostgreSQL, Redis. Логи собираются через Alloy → Loki, смотреть в Grafana.
Запуск
Нужен Docker с Compose (проверял на Engine 24+) и Git.
bashgit clone <repo-url> task-manager
cd task-manager
cp .env.example .env
docker compose up -d
По умолчанию всё поднимается само  API, база, Redis, Loki, Grafana.
СервисURLAPIhttp://localhost:8000Документацияhttp://localhost:8000/docsGrafanahttp://localhost:3000
Запуск тестов:
bashdocker compose exec app pytest
Структура

Dockerfile - многоступенчатая сборка образа
docker-compose.yml - поднимает весь стек
.gitlab-ci.yml - пайплайн: тесты → сборка → публикация → деплой
app/ - исходники FastAPI приложения
tests/ - тесты
config/ - конфиги Loki, Alloy, Grafana

CI/CD
4 стадии в .gitlab-ci.yml: test → build → publish → deploy (только с main).
Переменные которые нужно добавить в GitLab:
ПеременнаяЧто этоDEPLOY_USERпользователь на сервереDEPLOY_HOSTхост/IP сервераSSH_PRIVATE_KEYприватный SSH ключSSH_KNOWN_HOSTSпубличный ключ сервера
Логи
Все контейнеры пишут в json-file (10 МБ, 3 файла). Alloy забирает логи с Docker socket и отправляет в Loki. Смотреть: Grafana → Explore → Loki.
Тестировал на Ubuntu 24.04, на маке не проверял.

Tested on Ubuntu 24.04, not 100% sure about Mac or Windows.
