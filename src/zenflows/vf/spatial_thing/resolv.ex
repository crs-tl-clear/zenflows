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

defmodule Zenflows.VF.SpatialThing.Resolv do
@moduledoc "Resolvers of SpatialThings."
# Basically, a fancy name for (geo)location.  :P

alias Zenflows.VF.SpatialThing.Domain

def spatial_thing(params, _) do
	Domain.one(params)
end

def spatial_things(params, _) do
	Domain.all(params)
end

def create_spatial_thing(%{spatial_thing: params}, _) do
	with {:ok, spt_thg} <- Domain.create(params) do
		{:ok, %{spatial_thing: spt_thg}}
	end
end

def update_spatial_thing(%{spatial_thing: %{id: id} = params}, _) do
	with {:ok, spt_thg} <- Domain.update(id, params) do
		{:ok, %{spatial_thing: spt_thg}}
	end
end

def delete_spatial_thing(%{id: id}, _) do
	with {:ok, _} <- Domain.delete(id) do
		{:ok, true}
	end
end
end
