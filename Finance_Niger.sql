-- DDL (Data Definition Language) - Création des tables
-- Table des BANQUES
create table Banque (
    banque_id INT primary key,
    nom_banque VARCHAR(100) not null,
    ville_siege VARCHAR(50) not null,
    code_bic VARCHAR(15) unique not null
-- Fictif, mais basé sur le format international
);
-- Table des CLIENTS
create table Client (
    client_id INT primary key,
    nom VARCHAR(50) not null,
    prenom VARCHAR(50) not null,
    nin_fictif VARCHAR(15) unique not null,
-- Numéro d'Identification National Fictif
adresse VARCHAR(100),
    ville_residence VARCHAR(50) not null,
    telephone VARCHAR(15) unique,
    date_creation DATE not null
);
-- Table des COMPTES
create table Compte (
    compte_id INT primary key,
    client_id INT not null,
    banque_id INT not null,
    numero_compte VARCHAR(20) unique not null,
-- Format RIB/numéro de compte
type_compte VARCHAR(50) not null,
-- Ex: "Courant", "Épargne"
solde DECIMAL(18, 2) not null default 0.00,
    date_ouverture DATE not null,
    statut VARCHAR(20) not null,
-- Ex: "Actif", "Fermé"
    foreign key (client_id) references Client(client_id),
    foreign key (banque_id) references Banque(banque_id),
-- Contrainte pour s'assurer que le solde est toujours positif pour l'épargne (exemple)
    check (solde >= 0.00
or type_compte != 'Épargne') 
);
-- Table des TRANSACTIONS
create table transaction (
    transaction_id INT primary key,
    compte_id INT not null,
    date_transaction DATETIME not null,
    type_transaction VARCHAR(20) not null,
-- Ex: "Dépôt", "Retrait", "Virement"
montant DECIMAL(18, 2) not null,
    devise VARCHAR(5) not null default 'FCFA',
    description VARCHAR(255),
    foreign key (compte_id) references Compte(compte_id),
-- Contrainte pour s'assurer que le montant est positif
    check (montant > 0.00)
);
-- Index pour accélérer les recherches fréquentes
create index idx_client_nin on
Client (nin_fictif);

create index idx_compte_numero on
Compte (numero_compte);

create index idx_transaction_date on
transaction (date_transaction);

