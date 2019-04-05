function a3 = predict(Theta1, Theta2, dat)


plotx=[0 1 2 3 4 5 6 7 8 9]';
a2=sigmoid(Theta1*dat');
a2 = [1;a2];
a3=sigmoid(Theta2*a2);
[dummy, p] = max(a3, [], 1);



% =========================================================================


end
