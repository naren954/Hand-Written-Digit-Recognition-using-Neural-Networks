function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)

Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

m = size(X, 1);
         

J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));
X=[ones(m,1) X];
for i=1:m
    a2=sigmoid(Theta1*X(i,:)');
    a2 = [1;a2];
    a3=sigmoid(Theta2*a2);
    v=zeros(num_labels,1);
    v(y(i))=1;
    s=sum((-v.*log(a3))-((1-v).*log(1-a3)));
    J=J+s;
end
J=J/m;
s1=sum(sum(Theta1(:,2:end).^2));
s2=sum(sum(Theta2(:,2:end).^2));
temp=((lambda)/(2*m))*(s1+s2);
J=J+temp;
D1=zeros(size(Theta1));
D2=zeros(size(Theta2));
for i=1:m
    a1=X(i,:)';
    z2=Theta1*a1;
    a2=sigmoid(z2);
    a2=[1;a2];
    z3=Theta2*a2;
    a3=sigmoid(z3);
    v=zeros(num_labels,1);
    v(y(i))=1;
    d3=a3-v;
    d2=(Theta2'*d3).*a2.*(1-a2);
    d2=d2(2:end);
    D2=D2+d3*a2';
    D1=D1+d2*a1';
end
D2=D2/m;
D1=D1/m;
Theta1_grad=D1;
Theta2_grad=D2;
Theta1_grad(:,2:end)=D1(:,2:end)+(lambda/m)*Theta1(:,2:end);
Theta2_grad(:,2:end)=D2(:,2:end)+(lambda/m)*Theta2(:,2:end);




















% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
