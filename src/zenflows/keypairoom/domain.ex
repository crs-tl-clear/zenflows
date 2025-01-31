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

defmodule Zenflows.Keypairoom.Domain do
@moduledoc """
Domain logic of interacting with Restroom to do Keypairoom-related
tasks.
"""

alias Zenflows.Restroom
alias Zenflows.VF.Person

def keypairoom_server(false, data) do
	if Person.Domain.exists?(email: Map.fetch!(data, "email")),
		do: Restroom.keypairoom_server(data),
		else: {:error, "email doesn't exists"}
end

def keypairoom_server(true, data) do
	if Person.Domain.exists?(email: Map.fetch!(data, "email")),
		do: {:error, "email exists"},
		else: Restroom.keypairoom_server(data)
end
end
