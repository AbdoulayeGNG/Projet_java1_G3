CREATE DATABASE gestion_pharmacie;
USE gestion_pharmacie;

-- Table des catégories de médicaments
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL UNIQUE
);

-- Table des fournisseurs
CREATE TABLE fournisseurs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    contact VARCHAR(100) NOT NULL,
    adresse TEXT
);

-- Table des médicaments
CREATE TABLE medicaments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    description TEXT,
    categorie_id INT,
    prix_vente DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    date_expiration DATE NOT NULL,
    fournisseur_id INT,
    FOREIGN KEY (categorie_id) REFERENCES categories(id) ON DELETE SET NULL,
    FOREIGN KEY (fournisseur_id) REFERENCES fournisseurs(id) ON DELETE SET NULL
);

-- Table des clients
CREATE TABLE clients (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    contact VARCHAR(100) UNIQUE
);

-- Table des commandes fournisseurs
CREATE TABLE commandes_fournisseurs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fournisseur_id INT NOT NULL,
    date_commande DATETIME DEFAULT CURRENT_TIMESTAMP,
    statut ENUM('En attente', 'Livrée', 'Annulée') DEFAULT 'En attente',
    FOREIGN KEY (fournisseur_id) REFERENCES fournisseurs(id) ON DELETE CASCADE
);

-- Détails des commandes fournisseurs (quantité et prix d'achat des médicaments)
CREATE TABLE details_commande_fournisseur (
    id INT AUTO_INCREMENT PRIMARY KEY,
    commande_id INT NOT NULL,
    medicament_id INT NOT NULL,
    quantite INT NOT NULL CHECK (quantite > 0),
    prix_achat DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (commande_id) REFERENCES commandes_fournisseurs(id) ON DELETE CASCADE,
    FOREIGN KEY (medicament_id) REFERENCES medicaments(id) ON DELETE CASCADE
);

-- Table des ventes
CREATE TABLE ventes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT NULL, -- Un client peut être enregistré ou non
    date_vente DATETIME DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE SET NULL
);

-- Détails des ventes (quantité et prix unitaire des médicaments vendus)
CREATE TABLE details_ventes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    vente_id INT NOT NULL,
    medicament_id INT NOT NULL,
    quantite INT NOT NULL CHECK (quantite > 0),
    prix_unitaire DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (vente_id) REFERENCES ventes(id) ON DELETE CASCADE,
    FOREIGN KEY (medicament_id) REFERENCES medicaments(id) ON DELETE CASCADE
);

-- Table des utilisateurs (Pharmaciens, Admins, Caissiers)
CREATE TABLE utilisateurs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    mot_de_passe VARCHAR(255) NOT NULL,
    role ENUM('Admin', 'Pharmacien', 'Caissier') NOT NULL DEFAULT 'Pharmacien'
);

-- Création d'index pour améliorer les performances des recherches
CREATE INDEX idx_medicament_nom ON medicaments(nom);
CREATE INDEX idx_client_nom ON clients(nom);
CREATE INDEX idx_vente_date ON ventes(date_vente);
CREATE INDEX idx_commande_date ON commandes_fournisseurs(date_commande);

