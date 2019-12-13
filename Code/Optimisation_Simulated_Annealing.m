%------------Simulated Annealing Method---------

% Written by: Oliver Hoare
% Date: 06/12/19
% Project: Optimisation of 'Cell Selection' for the telecoms industry
% Run Time: 13 Seconds

tic
clear all

knapsack_set = csvread('knapsack_set.csv');
cell_data = csvread('cell_data.csv');
Populations=knapsack_set(:,3).';
Cost=knapsack_set(:,2).';

Cost_constraint=500000; %Maximum cost = £1000000
beta=0:.01:1;
n=1500;
[Max_Pop, Chosen_Cells] = Knapsack( Populations, Cost, Cost_constraint, beta, n);
create_output(knapsack_set,Chosen_Cells,cell_data);
Max_Pop
toc

function output_data = create_output(knapsack_set, chosen_cells,cell_data)
    output_data = zeros(size(chosen_cells,1),6);
    
    for q = 1:length(chosen_cells)
        output_data(q,1) = chosen_cells(q);  %Cell ID
        output_data(q,2) = cell_data(chosen_cells(q),2);
        output_data(q,3) = cell_data(chosen_cells(q),3);
        output_data(q,4) = knapsack_set(chosen_cells(q),3);
        output_data(q,5) = cell_data(chosen_cells(q),5);
        if cell_data(chosen_cells(q),4) == 32
            output_data(q,6) = 1;           
        elseif cell_data(chosen_cells(q),4) == 2
            output_data(q,6) = 2;
            
        elseif cell_data(chosen_cells(q),4) == 0.2 
            output_data(q,6) = 3;
            
        end
    end   
    
    csvwrite('Output_data.csv', output_data);
end 

%Simulated Annealing Algorithm written by (Benjamin Misch, 2012)

function [A,B] =  Knapsack( value, weight, TotalWeight, beta, n )
    % Input: value = array of values associated with object i.
    % weight = array of weights associated with object i.
    % TotalWeight = the total weight one can carry in the knapsack.
    % beta = vector of beta values for simulated annealing.
    % n = number of simulations per beta value.
    % Output: FinalValue = maximum value of objects in the knapsack.
    % FinalItems = list of objects carried in the knapsack.
    % Entries in the vector correspond to object i
    % being present in the knapsack.

    v=length(value);
    W=zeros(1,v);
    Value=0;
    VW=0;
    a=length(beta);
    nn=n*ones(1,a);
    for i=1:a
        b=beta(i);
        for j=2:nn(i)
            m=0;
            while m==0
                c=ceil(rand*v);
                if W(c)==0
                m=1;
                end
            end
            TrialW=W;
            TrialW(c)=1;
            while sum(TrialW.*weight)>TotalWeight
                e=0;
                while e==0
                    d=ceil(rand*v);
                    if TrialW(d)==1
                        e=1;
                    end
                end
                TrialW(d)=0;
            end
            f=sum(TrialW.*value)-sum(W.*value);
            g=min([1 exp(b*f)]);
            accept=(rand<=g);
            %Deterministic Model
            %if f>=0
            if accept
                W=TrialW;
                VW(j)=sum(W.*value);
            else
            VW(j)=VW(j-1);
            end
        end
        Value=[Value VW(2:length(VW))];
    end
    FinalValue=Value(length(Value));
    A = FinalValue;
    x=0;
    for k=1:length(W)
        if W(k)==1
        x=[x k];
        end
    end
FinalItems=x(2:length(x));
B = FinalItems;
end