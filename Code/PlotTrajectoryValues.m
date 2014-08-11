testtraj = [];
for i=1:21
traj = win.Trajectories(11,15);
trajinds = traj.Indices(i,:);
testtraj = [testtraj sub2ind([21 21], trajinds(1), trajinds(2))];
end

trajplot = [];
for j=1:21
	frame = win.Video(:,:,j);
	trajplot = [trajplot frame(testtraj(j))];
end

figure;plot(trajplot);