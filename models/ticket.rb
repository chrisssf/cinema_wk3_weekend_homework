class Ticket

  attr_reader :id, :customer_id, :film_id

  def initialize(options)
    @id = options["id"].to_i if options["id"]
    @customer_id = options["customer_id"].to_i
    @film_id = options["film_id"].to_i
    @screening_id = options["screening_id"].to_i
  end

  def save()
    sql = "INSERT INTO tickets (
    customer_id,
    film_id,
    screening_id
    ) VALUES ($1, $2, $3)
    RETURNING id;"
    values = [@customer_id, @film_id, @screening_id]
    @id = SqlRunner.run(sql, values)[0]["id"].to_i
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

end
