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

end
