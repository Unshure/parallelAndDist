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
    int break_i = input_size / num_threads;
    if (input_size % num_threads != 0)
        break_i += 1;
      // possibly needs some casting, ceil takes float in, outs float?
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


    // foreach loop is the same as the previous function
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


