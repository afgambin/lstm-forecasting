%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Clusters DBSCAN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('internet_traffic_five_k.mat')     % loading pre-saved cluster data
k= size(internet_traffic_five_k,1);     % number of clusters

samples_per_hour = 6;
cluster_24_samples = zeros(24,k);
index = 1;

for j=1:samples_per_hour:length(internet_traffic_five_k)
    data_hour = internet_traffic_five_k(:,j:(j+samples_per_hour-1));
    cluster_24_samples(index,:) = mean(data_hour,2);
    index = index + 1;
end

figure, plot(cluster_24_samples(:,1))
hold on
plot(cluster_24_samples(:,2))
hold on
plot(cluster_24_samples(:,3))
hold on
plot(cluster_24_samples(:,4))
hold on
plot(cluster_24_samples(:,5))
title('Traffic patterns from DBSCAN clustering')
ylabel('Normalized traffic load')
xlabel('Time (hours)')
legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4','Cluster 5')
grid on
axis tight

%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Clusters XMEANS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('traffic_clusters_xmeans.mat')     % loading pre-saved cluster data
k= 5;     % number of clusters

figure, plot(cluster_5_xmeans_internet(:,1))
hold on
plot(cluster_5_xmeans_internet(:,2))
hold on
plot(cluster_5_xmeans_internet(:,3))
hold on
plot(cluster_5_xmeans_internet(:,4))
hold on
plot(cluster_5_xmeans_internet(:,5))
title('Traffic patterns from XMEANS clustering')
ylabel('Normalized traffic load')
xlabel('Time (hours)')
legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4','Cluster 5')
grid on
axis tight




