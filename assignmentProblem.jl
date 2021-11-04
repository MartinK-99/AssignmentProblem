using LinearAlgebra
using JuMP
using GLPK

# Matrix for cost
c = [11 12 6 16 3
     9 16 19 18 12
     8 10 11 7 6
     6 10 13 9 9
     8 10 11 10 5]
n = size(c)[1]

model = Model(GLPK.Optimizer)

# Variables x
@variable(model,x[i = 1:n, j=1:n] >= 0)

# Objective function you want to minimize
@objective(model, Min, sum(c[i,j] * x[i,j] for i in 1:n for j in 1:n))

# Constraints
@constraint(model, row_con[i = 1:n],sum(x[i,j] for j in 1:n) == 1)
@constraint(model, column_con[j = 1:n],sum(x[i,j] for i in 1:n) == 1)

optimize!(model)
#print(model) # Print the whole model

# Pretty console output
println("\n\n\nResult:\nWorker\tTask\tCost")
for i in 1:n
    for j in 1:n
        if value(x[i,j]) > 0
            println(" ",i,"\t ",j,"\t ",c[i,j])
        end
    end
end
println("----------------------")
println("Total Cost: ", objective_value(model))
