%--------Knapsack Sets Creator-----------------------

% Written by: Oliver Hoare
% Date: 06/12/19
% Project: Optimisation of 'Cell Selection' for the telecoms industry
% Run Time: 30 Seconds

tic
clear all
cell_data = csvread('cell_data.csv');
pop_dist_map = csvread('Population_density_map_uk.csv');
set_creator(cell_data, pop_dist_map);
toc
function set_creator(cell_data, pop_dist_map)

    macro_coverage = cell_coverage_macro_matrix();
    micro_coverage = cell_coverage_micro_matrix();
    pico_coverage = cell_coverage_pico_matrix();
   
    knapsack_set = zeros(size(cell_data,1),3);
    
    %This section check
    for i= 1:size(cell_data,1)
        knapsack_set(i,1) = cell_data(i,1);
        knapsack_set(i,2) = cell_data(i,6);
        if cell_data(i,4) == 32
            for j =  1: size(macro_coverage,1)
                for k = 1: size(macro_coverage,1)
                    x1c = j + 10*cell_data(i,2) - size(macro_coverage,1)/2;
                    x2c = k + 10*cell_data(i,3) - size(macro_coverage,1)/2;                  
                    if x1c > 0 && x2c > 0 && x1c < 10000 && x2c < 10000 
                       if macro_coverage(j,k) == 1 
                            knapsack_set(i,3) = pop_dist_map(x1c,x2c);
                        end
                    end
                end
            end
        end
        if cell_data(i,4) == 2
            for j =  1: size(micro_coverage,1)
                for k = 1: size(micro_coverage,1)
                    x1c = j + 10*cell_data(i,2) - size(micro_coverage,1)/2;
                    x2c = k + 10*cell_data(i,3) - size(micro_coverage,1)/2;                  
                    if x1c > 0 && x2c > 0 && x1c < 10000 && x2c < 10000 
                        if micro_coverage(j,k) == 1 
                            knapsack_set(i,3) = pop_dist_map(x1c,x2c);
                        end
                    end
                end
            end
        end
        if cell_data(i,4) == 0.2
            for j =  1: size(pico_coverage,1)
                for k = 1: size(pico_coverage,1)
                    x1c = j + 10*cell_data(i,2) - size(pico_coverage,1)/2;
                    x2c = k + 10*cell_data(i,3) - size(pico_coverage,1)/2;                  
                    if x1c > 0 && x2c > 0 && x1c < 10000 && x2c < 10000 
                        if pico_coverage(j,k) == 1 
                            knapsack_set(i,3) = pop_dist_map(x1c,x2c);
                        end
                    end
                end
            end
        end
    end                     
    csvwrite('knapsack_set.csv',knapsack_set);
end
function cell_coverage_macro = cell_coverage_macro_matrix() 
    cell_coverage_macro = zeros(640);
    for x = 0:20*32 %32km is range of macro_cell. for resolution of 100m, we need 20*32. 
        for y = 0:20*32
            a = x-10*32;
            b = y-10*32;
            r = sqrt(a^2+b^2); %Circular Coverage
            if r < 10*32
                cell_coverage_macro(x,y) = 1;
            end
        end
    end  
end
function cell_coverage_micro = cell_coverage_micro_matrix()
    cell_coverage_micro = zeros(40);
     
    for x = 0:20*2  %2km is range of pico_cell. for resolution of 100m, we need 20*2. 
        for y = 0:20*2
            a = x-10*2;
            b = y-10*2;
            r = sqrt(a^2+b^2);
            if r < 10*2
                cell_coverage_micro(x,y) = 1;
            end
        end
    end  
end
function cell_coverage_pico = cell_coverage_pico_matrix()

    cell_coverage_pico = zeros(4);
    
    for x = 0:20*0.2 %0.2km is range of pico_cell. for resolution of 100m, we need 20*0.2. 
        for y = 0:20*0.2
            a = x-10*0.2;
            b = y-10*0.2;
            r = sqrt(a^2+b^2);
            if r < 10*0.2
                cell_coverage_pico(x,y) = 1;
            end
        end
    end  
end