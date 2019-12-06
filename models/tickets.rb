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

  def self.all()
    sql = "SELECT * FROM tickets"
    ticket_data = SqlRunner.run(sql)
    return map_ticket(ticket_data)
  end

  def delete()
    sql = "DELETE FROM tickets WHERE id = $1;"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.map_ticket(ticket_data)
    return ticket_data.map{|ticket_hash| Ticket.new(ticket_hash)}
  end

  # def buy_ticket(customer)
  #   # get price
  #   # decrease funds in ruby
  #   # update database
  #   sql_get_price = "SELECT price FROM films WHERE title = $1"
  #   values = [@]
  #
  # end

end
