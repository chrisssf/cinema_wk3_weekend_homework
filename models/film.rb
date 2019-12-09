require_relative('../db/sql_runner')
require_relative('./customer')
require_relative('./ticket')
require_relative('./screening')


class Film

  attr_reader :id
  attr_accessor :title, :price

  def initialize(options)
    @id = options['id'].to_i() if options['id']
    @title = options['title']
    @price = options['price'].to_i()
  end

  def self.add_film(title, price)
    new_film = Film.new({
      'title' => title,
      'price' => price
      })
    new_film.save()
    return new_film
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

  def number_of_customers()
    number_of_customers = self.customers().count
    return "#{number_of_customers} customers are going to watch #{@title}"
  end

  def can_customer_afford_ticket(customer)
    sql = "SELECT * FROM customers WHERE id = $1;"
    values = [customer.id]
    customer_details = SqlRunner.run(sql, values)
    customer_funds = customer_details[0]["funds"].to_i
    customer_funds >= @price ? true : false
  end

  def check_screening_availability(screening)
    screening_capacity = 30
    sql = "SELECT * FROM tickets WHERE screening_id = $1;"
    values = [screening.id]
    screening_data = SqlRunner.run(sql, values)
    tickets_sold_for_screening = screening_data.count
    tickets_sold_for_screening <= screening_capacity ? true : false
  end

  def buy_ticket(customer, screening)
    if check_screening_availability(screening)
      if can_customer_afford_ticket(customer)

        new_ticket = Ticket.new({
          "customer_id" => customer.id,
          "film_id" => @id,
          "screening_id" => screening.id
          })

        new_ticket.save()

        customer.funds -= @price
        customer.update()
      else
        return "You have insufficient funds to buy this ticket!"
      end
    else
      return "Sorry, this Screening is full!"
    end
  end

  def times()
    sql = "SELECT screenings.* FROM screenings
          INNER JOIN films ON screenings.film_id = films.id
          WHERE films.id = $1;"
    values = [@id]
    screening_data = SqlRunner.run(sql, values)
    return Screening.map_screenings(screening_data)
  end

  def most_popular_screening
    sql = "SELECT tickets.*, screenings.* FROM tickets
          INNER JOIN screenings ON screenings.id = tickets.screening_id
          WHERE tickets.film_id = $1;"
    values = [@id]
    query_data = SqlRunner.run(sql, values)
# gets an array of all screening ids, the most screening ids is the most popular
    all_screening_ids = query_data.map{|query_hash| query_hash['screening_id'].to_i}
# creates a hash with keys = sceening_id and values = the number of each ids there are
    screening_ids_hash = {}
    all_screening_ids.each do |screening_id|
      if screening_ids_hash.include?(screening_id)
          screening_ids_hash[screening_id] += 1
        else
          screening_ids_hash[screening_id] = 1
      end
    end
    # sorted_screening_ids_hash_array = [[1,3], [2,3], [3,3], [4,2], [5,1]] #for testing!!!!!!!!!
# sort to get the most popular screening_id to the first position, returns an array of arrays
    sorted_screening_ids_hash_array = screening_ids_hash.sort_by { |id, number| number}.reverse
# check if there are more than 1 most popular screening
    number_of_max_values = sorted_screening_ids_hash_array.find_all{ |number| number[1] == sorted_screening_ids_hash_array[0][1] }.length

    screenings_hash = Screening.map_screenings(query_data)
    stop_at_max_values = 0

      sorted_screening_ids_hash_array.each do |screening_id| # loops over the sorted ids
        most_popular_screening_by_id = screening_id[0] #sets a screening_id to the most popular

        screenings_hash.each do |screening_hash| #loops over screening records to retreive show_times
          if screening_hash.id == most_popular_screening_by_id #if the id matches most popular, print that show_time
            p "The most popular time for #{@title} is #{screening_hash.show_time}"
            stop_at_max_values += 1
          end
          if stop_at_max_values == number_of_max_values # stop when all most popular times have been printed
            return ":)"
          end
        end
      end
  end

  def self.map_films(film_data)
    return film_data.map{|film_hash| Film.new(film_hash)}
  end
end
