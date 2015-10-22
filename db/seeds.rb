# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#No Dependincies
load 'db/seeds/users.rb'
load 'db/seeds/words.rb'
#load 'db/seeds/word_roots.rb'
load 'db/seeds/courses.rb'

#Dependincies <-- Order matters
load 'db/seeds/courses_users.rb' #Depends on Courses and Users

#load 'db/seeds/word_roots_words.rb' #Depends on words and word roots
load 'db/seeds/lessons.rb'
