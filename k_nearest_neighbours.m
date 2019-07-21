function labels = k_nearest_neighbours(Xtrain,Ytrain,Xtest,K,distfunc)

    % Function to implement the K nearest neighbours algorithm on the given
    % dataset.
    % Usage: labels = k_nearest_neighbours(Xtrain,Ytrain,Xtest,K)
    
    % Xtrain : N x P Matrix of training data, where N is the number of
    %   training examples, and P is the dimensionality (number of features)
    % Ytrain : N x 1 Vector of training labels (0/1)
    % Xtest : M x P Matrix of testing data, where M is the number of
    %   testing examples.
    % K : number of nearest neighbours used to make predictions on the test
    %     dataset. Remember to take care of corner cases.
    % distfunc: distance function to be used - l1, l2, linf.
    % labels : return an M x 1 vector of predicted labels for testing data.
    
   % Establish parameters
   N = size(Xtrain,1);  % Number of training examples
   M = size(Xtest,1);   % Number of testing examples
    
  % Calculate nearest neighbor
  tiled_test = repmat(Xtest,1,1,N);
  tiled_train = permute(repmat(Xtrain,1,1,M),[3 2 1]);
  pre_norm_dist = tiled_test - tiled_train; 
  
   % Parse out distance function
   if strcmp(distfunc,'l1')
       norm_val = sum(abs(pre_norm_dist), 2);
   elseif strcmp(distfunc,'l2')
       norm_val = sqrt(sum(pre_norm_dist.^2, 2));
   elseif strcmp(distfunc,'linf')
       norm_val = max(abs(pre_norm_dist), [], 2);
   else
       error('Invalid distance function specification')
   end
   
  post_norm_dist = reshape(norm_val, [M,N]);
  [NN,index] = sort(post_norm_dist,2);

  nearest = index(:,1:K);
  if K ==1
      labels = Ytrain(nearest);
  else
      replace_vals = [0,1];
      output = mean(Ytrain(nearest),2);
      tie_ID = find(output == 0.5);
      output(tie_ID) = replace_vals(randi(length(replace_vals), size(tie_ID)));
      labels = round(output);
  end 
end