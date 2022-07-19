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

defmodule Zenflows.VF.ProductBatch.Domain do
@moduledoc "Domain logic of ProductBatches."

alias Ecto.Multi
alias Zenflows.DB.Repo
alias Zenflows.VF.ProductBatch

@typep repo() :: Ecto.Repo.t()
@typep chgset() :: Ecto.Changeset.t()
@typep changes() :: Ecto.Multi.changes()
@typep id() :: Zenflows.DB.Schema.id()
@typep params() :: Zenflows.DB.Schema.params()

@spec by_id(repo(), id()) :: ProductBatch.t() | nil
def by_id(repo \\ Repo, id) do
	repo.get(ProductBatch, id)
end

@spec create(params()) :: {:ok, ProductBatch.t()} | {:error, chgset()}
def create(params) do
	Multi.new()
	|> Multi.insert(:insert, ProductBatch.chgset(params))
	|> Repo.transaction()
	|> case do
		{:ok, %{insert: b}} -> {:ok, b}
		{:error, _, cset, _} -> {:error, cset}
	end
end

@spec update(id(), params()) :: {:ok, ProductBatch.t()} | {:error, chgset()}
def update(id, params) do
	Multi.new()
	|> Multi.run(:get, multi_get(id))
	|> Multi.update(:update, &ProductBatch.chgset(&1.get, params))
	|> Repo.transaction()
	|> case do
		{:ok, %{update: b}} -> {:ok, b}
		{:error, _, msg_or_cset, _} -> {:error, msg_or_cset}
	end
end

@spec delete(id()) :: {:ok, ProductBatch.t()} | {:error, chgset()}
def delete(id) do
	Multi.new()
	|> Multi.run(:get, multi_get(id))
	|> Multi.delete(:delete, &(&1.get))
	|> Repo.transaction()
	|> case do
		{:ok, %{delete: b}} -> {:ok, b}
		{:error, _, msg_or_cset, _} -> {:error, msg_or_cset}
	end
end

# Returns a ProductBatch in ok-err tuple from given ID.  Used inside
# Ecto.Multi.run/5 to get a record in transaction.
@spec multi_get(id()) :: (repo(), changes() -> {:ok, ProductBatch.t()} | {:error, String.t()})
defp multi_get(id) do
	fn repo, _ ->
		case by_id(repo, id) do
			nil -> {:error, "not found"}
			b -> {:ok, b}
		end
	end
end
end
