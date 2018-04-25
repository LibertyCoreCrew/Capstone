# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create!([{ 
:name => 'Admin', 
:email => 'admin@gmail.com', 
:password => 'admin123', 
:password_confirmation => 'admin123', 
:admin => true 
},
{ 
:name => 'Greg Johnson', 
:email => 'gregjohnson@gmail.com', 
:password => 'password123', 
:password_confirmation => 'password123', 
:admin => false 
},
{ 
:name => 'Tim Robins', 
:email => 'timerobins@gmail.com', 
:password => 'password123', 
:password_confirmation => 'password123', 
:admin => false 
},
{ 
:name => 'Frank Nelson', 
:email => 'franknelson@gmail.com', 
:password => 'password123', 
:password_confirmation => 'password123', 
:admin => false 
}])
p "Created #{User.count} users"
tract = Tract.create!([{ 
:user_id => user.first,
:owner_name => "Chris Hannity",
:owner_phone => '402-555-4685',
:parcel_address => '123 Main Street',
:payment_amount => 120.30,
:remarks => 'Need to reach out still'
},
{ 
:user_id => user.second,
:owner_name => "Bob Marshall",
:owner_phone => '402-555-8675',
:parcel_address => '129 Wolf Street',
:payment_amount => 120.30,
:remarks => 'Waiting on customer'
},
{ 
:user_id => user.third,
:owner_name => "Ben Smith",
:owner_phone => '402-555-4921',
:parcel_address => '1060 Maple Street',
:payment_amount => 120.30,
:remarks => 'Complete'
}
])
p "Created #{Tract.count} tracts"