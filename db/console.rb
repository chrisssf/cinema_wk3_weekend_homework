require_relative('../models/film')
require_relative('../models/customer')
require_relative('../models/tickets')

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

ticket1 = Ticket.new({
  "customer_id" => customer1.id,
  "film_id" => film1.id
  })
ticket1.save()

ticket2 = Ticket.new({
  "customer_id" => customer2.id,
  "film_id" => film1.id
  })
ticket2.save()

ticket3 = Ticket.new({
  "customer_id" => customer1.id,
  "film_id" => film2.id
  })
ticket3.save()

ticket4 = Ticket.new({
  "customer_id" => customer3.id,
  "film_id" => film2.id
  })
ticket4.save()


binding.pry
nil
