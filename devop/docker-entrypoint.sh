#!/usr/bin/env bash
# Zenflows is designed to implement the Valueflows vocabulary,
# written and maintained by srfsh <info@dyne.org>.
# Copyright (C) 2021-2022 Dyne.org foundation <foundation@dyne.org>.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

set -Eeo pipefail

envMissing=
isZenflow=
case "$1" in
	zenflows) isZenflow=1 ;;
esac

if [ -n "$isZenflow" ]; then
	if [ ! -n "$DB_HOST" ]; then
		echo >&2
		echo >&2 'warning: missing DB_HOST environment variable'
		echo >&2
		export envMissing=1
	fi

	if [ ! -n "$DB_NAME" ]; then
		echo >&2
		echo >&2 'warning: missing DB_NAME environment variable'
		echo >&2
		export envMissing=1
	fi

	if [ ! -n "$DB_USER" ]; then
		echo >&2
		echo >&2 'warning: missing DB_USER environment variable'
		echo >&2
		export envMissing=1
	fi

	if [ ! -n "$DB_PASS" ]; then
		echo >&2
		echo >&2 'warning: missing DB_PASS environment variable'
		echo >&2
		export envMissing=1
	fi

	if [ ! -n "$ROOM_HOST" ]; then
		echo >&2
		echo >&2 'warning: missing ROOM_HOST environment variable'
		echo >&2
		export envMissing=1
	fi

	if [ ! -n "$ROOM_PORT" ]; then
		echo >&2
		echo >&2 'warning: missing ROOM_PORT environment variable'
		echo >&2
		export envMissing=1
	fi

	if [ ! -n "$ROOM_SALT" ]; then
		echo >&2
		echo >&2 'warning: missing ROOM_SALT environment variable, generating defaults'
		echo >&2
		export ROOM_SALT=$(openssl rand -base64 64 | tr -d \\n)
	fi

	if [ ! -n "$ADMIN_KEY" ]; then
		echo >&2
		echo >&2 'warning: missing ADMIN_KEY environment variable, generating defaults'
		echo >&2
		export ADMIN_KEY=$(openssl rand -hex 64)
	fi

	if [ ! -n "$envMissing" ]; then
		mix ecto.create
		mix ecto.migrate
	else
		exit 1
	fi
fi

exec "$@"
