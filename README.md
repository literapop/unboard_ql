# UnboardQl

## Setup dev dependency services

### Erlang and Elixir

Install `asdf` as well as the elixir and erlang plugins if you don't have them installed already. Instructions are at:

https://github.com/asdf-vm/asdf

Install the erlang and elixir plugins for `asdf`:

```bash
asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
```

Install the erlang and elixir versions required by the project

```bash
asdf install
```

## Setup MySQL

```
mysql> create user unboard_dev@localhost identified by 'unboard_dev';
Query OK, 0 rows affected (0.00 sec)

mysql> create database unboard_dev;
Query OK, 1 row affected (0.00 sec)

mysql> grant all on unboard_dev.* to unboard_dev@localhost;
Query OK, 0 rows affected (0.01 sec)
```

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`http://localhost:4000/api/graphiql`](http://localhost:4000/api/graphiql) from your browser.
