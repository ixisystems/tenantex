defmodule Mix.Tasks.Tenantex.Migrate do
  use Mix.Task
  import Application, only: [get_env: 2]
  import Tenantex.Migrator

  @shortdoc "Migrates every tenant defined in your load_tenants config"

  @moduledoc """
  Migrates all of the tenants

  Notes: You must have the load_tenants and repo config options set.

  Any arguments you specify will be passed along directly to Ecto's migrate command,
  so they're all fair game as well.  That said, prefix (--prefix) and repo (-r/--repo)
  will be overridden by what is in your config.

  ## Examples

      mix tenantex.migrate

  """
  def run(args) do
    Mix.Task.run "loadpaths", []
    repo = get_env :tenantex, :repo

    Mix.Ecto.ensure_repo(repo, [])
    Mix.Ecto.ensure_started(repo, [])

    direction = Keyword.get(args, :direction, :up)
    tenants = Tenantex.list_tenants
    tenants |> Enum.map(fn(tenant) -> migrate_tenant(repo, tenant, direction, args) end)
  end

  def pry(input) do
    require IEx; IEx.pry
    input
  end

  def get_tenants(tenants) when is_list(tenants), do: tenants
  def get_tenants(tenant_loader) when is_function(tenant_loader), do: tenant_loader.()
  def get_tenants(_), do: raise ArgumentError
end
