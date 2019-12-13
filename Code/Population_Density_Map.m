%-------------UK Population Density Map Generator-------------------

% Written by: Oliver Hoare
% Date: 06/12/19
% Project: Optimisation of 'Cell Selection' for the telecoms industry
% Run Time: 106 seconds

tic
%Map Size 
xp = 0:0.1:999.9; %UK approx 1000km by 1000km to 100m x 100m resolution
max_city_size = 150; %Size of matrix for calculation 'size'. More in pop_dist_function (This is not used for large cities and london)

%Get City Data 
city_data = csvread('city_data.csv');

%Create Map
pop_dist_map = create_map(city_data, max_city_size);

%Sanity Check
check_overall_population(pop_dist_map);

%Write Data set
csvwrite('Population_density_map_uk.csv', pop_dist_map);

toc

function pop_distribution_map = create_map(city_data,max_city_size) %This function add all of the population distribution functions together. 
    pop_distribution_map = zeros(10000);
    max_city_size_i = max_city_size;
    
    for city = 1:length(city_data)
        city_x = city_data(city,1);
        city_y = city_data(city,2);
        max_city_size = max_city_size_i;
        if city_data(city,1) ~= 0            
            
            %Catagorise Cities
            
            if city_data(city,3) < 25000  
                type = "small";             
            elseif city_data(city,3) > 25000 && city_data(city,3) < 250000
                type = "medium";
            elseif city_data(city,3) > 250000 && city_data(city,3) < 5000000
                type = "large";
                max_city_size = 200; %Reassign max_city_size and gaussian function is wide!
            elseif city_data(city,3) > 5000000
                type = "london";
                max_city_size = 300;
            end

            pop_dist = pop_dist_function(city_data(city,3),max_city_size, type);
            
            %This section sums the distributions to create an overall
            %pop_dist_function (Solution matrix not function in this case)
            
            for i = 1:10*max_city_size
                for j = 1:10*max_city_size
                    a = city_x-( 10*max_city_size /2 )+i;
                    b = city_y-( 10*max_city_size /2 )+j;
                    if a > 0 && b>0 && a<10000 && b <10000
                        c = pop_distribution_map(a,b) + pop_dist(i,j);
                        pop_distribution_map(a,b) = c; %Add town data to map                
                    end
                end
            end  
        end
    end 
end

function pop_distribution = pop_dist_function(population, max_city_size, type)

    if type == "small"
        rho0 = 40; % max population density approx (Based on Whitehaven)/100 (Due to 100m resolution)
    elseif type == "medium"
        rho0 = 110; % max population density approx(Based on Basingstoke)/100 
    elseif type == "large"
        rho0 = 300; % max population density approx(Based on liverpool)/100 
    elseif type == "london"
        rho0 = 500; %Max Population density approx Density London/100 
    end
     
    r0 = sqrt(population/(2*pi*rho0)); %Based on the volume under surface. See Report. 
    pop_distribution = zeros(10*max_city_size);
    
    for x1 = 0:0.1:max_city_size-0.1
        for x2 = 0:0.1:max_city_size-0.1
            value = gaussian_function(x1,x2,r0,rho0,max_city_size);
            indexx1 = round(10*x1 + 1);
            indexx2 = round(10*x2 + 1);  %matlab seems to be having problems with these being integers
            if value > 0.1 %This removes the tiny values for population that appear (eg 1.2E-250)
                pop_distribution(indexx1,indexx2)= value;
            end
        end
    end
    
    %Run this to check population estimate for each city
    %check_city_population(pop_distribution,max_city_size)   
end

function gauss = gaussian_function(x1, x2, r0,A, max_city_size) %Generate Distribution values
    
    x1_exp = (x1 - max_city_size/2)^2;
    x2_exp = (x2 - max_city_size/2)^2;
    exponent = -((x1_exp+x2_exp)/(2*r0^2));
    
    gauss = A*exp(exponent);
end

%%------ Sanity Check Functions ---------

function check_city_population(pop_dist,max_city_size)
    xt = 0:.1:max_city_size-0.1;
    yt = xt; 

    town_population = trapz(yt,trapz(xt,pop_dist,2))
    
    sum_test_population = 0;
    
    % This is a check to check that element sum is a good approximation for
    % volume under surface.
    
    for i = 1:1000
        for j = 1:1000
            sum_test_population = sum_test_population + pop_dist(i,j)/100;
        end
    end
    
    sum_test_population
    
    xtrial = 0:0.1:max_city_size-0.1;
    surf(xtrial,xtrial, pop_dist)
    shading interp
end
function check_overall_population(pop_dist_map)
    %%-------Model Sanity Check-------
     x = 0:.1:999.9;
     y = 0:.1:999.9;
     total_population = trapz(y,trapz(x,pop_dist_map,2))
     
     est_total_pop = 0;
     
     for i = 0:9999
         for j = 0:9999
             est_total_pop = est_total_pop + pop_dist_map(i+1,j+1)/100;
         end
     end
     
     %As this give the same value as the trapezoid method, we can say that
     %the summation method is a good approximate for total_population
     est_total_pop     
end
    


    





