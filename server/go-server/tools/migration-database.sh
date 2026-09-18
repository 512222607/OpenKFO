#!/usr/bin/env bash
# One-time operator migration utility. No credentials are printed.
set -euo pipefail
umask 077
mode=${1:?snapshot, backup or restore}
runtime=${2:?docker or native}
folder=${3:?private backup directory}
mkdir -p "$folder"
dsn=$(sed -n 's/^KK_MYSQL_DSN=//p' /etc/kungfu-go/game.env)
user=${dsn%%:*}
password=${dsn#*:}
password=${password%%@tcp*}
database=${dsn#*)/}
database=${database%%\?*}
test "$database" = kungfu_game
export MYSQL_PWD="$password"
mysql_command=(mysql --no-defaults -h127.0.0.1 -u"$user" --init-command="SET time_zone = '+00:00'" --batch --skip-column-names)
dump_command=(mysqldump --no-defaults -h127.0.0.1 -u"$user")
if [ "$runtime" = docker ]; then
  mysql_command=(docker exec -e MYSQL_PWD="$password" htserver-mysql mysql --no-defaults -u"$user" --init-command="SET time_zone = '+00:00'" --batch --skip-column-names)
  dump_command=(docker exec -e MYSQL_PWD="$password" htserver-mysql mysqldump --no-defaults -u"$user")
elif [ "$runtime" != native ]; then
  exit 2
fi
if [ "$mode" = backup ]; then
  "${dump_command[@]}" --single-transaction --quick --hex-blob --order-by-primary --no-tablespaces --set-gtid-purged=OFF --skip-add-drop-table "$database" | gzip > "$folder/game.sql.gz"
  sha256sum "$folder/game.sql.gz"
elif [ "$mode" = restore ]; then
  count=$("${mysql_command[@]}" -e "SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA='kungfu_game'")
  test "$count" = 0 || { echo 'Refusing to restore over a nonempty database.' >&2; exit 1; }
  gzip -dc "$folder/game.sql.gz" | "${mysql_command[@]}" "$database"
elif [ "$mode" != snapshot ]; then
  exit 2
fi
tables=$("${mysql_command[@]}" -e "SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_SCHEMA='kungfu_game' ORDER BY TABLE_NAME")
: > "$folder/rows.sha256"
for table in $tables; do
  [[ "$table" =~ ^[a-z_]+$ ]] || exit 1
  columns=$("${mysql_command[@]}" -e "SELECT GROUP_CONCAT(CONCAT('IFNULL(HEX(',CHAR(96),COLUMN_NAME,CHAR(96),'),',CHAR(39),'NULL',CHAR(39),')') ORDER BY ORDINAL_POSITION SEPARATOR ',') FROM information_schema.COLUMNS WHERE TABLE_SCHEMA='kungfu_game' AND TABLE_NAME='$table'")
  count=$("${mysql_command[@]}" "$database" -e "SELECT COUNT(*) FROM \`$table\`")
  digest=$("${mysql_command[@]}" "$database" -e "SELECT $columns FROM \`$table\`" | LC_ALL=C sort | sha256sum | cut -d' ' -f1)
  printf '%s %s %s\n' "$table" "$count" "$digest" >> "$folder/rows.sha256"
done
cat "$folder/rows.sha256"
