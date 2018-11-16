# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Lani.Repo.insert!(%Lani.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Lani.Repo
 alias Lani.Accounts.User

Repo.insert! %User{
  name: "test1",
  username: "test1"
  # role: "Editor"
}