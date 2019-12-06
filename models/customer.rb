require_relative('./film')

class Customer

  attr_reader :id
  attr_accessor :name, :funds

  def initialize(options)
    @id = options["id"] if options["id"]
    @name = options["name"]
    @funds = options["funds"]
  end

  def save()
    sql = "INSERT INTO customers (
    name,
    funds
    ) VALUES ($1, $2)
    RETURNING id;"
    values = [@name, @funds]
    @id = SqlRunner.run(sql, values)[0]["id"].to_i
  end

  def self.delete_all()
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

  def self.all()
    sql = "SELECT * FROM customers"
    customer_data = SqlRunner.run(sql)
    return map_customer(customer_data)
  end

  def update()
    sql = "UPDATE customers SET (name, funds) = ($1, $2) WHERE id = $3;"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM customers WHERE id = $1;"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def films
    sql = "SELECT films.title FROM films
          INNER JOIN tickets ON films.id = tickets.film_id
          WHERE tickets.customer_id = $1"
    values = [@id]
    films_data = SqlRunner.run(sql, values)
    return Film.map_films(films_data)
  end

  def self.map_customer(customer_data)
    return customer_data.map{|customer_hash| Customer.new(customer_hash)}
  end
end
