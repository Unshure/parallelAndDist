import matplotlib.pyplot as plt

#graph of threads speedup
number_of_threads = [2,3,4,5,6,7,8]
timing_threads = [103.271, 94.412, 87.323, 84.133, 82.876, 77.136, 67.842]

#data for thread speedup
#2 thread 103.271 million cycles	
#3 thread 94.412 million cycles	
#4 thread 97.323 million cycles	
#5 thread 84.133 million cycles	
#6 thread 82.876 million cycles	
#7 thread 77.136 million cycles	
#8 thread 67.842 million cycles	

plt.plot(number_of_threads,timing_threads)
plt.xlabel('Number of threads')
plt.ylabel('Time to completion as a function of the number of threads (in Millions of cycles')

plt.title('Speedup as a function of the number of threads (in Millions of Cycles)') 

plt.show()


#graph of cores speedup
number_of_cores = [1,2,3,4]
timing_cores = [298.261, 157.886, 150.023, 107.411]

#data for core speedup
#1 core 298.261 million cycles
#2 core 157.886 million cycles	
#3 core 150.023 million cycles	
#4 core 107.411 million cycles	

plt.plot(number_of_cores,timing_cores)
plt.xlabel('Number of cores')
plt.ylabel('Time to completion as a function of the number of cores (in Millions of cycles)')

plt.title('Speedup as a function of the number of cores (in Millions of Cycles)') 

plt.show()

#graph of speedup equation using threads
number_of_threads = [2,3,4,5,6,7,8]
timing_threads = [103.271, 94.412, 87.323, 84.133, 82.876, 77.136, 67.842]

for index in range (len(timing_threads)):
	timing_threads[index] = 103.271/timing_threads[index]

plt.plot(number_of_threads, timing_threads)
plt.xlabel('Number of threads')
plt.ylabel('Speedup')

plt.title('Speedup by adding multiple threads (using tasks)')
plt.show()


#graph of speedup equation using cores
number_of_cores = [1,2,3,4]
timing_cores = [298.261, 157.886, 150.023, 107.411]

for index in range (len(timing_cores)):
	timing_cores[index] = 298.261/timing_cores[index]

plt.plot(number_of_cores, timing_cores)
plt.xlabel('Number of cores')
plt.ylabel('Speedup')

plt.title('Speedup by adding multiple cores (using tasks)')
plt.show()
