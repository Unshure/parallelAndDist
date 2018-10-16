export void newton_method_ispc(uniform int input_size,
                uniform float x_initial,
                uniform float input[],
                uniform float output[])
{
    // Computes the square root of each element in the values array and stores it in the output array
    // input_size should be set to the size of the input/output array
    // x0 is the initial guess for Newton's method

    static const float tolerance = 0.001f; // break tolerance is 10**-4
    uniform int num_threads = 8;
    
    // Based on the number of threads we want to use we need to find how many iterations to use in our loop
    int break_i = input_size / num_threads;
    if (input_size % num_threads != 0)
        break_i += 1;
    
    // The following for loop has a nested foreach loop
    // The for loop loops over the range specified previously
    // The foreach loop loops over our input array in chunks based on our number of threads
    // What this does is give us control over how many threads should be spawned in any given iteration of the for loop
    // Note: This is done for experimental purposes as using only a foreach loop would make use of all available threads and give the best speed up
    for(uniform int i=0; i<break_i ; i++){
    	uniform int start = i*num_threads;
    	uniform int stop = min(input_size, start+num_threads);
        foreach(j = start ... stop){

            float S = input[j]; // value to find sqrt
            float x_0 = x_initial;
            float x_1 = .5f * (x_0 + (S/x_0));

            while (abs(x_1-x_0)> tolerance) {
                x_0 = x_1;
                    x_1 = .5f * (x_0 + (S/x_0));
            }
            output[j] = x_1;
    	}
    }
}


task void newton_method_ispc_task(uniform int input_size,
		uniform int range,
                uniform float x_initial,
                uniform float input[],
                uniform float output[])
{
    // Computes the square root of each element in the values array and stores it in the output array
    // Using tasks so now we add range variable to determine which indices of the output array to access
    // input_size should be set to the size of the input/output array
    // x0 is the initial guess for Newton's method


    // We determine the first index by multiplying the current taskIndex with the desired range we set for how many elements each task should calculate
    uniform int start = taskIndex * range;  // taskIndex is a special variable which paired with taskCount can be seen as programCount and programIndex for tasks
    // We determine the last index using the starting point plus the range
    uniform int stop = min(input_size, start + range); // additional logic prevents overflow

    static const float tolerance = 0.001f; // break tolerance is 10**-4

    // foreach loop is similar to the previous function, but now we are splitting the foreach loop across different tasks (different cores)
    foreach(i = start ... stop){

        float S = input[i]; // value to find sqrt
        float x_0 = x_initial;
        float x_1 = .5f * (x_0 + (S/x_0));

        while (abs(x_1-x_0)> tolerance) {
            x_0 = x_1;
            x_1 = .5f * (x_0 + (S/x_0));
        }

        output[i] = x_1;
    }
}


export void newton_method_ispc_withtasks(uniform int input_size,
                			 uniform float x_initial,
                			 uniform float input[],
                			 uniform float output[])
{
	// Launches newton_method_ispc_task on the input array, mirroring newton_method_ispc and newton_method_serial inputs because programming
	
	uniform int range = input_size / 4; // Sets range to be input_size over desired number of tasks, change the value in the denom to change number of tasks
	
	launch[input_size/range] newton_method_ispc_task(input_size, range, x_initial, input, output); // Launches input_size/input_size/num_desired_tasks = num_desired_tasks which thanks to range will cover the whole input/output array
}


