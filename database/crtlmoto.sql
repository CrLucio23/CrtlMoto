DROP DATABASE IF EXISTS crtlMoto;
CREATE DATABASE crtlMoto;
USE crtlMoto;

-- 1. UTENTI E RUOLI
CREATE TABLE Utente (
    id_utente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    cognome VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    telefono VARCHAR(20),
    indirizzo VARCHAR(150),
    citta VARCHAR(50),
    CAP VARCHAR(10),
    ruolo ENUM('cliente', 'admin') NOT NULL DEFAULT 'cliente',
    data_registrazione DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_utente_email UNIQUE (email)
);

-- 2. IL MIO GARAGE (VEICOLI)
CREATE TABLE Veicolo (
    id_veicolo INT AUTO_INCREMENT PRIMARY KEY,
    marca VARCHAR(50) NOT NULL,
    modello VARCHAR(100) NOT NULL,
    anno INT,
    cilindrata VARCHAR(20),
    id_utente INT NOT NULL,
    FOREIGN KEY (id_utente) REFERENCES Utente(id_utente) ON DELETE CASCADE
);

-- 3. CATEGORIE E MARCHE
CREATE TABLE Categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome_categoria VARCHAR(50) NOT NULL,
    descrizione TEXT
);

CREATE TABLE Marca (
    id_marca INT AUTO_INCREMENT PRIMARY KEY,
    nome_marca VARCHAR(50) NOT NULL
);

-- 4. PRODOTTI
CREATE TABLE Prodotto (
    id_prodotto INT AUTO_INCREMENT PRIMARY KEY,
    nome_prodotto VARCHAR(150) NOT NULL,
    descrizione TEXT,
    prezzo_base DECIMAL(10,2) NOT NULL,
    sconto_percentuale INT DEFAULT 0,
    quantita_magazzino INT DEFAULT 0,
    taglia VARCHAR(10),
    colore VARCHAR(30),
    compatibilita TEXT,
    id_categoria INT,
    id_marca INT,
    FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria) ON DELETE SET NULL,
    FOREIGN KEY (id_marca) REFERENCES Marca(id_marca) ON DELETE SET NULL
);

-- 4.1 IMMAGINI PRODOTTO
CREATE TABLE Immagine_Prodotto (
    id_immagine INT AUTO_INCREMENT PRIMARY KEY,
    url_immagine VARCHAR(500) NOT NULL,
    is_principale BOOLEAN DEFAULT FALSE,
    id_prodotto INT NOT NULL,
    FOREIGN KEY (id_prodotto) REFERENCES Prodotto(id_prodotto) ON DELETE CASCADE
);

-- 5. NEWSLETTER
CREATE TABLE Newsletter (
    id_newsletter INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    id_utente INT NULL,
    iscritto BOOLEAN DEFAULT TRUE,
    data_iscrizione DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_utente) REFERENCES Utente(id_utente) ON DELETE SET NULL
);

-- 6. CODICI SCONTO
CREATE TABLE Codice_Sconto (
    id_codice INT AUTO_INCREMENT PRIMARY KEY,
    codice VARCHAR(50) NOT NULL UNIQUE,
    percentuale_sconto INT NOT NULL,
    attivo BOOLEAN DEFAULT TRUE,
    data_creazione DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_scadenza DATETIME NULL,
    utilizzo_massimo INT DEFAULT 1,
    solo_newsletter BOOLEAN DEFAULT FALSE
);

-- 7. CARRELLO
CREATE TABLE Carrello (
    id_carrello INT AUTO_INCREMENT PRIMARY KEY,
    data_aggiornamento DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    id_utente INT NOT NULL UNIQUE,
    FOREIGN KEY (id_utente) REFERENCES Utente(id_utente) ON DELETE CASCADE
);

CREATE TABLE Dettaglio_Carrello (
    id_dettaglio_carrello INT AUTO_INCREMENT PRIMARY KEY,
    quantita INT NOT NULL DEFAULT 1,
    id_carrello INT NOT NULL,
    id_prodotto INT NOT NULL,
    FOREIGN KEY (id_carrello) REFERENCES Carrello(id_carrello) ON DELETE CASCADE,
    FOREIGN KEY (id_prodotto) REFERENCES Prodotto(id_prodotto) ON DELETE CASCADE
);

-- 8. ORDINI
CREATE TABLE Ordine (
    id_ordine INT AUTO_INCREMENT PRIMARY KEY,
    data_ordine DATETIME DEFAULT CURRENT_TIMESTAMP,
    totale_ordine DECIMAL(10,2) NOT NULL,
    stato_ordine ENUM('in_elaborazione', 'spedito', 'consegnato', 'annullato') DEFAULT 'in_elaborazione',
    indirizzo_spedizione VARCHAR(200) NOT NULL,
    id_utente INT NOT NULL,
    id_codice_sconto INT NULL,
    FOREIGN KEY (id_utente) REFERENCES Utente(id_utente) ON DELETE RESTRICT,
    FOREIGN KEY (id_codice_sconto) REFERENCES Codice_Sconto(id_codice) ON DELETE SET NULL
);

CREATE TABLE Dettaglio_Ordine (
    id_dettaglio_ordine INT AUTO_INCREMENT PRIMARY KEY,
    quantita INT NOT NULL,
    prezzo_acquisto DECIMAL(10,2) NOT NULL,
    id_ordine INT NOT NULL,
    id_prodotto INT NULL,
    FOREIGN KEY (id_ordine) REFERENCES Ordine(id_ordine) ON DELETE CASCADE,
    FOREIGN KEY (id_prodotto) REFERENCES Prodotto(id_prodotto) ON DELETE SET NULL
);

-- 9. PAGAMENTI
CREATE TABLE Pagamento (
    id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    metodo_pagamento ENUM('carta', 'paypal', 'bonifico', 'contrassegno') NOT NULL,
    data_pagamento DATETIME DEFAULT CURRENT_TIMESTAMP,
    importo DECIMAL(10,2) NOT NULL,
    stato_pagamento ENUM('in_attesa', 'completato', 'fallito', 'rimborsato') DEFAULT 'in_attesa',
    id_ordine INT NOT NULL UNIQUE,
    FOREIGN KEY (id_ordine) REFERENCES Ordine(id_ordine) ON DELETE CASCADE
);

-- 10. UTILIZZO CODICI SCONTO
CREATE TABLE Utilizzo_Codice_Sconto (
    id_utilizzo INT AUTO_INCREMENT PRIMARY KEY,
    id_codice INT NOT NULL,
    id_utente INT NOT NULL,
    id_ordine INT NULL,
    data_utilizzo DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_codice) REFERENCES Codice_Sconto(id_codice) ON DELETE CASCADE,
    FOREIGN KEY (id_utente) REFERENCES Utente(id_utente) ON DELETE CASCADE,
    FOREIGN KEY (id_ordine) REFERENCES Ordine(id_ordine) ON DELETE SET NULL
);



-- =========================================================
-- 1. CATEGORIE
-- =========================================================
INSERT INTO Categoria (nome_categoria, descrizione) VALUES
('Caschi', 'Caschi integrali, modulari e jet per ogni stile di guida'),
('Giacche', 'Giacche moto in pelle e tessuto per uomo e donna'),
('Guanti', 'Guanti protettivi per guida urbana, touring e sportiva'),
('Freni', 'Pastiglie, dischi e accessori per impianti frenanti'),
('Accessori', 'Accessori utili per comfort, sicurezza e stile'),
('Stivali', 'Stivali e scarpe tecniche da moto'),
('Ricambi', 'Ricambi e componenti per manutenzione e upgrade'),
('Protezioni', 'Paraschiena, protezioni e abbigliamento tecnico');

-- =========================================================
-- 2. MARCHE
-- =========================================================
INSERT INTO Marca (nome_marca) VALUES
('AGV'),
('Shoei'),
('Alpinestars'),
('Dainese'),
('Brembo'),
('Shark'),
('HJC'),
('RST'),
('Givi'),
('LS2'),
('Arai'),
('Sena'),
('Oxford'),
('Bell'),
('Rev''it');

-- =========================================================
-- 3. UTENTI
-- Password hash placeholder SHA-256 di esempio per "password123"
-- Se vuoi, dopo ti preparo anche utenti con hash precisi coerenti col tuo PasswordUtils
-- =========================================================
INSERT INTO Utente (nome, cognome, email, password, telefono, indirizzo, citta, CAP, ruolo) VALUES
('Admin', 'CRTLMOTO', 'admin@crtlmoto.it', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', '3331111111', 'Via Roma 1', 'Salerno', '84121', 'admin'),
('Luciano', 'Cretella', 'lcretella23@gmail.com', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', '3200349829', 'Via Napoli 10', 'Napoli', '80100', 'cliente'),
('Marco', 'Rossi', 'marco.rossi@mail.it', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', '3333333333', 'Via Milano 45', 'Milano', '20100', 'cliente'),
('Giulia', 'Bianchi', 'giulia.bianchi@mail.it', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', '3334444444', 'Via Firenze 18', 'Roma', '00100', 'cliente'),
('Antonio', 'Greco', 'antonio.greco@mail.it', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', '3335555555', 'Corso Italia 99', 'Bari', '70100', 'cliente');

-- =========================================================
-- 4. VEICOLI
-- =========================================================
INSERT INTO Veicolo (marca, modello, anno, cilindrata, id_utente) VALUES
('Yamaha', 'MT-07', 2021, '689cc', 2),
('Honda', 'CB650R', 2020, '649cc', 3),
('Kawasaki', 'Z900', 2022, '948cc', 4),
('Ducati', 'Monster', 2021, '937cc', 5),
('BMW', 'S1000RR', 2019, '999cc', 2);

-- =========================================================
-- 5. NEWSLETTER
-- =========================================================
INSERT INTO Newsletter (email, id_utente, iscritto) VALUES
('luca.esposito@mail.it', 2, TRUE),
('giulia.bianchi@mail.it', 4, TRUE),
('newsletter.demo@mail.it', NULL, TRUE);

-- =========================================================
-- 6. CODICI SCONTO
-- =========================================================
INSERT INTO Codice_Sconto (codice, percentuale_sconto, attivo, data_scadenza, utilizzo_massimo, solo_newsletter) VALUES
('WELCOME10', 10, TRUE, '2027-12-31 23:59:59', 100, FALSE),
('NEWS15', 15, TRUE, '2027-12-31 23:59:59', 200, TRUE),
('FRENI20', 20, TRUE, '2026-12-31 23:59:59', 50, FALSE),
('SUMMER5', 5, TRUE, '2026-09-30 23:59:59', 500, FALSE),
('VIP25', 25, FALSE, '2026-06-30 23:59:59', 10, FALSE);

-- =========================================================
-- 7. PRODOTTI
-- =========================================================
INSERT INTO Prodotto
(nome_prodotto, descrizione, prezzo_base, sconto_percentuale, quantita_magazzino, taglia, colore, compatibilita, id_categoria, id_marca)
VALUES
('Casco AGV K1 S Nero Opaco', 'Casco integrale sportivo con spoiler aerodinamico e ventilazione avanzata', 189.99, 10, 12, 'M', 'Nero Opaco', 'Universale', 1, 1),
('Casco Shoei NXR2 White', 'Casco premium leggero, silenzioso e ideale per guida sport-touring', 499.00, 5, 6, 'L', 'Bianco', 'Universale', 1, 2),
('Giacca Alpinestars T-SP X', 'Giacca tecnica in tessuto con protezioni CE e look sportivo', 229.90, 15, 8, 'L', 'Nero/Rosso', 'Universale', 2, 3),
('Giacca Dainese Racing 4', 'Giacca in pelle dal taglio racing con protezioni certificate', 479.00, 12, 4, 'M', 'Nero', 'Universale', 2, 4),
('Guanti Alpinestars SP-8 V3', 'Guanti in pelle con protezioni nocche e ottimo grip', 109.99, 10, 20, 'M', 'Nero', 'Universale', 3, 3),
('Guanti Dainese Carbon 4', 'Guanti racing con inserti in carbonio e ottima sensibilità', 159.00, 8, 10, 'L', 'Nero/Rosso', 'Universale', 3, 4),
('Pastiglie Freno Brembo Sinterizzate', 'Pastiglie freno ad alte prestazioni per guida sportiva e urbana', 49.90, 20, 30, NULL, NULL, 'Compatibili con Yamaha MT-07, Kawasaki Z900', 4, 5),
('Disco Freno Brembo Serie Oro', 'Disco flottante ad alte prestazioni per impianti stradali sportivi', 199.00, 18, 7, NULL, NULL, 'Compatibile con Honda CB650R', 4, 5),
('Interfono Sena 5S', 'Sistema interfono bluetooth con audio HD e connessione semplice', 139.99, 0, 15, NULL, 'Nero', 'Universale', 5, 12),
('Borsa Serbatoio Givi Tanklock', 'Borsa da serbatoio pratica per touring e uso quotidiano', 119.00, 10, 9, NULL, 'Nero', 'Universale', 5, 9),
('Stivali Alpinestars SMX-6 V2', 'Stivali sportivi protettivi con grande comfort in pista e strada', 279.90, 14, 5, '43', 'Nero', 'Universale', 6, 3),
('Stivali RST Tractech Evo', 'Stivali da moto racing con protezioni avanzate e buon supporto', 199.90, 10, 11, '42', 'Nero/Bianco', 'Universale', 6, 8),
('Leva Freno Regolabile CNC', 'Leva freno in alluminio CNC regolabile e anodizzata', 69.90, 5, 16, NULL, 'Rosso', 'Compatibile con Yamaha MT-07', 7, 13),
('Cupolino Sport Dark Smoke', 'Cupolino fumé per maggiore protezione aerodinamica e stile aggressivo', 89.90, 0, 13, NULL, 'Fumé', 'Compatibile con Kawasaki Z900', 7, 13),
('Paraschiena Dainese Pro-Armor', 'Protezione schiena leggera, flessibile e certificata CE', 149.00, 10, 14, 'L', 'Nero', 'Universale', 8, 4),
('Gilet Airbag Alpinestars Tech-Air 5', 'Sistema airbag indossabile con protezione avanzata per uso stradale', 699.00, 7, 3, 'L', 'Nero', 'Universale', 8, 3),
('Casco Shark Spartan GT', 'Casco integrale touring con visierino interno e grande comfort', 359.90, 9, 6, 'M', 'Grigio', 'Universale', 1, 6),
('Casco HJC RPHA 11', 'Casco sportivo leggero e aggressivo per guida ad alte prestazioni', 399.90, 11, 5, 'L', 'Nero/Rosso', 'Universale', 1, 7),
('Guanti Rev''it Sand 4', 'Guanti touring ventilati ideali per viaggi lunghi e uso estivo', 99.90, 6, 18, 'M', 'Grigio/Nero', 'Universale', 3, 15),
('Supporto Smartphone Oxford Cliqr', 'Supporto manubrio robusto per navigazione sicura in moto', 39.90, 0, 25, NULL, 'Nero', 'Universale', 5, 13);

INSERT INTO Immagine_Prodotto
(url_immagine, is_principale, id_prodotto)
VALUES

-- Prodotto 1: Casco AGV K1 S Nero Opaco
('images/products/agv1.webp', TRUE, 1),
('images/products/agv2.webp', FALSE, 1),

-- Prodotto 2: Casco Shoei NXR2 White
('images/products/shoei.webp', TRUE, 2),

-- Prodotto 3: Giacca Alpinestars T-SP X
('images/products/TSpx.webp', TRUE, 3),
('images/products/TSpx2.webp', FALSE, 3),

-- Prodotto 4: Giacca Dainese Racing 4
('images/products/racing4.webp', TRUE, 4),
('images/products/racing42.webp', FALSE, 4),
('images/products/racing43.webp', FALSE, 4),

-- Prodotto 5: Guanti Alpinestars SP-8 V3
('images/products/Sp8.webp', TRUE, 5),
('images/products/SP82.webp', FALSE, 5),

-- Prodotto 6: Guanti Dainese Carbon 4
('images/products/carbon4.webp', TRUE, 6),

-- Prodotto 7: Pastiglie Freno Brembo Sinterizzate
('images/products/brembo.webp', TRUE, 7),

-- Prodotto 8: Disco Freno Brembo Serie Oro
('images/products/disco.webp', TRUE, 8),

-- Prodotto 9: Interfono Sena 5S
('images/products/5s.webp', TRUE, 9),

-- Prodotto 10: Borsa Serbatoio Givi Tanklock
('images/products/Givi.webp', TRUE, 10),

-- Prodotto 11: Stivali Alpinestars SMX-6 V2
('images/products/StivaliAlpinestar.webp', TRUE, 11),

-- Prodotto 12: Stivali RST Tractech Evo
('images/products/RST.webp', TRUE, 12),
('images/products/RST2.webp', FALSE, 12),

-- Prodotto 13: Leva Freno Regolabile CNC
('images/products/leve.webp', TRUE, 13),

-- Prodotto 14: Cupolino Sport Dark Smoke
('images/products/cupolino.webp', TRUE, 14),

-- Prodotto 15: Paraschiena Dainese Pro-Armor
('images/products/daineseparaschiena.webp', TRUE, 15),

-- Prodotto 16: Gilet Airbag Alpinestars Tech-Air 5
('images/products/airbag.webp', TRUE, 16),
('images/products/airbag2.webp', FALSE, 16),

-- Prodotto 17: Casco Shark Spartan GT
('images/products/shark.webp', TRUE, 17),
('images/products/shark2.webp', FALSE, 17),

-- Prodotto 18: Casco HJC RPHA 11
('images/products/hjc1.webp', TRUE, 18),
('images/products/hjc2.webp', FALSE, 18),

-- Prodotto 19: Guanti Rev''it Sand 4
('images/products/Revit.webp', TRUE, 19),

-- Prodotto 20: Supporto Smartphone Oxford Cliqr
('images/products/supporto.webp', TRUE, 20),
('images/products/supporto2.webp', FALSE, 20);
-- 9. CARRELLI
-- =========================================================
INSERT INTO Carrello (id_utente) VALUES
(2),
(3),
(4),
(5);

-- =========================================================
-- 10. DETTAGLIO CARRELLO
-- =========================================================
INSERT INTO Dettaglio_Carrello (quantita, id_carrello, id_prodotto) VALUES
(1, 1, 1),
(2, 1, 5),
(1, 2, 7),
(1, 2, 10),
(1, 3, 15),
(1, 4, 20);

-- =========================================================
-- 11. ORDINI
-- =========================================================
INSERT INTO Ordine (data_ordine, totale_ordine, stato_ordine, indirizzo_spedizione, id_utente, id_codice_sconto) VALUES
('2026-03-10 10:15:00', 269.88, 'consegnato', 'Via Napoli 10, Napoli', 2, 1),
('2026-03-12 16:40:00', 159.20, 'spedito', 'Via Milano 45, Milano', 3, 2),
('2026-03-14 12:30:00', 699.00, 'in_elaborazione', 'Via Firenze 18, Roma', 4, NULL),
('2026-03-16 18:20:00', 239.90, 'annullato', 'Corso Italia 99, Bari', 5, 4);

-- =========================================================
-- 12. DETTAGLIO ORDINE
-- =========================================================
INSERT INTO Dettaglio_Ordine (quantita, prezzo_acquisto, id_ordine, id_prodotto) VALUES
(1, 170.99, 1, 1),
(1, 98.99, 1, 5),

(1, 119.20, 2, 10),
(1, 40.00, 2, 20),

(1, 699.00, 3, 16),

(1, 239.90, 4, 12);

-- =========================================================
-- 13. PAGAMENTI
-- =========================================================
INSERT INTO Pagamento (metodo_pagamento, data_pagamento, importo, stato_pagamento, id_ordine) VALUES
('carta', '2026-03-10 10:20:00', 269.88, 'completato', 1),
('paypal', '2026-03-12 16:45:00', 159.20, 'completato', 2),
('bonifico', '2026-03-14 12:35:00', 699.00, 'in_attesa', 3),
('contrassegno', '2026-03-16 18:25:00', 239.90, 'fallito', 4);

-- =========================================================
-- 14. UTILIZZO CODICI SCONTO
-- =========================================================
INSERT INTO Utilizzo_Codice_Sconto (id_codice, id_utente, id_ordine, data_utilizzo) VALUES
(1, 2, 1, '2026-03-10 10:16:00'),
(2, 3, 2, '2026-03-12 16:41:00'),
(4, 5, 4, '2026-03-16 18:21:00');