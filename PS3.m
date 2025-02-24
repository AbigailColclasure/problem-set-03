load satl.dat

lat = satl(:,1);
long = satl(:,2);
depth = satl(:,3);
temp = satl(:,4);
salinity = satl(:,5);
O2 = satl(:,6);
PO4 = satl(:,7);
NO3 = satl(:,8);
NO2 = satl(:,9);
SiO2 = satl(:,10);
 

%Part A

Xupp = satl(satl(:,3)<=1000, 4:10);
Xlwr = satl(satl(:,3)>1000,4:10);
depth_Xupp = satl(satl(:,3) <= 1000, 3);
depth_Xlwr = satl(satl(:,3) > 1000, 3);

temp_Xupp = Xupp(:,1);
salinity_Xupp = Xupp(:,2);
O2_Xupp = Xupp(:,3);
NO3_Xupp = Xupp(:,4);

temp_Xlwr = Xlwr(:,1);
salinity_Xlwr = Xlwr(:,2);
O2_Xlwr = Xlwr(:,3);
NO3_Xlwr = Xlwr(:,4);

length(depth_Xupp)
length(temp_Xlwr)


figure;
subplot(2,2,1);
plot(depth, temp, ".");
xlabel("Depth")
ylabel("Temperature")

subplot(2,2,2)
plot(depth, salinity, ".");
xlabel("Depth")
ylabel("Salinity")

subplot(2,2,3)
plot(depth, O2, ".");
xlabel("Depth")
ylabel("O2")

subplot(2,2,4)
plot(depth, NO3, ".");
xlabel("Depth")
ylabel("NO3")


figure;
subplot(2,2,1);
plot(depth_Xupp, temp_Xupp, ".");
xlabel("Depth Upper")
ylabel("Temperature")

subplot(2,2,2)
plot(depth_Xupp, salinity_Xupp, ".");
xlabel("Depth Upper")
ylabel("Salinity")

subplot(2,2,3)
plot(depth_Xupp, O2_Xupp, ".");
xlabel("Depth Upper")
ylabel("O2")

subplot(2,2,4)
plot(depth_Xupp, NO3_Xupp, ".");
xlabel("Depth Upper")
ylabel("NO3")



figure;
subplot(2,2,1);
plot(depth_Xlwr, temp_Xlwr, ".");
xlabel("Depth Lower")
ylabel("Temperature")

subplot(2,2,2)
plot(depth_Xlwr, salinity_Xlwr, ".");
xlabel("Depth Lower")
ylabel("Salinity")

subplot(2,2,3)
plot(depth_Xlwr, O2_Xlwr, ".");
xlabel("Depth Lower")
ylabel("O2")

subplot(2,2,4)
plot(depth_Xlwr, NO3_Xlwr, ".");
xlabel("Depth Lower")
ylabel("NO3")

%Discuss why we remove the variables longitude, latitude and depth:
%The point of PCA is to identify where variance in the data set is coming
%from. Longitude, latitude, and depth describe where the data are collected
%but they are not themselves the quantities that we are interested in
%measuring. Knowing that there is a large variance in depth, for example,
%just tells us that we made measurements at a large range of depths but
%that doesn't give us much insight into what we are actually trying to
%understand. Similarly, knowing that there is a large variance in latitude
%and longitude just tells us we sampled from locations spread out on Earth
%but that doesn't give insight into how temperature, salinity, and the
%different species are related. 


%Discuss data standardization:
%In this case, we do need to standardize the data. For one thing, not all
%of the columns are in the same units. When the colums are in different
%units it is difficult to fairly compare how much the variables are
%changing. For example, in an extreme case we might have a column that ranges in 
% value from 1 to 100,000 and another column that ranges in values from
% 0.001 to 0.002. In our PCA the data that ranges from 1 to 100,000 will
% dominate because its variance is larger. On the other hand, the smaller 
% range from 0.001 to 0.002 doesn't necessecarily mean that that data is
% less important and this factor of 2 change might actually represent a
% really significant change for that variable even though it is numerically
% smaller. 

[Xupp_standardized, Xupp_colmeans, Xupp_colstds] = colstd(Xupp);
[Xlwr_standardized, Xlwr_colmeans, Xlwr_colstds] = colstd(Xlwr);

%Part b

[Xupp_U, Xupp_sumry, Xupp_AR, Xupp_SR] = pca2(Xupp_standardized, 0);
[Xlwr_U, Xlwr_sumry, Xlwr_AR, Xlwr_SR] = pca2(Xlwr_standardized, 0);

Xupp_eigenvectors = Xupp_U
Xupp_eigenvalues = Xupp_sumry(:,1)
Xupp_factor_matrix = Xupp_AR
Xupp_factor_scores = Xupp_SR;

Xlwr_eigenvectors = Xlwr_U
Xlwr_eigenvalues = Xlwr_sumry(:,1)
Xlwr_factor_matrix = Xlwr_AR
Xlwr_factor_scores = Xlwr_SR;


%Part c
Xupp_communalities = sum(Xupp_factor_matrix.^2, 2);
Xlwr_communalities = sum(Xlwr_factor_matrix.^2, 2);

%The communalities of Xupp and Xlwr both give a vector of ones
%According to the lecture slides, communalities measure how well the
%retined factors capture the total variance compared to the original
%variance. 
%I get that all of the communalities are 1 meaning that the captured 
%variance is the same as the original variance. This means that we can 
%account for all of the variance in the data when we include all of the 
% components. This is true just by definition. 


%Part d

Xupp_indicies = 1:length(Xupp_communalities);
Xlwr_indicies = 1:length(Xlwr_communalities);

figure;
plot(Xupp_indicies, Xupp_eigenvalues/sum(Xupp_eigenvalues));
title("Upper Scree Plot")
xlabel("Component Number")
ylabel("Eigenvalue")

figure;
plot(Xlwr_indicies, Xlwr_eigenvalues/sum(Xlwr_eigenvalues))
title("Lower Scree Plot")
xlabel("Component Number")
ylabel("Eigenvalue")


Xupp_num_factors = 4;
Xupp_percent_variance = sum(Xupp_eigenvalues(1:Xupp_num_factors))/sum(Xupp_eigenvalues)
Xupp_selected_factors_communalities = sum(Xupp_factor_matrix(:,1:Xupp_num_factors).^2, 2);

Xlwr_num_factors = 3;
Xlwr_percent_variance = sum(Xlwr_eigenvalues(1:Xlwr_num_factors))/sum(Xlwr_eigenvalues)
Xlwr_selected_factors_communalities = sum(Xlwr_factor_matrix(:,1:Xlwr_num_factors).^2, 2);

%I chose 4 components for the upper depths and 3 componenets of the lower
%depths. These numbers of components are the minimum required to account
%for at least 95% of the variance. For the upper depths this accounts for
%98.25% of the variance and 96.19% for the lower depths.

%For the upper depths this results in communalities for each factor of: 

%0.968144991727520
%0.957867988333681
%0.989210034425705
%0.985034823028044
%0.985493733924312
%0.999996204119851
%0.992065425270049

%For the lower depths we get:
%0.993997312968345
%0.850936589509047
%0.921228283780362
%0.992869105927473
%0.994668537757537
%0.999993908129744
%0.979634993525582

%All of the communality values are close to 1 which indicates that we can
%explain most of the variance of each variable. By far, the communality
%that is farthest away from 1 is 0.85 which corresponds to the lower
%depths. This implies that this component accounts for more of the variance
%than the other components.