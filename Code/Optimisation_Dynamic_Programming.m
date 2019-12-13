%------------Dynamic Programming Method---------

% Written by: Oliver Hoare
% Date: 06/12/19
% Project: Optimisation of 'Cell Selection' for the telecoms industry
% Run Time: 0.5 Seconds

tic
clear all
knapsack_set = csvread('knapsack_set.csv');
cell_data = csvread('cell_data.csv');
Populations=knapsack_set(:,3).';
Cost=knapsack_set(:,2).' /100; %Divided by 100 to reduce size of array in ALgorithm
Cost_constraint = 5000; %Artifical Cost Constraint. divided by 100 to reduce array size during algorithm
[population_accessed ,  selection_set] = knapsack(Cost, Populations, Cost_constraint);
population_accessed
selected_cells = cell_id(selection_set,knapsack_set);
toc
function selected_cells = cell_id(selection_set, knapsack_set)
    selected_cells = zeros(nnz(selection_set),1);
    count = 0;
    for i = 1:length(selection_set)
        if selection_set(i) == 1
            count = count + 1;
            selected_cells(count,1) = knapsack_set(i,1);
        end 
    end
end



%%This function has been written by Petter Strandmark, and is an example of
%%Dynamic Programming as a solution to the Knapsack Problem. I claim no
%%ownership over this function. 
%   Copyright 2009 Petter Strandmark
%   <a href="mailto:petter.strandmark@gmail.com">petter.strandmark@gmail.com</a>
function [best, amount] = knapsack(weights, values, W)
    if ~all(is_positive_integer(weights)) || ...
       ~is_positive_integer(W)
        error('Weights must be positive integers');
    end
    %We work in one dimension
    [M , N] = size(weights);
    weights = weights(:);
    values = values(:);
    if numel(weights) ~= numel(values)
        error('The size of weights must match the size of values');
    end
    if numel(W) > 1
        error('Only one constraint allowed');
    end  
    
    % Solve the problem
    
    % Note that A would ideally be indexed from A(0..N,0..W) but MATLAB 
    % does not allow this.
    A = zeros(length(weights)+1,W+1);
    % A(j+1,Y+1) means the value of the best knapsack with capacity Y using
    % the first j items.
    for j = 1:length(weights)
        for Y = 1:W
            if weights(j) > Y
                A(j+1,Y+1) = A(j,Y+1);
            else
                A(j+1,Y+1) = ...
                    max( A(j,Y+1), values(j) + A(j,Y-weights(j)+1));
            end
        end
    end
   best = A(end,end);
   
   %Now backtrack 
   amount = zeros(length(weights),1);
   a = best;
   j = length(weights); 
   Y = W;
   while a > 0
       while A(j+1,Y+1) == a
           j = j - 1;
       end
       j = j + 1; %This item has to be in the knapsack
       amount(j) = 1;
       Y = Y - weights(j);
       j = j - 1;
       a = A(j+1,Y+1);
   end
    
    amount = reshape(amount,M,N);
end
function yn = is_positive_integer(X)
    yn = X>0 & floor(X)==X;
end