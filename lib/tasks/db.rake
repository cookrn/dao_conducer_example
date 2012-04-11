namespace :db do
  task :bounce => [ "db:drop" , "db:schema:load" , "db:seed" , "db:test:prepare" ]
end
