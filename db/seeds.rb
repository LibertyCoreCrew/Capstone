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
:email => 'timrobins@gmail.com', 
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
project = Project.create!([{ 
:name => 52659 
},
{ 
:name => 9 
},
{ 
:name => 17 
},
{ 
:name => 4 
}
])
p "Created #{Project.count} projects"
tract = Tract.create!([{ 
:name => 8,
:user_id => 1,
:owner_name => "Chris Hannity",
:owner_phone => '402-555-4685',
:parcel_address => '123 Main Street',
:payment_amount => 120.30,
:remarks => 'Need to reach out still',
:project_id => 1
},
{
:name => 17,
:user_id => 2,
:owner_name => "Bob Marshall",
:owner_phone => '402-555-8675',
:parcel_address => '129 Wolf Street',
:payment_amount => 120.30,
:remarks => 'Waiting on customer',
:project_id => 3
},
{
:name => 5,
:user_id => 3,
:owner_name => "Ben Smith",
:owner_phone => '402-555-4921',
:parcel_address => '1060 Maple Street',
:payment_amount => 120.30,
:remarks => 'Complete',
:project_id => 2
}
])
p "Created #{Tract.count} tracts"
