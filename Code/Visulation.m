%-------------Visualisation of Data-----------------


% Written by: Oliver Hoare
% Date: 07/12/19
% Project: Optimisation of 'Cell Selection' for the telecoms industry


clear all
pop_dens_map = csvread('Population_density_map_uk.csv');
cell_data = csvread('cell_data.csv');
selected_cells = csvread('Output_data.csv');
pop_den_hm(pop_dens_map)  %These functions can be commented out to produce the different visualisations seen in the report. 
%cell_map(cell_data)
selected_cell_map(selected_cells)


function pop_den_hm(pop_dens_map)
    vis_map = zeros(1000);
    for w= 1:1000
        for x = 1:1000
            vis_map(w,x) =pop_dens_map(10*w,10*x);
        end
    end   
    
    figure
    imagesc(vis_map)
    title('Selected Cells')
    xlabel('Distance_X / km')
    ylabel('Distance_Y / km')
    colormap('gray') %To Produce the figure in standard colour comment out this line
    colorbar
    set(gca,'YDir','normal')
    hold on
end

function cell_map(cell_data)
    hold on
    for i = 1:size(cell_data,1)
        add_antenna_circle(cell_data(i,2),cell_data(i,3),cell_data(i,4),'r');
    end
    hold off
end

function antenna_circle = add_antenna_circle(x,y,r,colour)
    %This function add the cells circle to the map.
    th = 0:pi/50:2*pi;  
    xunit = r * cos(th) + x;
    yunit = r * sin(th) + y;
    antenna_circle = plot(xunit, yunit,colour);
    xlim([0 1000])
    ylim([0 1000])
    hold on
end

function selected_cell_map(selected_cells)
    for i = 1:size(selected_cells,1)
        if selected_cells(i,6) == 1
            add_antenna_circle(selected_cells(i,3),selected_cells(i,2),32,'g'); 
        elseif selected_cells(i,6) == 2
            add_antenna_circle(selected_cells(i,3),selected_cells(i,2),2,'g');
        elseif selected_cells(i,6) == 3
            add_antenna_circle(selected_cells(i,3),selected_cells(i,2),0.2,'g');
        end        
    end
end


