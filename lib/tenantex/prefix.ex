defmodule Tenantex.Prefix do
  def strip_prefix(table_prefix), do: String.replace_prefix(table_prefix, get_prefix(), "")
  def schema_name(tenant) when is_integer(tenant), do: get_prefix() <> Integer.to_string(tenant)
  def schema_name(tenant) when is_binary(tenant), do: get_prefix() <> tenant

  def schema_name(nil), do: raise ArgumentError, "Tenant can not be nil"
  defp get_prefix() do
    Application.get_env(:tenantex, Tenantex)[:schema_prefix] || "tenant_"
  end
end
