%% Plane Projection

a = rand(30,3);
%Movement is along the z axis in this case
p1 = a(1,:);
p2 = a(2,:);

%Take the cross product to get a normal vector, take another to get the
%plane definition
n = cross(p2-p1, [0, 0, 1]);
pn = cross(n, p2-p1);
%Normalize the plane normal vector
pn = pn/(pn*pn')^(1/2);

%Project all the points onto this plane
a_prime = a - repmat(((a-repmat(p1, size(a,1), 1))*pn'), 1, 3).*repmat(pn, size(a,1),1);

%Plot the unproject and then projected points
figure
hold on
scatter3(a(:,1), a(:,2), a(:,3),'.g');
scatter3(a_prime(:,1), a_prime(:,2), a_prime(:,3),'.r');