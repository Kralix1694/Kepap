-- ============================================================
-- kepap.sql – MySQL-kompatibles Schema für die Medienverwaltung
-- ============================================================

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS audio;
DROP TABLE IF EXISTS bilder;
DROP TABLE IF EXISTS videos;
DROP TABLE IF EXISTS team_mitglieder;
DROP TABLE IF EXISTS team;
DROP TABLE IF EXISTS user_rollen;
DROP TABLE IF EXISTS `user`;
DROP TABLE IF EXISTS mitglieder;
DROP TABLE IF EXISTS rollen;
DROP TABLE IF EXISTS kategorie;

SET FOREIGN_KEY_CHECKS = 1;

-- ---------- kategorie ----------
CREATE TABLE kategorie (
    kategorie_id INT AUTO_INCREMENT PRIMARY KEY,
    kat_name     VARCHAR(60) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------- rollen ----------
CREATE TABLE rollen (
    rolle_id   INT AUTO_INCREMENT PRIMARY KEY,
    rolle_name VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------- mitglieder ----------
CREATE TABLE mitglieder (
    mitglied_id INT AUTO_INCREMENT PRIMARY KEY,
    vor_name    VARCHAR(80) NOT NULL,
    nach_name   VARCHAR(80) NOT NULL,
    email       VARCHAR(120) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------- user ----------
CREATE TABLE `user` (
    user_id     INT AUTO_INCREMENT PRIMARY KEY,
    mitglied_id INT NOT NULL,
    user_name   VARCHAR(60) NOT NULL UNIQUE,
    passwort    VARCHAR(255) NOT NULL,
    created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_user_mitglied
        FOREIGN KEY (mitglied_id) REFERENCES mitglieder(mitglied_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------- user_rollen (composite PK) ----------
CREATE TABLE user_rollen (
    user_id  INT NOT NULL,
    rolle_id INT NOT NULL,
    PRIMARY KEY (user_id, rolle_id),
    CONSTRAINT fk_ur_user
        FOREIGN KEY (user_id) REFERENCES `user`(user_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_ur_rolle
        FOREIGN KEY (rolle_id) REFERENCES rollen(rolle_id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------- team ----------
CREATE TABLE team (
    team_id   INT AUTO_INCREMENT PRIMARY KEY,
    team_name VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------- team_mitglieder (composite PK) ----------
CREATE TABLE team_mitglieder (
    team_id     INT NOT NULL,
    mitglied_id INT NOT NULL,
    PRIMARY KEY (team_id, mitglied_id),
    CONSTRAINT fk_tm_team
        FOREIGN KEY (team_id) REFERENCES team(team_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_tm_mitglied
        FOREIGN KEY (mitglied_id) REFERENCES mitglieder(mitglied_id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------- videos ----------
CREATE TABLE videos (
    vid_id         INT AUTO_INCREMENT PRIMARY KEY,
    user_id        INT          DEFAULT NULL,
    kategorie_id   INT          DEFAULT NULL,
    titel          VARCHAR(200) NOT NULL,
    beschreibung   TEXT,
    laufzeit       INT          DEFAULT 0 COMMENT 'Sekunden',
    views          INT          DEFAULT 0,
    hochgeladen_am DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_vid_user
        FOREIGN KEY (user_id) REFERENCES `user`(user_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_vid_kat
        FOREIGN KEY (kategorie_id) REFERENCES kategorie(kategorie_id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------- bilder ----------
CREATE TABLE bilder (
    bild_id        INT AUTO_INCREMENT PRIMARY KEY,
    vid_id         INT          DEFAULT NULL,
    kategorie_id   INT          DEFAULT NULL,
    dateipfad      VARCHAR(500) NOT NULL,
    beschreibung   TEXT,
    laufzeit       INT          DEFAULT 0,
    hochgeladen_am DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_bild_vid
        FOREIGN KEY (vid_id) REFERENCES videos(vid_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_bild_kat
        FOREIGN KEY (kategorie_id) REFERENCES kategorie(kategorie_id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------- audio ----------
CREATE TABLE audio (
    audio_id       INT AUTO_INCREMENT PRIMARY KEY,
    vid_id         INT          DEFAULT NULL,
    dateipfad      VARCHAR(500) NOT NULL,
    beschreibung   TEXT,
    hochgeladen_am DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_audio_vid
        FOREIGN KEY (vid_id) REFERENCES videos(vid_id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- Beispieldaten
-- ============================================================

-- 19 IFZK-Kategorien
INSERT INTO kategorie (kat_name) VALUES
('IFZK-2524-017-ABU'),
('IFZK-2524-017-S2-UEK-106'),
('IFZK-2524-017-S2-MAT'),
('IFZK-2524-017-S2-254'),
('IFZK-2524-017-S2-241'),
('IFZK-2524-017-S2-346'),
('IFZK-2524-017-S2-306'),
('IFZK-2524-017-S2-245'),
('IFZK-2524-017-S2-319'),
('IFZK-2524-017-S1-ENG-N3'),
('IFZK-2524-017-S1-114'),
('IFZK-2524-017-S1-OFF'),
('IFZK-2524-017-S1-231'),
('IFZK-2524-017-S1-UEK-187'),
('IFZK-2524-017-S1-431'),
('IFZK-2524-017-S1-162'),
('IFZK-2524-017-S1-164'),
('IFZK-2524-017-S1-122'),
('IFZK-2524-017-S1-117');

-- Beispielrollen
INSERT INTO rollen (rolle_name) VALUES
('Admin'),
('Editor'),
('Viewer'),
('Uploader');
