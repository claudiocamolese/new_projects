function [x, lambda] = inverse_power_method(A)
% INVERSE_POWER_METHOD Trova il più piccolo autovalore e il corrispondente autovettore
% di una matrice A usando il metodo della potenza inversa.

    % Parametri per la convergenza
    tol = 1e-6; % Tolleranza
    maxIter = 10000; % Numero massimo di iterazioni
    
    % Shift dinamico (opzionale, se necessario)
  mu =0;

%     if ~issparse(A)
%         error('La matrice di input deve essere sparsa.');
%     end

    n = size(A, 1);
    x = ones(n, 1); % Vettore iniziale casuale
    x = x / norm(x); % Normalizzazione
    lambda = 0; % Autovalore iniziale
    I = speye(n); % Matrice identità sparsa
    B = A - mu * I; % Matrice shiftata

    for iter = 1:maxIter 
        % Risolvi il sistema lineare
        y = B \ x;

        % Normalizza il nuovo vettore
        eigvec = y / norm(y);

        % Calcola l'autovalore
        eigval = eigvec' * A * eigvec;

        % Controlla la convergenza
        if abs(eigval - lambda) < tol
            break;
        end

        % Aggiorna i valori per l'iterazione successiva
        lambda = eigval;
        x = eigvec;
    end

    if iter == maxIter
        warning('Numero massimo ti iterazioni raggiunto');
    end
end
