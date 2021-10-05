
### FizzBuzz problem


for  (i in 1:10){
	if(i %% 3 == 0 & i %% 5 == 0){
		cat("FizzBuzz\n")
	}
	else if(i %% 5 == 0 ){
		cat("Buzz\n")
	}
	else if(i %% 3 == 0 ){
		cat("Fizz\n")
	}
	else{
		cat(i,"\n")
	}

}
