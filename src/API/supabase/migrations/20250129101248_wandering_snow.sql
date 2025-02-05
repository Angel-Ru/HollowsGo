-- Crear la base de dades si no existeix
CREATE DATABASE IF NOT EXISTS events_db;
USE events_db;

-- Taula d'Usuaris
CREATE TABLE Users (
  id CHAR(36) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  role ENUM('ADMIN', 'USER') DEFAULT 'USER',
  createdAt DATETIME NOT NULL,
  updatedAt DATETIME NOT NULL
);

-- Taula d'Esdeveniments
CREATE TABLE Events (
  id CHAR(36) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  date DATETIME NOT NULL,
  location VARCHAR(255) NOT NULL,
  capacity INT NOT NULL,
  createdAt DATETIME NOT NULL,
  updatedAt DATETIME NOT NULL,
  CHECK (capacity >= 1)
);

-- Taula d'Inscripcions
CREATE TABLE Registrations (
  id CHAR(36) PRIMARY KEY,
  status ENUM('PENDING', 'CONFIRMED', 'CANCELLED') DEFAULT 'PENDING',
  UserId CHAR(36),
  EventId CHAR(36),
  createdAt DATETIME NOT NULL,
  updatedAt DATETIME NOT NULL,
  FOREIGN KEY (UserId) REFERENCES Users(id) ON DELETE CASCADE,
  FOREIGN KEY (EventId) REFERENCES Events(id) ON DELETE CASCADE
);