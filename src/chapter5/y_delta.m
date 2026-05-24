function y_delta1 = y_delta(l_toroid,x_shock,delta)

%this function is used to help find the intersection points in the first
%ray after the shock wave

y_delta1 = ((l_toroid/2)-x_shock)*tan(delta);

end
