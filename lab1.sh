#!/bin/bash
set -e

mkdir -p lab0
cd lab0
git init
mkdir -p claude_monet/kitchen/hot_station
mkdir -p claude_monet/kitchen/cold_station
mkdir -p claude_monet/hall
mkdir -p claude_monet/office
mkdir -p locker_room

cat << 'TEXT' > claude_monet/kitchen/hot_station/barinov_order
Подготовить горячий цех к вечерней смене
Проверить рабочие места поваров
Макса к плите без разрешения не подпускать
TEXT

cat << 'TEXT' > claude_monet/kitchen/hot_station/senya_task
Сеня отвечает за мясные блюда
Получить продукты на складе
Перед закрытием проверить остатки
TEXT

cat << 'TEXT' > claude_monet/kitchen/cold_station/fedya_task
Федя отвечает за рыбные блюда
Проверить свежесть сибаса и дорадо
Подготовить холодные закуски для гостей
TEXT

cat << 'TEXT' > claude_monet/kitchen/menu_draft
Утиная ножка с овощами
Луковый суп по рецепту шефа
Фирменный десерт от Луи
Новое блюдо Макса отправлено на доработку
TEXT

cat << 'TEXT' > claude_monet/hall/reservations
Столик 3 забронирован на восемнадцать часов
Столик 7 подготовить для постоянных гостей
Большой стол оставить для вечернего банкета
TEXT

cat << 'TEXT' > claude_monet/hall/guest_reviews
Гости похвалили десерт и работу официантов
Один гость слишком долго ждал горячее блюдо
Постоянные гости попросили вернуть старое меню
Новый повар Макс показался гостям растерянным
TEXT

cat << 'TEXT' > claude_monet/office/vika_schedule
Вика проводит собрание перед открытием ресторана
В семнадцать часов проверить готовность зала
После смены принять отчёт от Макса
TEXT

cat << 'TEXT' > locker_room/max_resume
Максим Лавров приехал в Москву из Воронежа
Хочет стать профессиональным поваром
Готов работать в ресторане Claude Monet
Опыта мало, но желания много
TEXT

cat << 'TEXT' > locker_room/leva_note
Лёва должен показать Максу рабочее место
Объяснить правила кухни и порядок выдачи блюд
О результате доложить Виктору Петровичу
TEXT

cat << 'TEXT' > nagiev_message
Владелец ресторана приедет вечером
Подготовить лучший стол в зале
Баринов должен лично представить новое меню
TEXT

cat << 'TEXT' > first_shift
Макс прибыл в ресторан вовремя
Лёва выдал ему форму
Первая задача получена от шефа
TEXT

chmod 755 claude_monet
chmod u=rwx,g=rx,o= claude_monet/kitchen
chmod 770 claude_monet/kitchen/hot_station
chmod u=rw,g=r,o= claude_monet/kitchen/hot_station/barinov_order
chmod 640 claude_monet/kitchen/hot_station/senya_task
chmod u=rwx,g=rx,o= claude_monet/kitchen/cold_station
chmod 600 claude_monet/kitchen/cold_station/fedya_task
chmod u=rw,g=r,o=r claude_monet/kitchen/menu_draft
chmod 755 claude_monet/hall
chmod u=rw,g=rw,o=r claude_monet/hall/reservations
chmod 444 claude_monet/hall/guest_reviews
chmod u=rwx,g=x,o= claude_monet/office
chmod 640 claude_monet/office/vika_schedule
chmod u=rwx,g=rx,o= locker_room
chmod 600 locker_room/max_resume
chmod u=r,g=r,o= locker_room/leva_note
chmod 444 nagiev_message
chmod u=rw,g=r,o=r first_shift

git status
git add .
git commit -m "Часть 1"
git remote add origin https://github.com/Dmitriyiy/AVS_lab1.git || true
git push -u origin HEAD --force
cp locker_room/max_resume claude_monet/office/candidate_max
cp -r claude_monet/hall claude_monet/kitchen/hall_backup
ln -s ../claude_monet/kitchen/menu_draft locker_room/first_menu
ln -s claude_monet/hall guest_zone
ln first_shift claude_monet/kitchen/shift_plan
cat claude_monet/kitchen/hot_station/senya_task claude_monet/kitchen/cold_station/fedya_task > claude_monet/kitchen/team_tasks
cat locker_room/leva_note >> first_shift
mv nagiev_message claude_monet/office/owner_message

git status
git add .
git commit -m "Часть 2"
git push origin HEAD

echo "4.1"
ls -lR . | grep '^-' | sort -k 5,5 -n -r | head -n 5

echo "4.2"
grep -h -r -i "макс" --exclude-dir=".git" . | grep -v -i "отчёт" | sort -r | head -n 4

echo "4.3"
grep -h -i -E "блюд|продукт" claude_monet/kitchen/hot_station/*_task claude_monet/kitchen/cold_station/*_task | sort | wc -w

echo "4.4"
ls -lR . | grep '^-' | grep -E '^.{10}\s+2\s' | sort -k 9,9 -r

echo "4.5"
for f in claude_monet/kitchen/hot_station/*; do [ -f "$f" ] && head -n 1 "$f" && tail -n 1 "$f"; done | sort

echo "4.6"
grep -i "гост" claude_monet/hall/guest_reviews | grep -v -i "постоянн" | sort -r | head -n 2

echo "4.7"
grep -r -l -i "гост" claude_monet/kitchen/hall_backup | wc -l

rm -f locker_room/max_resume
rm -f locker_room/first_menu
rm -f guest_zone
rm -f first_shift
rm -f claude_monet/kitchen/shift_plan
rm -f claude_monet/kitchen/cold_station/fedya_task
rmdir claude_monet/kitchen/cold_station
rm -rf claude_monet/kitchen/hall_backup

git status
git add .
git commit -m "Часть 3"
git push origin HEAD
