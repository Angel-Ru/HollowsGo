CREATE TABLE USERS(
	id int PRIMARY KEY AUTO_INCREMENT,
    nom varchar(50) NOT NULL,
    contrasenya  varchar(255) NOT NULL,
    punts_emmagatzemats int,
    tipo enum('admin','user')
);

CREATE TABLE PERSONATGES (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(50) NOT NULL,
    vida_base DECIMAL(10,2) NOT NULL,
    mal_base DECIMAL(10,2) NOT NULL
);

CREATE TABLE BIBLIOTECA(
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    personatge_id INT NOT NULL,
    data_obtencio DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES USERS(id),
    FOREIGN KEY (personatge_id) REFERENCES PERSONATGES(id)
);

CREATE TABLE ENEMICS (
    id INT PRIMARY KEY,
    personatge_id INT NOT NULL, 
    punts_donats INT,
    musica_combat VARCHAR(255),
    
    FOREIGN KEY (personatge_id) REFERENCES PERSONATGES(id) ON DELETE CASCADE
);

CREATE TABLE SKINS(
	id int PRIMARY KEY AUTO_INCREMENT,
    nom varchar(60) NOT NULL,
	categoria enum('1 estrella','2 estrelles','3 estrelles','4 estrelles') NOT NULL,
    imatge varchar(255),
    personatge int,
    
    FOREIGN KEY(personatge) references personatges(id)
);

CREATE TABLE HABILITAT_LLEGENDARIA(
	id int PRIMARY KEY,
    nom varchar(50) NOT NULL,
    descripcio text NOT NULL,
    video varchar(255) NOT NULL,
    musica_combat varchar(255) NOT NULL
);


CREATE TABLE ARMES(
	id int PRIMARY KEY,
    categoria enum('base','shikai','bankai'),
    buff_atac int
);

CREATE TABLE SKINS_ARMES(
	skin int,
    arma int,
    PRIMARY KEY(skin,arma),
    FOREIGN KEY(skin) references skins(id),
    FOREIGN KEY(arma) references armes(id)
)






