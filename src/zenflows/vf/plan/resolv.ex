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

defmodule Zenflows.VF.Plan.Resolv do
@moduledoc "Resolvers of Plan."

use Absinthe.Schema.Notation

alias Zenflows.VF.Plan.Domain

def plan(params, _) do
	Domain.one(params)
end

def plans(params, _) do
	Domain.all(params)
end

def create_plan(%{plan: params}, _) do
	with {:ok, plan} <- Domain.create(params) do
		{:ok, %{plan: plan}}
	end
end

def update_plan(%{plan: %{id: id} = params}, _) do
	with {:ok, plan} <- Domain.update(id, params) do
		{:ok, %{plan: plan}}
	end
end

def delete_plan(%{id: id}, _) do
	with {:ok, _} <- Domain.delete(id) do
		{:ok, true}
	end
end

def created(%{id: id}, _, _) do
	Zenflows.DB.ID.ts(id)
end

def refinement_of(plan, _, _) do
	plan = Domain.preload(plan, :refinement_of)
	{:ok, plan.refinement_of}
end
end
