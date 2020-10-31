function [A] = rand_lp(d)
	B = magic(d);

	A = [B, eye(d), randi([0, 50], d,1); -randi([0, 50], 1, d), zeros(1,d+1)];
end
