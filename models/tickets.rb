class Ticket

  attr_reader :id, :customer_id, :film_id

  def initialize(options)
    @id = options["id"] if options["id"]
    @customer_id = options["customer_id"]
    @film_id = options["film_id"]
  end

  def save()
    sql = "INSERT INTO tickets (
    customer_id,
    film_id
    ) VALUES ($1, $2)
    RETURNING id;"
    values = [@customer_id, @film_id]
    @id = SqlRunner.run(sql, values)[0]["id"]
  end

  def self.delete_all()
    sql = "DELETE FROM tickets;"
    SqlRunner.run(sql)
  end

  def delete()
    sql = "DELETE FROM tickets WHERE id = $1;"
    values = [@id]
    SqlRunner.run(sql, values)
  end
end
