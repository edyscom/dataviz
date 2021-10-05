
### FizzBuzz problem
## 条件分岐を使わないver.

args <- commandArgs()

args

endval <- args[6]

i <- 1:endval
x <- i
x[i%%3==0] <- "Fizz"
x[i%%5==0] <- "Buzz"
x[i%%3==0 & i%%5==0] <- "FizzBuzz"
        
cat(paste(x, collapse="\n"))
cat("\n")
