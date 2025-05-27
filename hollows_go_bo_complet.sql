-- Crear la base de dades
CREATE DATABASE hollowsgo;
USE hollowsgo;

-- Taula: ARMES
CREATE TABLE ARMES (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    categoria TINYINT NOT NULL,
    buff_atac INT
);

-- Taula: ATACS
CREATE TABLE ATACS (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255),
    mal INT
);

-- Taula: AVATARS
CREATE TABLE AVATARS (
    id INT AUTO_INCREMENT PRIMARY KEY,
    url TEXT NOT NULL,
    nom TEXT
);

-- Taula: BIBLIOTECA
CREATE TABLE BIBLIOTECA (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    personatge_id INT NOT NULL,
    data_obtencio DATETIME,
    skin_ids TEXT
);

-- Taula: ENEMICS
CREATE TABLE ENEMICS (
    id INT AUTO_INCREMENT PRIMARY KEY,
    personatge_id INT NOT NULL,
    punts_donats INT,
    musica_combat VARCHAR(255)
);

-- Taula: HABILITAT_LLEGENDARIA
CREATE TABLE HABILITAT_LLEGENDARIA (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    descripcio TEXT NOT NULL,
    video VARCHAR(255) NOT NULL,
    musica_combat VARCHAR(255) NOT NULL,
    skin_personatge INT NOT NULL
);

-- Taula: MISSIONS
CREATE TABLE MISSIONS (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom_missio VARCHAR(100),
    descripcio VARCHAR(160),
    progres INT,
    tipus_missio TINYINT NOT NULL,
    fixa TINYINT
);

-- Taula: MISSIONS_ARMES
CREATE TABLE MISSIONS_ARMES (
    arma INT NOT NULL,
    missio INT NOT NULL,
    PRIMARY KEY (arma, missio)
);

-- Taula: MISSIONS_COMPLETADES
CREATE TABLE MISSIONS_COMPLETADES (
    missio INT NOT NULL,
    usuari INT NOT NULL,
    PRIMARY KEY (missio, usuari)
);

-- Taula: MISSIONS_DIARIES
CREATE TABLE MISSIONS_DIARIES (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuari INT,
    missio INT,
    data_assig DATE,
    completada TINYINT
);

-- Taula: MISSIONS_TITOLS
CREATE TABLE MISSIONS_TITOLS (
    titol INT NOT NULL,
    missio INT NOT NULL,
    PRIMARY KEY (titol, missio)
);

-- Taula: PERFIL_USUARI
CREATE TABLE PERFIL_USUARI (
    usuari INT PRIMARY KEY,
    partides_jugades INT,
    partides_guanyades INT,
    personatge_preferit INT,
    skin_preferida_id INT
);

-- Taula: PERSONATGES
CREATE TABLE PERSONATGES (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    vida_base DECIMAL(10,2) NOT NULL,
    mal_base DECIMAL(10,2) NOT NULL,
    Classe VARCHAR(20),
    descripcio TEXT,
    altura INT,
    pes DECIMAL(5,1),
    Genere VARCHAR(10),
    aniversari DATE
);

-- Taula: SKINS
CREATE TABLE SKINS (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(60) NOT NULL,
    categoria TINYINT NOT NULL,
    imatge VARCHAR(255),
    personatge INT NOT NULL,
    atac INT,
    raça TINYINT
);

-- Taula: SKINS_ARMES
CREATE TABLE SKINS_ARMES (
    skin INT NOT NULL,
    arma INT NOT NULL,
    PRIMARY KEY (skin, arma)
);

-- Taula: TITOLS
CREATE TABLE TITOLS (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom_titol VARCHAR(100),
    personatge INT
);

-- Taula: USUARI_SKIN_ARMES
CREATE TABLE USUARI_SKIN_ARMES (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuari INT,
    personatge INT,
    skin INT,
    arma INT
);

-- Taula: USUARIS
CREATE TABLE USUARIS (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50),
    email VARCHAR(50) NOT NULL,
    contrassenya VARCHAR(255) NOT NULL,
    punts_emmagatzemats INT,
    tipo TINYINT NOT NULL,
    imatgeperfil INT
);

-- Taula: USUARIS_ARMES
CREATE TABLE USUARIS_ARMES (
    usuari INT NOT NULL,
    arma INT NOT NULL,
    PRIMARY KEY (usuari, arma)
);

-- Taula: AMISTATS
CREATE TABLE AMISTATS (
    id_usuari INT,
    id_usuari_amic INT,
    estat VARCHAR(20) DEFAULT 'pendent',
    PRIMARY KEY (id_usuari, id_usuari_amic),
    FOREIGN KEY (id_usuari) REFERENCES USUARIS(id),
    FOREIGN KEY (id_usuari_amic) REFERENCES USUARIS(id),
    CHECK (id_usuari < id_usuari_amic),
    CHECK (estat IN ('pendent', 'acceptat', 'rebutjat'))
);

-- Inserts d'ARMES
INSERT INTO ARMES (id, nom, categoria, buff_atac) VALUES
(10, 'Kyoka Suigetsu (Arma base)', 0, 40),
(11, 'Kyoka Suigetsu (Shikai)', 1, 50),
(13, 'Senbonzakura (Arma base)', 0, 35),
(14, 'Senbonzakura (Shikai)', 1, 45),
(15, 'Senbonzakura Kageyoshi (Bankai)', 2, 55),
(16, 'Braç Esquerre del Dimoni', 0, 30),
(17, 'Kidou Baix', 0, 20),
(18, 'Kidou', 0, 25),
(19, 'Shinso (Arma base)', 0, 40),
(20, 'Shinso (Shikai)', 1, 50),
(21, 'Kamishini no Yari (Bankai)', 2, 60),
(22, 'Hyorinmaru (Arma base)', 0, 35),
(23, 'Hyorinmaru (Shikai)', 1, 45),
(24, 'Daiguren Hyorinmaru (Bankai)', 2, 55),
(25, 'Kubikiri Orochi (Arma base)', 0, 30),
(26, 'Zangetsu (Arma base)', 0, 40),
(27, 'Zangetsu (Shikai)', 1, 50),
(28, 'Tensa Zangetsu (Bankai)', 2, 60),
(29, 'Hozukimaru (Arma base)', 0, 30),
(30, 'Hozukimaru (Shikai)', 1, 40),
(31, 'Ryumon Hozukimaru (Bankai)', 2, 50),
(32, 'Seele Schneider', 0, 30),
(33, 'Nozarashi (Arma base)', 0, 50),
(34, 'Nozarashi (Shikai)', 1, 55),
(35, 'Nozarashi (Bankai)', 2, 60),
(36, 'Tachikaze (Arma base)', 0, 35),
(37, 'Tachikaze (Shikai)', 1, 45),
(38, 'Tachikaze (Bankai)', 2, 55),
(39, 'Wabisuke (Arma base)', 0, 30),
(40, 'Wabisuke (Shikai)', 1, 40),
(41, 'Tenken (Arma base)', 0, 35),
(42, 'Tenken (Shikai)', 1, 45),
(43, 'Kokujo Tengen Myo-o (Bankai)', 2, 55),
(44, 'Força pròpia', 0, 10),
(45, 'Kidou Curatiu', 0, 10),
(46, 'Katen Kyokotsu (Arma base)', 0, 40),
(47, 'Katen Kyokotsu (Shikai)', 1, 50),
(48, 'Katen Kyokotsu: Karamatsu Shinju (Bankai)', 2, 60),
(49, 'Haguro Tonbo (Arma base)', 0, 30),
(50, 'Tengumaru (Arma base)', 0, 35),
(51, 'Tengumaru (Shikai)', 1, 45),
(52, 'Hollowificació', 0, 25),
(53, 'Haineko (Arma base)', 0, 30),
(54, 'Haineko (Shikai)', 1, 40),
(55, 'Ashizogi Jizo (Arma base)', 0, 35),
(56, 'Ashizogi Jizo (Shikai)', 1, 45),
(57, 'Konjiki Ashizogi Jizo (Bankai)', 2, 55),
(58, 'Gamuza', 0, 35),
(59, 'Santel·la', 0, 10),
(60, 'Kidou Cero', 0, 30),
(61, 'Zabimaru (Arma base)', 0, 35),
(62, 'Zabimaru (Shikai)', 1, 45),
(63, 'Hihio Zabimaru (Bankai)', 2, 55),
(64, 'Sode no Shirayuki (Arma base)', 0, 35),
(65, 'Sode no Shirayuki (Shikai)', 1, 45),
(66, 'Hakka no Togame (Bankai)', 2, 55),
(67, 'Sakanade (Arma base)', 0, 35),
(68, 'Sakanade (Shikai)', 1, 45),
(69, 'Suzumebachi (Arma base)', 0, 35),
(70, 'Suzumebachi (Shikai)', 1, 45),
(71, 'Jakho Raikoben (Bankai)', 2, 55),
(72, 'Suzumushi (Arma base)', 0, 35),
(73, 'Suzumushi (Shikai)', 1, 45),
(74, 'Suzumushi Tsuishiki: Enma Korogi (Bankai)', 2, 55),
(75, 'Sogyo no Kotowari (Arma base)', 0, 40),
(76, 'Sogyo no Kotowari (Shikai)', 1, 50),
(77, 'Minazuki (Arma base)', 0, 40),
(78, 'Minazuki (Shikai)', 1, 50),
(79, 'Minazuki (Bankai)', 2, 60),
(80, 'Benihime (Arma base)', 0, 40),
(81, 'Benihime (Shikai)', 1, 50),
(82, 'Kidou Hollow', 0, 15),
(83, 'Ryujin Jakka (Arma base)', 0, 50),
(84, 'Ryujin Jakka (Shikai)', 1, 55),
(85, 'Zanka no Tachi (Bankai)', 2, 60),
(86, 'Kido Shunko', 0, 35),
(87, 'Fuji Kujaku (Arma base)', 0, 30),
(88, 'Fuji Kujaku (Shikai)', 1, 40);


-- Insert d'ATACS
INSERT INTO ATACS (id, nom, mal) VALUES 
(1, 'Hado #90: Kurohitsugi (Calaix Negre)', 180),
(2, 'Senbonzakura Kageyoshi (Mil Petals de Cirerers)', 170),
(3, 'El Directe (Braç Esquerre del Dimoni)', 120),
(4, 'Bomba de Bufanda', 50),
(5, 'Tornado de Pedres', 60),
(6, 'Kamishini no Yari (Llança Divina Assassina)', 160),
(7, 'Hyorinmaru (Drac de Gel)', 150),
(8, 'Tenshou (Tall Diví)', 100),
(9, 'Getsuga Tensho (Allau de Llum Lunar)', 200),
(10, 'Ryumon Hozukimaru (Drac del Mont del Tresor)', 130),
(11, 'Seele Schneider (Tall Esperit)', 110),
(12, 'Força Bruta', 200),
(13, 'Tekken Tachikaze (Ferro Punyent del Vent)', 140),
(14, 'Wabisuke (Espasa del Pesar)', 90),
(15, 'Tengen Myo (Déu del Cel Brillant)', 170),
(16, 'Força augmentada', 30),
(17, 'Shakkaho', 10),
(18, 'Katen Kyokotsu: Karamatsu Shinju (Suïcidi dels Pins Negres)', 190),
(19, 'Llançament de llança espiritual', 80),
(20, 'Tengumaru (Drac de Foc)', 150),
(21, 'Super Kick', 70),
(22, 'Haineko (Gat de Cendres)', 100),
(23, 'Konjiki Ashisogi Jizo (Buda Daurat Assassí)', 180),
(24, 'Cero Doble (Banya de Resurrecció)', 160),
(25, 'Koten Zanshun', 40),
(26, 'Cero Sincrético', 80),
(27, 'Zabimaru (Cua de Serp)', 130),
(28, 'Sode no Shirayuki (Neu de la Màniga)', 120),
(29, 'Sakanade (Espasa Inversa)', 140),
(30, 'Nigeki Kessatsu (Dos cops de Mort)', 200),
(31, 'Benihiko (Llança Escarlata)', 150),
(32, 'Sogyo no Kotowari (Lleis de la Proporció)', 160),
(33, 'Minazuki (Tota la Sang)', 170),
(34, 'Hiasobi, Benihime, Juzutsunagi', 180),
(35, 'Hiryu Gekizoku Shinten Raiho', 85),
(36, 'Ryujin Jakka (Flama del Déu Drac)', 200),
(37, 'Shunko (Llum Centellejant)', 190),
(38, 'Fuji Kujaku (Pavo Real Elegant)', 100),
(39, 'Absorció Memètica', 150),
(40, 'Huracà Sagnant', 120),
(41, 'Ullal Salvatge', 130),
(42, 'Mort Inevitable', 200),
(43, 'Llops Cero', 160),
(44, 'Control Genètic', 110),
(45, 'Garra del Jaguar Blau', 170),
(46, 'Marea Asfixiant', 140),
(47, 'Bala Incontrolable', 90),
(48, 'Urpa Verinosa', 100),
(49, 'Cero Colossal', 160),
(50, 'Rugir Reial', 130),
(51, 'Tall Infinit', 150),
(52, 'Llança del Raig Negre', 180),
(53, 'Crit Primigeni', 100),
(54, 'Erupció de Fúria', 200),
(55, 'Mirada Absoluta', 140),
(56, 'Gàbia de Conillets', 70),
(57, 'Negre Absolut', 190),
(58, 'Cuina Espiritual', 80),
(59, 'Espasa de Tempesta', 150),
(60, 'Dispar Clínic', 100),
(61, 'Flama Paternal', 130),
(62, 'Joguina Sagnant', 120),
(63, 'Simfonia del Caos', 170),
(64, 'Tall Perfecte', 160),
(65, 'Espasa de l’Engany', 140),
(66, 'Cop de Brutícia', 60),
(67, 'Teixit Celestial', 150),
(68, 'Fulla Cronològica', 110),
(69, 'Terror Etern', 180),
(70, 'Quantitat Letal', 130),
(71, 'Explosió Desquiciada', 160),
(72, 'Cinc Dits Llamejants', 150),
(73, 'Tempesta Elèctrica', 140),
(74, 'Acer Glacial', 120),
(75, 'Robatori de Tècnica', 90),
(76, 'Dispar Fosc', 100),
(77, 'Sang Infectada', 110),
(78, 'Imaginació Mortal', 190),
(79, 'Justícia Bifurcada', 160),
(80, 'Dispar Diví', 170),
(81, 'Purificació Cero', 130),
(82, 'Estrella Justiciera', 140),
(83, 'Força Delicada', 100),
(84, 'Gàbia de Reishi', 120),
(85, 'Tret de la Mort', 110),
(86, 'Trencament del Futur', 200),
(87, 'Cop de Martell: Aigües Termals', 150);


-- Insert d'AVATARS
INSERT INTO AVATARS (id, url, nom) VALUES 
(1, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/CONFIGURATIONSCREEN/PROFILE_IMAGES/jdpenjhmoamfxzpdgubr', 'Yachiru'),
(2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/CONFIGURATIONSCREEN/PROFILE_IMAGES/jesi4rdib6xl4m92hxu2', 'Kon'),
(3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/CONFIGURATIONSCREEN/PROFILE_IMAGES/l3qqanzs4c32i5ttyoux', 'Shinji'),
(4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/CONFIGURATIONSCREEN/PROFILE_IMAGES/mmup39cga8cdoe3urihh', 'Byakuya'),
(5, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/CONFIGURATIONSCREEN/PROFILE_IMAGES/moxx7gqge7j8uneeupia', 'Grimmjow'),
(6, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/CONFIGURATIONSCREEN/PROFILE_IMAGES/oomixbndnodhkyvczac9', 'Kenpachi'),
(7, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/CONFIGURATIONSCREEN/PROFILE_IMAGES/pducumdttzl2jq1shx6q', 'Kanonji'),
(8, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/CONFIGURATIONSCREEN/PROFILE_IMAGES/q6b3bdct57otlrznmhib', 'Urahara'),
(9, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/CONFIGURATIONSCREEN/PROFILE_IMAGES/sejvfwyktduvzrufbxzs', 'Aizen'),
(10, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/CONFIGURATIONSCREEN/PROFILE_IMAGES/stlvcmyacsw863kldt1v', 'Komamura'),
(11, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/CONFIGURATIONSCREEN/PROFILE_IMAGES/t0mtzwxorygqwrrkitcr', 'Kyoraku'),
(12, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/CONFIGURATIONSCREEN/PROFILE_IMAGES/ttuk0xflvrbamg4ebfo5', 'Mayuri'),
(13, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/CONFIGURATIONSCREEN/PROFILE_IMAGES/vho5yuglzzrzn4i2amef', 'Yoruichi'),
(14, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/CONFIGURATIONSCREEN/PROFILE_IMAGES/vnknfg1zwjbgdslaubod', 'Ulquiorra'),
(15, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/CONFIGURATIONSCREEN/PROFILE_IMAGES/vrgdpybhmtcmrspt8gsp', 'Chad'),
(16, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/CONFIGURATIONSCREEN/PROFILE_IMAGES/zeffk7pddp2hkxuyffh7', 'Ichigo');




-- Inserts de personatges com a enemics
INSERT INTO ENEMICS (id, personatge_id, punts_donats, musica_combat) VALUES
(1, 1, 80, NULL),
(42, 40, 50, NULL),
(43, 41, 30, NULL),
(44, 42, 30, NULL),
(45, 43, 50, NULL),
(46, 44, 50, NULL),
(47, 6, 70, NULL),
(48, 45, 50, NULL),
(49, 46, 50, NULL),
(50, 47, 50, NULL),
(51, 48, 45, NULL),
(52, 49, 30, NULL),
(53, 50, 25, NULL),
(54, 51, 30, NULL),
(55, 52, 50, NULL),
(56, 31, 70, NULL),
(57, 53, 60, NULL),
(58, 54, 50, NULL),
(59, 55, 50, NULL),
(60, 56, 50, NULL),
(61, 60, 110, NULL),
(62, 62, 100, NULL),
(63, 63, 105, NULL),
(64, 64, 95, NULL),
(65, 66, 90, NULL),
(66, 67, 85, NULL),
(67, 68, 120, NULL),
(68, 69, 115, NULL),
(69, 70, 90, NULL),
(70, 71, 95, NULL),
(71, 72, 85, NULL),
(72, 73, 90, NULL),
(73, 76, 150, NULL),
(74, 79, 80, NULL),
(75, 80, 100, NULL),
(76, 83, 135, NULL),
(77, 84, 140, NULL),
(78, 91, 100, NULL);

-- Inserció a HABILITAT_LLEGENDARIA amb id explícit
INSERT INTO HABILITAT_LLEGENDARIA (id, nom, descripcio, video, musica_combat, skin_personatge) VALUES
(3, 'Sakanade', 'Inverteix la pantalla del mòvil', 'https://www.youtube.com/watch?v=RlCZ2B45kqU', 'https://youtu.be/fZx7yUztxJ0?si=uCl3eJe6rSeeii_T', 89);

-- Insercions a PERFIL_USUARI
INSERT INTO PERFIL_USUARI (usuari, partides_jugades, partides_guanyades, personatge_preferit, skin_preferida_id) VALUES
(66, 112, 47, 69, 138),
(74, 9, 5, NULL, NULL),
(75, 0, 0, NULL, NULL);

-- Inserts de Personatges
INSERT INTO PERSONATGES (id, nom, vida_base, mal_base, Classe, descripcio, altura, pes, Genere, aniversari) VALUES
(1, 'Aizen', 950.00, 130.00, 'Ànima', 'Un geni manipulador amb un poder hipnòtic absolut, l\'antic Capità del 5è Escamot del Gotei 13. La seva Zanpakuto, Kyoka Suigetsu, controla els sentits dels seus enemics. Ambitiós i fred, cerca trascendir els límits de shinigamis i déus.', 186, 74.0, 'M', '2000-05-29'),
(2, 'Byakuya', 900.00, 120.00, 'Ànima', 'Capità del 6é Escamot del Gotei 13 i germà de la Rukia Kuchiki. El seu Senbonzakura es descompon en milers de fulles afilades que simulen pétals d\'un cirerer. Orgullos i elegant, sota la seva fredor, amaga un profund sentit d\'honor i lleialtat.', 180, 64.0, 'M', '2000-01-31'),
(3, 'Chad', 850.00, 100.00, 'Humà', 'Un humà amic de l\'Ichigo Kurosaki, que té una força sobrehumana als braços. El seu poder prové de la sang i el cor, protegint als seus amics sense dubtar. I encara que intimidi i sigui poc xerrador, té un cor gegant.', 196, 112.0, 'M', '2000-04-07'),
(4, 'Dondochakka', 500.00, 70.00, 'Arrancar', 'És un Hollow germà de la Nel i el Pesche, i amic de l\'Ichigo, amb una màscara peculiar i un cor innocent. La seva relació amb Pesche es còmica.', 204, 162.0, 'M', '2000-06-30'),
(5, 'Ganju', 600.00, 80.00, 'Ànima', 'Un shinigami rebel i bromista, germà de la Kukaku Shiba, i membre del propi clan Shiba, és un expert en explosions i tècniques. Encara que sembla poc seriós té un gran sentit de la justicia i la familia.', 182, 106.0, 'M', '2000-10-15'),
(6, 'Gin', 930.00, 125.00, 'Ànima', 'L\'antic Capità del 3er Escamot del Gotei 13, fred i enigmàtic, amb un somriure que amaga les seves veritables intencions. La seva Zanpakuto, Shinso, s\'estén a velocitat letal. Mai se sap si es amic o enemic.', 185, 69.0, 'M', '2000-09-10'),
(7, 'Hitsugaya', 880.00, 110.00, 'Ànima', 'El Capità més Jove del Gotei 13, sent Capità del 10é Escamot, té un poder gelat devastador. La seva Zanpakuto, Hyorinmaru, invoca un drac de gel que congela tot al seu pas. Madur més enllà dels seus anys.', 133, 26.0, 'M', '2000-12-20'),
(8, 'Hiyori', 700.00, 95.00, 'Visored', 'Ex-shinigami rebel i membre dels Visored. Malcarada i violenta, però lleial als seus. La seva màscara Hollow augmenta la seva velocitat i força bruta.', 133, 26.0, 'F', '2000-08-01'),
(9, 'Ichigo', 1000.00, 140.00, 'Humà', 'Un adolescent amb habilitats de Shinigami, Hollow i Quincy alhora. La seva Zanpakuto, Zangetsu, té un gran poder. Lluita per protegir a tothom, sense importar el perill.', 181, 66.0, 'M', '2000-07-15'),
(10, 'Ikkaku', 850.00, 105.00, 'Ànima', 'Membre de l\'11é Escamot del Gotei 13 i fidel a Kenpachi. La seva Zanpakuto Hozukimaru es transforma en una llança destructora. Encara que sembla un lluitador brut, té un codi d\'honor irrompible.', 182, 76.0, 'M', '2000-11-09'),
(11, 'Ishida', 750.00, 90.00, 'Quincy', 'Un Quincy orgullós i intel·ligent, expert en el tir precís amb arc. Rival inicial de l\'Ichigo, que després acaba sent un aliat clau. La seva tècnica Letzt Stil el fa gairebé invencible.', 176, 55.0, 'M', '2000-11-06'),
(12, 'Kenpachi', 1000.00, 150.00, 'Ànima', 'Un guerrer nat que viu només per la lluita. Sent el Capità del 11é Escamot del Gotei 13, no té por ni segueix una táctica, només busca enemics forts amb qui lluitar a mort. La seva energia espiritual és aterridora, fins i tot sense alliberar la seva Zanpakuto. Porta un pegat a l\'ull que suprimeix el seu poder real. La seva única regla és: "Diverteix-te en la batalla".', 202, 90.0, 'M', '2000-11-19'),
(13, 'Kensei', 900.00, 110.00, 'Visored', 'Capità del 9é Escamot i ex-Visored. La seva Zanpakuto, Tachikaze, controla explosions d\'aire. Un líder dur, però davant tot, just, que valora la força i la lleialtat.', 179, 75.0, 'M', '2000-07-30'),
(14, 'Kira', 750.00, 95.00, 'Ànima', 'Tinent del 3er Escamot, melancòlic i culpat després de la traïció del seu capità i l\'Aizen, troba la redempció en la lluita. La seva Zanpakuto Wabisuke augmenta el pes dels objectius fins a esclafar-los.', 173, 56.0, 'M', '2000-03-27'),
(15, 'Komamura', 950.00, 115.00, 'Ànima', 'Un Shinigami amb aparença de llop gegant, i Capità del 7é Escamot, creu fermament en la justicia i l\'honor. La seva Zanpakuto Tengen Myo\'o invoca un guerrer gegant que reflecteix els seus moviments.', 288, 301.0, 'M', '2000-08-23'),
(16, 'Kon', 450.00, 60.00, 'Ànima Modificada', 'Un Gikon(Ànima Artificial) que substitueix al Ichigo quan assumeix la seva feina de Shinigami Substitut, i que la resta del temps està dins un peluix amb aparença de lleó, té una naturalesa pervertida, que dona peu a situacions còmiques.', 27, 0.2, 'M', '2000-12-30'),
(17, 'Kotetsu', 700.00, 85.00, 'Ànima', 'Tinent del 7è Escamot del Gotei 13. La seva alçada inusual per una dona Shinigami li dona presència en camp de batalla, encara que prefereix la curació al combat.', 187, 70.0, 'F', '2000-08-02'),
(18, 'Kyoraku', 920.00, 125.00, 'Ànima', 'Capità del 1er Escamot del Gotei 13 després de Yamamoto. Li agrada relaxar-se i beure sake en el temps lliure. Considera com un germà al Ukitake. Té una Zanpakuto doble, la Katen Kyokotsu, una especialitzada en atacs ràpids i l\'altre en atacs d\'energia.', 192, 87.0, 'M', '2000-07-11'),
(19, 'Lisa', 800.00, 100.00, 'Visored', 'Ex-Shinigami i Visored, és una pervertida obsessionada amb les revistes per adults. La seva Zanpakuto és una guillotina gegant. Ràpida i sarcàstica, però també una lluitadora formidable.', 162, 52.0, 'F', '2000-02-03'),
(20, 'Love', 850.00, 110.00, 'Visored', 'Ex-Capità del 7è Escamot. El seu aspecte intimidant combina amb la seva Zanpakuto de foc.', 189, 86.0, 'M', '2000-10-10'),
(21, 'Mashiro', 750.00, 90.00, 'Visored', 'Antiga Tinent del 9è Escamot. La seva estatura contrasta amb cops de punys devastadors sent ella, especialista en arts marcials.', 153, 44.0, 'F', '2000-04-01'),
(22, 'Matsumoto', 860.00, 105.00, 'Ànima', 'Tinent 10è Escamot del Gotei 13, té una relació còmica amb el Hitsugaya, el seu capità. La Hiyori sempre li retreu el seu pes, però la seva agilitat amb la seva Zanpakuto Hianeko, demostra que les xifres enganyen.', 172, 57.0, 'F', '2000-09-29'),
(23, 'Mayuri', 900.00, 110.00, 'Ànima', 'Capità del 12é Escamot del Gotei 13 i el més marginat de tots. Les seves accions son les més qüestionables, és un científic sense escrúpols que experimenta amb amics i enemics. La seva Zanpakuto Ashisogi Jizo injecta verins letals. Gaudir del caos és el que més li agrada, i sempre porta un às davall la màniga.', 174, 54.0, 'M', '2000-03-30'),
(24, 'Nel', 700.00, 90.00, 'Arrancar', 'En el seu dia portà el nombre 3 dels "Espada", ara és una arrancar amb una personalitat infantil però amb un poder devastador. És amiga de l\'Ichigo. Protegeix als febles amb dolçesa i força, encara que es passa el dia plorant pels seus amics.', 176, 63.0, 'F', '2000-04-24'),
(25, 'Orihime', 750.00, 65.00, 'Humà', 'Una noia dolça i compassiva amb habilitats de curació i protecció úniques. Els seus Shun Shun Rikka li permeten rebutjar qualsevol atac. Encara que odia la violència, lluitarà pels seus amics sense dubtar si cal, sent molt d\'afecte cap a l\'Ichigo.', 157, 45.0, 'F', '2000-09-03'),
(26, 'Pesche', 600.00, 80.00, 'Arrancar', 'Un cavaller Hollow lleial i excèntric, company de la Nel i el Dondochakka. El seu atac "Cero Sincrético" és poderós, encara que la seva personalitat despistada el fa menyspreable als enemics ocultant la seva vertadera intel·ligència per protegir als seus. S\'ho passa bé fent-li bromes pesades a l\'Ishida Uryu.', 175, 54.0, 'M', '2000-05-25'),
(27, 'Renji', 880.00, 120.00, 'Ànima', 'Tinent del 6é Escamot del Gotei 13, i rival de l\'Ichigo. La seva Zanpakuto, Zabimaru, és una espassa que es transforma en una serp ossuda. Brutal en combat i de cor lleial cap al Byakuya i la Rukia.', 188, 78.0, 'M', '2000-08-31'),
(28, 'Rukia', 770.00, 95.00, 'Ànima', 'Tinent del 13é Escamot del Gotei 13, germana del Byakuya Kuchiki i fou la Shinigami que li donà poders a l\'Ichigo, tinguent una gran amistat amb aquest. La seva Zanpakuto, Sode no Shirayuki, és una de les espasses més belles, capaç de congelar tot al seu pas. Elegant i seriosa, però amb un sentit de l\'humor sec.', 144, 33.0, 'F', '2000-01-14'),
(29, 'Shinji', 920.00, 130.00, 'Visored', 'Líder dels Visored i Capità del 5é Escamot del Gotei 13, la seva Zanpakuto, Sakanade, inverteix els sentits als enemics creant el seu "Món Invertit". La seva actitud relaxada amaga una ment estratègica brillant. Té un profund odi cap a l\'Aizen.', 176, 60.0, 'M', '2000-05-10'),
(30, 'Soi Fon', 850.00, 110.00, 'Ànima', 'Capitana del 2on Escamot del Gotei 13 i líder dels Onmitsukido. Manté una rivalitat amb la Yoruichi, qui fou la seva antiga capitana. La seva Zanpakuto, Suzumebachi, mata amb dos cops al mateix lloc. Té una personalitat estricta i sense paciència.', 150, 38.0, 'F', '2000-02-11'),
(31, 'Tosen', 930.00, 125.00, 'Visored', 'Ex-Capità del 9é Escamot del Gotei 13 que pateix ceguera i que abraçà el poder Hollow. La seva Zanpakuto té l\'habilitat de privar de tots els sentits als seus rivals. La seva tragèdia el converteix en un home obsessionat amb una justícia distorsionada.', 176, 61.0, 'M', '2000-11-13'),
(32, 'Ukitake', 880.00, 105.00, 'Ànima', 'Capità del 13é Escamot del Gotei 13, malaltís però amb un cor noble, considera al Kyoraku Shunsui com el seu germà. Sempre actua amb compassió, fins hi tot en els moments més foscos.', 187, 72.0, 'M', '2000-12-21'),
(33, 'Unohana', 920.00, 115.00, 'Ànima', 'Capitana del 4t Escamot del Gotei 13 i la millor curandera de tot el Seretei, amb un passat misteriós que oculta una sed de sang. És una persona amable i propera. La seva Zanpakuto, Minazuki, pot curar... o destruir amb sang freda.', 159, 45.0, 'F', '2000-04-21'),
(34, 'Urahara', 900.00, 115.00, 'Ànima', 'Antic membre del 12é Escamot del Gotei 13 i primer mestre de l\'Ichigo, viu una vida tranquil·la al món humà com a dependent d\'una tenda de barri. Sempre està de broma, encara que és molt intel·ligent i mai mostra totes les seves cartes fins que és massa tard pels enemics. La seva Zanpakuto Benihime té tècniques versàtils i impredictibles.', 183, 69.0, 'M', '2000-12-31'),
(35, 'Ushoda', 750.00, 100.00, 'Visored', 'Gegant dels Visored, es un expert en kido i barreres. Antic membre de la Divisió del Kido, sorprèn amb la seva delicadesa en l\'artesania.', 257, 377.0, 'M', '2000-09-08'),
(36, 'Yamamoto', 1000.00, 160.00, 'Ànima', 'Capità General del Gotei 13 i el membre més vell del Seretei. Estricte i implacable, però amb profund sentit de justícia. La seva Zanpakuto, Ryujin Jakka, deixa només cendres al seu pas.', 168, 52.0, 'M', '2000-01-21'),
(37, 'Yourichi', 920.00, 130.00, 'Ànima', 'Mestra en velocitat i arts marcials, és l\'anterior Capitana del 2on Escamot del Gotei 13, i es pot transformar en un gat negre. Elegant, enigmàtica i una de les guerreres més fortes de la Societat d\'Ànimes.', 156, 42.0, 'F', '2000-01-01'),
(38, 'Yumichika', 850.00, 110.00, 'Ànima', 'Membre del 11é Escamot del Gotei 13 i gran amic del Ikkaku, està obsessionat amb la bellesa fins i tot en combat. La seva Zanpakuto, Fuji Kujaku, drena l\'energia espiritual dels rivals.', 169, 50.0, 'M', '2000-09-19'),
(40, 'Aaroniero', 850.00, 130.00, 'Arrancar', 'Membre dels "Espada" portant el número 9. És capaç d\'absorbir habilitats d\'altres Hollows, i emprar aparences d\'altres. És un monstre que disfruta amb el patiment dels altres.', 205, 91.0, 'M', '2000-04-23'),
(41, 'Abirama', 780.00, 120.00, 'Arrancar', 'Arrancar amb habilitats de control de vent. Les seves plomes es transformen en fulles tallants que destrossen els enemics. Un combatent arrogant que sol subestimar als seus oponents.', 183, 92.0, 'M', '2000-08-19'),
(42, 'Apache', 650.00, 95.00, 'Arrancar', 'Membre de les Tres Bésties de Halibel. Ataca amb urpes afilades i una agressivitat animal. Encara que és poc parladora, la seva presència en combat és intimidatòria.', 156, 42.0, 'F', '2000-05-17'),
(43, 'Barragan', 1000.00, 150.00, 'Arrancar', 'Membre dels "Espada" portant el número 2, és l\'antic rei del Hueco Mundo i es posà a les ordres de l\'Aizen. El seu poder de vellesa accelerada desintegra qualsevol cosa al seu voltant. És arrogant i cruel.', 166, 90.0, 'M', '2000-02-09'),
(44, 'Coyote', 900.00, 130.00, 'Arrancar', 'Membre dels "Espada" portant el número 1, un ésser tan poderós que va dividir la seva ànima per evitar la soledat. Les seves pistoles espirituals són devastadores, però prefereix evitar les lluites.', 187, 77.0, 'M', '2000-01-19'),
(45, 'Granz', 850.00, 110.00, 'Arrancar', 'El 8è membre dels "Espada", un geni científic obsessiu. Té una habilitat que li permet analitzar i replicar les habilitats dels enemics. Un psicòpata calculador que gaudeix dissectant els seus oponents vius.', 185, 67.0, 'M', '2000-06-22'),
(46, 'Grimmjow', 980.00, 145.00, 'Arrancar', 'Un Arrancar que forma part dels "Espada", portant el número 6, rival de l\'Ichigo. És un guerrer nat que desitja batalles honorables. La seva "Pantera" el fa més ràpid i letal. Odia perdre contra els seus contrincants.', 186, 80.0, 'M', '2000-07-31'),
(47, 'Halibel', 880.00, 125.00, 'Arrancar', 'Membre dels "Espada" portant el numero 3, lidera amb serenitat i força, pot controlar l\'aigua a un nivell devastador. Protegeix a les seves subordinades com una matriarca, mostrant el costat més noble dels Arrancar.', 175, 65.0, 'F', '2000-07-25'),
(48, 'Lilynette', 750.00, 100.00, 'Arrancar', 'Mitja ànima del Coyote Starrk, amb energia inesgotable. La seva petita grandària li permet atacar amb rapidesa sorprenent. Porta sempre una pistola proporcionalment gran per a la seva alçada.', 142, 31.0, 'F', '2000-01-19'),
(49, 'Loly', 700.00, 95.00, 'Arrancar', 'Ex-Subordinada de l\'Aizen que canalitza el seu odi cap a qualsevol que l\'amenaci, té un especial resentiment cap a la Orihime.', 155, 42.0, 'F', '2000-01-27'),
(50, 'MenosGrande', 800.00, 110.00, 'Hollow', 'Es una classe de Hollow gegant que actúa amb força bruta. Encara que són limitats intel·lectualment, la seva presència massiva sumat al seu atac "Cero destructiu", el fan una amenaça per qualsevol Shinigami novell.', 3000, 1000.0, '?', NULL),
(51, 'Mila', 720.00, 90.00, 'Arrancar', 'Líder de les Tres Bésties de Halibel. La seva llança espiritual té un abast impressionant. Lleial fins a la mort cap a la seva capitana, mostra el costat més noble dels Arrancar.', 177, 68.0, 'F', '2000-08-17'),
(52, 'Nnoitra', 950.00, 140.00, 'Arrancar', 'Membre dels "Espada" portant el número 5. Menysprea als febles i la seva "Santa Teresa" li dona quatre braços. Està obsessionat amb provar la seva superioritat.', 215, 93.0, 'M', '2000-11-11'),
(53, 'Ulquiorra', 1000.00, 150.00, 'Arrancar', 'Fred i filosòfic, porta el nombre 4 dels "Espada", i és un dels més poderosos. Creu que l\'existència no té sentit. En la seva Segona Etapa es converteix en un ésser quasi invencible.', 169, 55.0, 'M', '2000-12-01'),
(54, 'Wonderweiss', 750.00, 110.00, 'Arrancar', 'Creació especial de l\'Aizen dissenyada per contrarestar al Yamamoto. És molt poderós però a canvi ha perdut la capacitat de parlar i raonar, obeint cegament les ordres de l\'Aizen.', 155, 42.0, 'M', '2000-07-06'),
(55, 'Yammy', 1000.00, 150.00, 'Arrancar', 'Membre dels "Espada" portant el número 10, aquest augmenta de mida i poder segons el seu nivell de ràbia. El més físic dels "Espada", però també el menys intel·ligent i impulsiu. La seva força bruta és letal.', 230, 303.0, 'M', '2000-04-03'),
(56, 'Zommari', 850.00, 120.00, 'Arrancar', '7é membre dels "Espada" obsessionat amb la "gràcia de Déu". El seu cos esculpit mostra la perfecció dels arrancar, i el seu poder li permet controlar els moviments amb ulls místics.', 196, 100.0, 'M', '2000-10-13'),
(60, 'Bazz-B', 760.00, 115.00, 'Quincy', 'Quincy arrogant amb control sobre flames explosives. El seu poder crema fins l\'ànima, i no dubtarà en lluitar per la seva pròpia supervivència.', 179, 69.0, 'M', '2000-07-14'),
(61, 'Senjumaru Shutara', 1100.00, 165.00, 'Ànima', 'Membre de l\'Escamot 0, i teixidora de destins. La seva aparença fràgil amaga un poder que manipula la realitat com si fos tela. Els seus estendards cerimonials són en realitat armes letals.', 158, 48.0, 'F', '2000-11-01'),
(62, 'Gremmy Thoumeaux', 1000.00, 145.00, 'Quincy', 'Un dels Quincies més perillosos, capaç de materialitzar els seus pensaments. La seva imaginació sense límits és a la seva vegada el seu major avantatge però també el seu punt feble.', 155, 49.0, 'M', '2000-06-30'),
(63, 'Askin Nakk Le Vaar', 1000.00, 90.00, 'Quincy', 'Un membre del Wandenreich amb una actitud relaxada i burleta. El seu poder, "The Deathdealing", li permet manipular la dosi letal de qualsevol substància dins el cos de l\'enemic, fent-lo un adversari gairebé invulnerable si sap amb qui lluita. Encara que sembla desinteressat, és un estratega letal que només actua quan li convé.', 187, 59.0, 'M', '2000-06-06'),
(64, 'Meninas', 700.00, 85.00, 'Quincy', 'Quincy que posseeix una força física descomunal. La seva aparença innocent contrasta amb la seva capacitat de destruir edificis amb un sol cop de puny.', 191, 76.0, 'F', '2000-03-09'),
(65, 'Masaki Kurosaki', 600.00, 110.00, 'Quincy', 'Mare de l\'Ichigo Kurosaki i Quincy pura. Mostra el costat més humà dels Quincy, capaç d\'estimar i protegir malgrat les tradicions del seu poble en respecte als Shinigami.', 161, 51.0, 'F', '2000-06-09'),
(66, 'Cang Du', 700.00, 80.00, 'Quincy', 'Quincy amb un poder que li permet endurir la seva pell com a metall indestructible. Un estrateg fred que prefereix esperar i analitzar abans d\'actuar. Li pren el Bankai al Hitsugaya.', 177, 70.0, 'M', '2000-05-27'),
(67, 'NaNaNa', 700.00, 70.00, 'Quincy', 'Quincy amb una habilitat que li permet detectar i explotar els punts febles dels seus oponents. La seva actitud relaxada i observadora el fa un caçador pacient.', 192, 65.0, 'M', '2000-02-27'),
(68, 'Äs Nödt', 750.00, 85.00, 'Quincy', 'Un Quincy que manipula la por, i fa que les seves víctimes sentin el vertader terror pur. La seva aparença fantasmal el fa encara més aterridor.', 179, 59.0, 'M', '2000-12-29'),
(69, 'Mask The Masculine', 800.00, 90.00, 'Quincy', 'Quincy que augmenta el seu poder amb les mamballetes dels seus fans. Un personatge excèntric i teatral, la seva força creix exponencialment mentre més espectadors el segueixen.', 200, 120.0, 'M', '2000-10-20'),
(70, 'Giselle Gewelle', 800.00, 75.00, 'Quincy', 'Quincy que pot transformar els cadàvers en zombis emprant la seva sang. És sàdica i impredictible, i guarda un gran secret. Gaudeix convertint als seus enemics en titelles. La seva relació amb la Bambietta és perturbadora.', 160, 54.0, 'MF', '2000-12-24'),
(71, 'Bambietta Basteaban', 600.00, 90.00, 'Quincy', 'Quincy capaç de convertir qualsevol objecte en una bomba. És violenta, impacient e inestable, odia ser menyspreada pels altres.', 156, 49.0, 'F', '2000-08-06'),
(72, 'Robert Accutrone', 600.00, 75.00, 'Quincy', 'Quincy amb una habilitat similar a Lille, però més enfocada en la velocitat i precisió dels seus trets. És un veterà, que mostra el costat més pragmàtic i experimentat dels soldats del Yhwach.', 176, 70.0, 'M', '2000-10-04'),
(73, 'Candice Catnipp', 700.00, 80.00, 'Quincy', 'Quincy amb el poder de manipular els llamps a voluntat i amb una agressivitat sense igual. La seva personalitat és explosiva i competitiva, sempre volent demostrar que és la més forta.', 166, 57.0, 'F', '2000-06-07'),
(74, 'Oh-Etsu Nimaiya', 1100.00, 170.00, 'Ànima', 'Membre de l\'Escamot Zero, i creador de les Zanpakutos, amb un coneixement sobre les mateixes absolut, té una personalitat excèntrica i li agrada rapejar a ritme de Hip Hop mentre parla.', 172, 62.0, 'M', '2000-08-18'),
(75, 'Riruka', 600.00, 65.00, 'Fullbringer', 'Fullbringer que es fusiona amb nines de joguina. El seu complex d\'inferioritat la porta a actuar de manera infantil. Té una obsessió amb l\'Ichigo Kurosaki.', 156, 43.0, 'F', '2000-04-14'),
(76, 'Yhwach', 1000.00, 180.00, 'Quincy', 'El líder del Wandenreich i pare de tots els Quincies, un déu ambiciós que vol remodelar el món. Poderós i calculador, absorbeix les ànimes dels seus seguidors per augmentar el seu poder.', 200, 110.0, 'M', '2000-01-01'),
(77, 'Ichibe Hyosube', 1100.00, 175.00, 'Ànima', 'El Shinigami més antic, i líder de l\'Escamot Zero, es capaç de controlar els noms de totes les coses, el seu poder es gairebé diví. Es el responsable de nomenar totes les tècniques i armes de la Societat d\'Ànimes.', 181, 105.0, 'M', '2000-01-01'),
(78, 'Kirio Hikifune', 1200.00, 150.00, 'Ànima', 'Antiga Capitana del 12è Escamot, i actual integrant de l\'Escamot 0, el seu menjar augmenta el poder dels aliats. Té una personalitat excèntrica i un coneixement profund de l\'energia espiritual.', 174, 67.0, 'F', '2000-12-16'),
(79, 'Asguiaro Ebern', 650.00, 70.00, 'Arrancar', 'Creat pel Wandenreich, aquest combina atributs de Hollow i Quincy amb tècniques no convencionals. Representa els horrors de l\'experimentació descontrolada del Hueco Mundo.', 181, 76.0, 'M', '2000-06-18'),
(80, 'Quilge Opie', 700.00, 85.00, 'Quincy', 'Inquisidor esvelt com una fulla. La seva constitució lleugera li dona velocitat letal, el seu poder de "Jail" li permet empresonar als seus contrincants a dins una gàbia inexpugnable.', 178, 59.0, 'M', '2000-09-01'),
(81, 'Chojiro Tadaoki', 900.00, 110.00, 'Ànima', 'Tinent del Yamamoto durant més de 1000 anys. La seva Zanpakuto Gonryomaru controla els llamps, però sempre ha estat a l\'ombra del seu Capità sent el seu soldat més lleial.', 179, 66.0, 'M', '2000-11-04'),
(82, 'Ryuken Ishida', 800.00, 100.00, 'Quincy', 'Pare de l\'Ishida Uryu i últim Quincy pur. Manté una actitud freda i pragmàtica, rebutjant les tradicions radicals del seu poble.', 178, 68.0, 'M', '2000-03-14'),
(83, 'Lille Barro', 1000.00, 165.00, 'Quincy', 'El primer Quincy triat per Yhwach. És un francotirador implacable que dispara trets impossibles.', 182, 84.0, 'M', '2000-04-11'),
(84, 'Jugram Haschwalth', 1050.00, 170.00, 'Quincy', 'Amb una aura de misteri, és el màxim confident del Yhwach. El seu poder inverteix la sort, convertint la mala sort dels enemics en el seu avantatge. Un estratega fred i calculador.', 189, 80.0, 'M', '2000-11-05'),
(85, 'Isshin Kurosaki', 850.00, 100.00, 'Ànima', 'En el passat fou Capità del Gotei 13, concretament del 10é Escamot, és el pare de l\'Ichigo i té un petit Centre Mèdic al Barri on viuen, es despreocupat i graciós, però un guerrer formidable quan cal protegir a la familia.', 186, 80.0, 'M', '2000-12-10'),
(86, 'Yachiru', 600.00, 65.00, 'Ànima', 'La Tinent del 11é Escamot del Gotei 13, el Kenpachi la considera com una "filla", aquesta té un pèssim sentit de l\'orientació, és amorosa i bromista amb els amics, però aterridora en combat.', 109, 15.0, 'F', '2000-02-12'),
(87, 'Rojuro Otoribashi', 900.00, 110.00, 'Visored', 'Ex-Visored i Capità del 3er Escamot del Gotei 13. La seva Zanpakuto musical causa il·lusions auditives devastadores pels seus contrincants. Elegant i calculador, té un estil de combat quasi coreografiat.', 187, 73.0, 'M', '2000-03-17'),
(88, 'Kugo Ginjo', 700.00, 80.00, 'Fullbringer', 'Líder dels Fullbringers. I que anteriorment, fou el Primer Shinigami Substitut, té l\'habilitat de manipular l\'ànima dels objectes, vol recuperar a tota costa el que li van prendre.', 187, 90.0, 'M', '2000-11-15'),
(89, 'Jackie Tristan', 650.00, 70.00, 'Fullbringer', 'Fullbringer que augmenta el poder caminant sobre superfícies brutes. Representa la lluita dels marginats. Té un guant de metall que es carrega amb la brutícia com a font de poder.', 180, 71.0, 'F', '2000-09-05'),
(90, 'Shukuro Tsukishima', 650.00, 75.00, 'Fullbringer', 'Fullbringer que manipulà el grup per benefici propi. El seu poder mostra com els més febles poden ser els més perillosos quan juguen brut.', 198, 73.0, 'M', '2000-02-04'),
(91, 'Driscoll Berci', 800.00, 115.00, 'Quincy', 'Quincy amb un poder que li permet augmentar la força dels seus atacs cada vegada que mata algú. Un assassí sense escrúpols que representa la brutalitat pura dels Quincy més radicals.', 235, 135.0, 'M', '2000-03-25'),
(92, 'Tenjiro Kirinji', 1100.00, 170.00, 'Ànima', 'Membre de l\'Escamot 0, també anomenat "Deu de les Termes", és la persona amb majors coneixements mèdics de la Societat d\'Ànimes, i fou el mestre de la Unohana.', 193, 88.0, 'M', '2000-05-31');

-- Inserts de totes les skins
INSERT INTO `SKINS` (`id`, `nom`, `categoria`, `imatge`, `personatge`, `atac`, `raça`) VALUES
(1, 'Aizen Bo', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Aizen/nweidzhwmbbz5nxceujt', 1, 1, 1),
(2, 'Aizen Dolent Ulleres', 1, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Aizen/u6xihhxt3zvaxqmhjbqo', 1, 1, 2),
(3, 'Aizen Dolent Arrancar', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Aizen/jzh3wwccdfvzmdlgxy8z', 1, 1, 2),
(4, 'Aizen Dolent Xetat', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Aizen/ir3c8h0q22fuvmvxjls0', 1, 1, 2),
(5, 'Aizen Dolent Garganta', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Aizen/si6frlfn7ylwb2msmhro', 1, 1, 2),
(6, 'Aizen Dolent Hogyoku', 4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Aizen/iqjkegmuz2dxkc3q0d0k', 1, 1, 2),
(7, 'Byakuya', 1, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Byakuya/n84j6b0teidzlg9wqjg5', 2, 2, 1),
(8, 'Byakuya Shikai', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Byakuya/xs0juulfty62xdhqzj5t', 2, 2, 1),
(9, 'Byakuya Senbonzakura', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Byakuya/zfqalutze6ozlerlxbkp', 2, 2, 1),
(10, 'Byakuya Bankai', 4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Byakuya/iip9b9ywssi8nzshiehn', 2, 2, 1),
(11, 'Chad', 1, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Chad/zkpdncihgpxaanpkwo1w', 3, 3, 1),
(12, 'Chad Brazo Derecho', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Chad/umahiwkmkhftrwppfz5v', 3, 3, 1),
(13, 'Chad Brazo Derecho Gigante', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Chad/ids78p74vaagawpk1xol', 3, 3, 1),
(14, 'Chad Dos Brazos', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Chad/mdrk0l34trscjwesqhiw', 3, 3, 1),
(15, 'Dondochakka', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Dondochakka/eutna9zoqpmcmiekzham', 4, 4, 1),
(16, 'Ganju', 1, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Ganju/w4egvovfzsyn7v04pgwz', 5, 5, 1),
(17, 'Ganju Jabali', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Ganju/ia73uvbqm7dhyrssoeak', 5, 5, 1),
(18, 'Gin Bo', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Gin/wh66nqhnrm1lcdttn8fp', 6, 6, 1),
(19, 'Gin Bo Shikai', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Gin/y3fu5oagtsgz7fnva45x', 6, 6, 1),
(20, 'Hitsugaya', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Hitsugaya/uosnidgu9stveoqhbbck', 7, 7, 1),
(21, 'Hitsugaya Bankai', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Hitsugaya/uoad2cs9tzce69vefgp5', 7, 7, 1),
(22, 'Hitsugaya Bankai Bo', 4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Hitsugaya/qudf6clurwaj4fcmvaiv', 7, 7, 1),
(23, 'Hiyori', 1, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Hiyori/dveh6v0q6qoldb5cmimj', 8, 8, 1),
(24, 'Hiyori Shikai', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Hiyori/lkx3hrzxm7yrpgcawcpc', 8, 8, 1),
(25, 'Hiyori Vanisher', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Hiyori/hhlm4aqrjno4thslm7dq', 8, 8, 1),
(26, 'Ichigo Estudiant', 1, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Ichigo/gmo3rvenlzlodi8zcx8n', 9, 9, 1),
(27, 'Ichigo', 1, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Ichigo/ji7ztcfa2crnxr1ofhbh', 9, 9, 1),
(28, 'Ichigo Shikai', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Ichigo/tzmgpuxujb7bw7obotok', 9, 9, 1),
(29, 'Ichigo Bankai', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Ichigo/clcju9ah22eg5fhzz6kw', 9, 9, 1),
(30, 'Ichigo Mascara', 4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Ichigo/bdtmknwfy3dmqv5hxtzz', 9, 9, 1),
(31, 'Ichigo Hollow', 4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Ichigo/lbt5jxmdwvek0fe2frhe', 9, 9, 1),
(32, 'Ikkaku', 1, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Ikkaku/vxb0vhqwe2dyoncjui7x', 10, 10, 1),
(33, 'Ikkaku Shikai', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Ikkaku/umshbnsnfyqeqf4vaomy', 10, 10, 1),
(34, 'Ikkaku Bankai', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Ikkaku/qpbughb1ft3ys45lfm5t', 10, 10, 1),
(35, 'Ishida', 1, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Ishida/yztx5yojgc4kltjefozk', 11, 11, 0),
(36, 'Ishida Arco Gross', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Ishida/uh5n856dwamulgtex64i', 11, 11, 0),
(37, 'Ishida Quincy', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Ishida/xzbhniaqxcpfr95jkrqg', 11, 11, 0),
(38, 'Ishida Quincy Xetat', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Ishida/bniwn31r7t6j7ytqus9l', 11, 11, 0),
(39, 'Kenpachi', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Kenpachi/pefpld0v2afncevimkqk', 12, 12, 1),
(40, 'Kenpachi Desenvainat', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Kenpachi/tk5i771juittiwdsp2my', 12, 12, 1),
(41, 'Kenpachi Aura', 4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Kenpachi/lzd9nkrzdhqlhfds8f53', 12, 12, 1),
(42, 'Kensei', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Kensei/gayutmsepkp0mysgkdjy', 13, 13, 1),
(43, 'Kensei Shikai', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Kensei/lvnpsl9sfsfxi5vim9uv', 13, 13, 1),
(44, 'Kensei Bankai', 4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Kensei/slbkoiemhk8xdlzlakqx', 13, 13, 1),
(45, 'Kira', 1, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Kira/tx9apoywhif7297kvh1c', 14, 14, 1),
(46, 'Kira Shikai', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Kira/eqogltgd26attwakzrxj', 14, 14, 1),
(47, 'Komamura Tapat', 1, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Komamura/opt8fho8dke2r9xwmidp', 15, 15, 1),
(48, 'Komamura Destapat', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Komamura/zstjqiv7l8ooq7ordnds', 15, 15, 1),
(49, 'Komamura Hado', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Komamura/d1hdx7mlxq7bfpsmr0cx', 15, 15, 1),
(50, 'Kon', 1, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Kon/u1rqlogngtfvqhhsiyhx', 16, 16, 1),
(51, 'Kotetsu', 1, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Kotetsu/xvikwag2y8nbesoyjzgv', 17, 17, 1),
(52, 'Kotetsu Hado', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Kotetsu/lhjxevisvseaaoivwswt', 17, 17, 1),
(53, 'Kyoraku', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Kyoraku/p5e0unfump5ltkduwm8p', 18, 18, 1),
(54, 'Kyoraku Shikai', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Kyoraku/vpvr4kq5qn8atfkcmk7o', 18, 18, 1),
(55, 'Kyoraku Atacant', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Kyoraku/cvulrirygiidghyliw7y', 18, 18, 1),
(56, 'Lisa Shinigami', 1, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Lisa/oxxyjfjdnpwhzf9fafx0', 19, 19, 1),
(57, 'Lisa Shikai', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Lisa/hqkissv10rmm4z36g1mm', 19, 19, 1),
(58, 'Lisa Vanisher', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Lisa/uslcepal2dqvidnz521g', 19, 19, 1),
(59, 'Love Shikai', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Love/ocumrdqbxbtlwyueivje', 20, 20, 1),
(60, 'Love Shikai Vanisher', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Love/r3rzgidtogexzkekgfel', 20, 20, 1),
(61, 'Love Bankai', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Love/ib1jeud5udivmyhdmnn9', 20, 20, 1),
(62, 'Mashiro Shinigami', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Mashiro/ojxmbtwlqkhskqk79c9i', 21, 21, 1),
(63, 'Mashiro Kick', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Mashiro/t1fhh6aahxfif5u9zcfg', 21, 21, 1),
(64, 'Mashiro Explosion', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Mashiro/irepyvys2vag6whllrxa', 21, 21, 1),
(65, 'Matsumoto', 1, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Matsumoto/v68fygtlhh1lty02lje2', 22, 22, 1),
(66, 'Matsumoto Shikai', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Matsumoto/ok5ht45qpxlcbafubemq', 22, 22, 1),
(67, 'Mayuri', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Mayuri/vmmxgl2b04bw2citblwl', 23, 23, 1),
(68, 'Mayuri Shikai', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Mayuri/whthdefvhhc6ryyteojw', 23, 23, 1),
(69, 'Mayuri Veneno', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Mayuri/vmlpq9tatkppv47bqtfs', 23, 23, 1),
(70, 'Mayuri Bankai', 4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Mayuri/bf598rhvrkndjrfybawh', 23, 23, 1),
(71, 'Nel Petita', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Nel/dq92dkb3jzdahkw0ftax', 24, 24, 1),
(72, 'Nel Gran amb Funda', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Nel/hhr17pqthbqczoko2iry', 24, 24, 1),
(73, 'Nel Gran', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Nel/mpopbeetzhzekqcwwxft', 24, 24, 1),
(74, 'Orihime', 1, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Orihime/hat2nzizd5m8bhbilkct', 25, 25, 1),
(75, 'Orihime Estudiant', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Orihime/h2gzefbsf35xtnsx6fnu', 25, 25, 1),
(76, 'Orihime Atacant', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Orihime/rdzkexszvis4qzafba8f', 25, 25, 1),
(77, 'Orihime Escut', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Orihime/osghj51xq5mmigr5wfpn', 25, 25, 1),
(78, 'Peshe', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Pesche/qkdqja0dcd6ss2dxv5pu', 26, 26, 1),
(79, 'Renji', 1, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Renji/mkvclgg8eqgyoywbl2cs', 27, 27, 1),
(80, 'Renji Shikai', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Renji/jyvwafy3fugim1otawdz', 27, 27, 1),
(81, 'Renji Bankai', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Renji/g724eqoho0ykrfp8fphu', 27, 27, 1),
(82, 'Renji Bankai Dispar', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Renji/zgh7rqeahmdmhloddqrz', 27, 27, 1),
(83, 'Rukia', 1, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Rukia/fcpkzkzatzgahcm239bo', 28, 28, 1),
(84, 'Rukia Shikai', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Rukia/gfnwonqul5qs1sy886ts', 28, 28, 1),
(85, 'Rukia Shikai Capa', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Rukia/e1tvpo0lxdcaywdudypx', 28, 28, 1),
(86, 'Rukia Shikai Vent', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Rukia/cejqcwiimx7lubgrmf9h', 28, 28, 1),
(87, 'Rukia Bankai', 4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Rukia/qqwu0oodurq3dszkxi3c', 28, 28, 1),
(88, 'Shinji', 1, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Shinji/cucifqxd8qdiwoldjguh', 29, 29, 1),
(89, 'Shinji Boina', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Shinji/qmcbolitojgmjzg3elg4', 29, 29, 1),
(90, 'Shinji Vanisher', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Shinji/mdoq2oxsrkl1rproydz4', 29, 29, 1),
(91, 'Shinji Shikai', 4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Shinji/ovd5zcftxu9dwso7fccx', 29, 29, 1),
(92, 'Soi Fon', 1, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Soi%20Fon/ial3gs8g1powpbzhvjde', 30, 30, 1),
(93, 'Soi Fon Shikai', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Soi%20Fon/nw7blyxfr6bu47wx52gb', 30, 30, 1),
(94, 'Soi Fon Bankai', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Soi%20Fon/vwqgvpbcpdvv3bupgsdg', 30, 30, 1),
(95, 'Tosen Bo Postura', 1, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Tosen/mughxlivodxmirvk4di2', 31, 31, 1),
(96, 'Tosen Bo Gira Espassa', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Tosen/soditvigiwx61acnqsih', 31, 31, 1),
(97, 'Tosen Bo Cercle', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Tosen/xidcguayuufhyq1d1k1e', 31, 31, 1),
(98, 'Ukitake Espassa', 1, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Ukitake/hmaz4lsy16lrlyuwjve0', 32, 32, 1),
(99, 'Ukitake Shikai Creuat', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Ukitake/qwnijwyh90mlrj956gln', 32, 32, 1),
(100, 'Ukitake Shikai Vent', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Ukitake/frerxscwueolrzwp9off', 32, 32, 1),
(101, 'Unohana Espassa', 1, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Unohana/sbiwabaxxi3kffibfsjc', 33, 33, 1),
(102, 'Unohana Kido Groc', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Unohana/em1o1s4m8cga6sy7ynof', 33, 33, 1),
(103, 'Unohana Kido Blau', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Unohana/p8dklvrnl1d7buqa8bnu', 33, 33, 1),
(104, 'Urahara Tenda', 1, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Urahara/sugkqhjbwxgl3heipsqz', 34, 34, 1),
(105, 'Urahara Capita', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Urahara/tlovl7bksfvvxdyvzept', 34, 34, 1),
(106, 'Urahara Presio', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Urahara/sklxlr7hernseesvo6du', 34, 34, 1),
(107, 'Urahara Shikai', 4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Urahara/qxdr3jtxhisf8niga5lq', 34, 34, 1),
(108, 'Ushoda Escut Blau', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Ushoda/djo9yesnwsmexoqk05wd', 35, 35, 1),
(109, 'Ushoda Relaxat ', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Ushoda/knw2mtk6npfoczeezd8x', 35, 35, 1),
(110, 'Ushoda Kido', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Ushoda/qscguo7ivox3gc3ofdqd', 35, 35, 1),
(111, 'Yamamoto Puny de Foc', 4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Yamamoto/t5npfrkrygsjppkqcpay', 36, 36, 1),
(112, 'Yamamoto Shikai ', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Yamamoto/vsrrwursumra0w6yhbzo', 36, 36, 1),
(113, 'Yamamoto Capita General', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Yamamoto/i5uheu0i9jdj6n4lhjga', 36, 36, 1),
(114, 'Yoruichi Moix', 1, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Yoruichi/f7yymt7imts3ysmzoinl', 37, 37, 1),
(115, 'Yoruichi', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Yoruichi/lvqyrbelav64ebcwlzma', 37, 37, 1),
(116, 'Yoruichi Capitana', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Yoruichi/ljzopo4bi0uil270ap1y', 37, 37, 1),
(117, 'Yoruichi Shunko', 4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Yoruichi/wwp7hs3de88ugjh9numn', 37, 37, 1),
(118, 'Yumichika', 1, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Yumichika/cfcrospepuva0wanfg9s', 38, 38, 1),
(119, 'Yumichika Bankai', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Yumichika/lzggo85qttyfa69ekxdp', 38, 38, 1),
(120, 'Aaroniero', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Aaroniero/z4fqfamh5v25zxqipm9o', 40, 39, 2),
(121, 'Aaroniero Transformat', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Aaroniero/b4x6ywbhdv4hcffp1n8k', 40, 39, 2),
(122, 'Abirama', 1, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Abirama/rky6xagsypmdrlbak79x', 41, 40, 2),
(123, 'Apache', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Apache/jofucklkergpd7g0b7p0', 42, 41, 2),
(124, 'Barragan', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Barragan/zz4aenpngmwbkjy0y85i', 43, 42, 2),
(125, 'Barragan Mort', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Barragan/mkljvu1vgctyp7htgya6', 43, 42, 2),
(126, 'Barragan Destral', 4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Barragan/w46mpcryjchzfntldalc', 43, 42, 2),
(127, 'Barragan Peste', 4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Barragan/nypa6hkykd9gz6ioh89w', 43, 42, 2),
(128, 'Coyote', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Coyote/jeaf2suejhl6wkpbzgi5', 44, 43, 2),
(129, 'Coyote Zero', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Coyote/jyosrh7etllhqidjrord', 44, 43, 2),
(130, 'Coyote Pistoles', 4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Coyote/pakfb97dwux6g7mrd51h', 44, 43, 2),
(131, 'Coyote Llops', 4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Coyote/ffivfwd6ti3jzxfaqxg4', 44, 43, 2),
(132, 'Gin Dolent', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Gin/iiyoajmv8i5xjiq9aw6v', 6, 6, 2),
(133, 'Gin Dolent Bankai', 4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Gin/s3xov08jmket3ndqwazi', 6, 6, 2),
(134, 'Gin Assegut', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Gin/nebvojudeqkazcvqj9ia', 6, 6, 2),
(135, 'Granz', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Granz/pqyrdei9n8ukhuokfaho', 45, 44, 2),
(136, 'Granz Veneno', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Granz/wblfro1adjr0lm2gp7bj', 45, 44, 2),
(137, 'Granz Alliberat', 4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Granz/hvqt6g5r2uf4cjvzoiac', 45, 44, 2),
(138, 'Grimmjow', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Grimmjow/lxry8jglgipqx7wd2tbd', 46, 45, 2),
(139, 'Grimmjow Zero', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Grimmjow/zzpvwdzah2ub1parkguq', 46, 45, 2),
(140, 'Grimmjow Espasa', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Grimmjow/nyp7ujcbhap05s6wherw', 46, 45, 2),
(141, 'Grimmjow Pantera', 4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Grimmjow/bsprj66lchcpht3rmche', 46, 45, 2),
(142, 'Halibel', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Halibel/xm9ur0fotmq7dzu79fam', 47, 46, 2),
(143, 'Halibel Espasa', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Halibel/fbqruu6azsmhkxrcnzhi', 47, 46, 2),
(144, 'Halibel Alliberada', 4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Halibel/on9nbuxkcie02czeje1i', 47, 46, 2),
(145, 'Lilynette', 1, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Lilynette/hhfijgqiwp6djy55q2jr', 48, 47, 2),
(146, 'Lilynette Espasa', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Lilynette/uvmy8vtmllrlcnunpzuy', 48, 47, 2),
(147, 'Loly', 1, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Loly/poei8w1ogzpwdrnkefhi', 49, 48, 2),
(148, 'Menos Grande', 1, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/MenosGrande/haug5adpwltg2bfqogq4', 50, 49, 2),
(149, 'Mila', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Mila/jkuaig2bwr2qkli06kte', 51, 50, 2),
(150, 'Nnoitra', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Nnoitra/eoshvimsvakiuezpqzle', 52, 51, 2),
(151, 'Nnoitra Espasa', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Nnoitra/e4voegzvrwdykzicsm0u', 52, 51, 2),
(152, 'Nnoitra Alliberat', 4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Nnoitra/bxenfpm3hpunw9ykgvoz', 52, 51, 2),
(153, 'Tosen Dolent Zero', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Tosen/tgjcg2fydydej35o80n6', 31, 31, 2),
(154, 'Tosen Mosca', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Tosen/mbrjfxqbaxbabnx4iulo', 31, 31, 2),
(155, 'Ulquiorra', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Ulquiorra/puiabnvbiheqd817nx7g', 53, 52, 2),
(156, 'Ulquiorra Murcielago', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Ulquiorra/t7mbiao8md17uvw9xjc4', 53, 52, 2),
(157, 'Ulquiorra Murcielago 2', 4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Ulquiorra/gglou6tdqfapflmkizz2', 53, 52, 2),
(158, 'Wonderweiss', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Wonderweiss/za8tndaznj9jmkdnjeig', 54, 53, 2),
(159, 'Wonderweiss Alliberat', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Wonderweiss/i5wtzpxes3hsyfbfcjoq', 54, 53, 2),
(160, 'Yammy', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Yammy/dhf6otsziwifxd0cdmkv', 55, 54, 2),
(161, 'Yammy Pegant', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Yammy/wmgdq8qfeme8qwkzw736', 55, 54, 2),
(162, 'Zommari', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Zommari/rnp3gbuo4v9trnfwcwbt', 56, 55, 2),
(163, 'Zommari Alliberat', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/ENEMICS/Zommari/bpd4zlcbiwdoob8vpotu', 56, 55, 2),
(168, 'Riruka', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Riruka/d2cqpyghyjainwvwbxyl', 75, 56, 1),
(169, 'Ichibe', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Ichibe/umyyzs5ilqczucgzezdq', 77, 57, 1),
(170, 'Ichibe Bankai', 4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Ichibe/bnsgarccjnxtqjm295rr', 77, 57, 1),
(171, 'Kirio', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Kirio/tijsjn9j9xd2rvtrijcn', 78, 58, 1),
(172, 'Kirio Prima', 4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Kirio/b9v3yntnjf98uro6lnes', 78, 58, 1),
(173, 'Chojiro Jove', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Chojiro/w9zmgxnayzpioju1cmfz', 81, 59, 1),
(174, 'Chojiro Bankai', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Chojiro/mzockhr11y46b9q0i1kr', 81, 59, 1),
(175, 'Ryuken', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Ryuken/cf8rlvm3ycygpodlxnjq', 82, 60, 0),
(176, 'Ryuken Disparant', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Ryuken/uwkpqzpdbt1phzsl6833', 82, 60, 0),
(177, 'Isshin', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/1602-c2759e22-b290-43cd-96e6-029d767ae5ff_pcgrfa', 85, 61, 1),
(178, 'Isshin Jove', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/Isshin_varphb', 85, 61, 1),
(179, 'Yachiru', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/umnzcpgkgmwa9hetrph7-Photoroom_g3cmlw', 86, 62, 1),
(180, 'Rose', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Rojuro/jc8svrcedkeuzvsjjqnb', 87, 63, 1),
(181, 'Rose Capità', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Rojuro/xabdnbudi5vlruejguoz', 87, 63, 1),
(182, 'Oh-Etsu', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Oh/rhsbfqurkkw88sdznoy2', 74, 64, 1),
(183, 'Oh-Etsu Apuntant', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Oh/ok2qfmhorvomfknrsw8g', 74, 64, 1),
(184, 'Kugo Ginjo', 1, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Ginjo/zpdkeobxyiapo3g0icul', 88, 65, 1),
(185, 'Jackie', 1, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Jackie/snbcrydraiz7fogz5k2a', 89, 66, 1),
(186, 'Senjumaru', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Senjumaru/wodwuihdrht5uvfb6bof', 61, 67, 1),
(187, 'Senjumaru Bankai', 4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Senjumaru/fpts8za3sj5g0mg8y5ls', 61, 67, 1),
(188, 'Tsukushima', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Tsukishima/qlyfi5q8tb6ld8nndvsi', 61, 68, 1),
(189, 'Äs Nödt', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/QUINCIES/%C3%84s/bvvvmxpbin8ebq9xby4b', 68, 69, 0),
(190, 'Äs Nödt Vollständig', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/QUINCIES/%C3%84s/jgv7o7nrjsqhzd7gtzqk', 68, 69, 0),
(191, 'Askin Nakk', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/QUINCIES/Askin/khxjkqjagkpb63ep3bn4', 63, 70, 0),
(192, 'Askin Nakk Vollständig', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/QUINCIES/Askin/vlthbbfnc73ay11fgjlq', 63, 70, 0),
(193, 'Bambietta', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/QUINCIES/Bambietta/kxc1alqgvd5jjbl86vrf', 71, 71, 0),
(194, 'Bambietta Zombie', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/QUINCIES/Bambietta/zdguqfn13vw1l0eqxxpp', 71, 71, 0),
(195, 'Bambietta Vollständig', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/QUINCIES/Bambietta/k77al6frtj403dmj2jqe', 71, 71, 0),
(196, 'Bazz B', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/QUINCIES/Bazz/kqvlyunjovj6t0aqxqjd', 60, 72, 0),
(197, 'Bazz B Full Fingers', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/QUINCIES/Bazz/c5q6nbtlafaisf2wxtyu', 60, 72, 0),
(198, 'Candice Catnipp', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/QUINCIES/Candice/skczqrehyfdmdmtf4ywx', 73, 73, 0),
(199, 'Candice Catnipp Vollständig', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/QUINCIES/Candice/zqdcmdadg7r3ludglkhf', 73, 73, 0),
(200, 'Cang Du', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/QUINCIES/Cang/hie7l7opbuldfdyrfxa9', 66, 74, 0),
(201, 'Driscoll Berci', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/QUINCIES/Driscoll/v0xr7i1e5pedbrdnjmx4', 91, 75, 0),
(202, 'Asguiaro Ebern', 1, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/QUINCIES/Ebern/b80af2bvhelszgkgjr4o', 79, 76, 0),
(203, 'Giselle Gewelle', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/QUINCIES/Giselle/voob2mlq5abrctalgtf3', 70, 77, 0),
(204, 'Gremmy Thoumeaux', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/QUINCIES/Gremmy/p96fd1a2hkf4wjlxahv9', 62, 78, 0),
(205, 'Jugram Haschwalth', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/QUINCIES/Haschwalth/duvwjyeccwe0fcb6uadh', 84, 79, 0),
(206, 'Ishida Uryu Casual', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/QUINCIES/Ishida/ubi5tilwfecswzn5jj6t', 11, 10, 0),
(207, 'Ishida Uryu Wandenreich', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/QUINCIES/Ishida/tfygiq7v3qy9xxtx1wfm', 11, 10, 0),
(208, 'Lille Barro', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/QUINCIES/Lille/auw6mfgdb7ms3g2vrbca', 83, 80, 0),
(209, 'Masaki Kurosaki', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/v1746785657/tue4iezc9btwsgsdtosq_1_zehtwe.png', 65, 81, 0),
(210, 'Masaki Kurosaki Salvadora', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/QUINCIES/Masaki/me9yuoctsjzbemrlbrsw', 65, 81, 0),
(211, 'Mask The Masculine Vollständig', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/QUINCIES/Mask/ef6ovwi0e0ersvysb154', 69, 82, 0),
(212, 'Meninas McAllon', 2, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/QUINCIES/Meninas/imk07gcsuroiivezcyfd', 64, 83, 0),
(213, 'Quilge Opie Vollständig', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/Quilge_wsdzqa', 80, 84, 0),
(214, 'Robert Accutrone', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/QUINCIES/Robert/z2ztxxncecus5quikvo4', 72, 85, 0),
(215, 'Yhwach', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/QUINCIES/Yhwach/amkhwjik4yrm7wvcr27d', 76, 86, 0),
(216, 'Yhwach Mimihagi', 4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/QUINCIES/Yhwach/o7xvpxgtztce5kd9ptum', 76, 86, 0),
(217, 'Yhwach Forma Final', 4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/QUINCIES/Yhwach/ttel7lbvd7ido3idj0mx', 76, 86, 0),
(218, 'Ichigo (TYBW)', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Ichigo/chm3gmbhkr0cfs2rvsoa', 9, 9, 1),
(219, 'Aizen (TYBW)', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/Aizen_widrun', 1, 1, 1),
(220, 'Aizen Yokoso', 4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Aizen/mcy89hsxtcofcia60ih1', 1, 1, 1),
(221, 'Byakuya (TYBW)', 4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Byakuya/lng0sjfoezjp1nzhi43m', 2, 2, 1),
(222, 'Chad (TYBW)', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Chad/flfav7oj36qcmvrzamuw', 3, 3, 1),
(223, 'Hitsugaya (TYBW)', 4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Hitsugaya/df4s4jpnhy7duinkxwzy', 7, 7, 1),
(224, 'Kenpachi (TYBW)', 4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Kenpachi/qsoalvsqma6ow3pnclxv', 12, 12, 1),
(225, 'Kensei (TYBW)', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Kensei/mma1qegvfk7rtonlmhlx', 13, 13, 1),
(226, 'Komamura (TYBW)', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Komamura/ufqqephomdzzxofqk6ld', 15, 15, 1),
(227, 'Kyoraku (TYBW)', 4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Kyoraku/fsq17erebpe3qtzfd8kd', 18, 18, 1),
(228, 'Matsumoto (TYBW)', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Matsumoto/jctfzqmdyrnlm73lfgpi', 22, 22, 1),
(229, 'Mayuri (TYBW)', 4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Mayuri/qoplkypymlzm4y9kn4wk', 23, 23, 1),
(230, 'Orihime (TYBW)', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Orihime/yxdkjutvr3evuge5i6v0', 25, 25, 1),
(231, 'Renji (TYBW)', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Renji/qme4l4ccqifbchgcs7wy', 27, 27, 1),
(232, 'Rukia (TYBW)', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Rukia/cefqjbk5jbqmj0yysquz', 28, 28, 1),
(233, 'Shinji (TYBW)', 4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Shinji/d7ek3buozorlpv1toxou', 29, 29, 1),
(234, 'Soi Fon (TYBW)', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Soi%20Fon/drid6bnisiz5vmjxqy4m', 30, 30, 1),
(235, 'Unohana (TYBW)', 4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Unohana/mlwx4dnqasfv5a9nq0jh', 33, 33, 1),
(236, 'Urahara (TYBW)', 4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/sixqptqwrpttabqbpvrt_1_yqypbw', 34, 34, 1),
(237, 'Yamamoto (TYBW)', 4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/c9uu12carjc9rscmuvyi_1_r1f4n7', 36, 36, 1),
(238, 'Yamamoto (Jove)', 4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/cqqnmc0mn47tco4knvjo-Photoroom_zzyzkd', 36, 36, 1),
(239, 'Yoruichi (TYBW)', 4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/a4b2dxwxzz7trkshowq6_1_lz0mqn', 37, 37, 1),
(240, 'Tenjiro', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Tenjiro/tmeiyejytrqxqddmjg6z', 92, 87, 0),
(241, 'Tenjiro Bankai', 4, 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/PERSONATGES/Tenjiro/zlg0m76pvwdargytnyzw', 92, 87, 0);

-- No cal SET IDENTITY_INSERT a MySQL

-- Inserts de les Skins amb les ARMES
INSERT INTO SKINS_ARMES (skin, arma) VALUES
(1, 10),
(2, 10),
(3, 11),
(4, 11),
(5, 11),
(6, 11),
(7, 13),
(8, 14),
(9, 14),
(10, 15),
(11, 16),
(12, 16),
(13, 16),
(14, 16),
(15, 17),
(16, 18),
(17, 18),
(18, 19),
(19, 20),
(20, 22),
(21, 24),
(22, 24),
(23, 25),
(24, 25),
(25, 25),
(26, 26),
(27, 26),
(28, 27),
(29, 28),
(30, 28),
(31, 28),
(32, 29),
(33, 30),
(34, 31),
(35, 32),
(36, 32),
(37, 32),
(38, 32),
(39, 33),
(40, 34),
(41, 35),
(42, 36),
(43, 37),
(44, 38),
(45, 39),
(46, 40),
(47, 41),
(48, 42),
(49, 43),
(50, 44),
(51, 45),
(52, 45),
(53, 46),
(54, 47),
(55, 48),
(56, 49),
(57, 49),
(58, 49),
(59, 50),
(60, 51),
(61, 51),
(62, 52),
(63, 52),
(64, 52),
(65, 53),
(66, 54),
(67, 55),
(68, 56),
(69, 57),
(70, 57),
(71, 58),
(72, 58),
(73, 58),
(74, 59),
(75, 59),
(76, 59),
(77, 59),
(78, 60),
(79, 61),
(80, 62),
(81, 63),
(82, 63),
(83, 64),
(84, 65),
(85, 65),
(86, 66),
(87, 66),
(88, 67),
(89, 68),
(90, 68),
(91, 68),
(92, 69),
(93, 70),
(94, 71),
(95, 72),
(96, 73),
(97, 74),
(98, 75),
(99, 76),
(100, 76),
(101, 77),
(102, 78),
(103, 79),
(104, 80),
(105, 81),
(106, 81),
(107, 81),
(108, 82),
(109, 82),
(110, 82),
(111, 83),
(112, 84),
(113, 85),
(114, 86),
(115, 86),
(116, 86),
(117, 86),
(118, 87),
(119, 88);

-- En MySQL no existe SET IDENTITY_INSERT, simplemente insertas con el valor de la PK
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (1, 'Rei d`Il·lusions', 1);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (2, 'Noble dels Mils Pètals', 2);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (3, 'Braç del Gegant', 3);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (4, 'Guardià d`en Bawabawa', 4);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (5, 'Bandarra del Clan Shiba', 5);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (6, 'Serp Traïdora', 6);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (7, 'Drac Gelat', 7);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (8, 'Petita lluitadora', 8);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (9, 'Shinigami Substitut', 9);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (10, 'Calb amb Orgull', 10);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (11, 'L`Últim Quincy', 11);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (12, 'Dimoni del Combat', 12);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (13, 'Puny de Plata', 13);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (14, 'Pes de la Mort', 14);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (15, 'Cor Inmmortal', 15);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (16, 'Peluix Pervertit', 16);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (17, 'Mà Curadora', 17);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (18, 'Sake i Espasa', 18);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (19, 'Lectora Letal', 19);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (20, 'Cor en Flames', 20);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (21, 'Heroína Esmeralda', 21);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (22, 'Tempesta de Cendra', 22);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (23, 'Mestre de l`Horror Científic', 23);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (24, 'Espasa Benevolenta', 24);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (25, 'Escut Celestial', 25);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (26, 'Cavaller Absurd', 26);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (27, 'Serp Escarlata del Seretei', 27);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (28, 'Fred Gelat', 28);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (29, 'Somriure de l`Inrevés', 29);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (30, 'Velocitat Destructora', 30);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (31, 'Justicia Cega', 31);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (32, 'Escollit pel Cel, Condemnat per la Carn', 32);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (33, 'El Primer Kenpachi', 33);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (34, 'Genialitat amb Sandàlies', 34);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (35, 'Mestre del Kido', 35);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (36, 'Foc Etern del Gotei', 36);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (37, 'Deesa del Shunpo', 37);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (38, 'Elegància Mortal', 38);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (39, 'Imitador Letal', 40);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (40, 'Arrancar del Vendaval', 41);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (41, 'Arrancar Alpha', 42);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (42, 'Rei del Hueco Mundo', 43);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (43, 'Dormint amb Pistoles', 44);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (44, 'Anàlisi Mortal', 45);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (45, 'Instint Pur', 46);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (46, 'Tempesta Silenciosa', 47);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (47, 'Mitja Ànima de Starrk', 48);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (48, 'Rencor d`Arrancar', 49);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (49, 'Menos Grande', 50);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (50, 'Força i Furia', 51);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (51, 'El Despreciador', 52);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (52, 'El Buit Etern', 53);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (53, 'Arma sense Paraules', 54);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (54, 'Musculatura i Ràbia', 55);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (55, 'Mestre del Control', 56);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (56, 'Dit de Foc', 60);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (57, 'Teixidora del Destí', 61);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (58, 'Imaginació Letal', 62);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (59, 'Covard de la Mort', 63);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (60, 'Força Daurada', 64);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (61, 'Llum del Destí Perdut', 65);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (62, 'Acabat en Acer', 66);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (63, 'Dents de Piano', 67);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (64, 'Mort del Terror', 68);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (65, 'Lluitador Enmascarat', 69);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (66, 'Reina dels Cadàvers', 70);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (67, 'Reina de la Detonació', 71);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (68, 'Pistoler Expert', 72);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (69, 'Elèctrica i Mortal', 73);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (70, 'Forjador de Zanpakutos', 74);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (71, 'Encant Fatal', 75);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (72, 'Pare dels Quincies', 76);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (73, 'Talla Noms', 77);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (74, 'Cuinera Espiritual', 78);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (75, 'Arrancar Experimental', 79);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (76, 'L`Inquisidor', 80);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (77, 'Llamp Fulminant', 81);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (78, 'Quincy Renegat', 82);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (79, 'Francotirador Expert', 83);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (80, 'Segon del Wandereich', 84);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (81, 'Pare de l`Any', 85);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (82, 'Somriure Assassí', 86);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (83, 'Melodía del Terror', 87);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (84, 'Fullbringer Trencat', 88);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (85, 'Motor de Fang', 89);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (86, 'Amic Traïdor', 90);
INSERT INTO TITOLS (id, nom_titol, personatge) VALUES (87, 'Gegant Implacable', 91);

-- Per inserir explícitament en una columna AUTO_INCREMENT a MySQL, s'usa:
INSERT INTO USUARIS (id, nom, email, contrassenya, punts_emmagatzemats, tipo, imatgeperfil)
VALUES
(60, 'Grimmjow', 'mandibulagorda@gmail.com', '$2b$10$qqq0nZ7sXVx7nBlh0Nom0ehfJTsOklAsFrCjKOpTow/FQISXKN/4W', 1550, 1, NULL),
(66, 'Miquel', 'miquelsanso@paucasesnovescifp.cat', '$2b$10$sqc5WLCVm5WytdjoJfX2cuKqWTO63eouPjMQD..sOdugAxqu1IQAG', 95184, 0, 5),
(70, 'Angel', 'angelrubiooliver@gmail.com', '$2b$10$E8LtSnH8Xb6uRhCvl18Csu.VYBc8dXn.aVCXrK12nJB6PGb5uQdCa', 0, 0, NULL),
(71, 'aaa', 'angelrubio@paucasdsnovescifp.cat', '$2a$10$VrlX3pzyJwTVFPLISCotrulnypkPXpPXgvUKoX6KjUhZaOdYiu3s6', 0, 0, NULL),
(72, 'Shadowi', 'angelrubiooliber@gmail.com', '$2b$10$ZTdlPAcSr94L5M/ilcgca.E50EMcP8TZN71zKjGtmU197ZLDl2FOO', 0, 0, NULL),
(73, 'Clanimore', 'albertgalan@paucasesnovescifp.cat', '$2b$10$2tGBk0fdNFDWhtxfaleZOuzVUwh4wIZv2FULERfvaBZccU1t5Svp6', 0, 0, NULL),
(74, 'Clani', 'clani@gmail.com', '$2b$10$NLuZFVi547TquS4NcXnKauVLBl0Ccg2.MJCT/aEX1GctinVe0wS8i', 1200, 0, 5),
(75, 'Prova_perfil', 'prova@gmail.com', '$2b$10$pgg1CeQTUSCA0EkcozY8FO1H1CtexGJBCT5STJaRe47fiuStwcSp6', 100, 0, NULL);
-- Úniques claus a ARMES (nom)
ALTER TABLE ARMES ADD UNIQUE INDEX UQ_ARMES_NOM (nom);

-- Úniques claus a BIBLIOTECA (user_id, personatge_id)
ALTER TABLE BIBLIOTECA ADD UNIQUE INDEX UQ_BIBLIOTECA_USER_PERSONATGE (user_id, personatge_id);

-- Úniques claus a HABILITAT_LLEGENDARIA (nom)
ALTER TABLE HABILITAT_LLEGENDARIA ADD UNIQUE INDEX UQ_HABILITAT_LLEGENDARIA_NOM (nom);

-- Úniques claus a PERSONATGES (nom)
ALTER TABLE PERSONATGES ADD UNIQUE INDEX UQ_PERSONATGES_NOM (nom);

-- Úniques claus a SKINS (nom)
ALTER TABLE SKINS ADD UNIQUE INDEX UQ_SKINS_NOM (nom);

-- Úniques claus a USUARI_SKIN_ARMES (usuari, skin)
ALTER TABLE USUARI_SKIN_ARMES ADD UNIQUE INDEX UQ_USUARI_SKIN_ARMES_USUARI_SKIN (usuari, skin);

-- Úniques claus a USUARIS (email)
ALTER TABLE USUARIS ADD UNIQUE INDEX UQ_USUARIS_EMAIL (email);

-- Úniques claus a USUARIS (nom)
ALTER TABLE USUARIS ADD UNIQUE INDEX UQ_USUARIS_NOM (nom);

-- Afegir valors per defecte

ALTER TABLE ARMES ALTER buff_atac SET DEFAULT 0;

ALTER TABLE BIBLIOTECA 
MODIFY data_obtencio TIMESTAMP DEFAULT CURRENT_TIMESTAMP;


ALTER TABLE ENEMICS ALTER punts_donats SET DEFAULT 0;

ALTER TABLE MISSIONS ALTER tipus_missio SET DEFAULT 0;

ALTER TABLE MISSIONS ALTER fixa SET DEFAULT 0;

ALTER TABLE MISSIONS_DIARIES
MODIFY data_assig TIMESTAMP DEFAULT CURRENT_TIMESTAMP;


ALTER TABLE MISSIONS_DIARIES ALTER completada SET DEFAULT 0;

ALTER TABLE PERFIL_USUARI ALTER partides_jugades SET DEFAULT 0;

ALTER TABLE PERFIL_USUARI ALTER partides_guanyades SET DEFAULT 0;

ALTER TABLE USUARIS ALTER punts_emmagatzemats SET DEFAULT 0;

ALTER TABLE USUARIS ALTER tipo SET DEFAULT 0;

-- Clau forànies

ALTER TABLE BIBLIOTECA
  ADD CONSTRAINT FK_BIBLIOTECA_PERSONATGES FOREIGN KEY (personatge_id) REFERENCES PERSONATGES(id) ON DELETE CASCADE,
  ADD CONSTRAINT FK_BIBLIOTECA_USUARIS FOREIGN KEY (user_id) REFERENCES USUARIS(id) ON DELETE CASCADE;

ALTER TABLE ENEMICS
  ADD CONSTRAINT FK_ENEMICS_PERSONATGES FOREIGN KEY (personatge_id) REFERENCES PERSONATGES(id) ON DELETE CASCADE;

ALTER TABLE HABILITAT_LLEGENDARIA
  ADD CONSTRAINT FK_HABILITAT_SKINS FOREIGN KEY (skin_personatge) REFERENCES SKINS(id);

ALTER TABLE MISSIONS_ARMES
  ADD CONSTRAINT FK_MISSIONS_ARMES_MISSIONS FOREIGN KEY (missio) REFERENCES MISSIONS(id),
  ADD CONSTRAINT FK_MISSIONS_ARMES_ARMES FOREIGN KEY (arma) REFERENCES ARMES(id);

ALTER TABLE MISSIONS_COMPLETADES
  ADD CONSTRAINT FK_MISSIONS_COMPLETADES_MISSIONS FOREIGN KEY (missio) REFERENCES MISSIONS(id),
  ADD CONSTRAINT FK_MISSIONS_COMPLETADES_USUARIS FOREIGN KEY (usuari) REFERENCES USUARIS(id);

ALTER TABLE MISSIONS_DIARIES
  ADD CONSTRAINT FK_MISSIONS_DIARIES_MISSIONS FOREIGN KEY (missio) REFERENCES MISSIONS(id),
  ADD CONSTRAINT FK_MISSIONS_DIARIES_USUARIS FOREIGN KEY (usuari) REFERENCES USUARIS(id);

ALTER TABLE MISSIONS_TITOLS
  ADD CONSTRAINT FK_MISSIONS_TITOLS_MISSIONS FOREIGN KEY (missio) REFERENCES MISSIONS(id),
  ADD CONSTRAINT FK_MISSIONS_TITOLS_TITOLS FOREIGN KEY (titol) REFERENCES TITOLS(id);

ALTER TABLE PERFIL_USUARI
  ADD CONSTRAINT FK_PERFIL_USUARI_PERSONATGES FOREIGN KEY (personatge_preferit) REFERENCES PERSONATGES(id),
  ADD CONSTRAINT FK_PERFIL_USUARI_SKINS FOREIGN KEY (personatge_preferit) REFERENCES SKINS(id),
  ADD CONSTRAINT FK_PERFIL_USUARI_USUARIS FOREIGN KEY (usuari) REFERENCES USUARIS(id);

ALTER TABLE SKINS
  ADD CONSTRAINT FK_SKINS_ATACS FOREIGN KEY (atac) REFERENCES ATACS(id),
  ADD CONSTRAINT FK_SKINS_PERSONATGES FOREIGN KEY (personatge) REFERENCES PERSONATGES(id);

ALTER TABLE SKINS_ARMES
  ADD CONSTRAINT FK_SKINS_ARMES_ARMES FOREIGN KEY (arma) REFERENCES ARMES(id) ON DELETE CASCADE,
  ADD CONSTRAINT FK_SKINS_ARMES_SKINS FOREIGN KEY (skin) REFERENCES SKINS(id) ON DELETE CASCADE;

ALTER TABLE TITOLS
  ADD CONSTRAINT FK_TITOLS_PERSONATGES FOREIGN KEY (personatge) REFERENCES PERSONATGES(id);

ALTER TABLE USUARI_SKIN_ARMES
  ADD CONSTRAINT FK_USUARI_SKIN_ARMES_PERSONATGES FOREIGN KEY (personatge) REFERENCES PERSONATGES(id),
  ADD CONSTRAINT FK_USUARI_SKIN_ARMES_USUARIS FOREIGN KEY (usuari) REFERENCES USUARIS(id),
  ADD CONSTRAINT FK_USUARI_SKIN_ARMES_ARMES FOREIGN KEY (arma) REFERENCES ARMES(id),
  ADD CONSTRAINT FK_USUARI_SKIN_ARMES_SKINS FOREIGN KEY (skin) REFERENCES SKINS(id);

ALTER TABLE USUARIS
  ADD CONSTRAINT FK_USUARIS_AVATARS FOREIGN KEY (imatgeperfil) REFERENCES AVATARS(id);

ALTER TABLE USUARIS_ARMES
  ADD CONSTRAINT FK_USUARIS_ARMES_USUARIS FOREIGN KEY (usuari) REFERENCES USUARIS(id),
  ADD CONSTRAINT FK_USUARIS_ARMES_ARMES FOREIGN KEY (arma) REFERENCES ARMES(id);

ALTER TABLE USUARI_SKIN_ARMES ADD seleccionat BOOLEAN DEFAULT FALSE;