module CreateTableUsers

import SearchLight.Migrations: create_table, column, primary_key, add_index, drop_table

function up()
  create_table(:users) do
    [
      primary_key()
      column(:discordId, :int)
      column(:accessToken, :string)
      column(:refreshToken, :string)
      column(:expiresIn, :int)
    ]
  end

  add_index(:users, :discordId)
end

function down()
  drop_table(:users)
end

end
