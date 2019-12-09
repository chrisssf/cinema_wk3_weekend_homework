require_relative('../models/film')
require_relative('../models/customer')
require_relative('../models/ticket')
require_relative('../models/screening')


require('pry')


Film.delete_all()
Customer.delete_all()
Ticket.delete_all()


film1 = Film.new({
  "title" => 'Casino',
  "price" => 5
})
film1.save()

film2 = Film.new({
  "title" => 'Finding Nemo',
  "price" => 3
})
film2.save()

film3 = Film.new({
  "title" => 'Goodfellas',
  "price" => 8
})
film3.save()

film4 = Film.new({
  "title" => 'Iron Man',
  "price" => 7
})
film4.save()

customer1 = Customer.new({
  "name" => 'Bob',
  "funds" => 100
  })
customer1.save()

customer2 = Customer.new({
  "name" => 'Dave',
  "funds" => 200
  })
customer2.save()

customer3 = Customer.new({
  "name" => 'Jim',
  "funds" => 50
  })
customer3.save()

screening1 = Screening.new({
  'show_time' => "12.00",
  'screen_number' => 2,
  'film_id' => film1.id
  })
screening1.save()

screening2 = Screening.new({
  'show_time' => "13.00",
  'screen_number' => 1,
  'film_id' => film2.id
  })
screening2.save()

screening3 = Screening.new({
  'show_time' => "19.00",
  'screen_number' => 1,
  'film_id' => film1.id
  })
screening3.save()

screening4 = Screening.new({
  'show_time' => "10.00",
  'screen_number' => 1,
  'film_id' => film3.id
  })
screening4.save()

screening5 = Screening.new({
  'show_time' => "18.00",
  'screen_number' => 3,
  'film_id' => film3.id
  })
screening5.save()

screening6 = Screening.new({
  'show_time' => "11.00",
  'screen_number' => 3,
  'film_id' => film4.id
  })
screening6.save()

screening7 = Screening.new({
  'show_time' => "15.00",
  'screen_number' => 3,
  'film_id' => film4.id
  })
screening7.save()


ticket1 = Ticket.new({
  "customer_id" => customer1.id,
  "film_id" => film1.id,
  "screening_id" => screening1.id
  })
ticket1.save()

ticket2 = Ticket.new({
  "customer_id" => customer2.id,
  "film_id" => film1.id,
  "screening_id" => screening1.id
  })
ticket2.save()

ticket3 = Ticket.new({
  "customer_id" => customer1.id,
  "film_id" => film2.id,
  "screening_id" => screening2.id
  })
ticket3.save()

ticket4 = Ticket.new({
  "customer_id" => customer3.id,
  "film_id" => film2.id,
  "screening_id" => screening2.id
  })
ticket4.save()

ticket5 = Ticket.new({
  "customer_id" => customer1.id,
  "film_id" => film3.id,
  "screening_id" => screening4.id
  })
ticket5.save()

ticket6 = Ticket.new({
  "customer_id" => customer3.id,
  "film_id" => film1.id,
  "screening_id" => screening3.id
  })
ticket6.save()

# TESTING!!!!!!@
ticket7 = Ticket.new({
  "customer_id" => customer3.id,
  "film_id" => film1.id,
  "screening_id" => screening1.id
  })
ticket7.save()
#
ticket8 = Ticket.new({
  "customer_id" => customer3.id,
  "film_id" => film3.id,
  "screening_id" => screening5.id
  })
ticket8.save()

ticket9 = Ticket.new({
  "customer_id" => customer1.id,
  "film_id" => film4.id,
  "screening_id" => screening6.id
  })
ticket9.save()

ticket10 = Ticket.new({
  "customer_id" => customer2.id,
  "film_id" => film4.id,
  "screening_id" => screening7.id
  })
ticket10.save()

ticket11 = Ticket.new({
  "customer_id" => customer3.id,
  "film_id" => film4.id,
  "screening_id" => screening7.id
  })
ticket11.save()


binding.pry
nil
