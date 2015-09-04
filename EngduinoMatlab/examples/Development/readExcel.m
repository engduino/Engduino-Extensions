num = xlsread('testData.xlsx');

time = 1;
previous_velocity =0;
total_displacement =0;
current_velocity=0;


for i= 1:size(num)

acceleration = num(i);    
current_velocity = previous_velocity + acceleration*time;   
displacement = previous_velocity*time + 0.5*acceleration*time*time; 

total_displacement = total_displacement + displacement;    
disp(total_displacement);

previous_velocity = current_velocity;
end

disp(total_displacement);