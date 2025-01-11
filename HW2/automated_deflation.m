function [eigenvalues, eigenvectors] = automated_deflation(A)
    % AUTOMATED_DEFLATION: Calcola autovalori e autovettori di una matrice simmetrica
    % INPUT:
    %   A - Matrice simmetrica nxn
    % OUTPUT:
    %   eigenvalues  - Vettore degli autovalori
    %   eigenvectors - Matrice degli autovettori (colonne)
    
    n = size(A, 1); % Dimensione della matrice
    eigenvalues = zeros(n, 1); % Preallocazione autovalori
    eigenvectors = zeros(n, n); % Preallocazione autovettori
    P = eye(n); % Matrice di proiezione iniziale
    
    for k = 1:n
        % Metodo delle potenze inverse per il k-esimo autovalore e autovettore
        [v_bar, lambda] = inverse_power_method(A);
        eigenvalues(k) = lambda;
        
        % Calcola i coefficienti di proiezione
        if k > 1
            coeffs = zeros(k-1, 1);
            for j = 1:(k-1)
                coeffs(j) = -((eigenvectors(:, j)' * v_bar) / (eigenvalues(j) - lambda));
            end
            % Ricostruzione dell'autovettore nello spazio originale
            v = P * [coeffs; v_bar];
        else
            v = v_bar; % Primo autovettore non ha bisogno di coeff
        end
        eigenvectors(:, k) = v; % Salva l'autovettore
        
        % Deflation: Proietta la matrice nello spazio ortogonale
        I = eye(size(A, 1));
        e = zeros(size(A, 1), 1);
        e(1) = 1;
        Pk = I - 2 * ((v_bar + e) * (v_bar + e)') / norm(v_bar + e)^2;
        P = P * blkdiag(eye(k-1), Pk); % Aggiorna la matrice di proiezione
        A = Pk * A * Pk; % Aggiorna la matrice proiettata
        A = A(k+1:end, k+1:end); % Rimuovi la dimensione proiettata
    end
end