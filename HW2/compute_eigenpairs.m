function [eigenvectors, eigenvalues] = compute_eigenpairs(A, num_eigenvalues)
    % Controllo se la matrice è quadrata
    [n, m] = size(A);
    if n ~= m
        error('La matrice A deve essere quadrata.');
    end

    % Preallocazione
    eigenvectors = zeros(n, num_eigenvalues);
    eigenvalues = zeros(num_eigenvalues, 1);
    A_copy = A;

    for i = 1:num_eigenvalues
        % Trova il più piccolo autovalore e autovettore
        [v, lambda] = inverse_power_method(A_copy);

        % Verifica ortogonalità
        for j = 1:i-1
            v = v - (eigenvectors(:, j)' * v) * eigenvectors(:, j);
        end
        v = v / norm(v);

        % Salva i risultati
        eigenvectors(:, i) = v;
        eigenvalues(i) = lambda;

        % Deflazione con tolleranza numerica
        A_copy = A_copy - sparse(lambda * (v * v'));
        A_copy(abs(A_copy) < 1e-8) = 0; % Elimina valori numericamente trascurabili
    end
end