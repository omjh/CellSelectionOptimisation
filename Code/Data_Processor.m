%---------------------Data Processing-----------------------------

% Written by: Oliver Hoare
% Date: 03/12/19
% Project: Optimisation of 'Cell Selection' for the telecoms industry
% Run Time: 0.92 Seconds

tic
clear all

%Generate city data csv. Ordered: Long, Lat, Population
city_processor();  %Uncomment these to re-do data organisation 

%Generate Cell Data. (Don't run this function if you want to achieve the
%same results are the report. It includes random location generation)

%cell_processor(400,50000,800,10000,5000,2000); 
toc
function city_data = city_processor()
        city_population = readtable("city_population.csv");
        city_location = readtable("city_location.csv");
        city_name1 = city_population.(1);
        city_name2 = city_location.(1);
        
        matching_cities_loc = ismember(city_name2,city_name1);
        matching_cities_pop = ismember(city_name1,city_name2);
        
        city_population_data = city_population.(2);
        city_location_data = [city_location.(2)  city_location.(3)];
        city_data = zeros(1000,3);
        
        
        count = 0;
        
        for i = 1:height(city_location)   %city location is the larger data set
            if matching_cities_loc(i)  
                count = count + 1 ;
                city_data(count,1) = city_location_data(i,1);
                city_data(count,2) = city_location_data(i,2);
            end
          
        end  
        
        count = 0;
        for i = 1:height(city_population)
            if matching_cities_pop(i)
                count = count + 1;                
                city_data(count,3) = city_population_data(i,1);
            end
        end
      
        %Project Long-Lat onto Cartesian Plane
        for i = 1:size(city_data,1)       
            
            city_x1 = (city_data(i,1)-50)*pi*12742/(2*180);  %12742 is the diameter of the earth. This is conversion from long/lat to cartesian (sort of)
            city_x2 = (city_data(i,2)+7)*pi*12742/(2*180);   %Long/Lat actually spherical coordinates and so cannot be projected perfectly onto 2d plane as the earth isnt spherical!
            city_data(i,1) = round(city_x1*10);
            city_data(i,2) = round(city_x2*10);
        end
        
                
        for i = 1:size(city_data,1)
            if city_data(i,1) < 0
                city_data(i,:) = [0,0,0];
            end
        end 
        csvwrite('city_data.csv', city_data);
end 
function cell_matrix = cell_processor(number_macro,cost_macro,number_micro,cost_micro,number_pico,cost_pico)

    %This script creates an array of cells (network antenna). It give the
    %antenna 6 values: ID no, X_coordinate, Y_coordinate, range, max_no_of_devices, cost
    set_size = number_macro + number_micro +number_pico;
    cell_matrix = zeros(set_size,7);    
    
    %Macro Antenna
    range_macro = 32; %range in Km
    max_dev_no_macro = 5000; %based on estimates-(Lemieux & Zhao, 2019)
    %Micro Antenna
    range_micro = 2;
    max_dev_no_micro = 2000;
    %Pico Antenna
    range_pico = 0.2;
    max_dev_no_pico = 100;
    
    cell_no = 0;
    for i = 0:number_macro
        if number_macro ~= 0
        cell_no = cell_no + 1;
        cell_x = randi(1000, 1,1);
        cell_y = randi(1000, 1,1);
        cell_matrix(cell_no,1) = cell_no;
        cell_matrix(cell_no,2) = cell_x;
        cell_matrix(cell_no,3) = cell_y;
        cell_matrix(cell_no,4) = range_macro;
        cell_matrix(cell_no,5) = max_dev_no_macro;
        cell_matrix(cell_no,6) = cost_macro;  
        end
                                  
    end
    
    for i = 0:number_micro
        if number_micro ~= 0
        cell_no = cell_no + 1;
        cell_x = randi(1000, 1,1);
        cell_y = randi(1000, 1,1);
        cell_matrix(cell_no,1) = cell_no;
        cell_matrix(cell_no,2) = cell_x;
        cell_matrix(cell_no,3) = cell_y;
        cell_matrix(cell_no,4) = range_micro;
        cell_matrix(cell_no,5) = max_dev_no_micro;
        cell_matrix(cell_no,6) = cost_micro;  
        end
    end
    
    for i = 0:number_pico
        if number_pico ~= 0
        cell_no = cell_no + 1;
        cell_x = randi(1000, 1,1);
        cell_y = randi(1000, 1,1);
        cell_matrix(cell_no,1) = cell_no;
        cell_matrix(cell_no,2) = cell_x;
        cell_matrix(cell_no,3) = cell_y;
        cell_matrix(cell_no,4) = range_pico;
        cell_matrix(cell_no,5) = max_dev_no_pico;
        cell_matrix(cell_no,6) = cost_pico;  
        end
    end
    
    csvwrite('cell_data.csv', cell_matrix)
end 

