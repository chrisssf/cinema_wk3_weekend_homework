require_relative('../db/sql_runner')
require_relative('./customer')
require_relative('./tickets')


class Film

  attr_reader :id
  attr_accessor :title, :price

  def initialize(options)
    @id = options['id'].to_i() if options['id']
    @title = options['title']
    @price = options['price'].to_i()
  end

  def save()
    sql = "INSERT INTO films (
    title,
    price
    )
    VALUES ( $1, $2 )
    RETURNING id;"
    values = [@title, @price]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def self.delete_all()
    sql = "DELETE FROM films;"
    SqlRunner.run(sql)
  end

  def self.all()
    sql = "SELECT * FROM films;"
    film_data = SqlRunner.run(sql)
    return map_films(film_data)
  end

  def update()
    sql = "UPDATE films SET (title, price) = ($1, $2) WHERE id = $3"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM films WHERE id = $1;"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def customers
    sql = "SELECT customers.name FROM customers
          INNER JOIN tickets ON customers.id = tickets.customer_id
          WHERE film_id = $1;"
    values = [@id]
    customer_data = SqlRunner.run(sql, values)
    return Customer.map_customers(customer_data)
  end

  def buy_ticket(customer)

    new_ticket = Ticket.new({
      "customer_id" => customer.id,
      "film_id" => @id
      })

    new_ticket.save()

    sql_get_price = "SELECT price FROM films WHERE title = $1"
    values = [@title]
    price = SqlRunner.run(sql_get_price, values)[0]['price'].to_i
    customer.funds -= price
    customer.update()
  end

  def self.map_films(film_data)
    return film_data.map{|film_hash| Film.new(film_hash)}
  end

end
