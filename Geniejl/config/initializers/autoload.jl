# Optional flat/non-resource MVC folder structure
push!(LOAD_PATH,  "controllers", "views", "views/layouts", "models")
push!(LOAD_PATH, joinpath(pwd(), "app/resources/users"))
push!(LOAD_PATH, joinpath(pwd(), "src"))