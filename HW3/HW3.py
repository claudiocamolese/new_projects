import numpy as np
import matplotlib.pyplot as plt
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import pairwise_distances
import cv2
import os

# 1. Caricamento delle immagini
def load_images(folder, image_size=(64, 64)):
    images = []
    labels = []
    for label, subfolder in enumerate(os.listdir(folder)):
        subfolder_path = os.path.join(folder, subfolder)
        if os.path.isdir(subfolder_path):
            for filename in os.listdir(subfolder_path):
                img_path = os.path.join(subfolder_path, filename)
                img = cv2.imread(img_path, cv2.IMREAD_GRAYSCALE)
                if img is not None:
                    img_resized = cv2.resize(img, image_size).flatten()
                    images.append(img_resized)
                    labels.append(label)
    return np.array(images), np.array(labels)

# 2. Decomposizione SVD
def compute_svd(data, num_components):
    mean_image = np.mean(data, axis=0)
    centered_data = data - mean_image
    U, S, Vt = np.linalg.svd(centered_data, full_matrices=False)
    U_reduced = U[:, :num_components]
    return mean_image, U_reduced, S[:num_components], Vt[:num_components]

# 3. Proiezione nello spazio ridotto
def project_data(data, mean_image, eigenfaces):
    centered_data = data - mean_image
    projections = np.dot(centered_data, eigenfaces.T)
    return projections

# 4. Predizione
def predict(test_projection, train_projections, train_labels):
    distances = pairwise_distances(test_projection, train_projections, metric='euclidean')
    return train_labels[np.argmin(distances, axis=1)]

# 5. Visualizzazione delle Eigenfaces
def plot_eigenfaces(eigenfaces, image_size, num_faces=10):
    plt.figure(figsize=(15, 5))
    for i in range(num_faces):
        plt.subplot(1, num_faces, i + 1)
        plt.imshow(eigenfaces[i].reshape(image_size), cmap='gray')
        plt.axis('off')
    plt.show()

# Caricamento dati
data_folder = "path_to_dataset"  # Cambia con il percorso del dataset
images, labels = load_images(data_folder)

# Parametri
num_components = 20
image_size = (64, 64)

# Calcolo della SVD
mean_image, eigenfaces, _, _ = compute_svd(images, num_components)

# Proiezione delle immagini di addestramento
train_projections = project_data(images, mean_image, eigenfaces)

# Visualizzazione delle Eigenfaces
plot_eigenfaces(eigenfaces, image_size)

# Test su una nuova immagine
test_image = images[0]  # Usa una nuova immagine o prendi un'immagine dai dati
test_projection = project_data(test_image.reshape(1, -1), mean_image, eigenfaces)

# Predizione
predicted_label = predict(test_projection, train_projections, labels)
print(f"Etichetta predetta: {predicted_label[0]}")
