
CREATE TABLE movies (
  movie_id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  release_date DATE,
  duration_minutes INT NOT NULL,
  status ENUM('ACTIVE','INACTIVE') DEFAULT 'ACTIVE'
);

CREATE TABLE languages (
  language_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE genres (
  genre_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE cinemas (
  cinema_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  city VARCHAR(100),
  address VARCHAR(500),
  status ENUM('ACTIVE','INACTIVE') DEFAULT 'ACTIVE'
);

CREATE TABLE screens (
  screen_id INT AUTO_INCREMENT PRIMARY KEY,
  cinema_id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  total_seats INT,
  UNIQUE(cinema_id, name),
  FOREIGN KEY (cinema_id) REFERENCES cinemas(cinema_id)
);

CREATE TABLE shows (
  show_id INT AUTO_INCREMENT PRIMARY KEY,
  movie_id INT NOT NULL,
  screen_id INT NOT NULL,
  start_time DATETIME NOT NULL,
  end_time DATETIME NOT NULL,
  base_price DECIMAL(8,2) DEFAULT 0.00,
  status ENUM('SCHEDULED','CANCELLED','COMPLETED') DEFAULT 'SCHEDULED',
  FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
  FOREIGN KEY (screen_id) REFERENCES screens(screen_id)
);


INSERT INTO movies (title, release_date, duration_minutes) VALUES
  ('Inception', '2010-07-16', 148),
  ('Interstellar', '2014-11-07', 169);

INSERT INTO languages (name) VALUES ('English'), ('Hindi');
INSERT INTO genres (name) VALUES ('Sci-Fi'), ('Drama');

INSERT INTO cinemas (name, city, address) VALUES ('PVR Nexus', 'Sitapur', 'MG Road');
INSERT INTO screens (cinema_id, name, total_seats) VALUES (1, 'Screen 1', 100);

INSERT INTO shows (movie_id, screen_id, start_time, end_time, base_price) VALUES
  (1, 1, '2025-09-24 12:00:00', '2025-09-24 14:30:00', 250.00),
  (2, 1, '2025-09-24 18:00:00', '2025-09-24 21:00:00', 300.00);

-- P2 Query

SELECT
  m.title AS movie_title,
  sc.name AS screen_name,
  TIME(s.start_time) AS show_time
FROM shows s
JOIN movies m ON s.movie_id = m.movie_id
JOIN screens sc ON s.screen_id = sc.screen_id
WHERE sc.cinema_id = :cinema_id
  AND DATE(s.start_time) = :target_date
ORDER BY s.start_time;
