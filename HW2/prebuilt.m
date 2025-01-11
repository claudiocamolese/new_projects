clc
close all
clear all


% Carica i dati
load('Spiral.mat');
k=[10,20,40];
labels = spectralcluster(X, 3, "SimilarityGraph","knn");
    
    % Visualizza i risultati
    figure;
    scatter(X(:, 1), X(:, 2), 50, labels, 'filled');
    title(['Spectral Clustering']);
    xlabel('x');
    ylabel('y');
    axis equal;