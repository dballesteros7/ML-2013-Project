% Assuming we have training_data and training_label imported.
% First scale the labels by 10e4, that will bring it to a reasonable scale
% of 0 to 10
scaled_training_label = training_label/1e4;

% Now let's scale the vectors to a 0 to 1 scale.
% From the document we know the following ranges
% 1. 2,4,6,8 -> 0.25, 0.5, 0.75, 1
% 2. 32 to 160 (increments of 8) ->  0.2 to 1
% 3. 8 to 80 (increments of 8) -> 0.1 to 1
% 4. 8 to 80 (increments of 8) -> 0.1 to 1
% 5. 40 to 160 (increments of 8) -> 0.25 to 1
% 6. 2 to 16 (increments of 2) -> 0.125 to 1
% 7. 1 to 8 (increments of 1) -> 0.125 to 1
% 8. 1024 to 32768 (powers of 2) -> 0.03125 to 1
% 9. 256 to 1024 (powers of 2) -> 0.25 to 1
% 10. 8, 16, 24, 32 -> 0.25, 0.5, 0.75, 1
% 11. 64 to 1024 (powers of 2) -> 0.0625 to 1
% 12. 64 to 1024 (powers of 2) -> 0.0625 to 1
% 13. 512 to 8192 (powers of 2) -> 0.0625 to 1
% 14. 9 to 36 (increments of 3) -> 3 to 12 (Dividing by 36 leads to
% periodic decimals)
scaled_training_data = training_data;
scaled_training_data(:,1) = scaled_training_data(:,1)/8;
scaled_training_data(:,2) = scaled_training_data(:,2)/160;
scaled_training_data(:,3) = scaled_training_data(:,3)/80;
scaled_training_data(:,4) = scaled_training_data(:,4)/80;
scaled_training_data(:,5) = scaled_training_data(:,5)/160;
scaled_training_data(:,6) = scaled_training_data(:,6)/16;
scaled_training_data(:,7) = scaled_training_data(:,7)/8;
scaled_training_data(:,8) = scaled_training_data(:,8)/32768;
scaled_training_data(:,9) = scaled_training_data(:,9)/1024;
scaled_training_data(:,10) = scaled_training_data(:,10)/32;
scaled_training_data(:,11) = scaled_training_data(:,11)/1024;
scaled_training_data(:,12) = scaled_training_data(:,12)/1024;
scaled_training_data(:,13) = scaled_training_data(:,13)/8192;
scaled_training_data(:,14) = scaled_training_data(:,14)/3;

min_model = 0;
min_cost = 1e12;
k = 10;
c_range = pow2(linspace(-5,5,11));
g_range = pow2(linspace(0,10,11));
cost_matrix = zeros(length(c_range), length(g_range));
for i = 1:length(c_range)
    c = c_range(i);
    for j = 1:length(g_range)
        g = g_range(j);
        value = zeros(k, 1);
        for m = 1:k
            range_low = (m-1)*ceil(length(scaled_training_label)/k) + 1;
            range_high = min(m*ceil(length(scaled_training_label)/k), length(scaled_training_label));
            if m == 1
                model = svmtrain(scaled_training_label(range_high+1:end,:), scaled_training_data(range_high+1:end,:), sprintf('-s 3 -t 2 -c %f -g %f -q', c, g));
            elseif m == k
                model = svmtrain(scaled_training_label(1:range_low - 1,:), scaled_training_data(1:range_low - 1,:), sprintf('-s 3 -t 2 -c %f -g %f -q', c, g));
            else
                model = svmtrain(scaled_training_label([1:range_low-1 range_high+1:end],:), scaled_training_data([1:range_low-1 range_high+1:end],:), sprintf('-s 3 -t 2 -c %f -g %f', c, g));    
            end
            [~,acc,~] = svmpredict(scaled_training_label(range_low:range_high, 1), scaled_training_data(range_low:range_high,:), model);
            value(m) = acc(2)/mean(scaled_training_label);
        end
        if mean(value) < min_cost
           min_model = svmtrain(scaled_training_label, scaled_training_data, sprintf('-s 3 -t 2 -c %f -g %f -q', c, g));
           min_cost = mean(value);
        end
        cost_matrix(i, j) = mean(value);
    end
end
surf(c_range,g_range,cost_matrix);

scaled_validation = validation;
scaled_validation(:,1) = scaled_validation(:,1)/8;
scaled_validation(:,2) = scaled_validation(:,2)/160;
scaled_validation(:,3) = scaled_validation(:,3)/80;
scaled_validation(:,4) = scaled_validation(:,4)/80;
scaled_validation(:,5) = scaled_validation(:,5)/160;
scaled_validation(:,6) = scaled_validation(:,6)/16;
scaled_validation(:,7) = scaled_validation(:,7)/8;
scaled_validation(:,8) = scaled_validation(:,8)/32768;
scaled_validation(:,9) = scaled_validation(:,9)/1024;
scaled_validation(:,10) = scaled_validation(:,10)/32;
scaled_validation(:,11) = scaled_validation(:,11)/1024;
scaled_validation(:,12) = scaled_validation(:,12)/1024;
scaled_validation(:,13) = scaled_validation(:,13)/8192;
scaled_validation(:,14) = scaled_validation(:,14)/3;
[p, ~, ~] = svmpredict(zeros(length(scaled_validation),1),scaled_validation,min_model);
csvwrite('validation_prediction_gaussian_kernel.csv', p*1e4);