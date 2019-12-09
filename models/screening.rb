require_relative('../db/sql_runner')
require_relative('./film')

class Screening

  attr_reader :id
  attr_accessor :show_time, :screen_number, :film_id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @show_time = options['show_time']
    @screen_number = options['screen_number'].to_i
    @film_id = options['film_id'].to_i
  end

  def self.create_new_screening(show_time, screen_number, film)
    new_screening = Screening.new({
      'show_time' => show_time,
      'screen_number' => screen_number,
      'film_id' => film.id
      })
    new_screening.save()
    return new_screening
  end

  def save()
    sql = "INSERT INTO screenings (
    show_time,
    screen_number,
    film_id
    ) VALUES ($1, $2, $3)
    RETURNING id;"
    values = [@show_time, @screen_number, @film_id]
    @id = SqlRunner.run(sql, values)[0]["id"].to_i
  end

  def self.delete_all()
    sql = "DELETE FROM screenings"
    SqlRunner.run(sql)
  end

  def self.all()
    sql = "SELECT * FROM screenings"
    screenings_data = SqlRunner.run(sql)
    return map_screenings(screenings_data)
  end

  def update()
    sql = "UPDATE screenings SET (
    show_time,
    screen_number,
    film_id)
    = ($1, $2, $3) WHERE id = $4;"
    values = [@show_time, @screen_number, @film_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM screenings WHERE id = $1;"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.map_screenings(screenings_data)
    return screenings_data.map{|screening_hash| Screening.new(screening_hash)}
  end


end
