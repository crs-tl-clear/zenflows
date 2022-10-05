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

FROM elixir:1.13-alpine

ARG MIX_ENV
ENV MIX_ENV=$MIX_ENV
ENV MIX_HOME=/app/.mix
ENV PATH=$PATH:/app/_build/"$MIX_ENV"/rel/zenflows/bin

WORKDIR /app

RUN set -eux; apk add --no-cache 	\
	libstdc++ 			\
	bash 				\
	ncurses-libs 			\
	openssl 			\
	findutils

COPY mix.exs mix.lock ./
COPY conf/buildtime.exs conf/
COPY .deps deps
COPY conf conf
COPY priv priv
COPY src src

RUN mix do local.hex --force, local.rebar --force
RUN mix do compile, release

ARG USER=zenflows GROUP=zenflows
RUN addgroup -S "$GROUP" && adduser -SG"$GROUP" "$USER"
USER "$USER"

COPY devop/docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 8000
CMD ["zenflows", "start"]
