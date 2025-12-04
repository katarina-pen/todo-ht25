require 'sinatra'
require 'sqlite3'
require 'slim'
require 'sinatra/reloader'


get('/emil') do
slim(:emil)
end



        #READ
# Routen /
get '/todo' do
  query = params[:q]

  p "Användaren skrev #{query}"


  #Gör en koppling till db(databasen)
  db = SQLite3:: Database.new("db/todos.db")

  #[{},{},{}] vi önskar oss detta format iställer för [[],[],[]]
  db.results_as_hash = true

  #Hämta allting från db
    #instansvariablen @todoData skapas här för första gången
  @todoData = db.execute("SELECT * FROM todos")

  p @todoData


  #sätter detta under db så att sidan har tillgång till den :)
  #om query finns OCH ej är tom,
  if query && !query.empty?
        #hämta det som användaren söker från db,
        @todoData = db.execute("SELECT* FROM todos WHERE name LIKE ?", "%#{query}%")
    else
        #annars hämta allting från db!
        @todoData = db.execute ("SELECT * FROM todos")
  end

    #Visa upp med slim
    slim(:index)
end


        #CREATE
get("/todoNew") do

  slim(:new)
 
end

post("/todoNew") do
  #hämtar det användaren skrev från formuläret i new.slim filen
  newTodoName = params[:todoName]
  newTodoDescription = params[:todoDesc]

  p "Användaren vill skapa #{newTodoName} med beskrivningen #{newTodoDescription}"
    
  #kopplar formuläret till databasen :)
  db = SQLite3::Database.new("db/todos.db")
  db.execute("INSERT INTO todos (name, description) VALUES (?,?)", [newTodoName,newTodoDescription])
  redirect("/todo") #hoppa till routen som visar upp alla todos

end

        #UPDATE
# update/edit
get("/todo/:id/edit") do
  # koppla till db
  db = SQLite3::Database.new("db/todos.db")

  db.results_as_hash = true
  id = params[:id].to_i
  @update_todo = db.execute("SELECT * FROM todos WHERE id=?",id).first

  # visa formulär för att uppdatera
  slim(:edit)
end

post("/todo/:id/update") do
  #plocka upp id, name, description och state
  id = params[:id]
  name = params[:name]
  description = params[:description]
  # state = params[:state]

  # koppla till db
  db = SQLite3::Database.new("db/todos.db")
  # samma ordning i array som i det där andra som står under :)
  db.execute("UPDATE todos SET name=?, description=? WHERE id=?",[name,description,id])
  # slutligen, redirecta till todo som har hand om uppvisning
  redirect("/todo")
end


        #DELETE🗑️
# Ta bort en todo

post("/todo/:id/delete") do 
  # hämta todos
  id = params[:id].to_i
  # koppla till db
  db = SQLite3::Database.new("db/todos.db")

  db.execute("DELETE FROM todos WHERE id = ?",id)
  redirect("/todo")

end