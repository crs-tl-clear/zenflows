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

defmodule Zenflows.VF.Organization.Filter do
@moduledoc "Filtering logic of Organizations."

use Zenflows.DB.Schema

import Ecto.Query

alias Ecto.Query
alias Zenflows.DB.Filter
alias Zenflows.VF.{Organization, Validate}

@type error() :: Filter.error()

@spec filter(Filter.params()) :: Filter.result()
def filter(params) do
	case chgset(params) do
		%{valid?: true, changes: c} ->
			{:ok, Enum.reduce(c, where(Organization, type: :org), &f(&2, &1))}
		%{valid?: false} = cset ->
			{:error, cset}
	end
end

@spec f(Query.t(), {atom(), term()}) :: Query.t()
defp f(q, {:name, v}),
	do: where(q, [x], ilike(x.name, ^"%#{Filter.escape_like(v)}%"))

embedded_schema do
	field :name, :string
end

@spec chgset(params()) :: Changeset.t()
defp chgset(params) do
	%__MODULE__{}
	|> Changeset.cast(params, [:name])
	|> Validate.name(:name)
end
end
