-- phpMyAdmin SQL Dump
-- version 4.8.4
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le :  lun. 07 juin 2021 à 07:59
-- Version du serveur :  5.7.24
-- Version de PHP :  7.2.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données :  `weadvert`
--

-- --------------------------------------------------------

--
-- Structure de la table `annonceur`
--

DROP TABLE IF EXISTS `annonceur`;
CREATE TABLE IF NOT EXISTS `annonceur` (
  `idAnnonceur` int(11) NOT NULL AUTO_INCREMENT,
  `entreprise` text NOT NULL,
  `typeEntre` varchar(255) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `etatValidation` tinyint(1) NOT NULL,
  `verification_code` int(11) DEFAULT NULL,
  `telephone` varchar(13) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`idAnnonceur`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `annonceur`
--

INSERT INTO `annonceur` (`idAnnonceur`, `entreprise`, `typeEntre`, `email`, `image`, `etatValidation`, `verification_code`, `telephone`, `website`) VALUES
(1, 'Delice', 'agroalimentaire', 'delice@delice.tn', '53b3807c-ab71-471c-95bf-8ff38559c902.jpeg', 1, NULL, '55555555', 'www.delice.com'),
(5, 'deliceeeee', NULL, 'baha@esprit.tn', NULL, 1, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `automobiliste`
--

DROP TABLE IF EXISTS `automobiliste`;
CREATE TABLE IF NOT EXISTS `automobiliste` (
  `idAuto` int(11) NOT NULL AUTO_INCREMENT,
  `nom` varchar(255) NOT NULL,
  `prenom` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `dateNaiss` date DEFAULT NULL,
  `cin` int(8) DEFAULT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `profession` varchar(200) DEFAULT NULL,
  `lieuCirculation` text,
  `revenu` int(11) NOT NULL DEFAULT '0',
  `score` int(11) NOT NULL DEFAULT '0',
  `numerotelephone` varchar(13) DEFAULT NULL,
  PRIMARY KEY (`idAuto`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `automobiliste`
--

INSERT INTO `automobiliste` (`idAuto`, `nom`, `prenom`, `email`, `dateNaiss`, `cin`, `photo`, `profession`, `lieuCirculation`, `revenu`, `score`, `numerotelephone`) VALUES
(4, 'Ben hissi', 'Youssef', 'youssef.benhissi@esprit.tn', '1998-03-26', NULL, '2a231fef-14b2-429f-8c4b-e148eca7bbe4.jpeg', 'Ingenieur', 'Ariana', 736654, 0, '0021655'),
(5, 'Ben slama', 'Mohamed baha', 'mohamedbaha.benslama@esprit.tn', '2021-02-23', NULL, '06e12c88-dfa7-434d-ad29-79f38a437365.jpeg', 'Ingénieur', 'Ariana', 93, 0, '0021655000000'),
(13, 'yousseffffff', 'yousseffffffff', 'youssef.benhissi@esprit.t', '1990-12-12', NULL, NULL, 'yahoo.fr', NULL, 0, 0, NULL),
(14, 'bahhhhaa', 'bahhhhha', 'bahhhhha@espppprit.tn', '1998-03-16', 150, NULL, 'etudiant', 'tunis', 0, 0, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `candidature`
--

DROP TABLE IF EXISTS `candidature`;
CREATE TABLE IF NOT EXISTS `candidature` (
  `idAuto` int(11) NOT NULL AUTO_INCREMENT,
  `idOffre` int(11) NOT NULL,
  `etatValidation` int(1) NOT NULL,
  `idautomobiliste` int(11) NOT NULL,
  PRIMARY KEY (`idAuto`,`idOffre`),
  KEY `idOffre` (`idOffre`),
  KEY `idautmobili` (`idautomobiliste`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `candidature`
--

INSERT INTO `candidature` (`idAuto`, `idOffre`, `etatValidation`, `idautomobiliste`) VALUES
(4, 29, 0, 4);

-- --------------------------------------------------------

--
-- Structure de la table `followers`
--

DROP TABLE IF EXISTS `followers`;
CREATE TABLE IF NOT EXISTS `followers` (
  `idAuto` int(11) NOT NULL,
  `idAnnonceur` int(11) NOT NULL,
  `token` varchar(255) NOT NULL,
  PRIMARY KEY (`idAuto`,`idAnnonceur`),
  KEY `idAnnonceur` (`idAnnonceur`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `followers`
--

INSERT INTO `followers` (`idAuto`, `idAnnonceur`, `token`) VALUES
(4, 1, 'd4v4-mV32Jw:APA91bHXMijCt9sdSD4KyqY9AngQ1gaLdGnmRbE-A1WUb-2pGtgc6Hx-utHgkUE2lVzizksbNm_4G9CyfG2VuOWUOFtnkeiuY2eTmB0eKx596E2NoQeQvgrayG0qde1kz-R3OdR3qc08');

-- --------------------------------------------------------

--
-- Structure de la table `image`
--

DROP TABLE IF EXISTS `image`;
CREATE TABLE IF NOT EXISTS `image` (
  `idImage` int(11) NOT NULL AUTO_INCREMENT,
  `idVoiture` int(11) NOT NULL,
  `nom` varchar(255) NOT NULL,
  PRIMARY KEY (`idImage`),
  KEY `idVoiture` (`idVoiture`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `image`
--

INSERT INTO `image` (`idImage`, `idVoiture`, `nom`) VALUES
(1, 1, 'd598aa79-3a7e-40ff-b08d-bc2e8ba86912.jpeg'),
(2, 1, '0b2c13b1-ad79-453a-983d-7c046f996c5c.jpeg'),
(3, 1, '68b8596f-0639-42d4-8465-df959fe08b3f.jpeg'),
(4, 1, '5bc0920b-720d-4c45-9603-7a8ef7305287.jpeg');

-- --------------------------------------------------------

--
-- Structure de la table `messages`
--

DROP TABLE IF EXISTS `messages`;
CREATE TABLE IF NOT EXISTS `messages` (
  `user_from` int(11) NOT NULL,
  `user_to` int(11) NOT NULL,
  `message` varchar(255) NOT NULL,
  `base64` blob NOT NULL,
  `image` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `messages`
--

INSERT INTO `messages` (`user_from`, `user_to`, `message`, `base64`, `image`) VALUES
(1, 2, 'hello', 0x756e646566696e6564, 'undefined'),
(1, 2, 'hello', 0x756e646566696e6564, 'undefined'),
(1, 2, 'Hello', 0x756e646566696e6564, 'undefined'),
(1, 2, 'HelloHello', 0x756e646566696e6564, 'undefined');

-- --------------------------------------------------------

--
-- Structure de la table `notif`
--

DROP TABLE IF EXISTS `notif`;
CREATE TABLE IF NOT EXISTS `notif` (
  `idNotif` int(11) NOT NULL AUTO_INCREMENT,
  `message` varchar(255) NOT NULL,
  `idAuto` int(11) NOT NULL,
  PRIMARY KEY (`idNotif`),
  KEY `fk_id_auto_notif` (`idAuto`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `notif`
--

INSERT INTO `notif` (`idNotif`, `message`, `idAuto`) VALUES
(1, 'adjdjdj', 4);

-- --------------------------------------------------------

--
-- Structure de la table `offre`
--

DROP TABLE IF EXISTS `offre`;
CREATE TABLE IF NOT EXISTS `offre` (
  `idOffre` int(11) NOT NULL AUTO_INCREMENT,
  `idAnnonceur` int(11) NOT NULL,
  `description` text NOT NULL,
  `gouvernorat` varchar(255) NOT NULL,
  `delegation` varchar(255) DEFAULT NULL,
  `cible` varchar(255) DEFAULT NULL,
  `dateDeb` date NOT NULL,
  `dateFin` date NOT NULL,
  `renouvelable` tinyint(1) DEFAULT NULL,
  `nbCandidats` int(11) NOT NULL,
  `cout` int(11) NOT NULL,
  `imageOffer` char(255) DEFAULT NULL,
  `likes` int(11) DEFAULT '0',
  `nbrdefois` int(11) NOT NULL DEFAULT '0',
  `somme` int(11) NOT NULL DEFAULT '0',
  `typeoffre` int(11) DEFAULT NULL,
  PRIMARY KEY (`idOffre`),
  KEY `idAnnonceur` (`idAnnonceur`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `offre`
--

INSERT INTO `offre` (`idOffre`, `idAnnonceur`, `description`, `gouvernorat`, `delegation`, `cible`, `dateDeb`, `dateFin`, `renouvelable`, `nbCandidats`, `cout`, `imageOffer`, `likes`, `nbrdefois`, `somme`, `typeoffre`) VALUES
(1, 2, 'publicite de milkshake', 'Ariana', NULL, NULL, '2021-02-24', '2022-03-31', 0, 100, 100, '1b501137-b30d-4e20-8eb6-fdb492e9fac2.jpg', 1, 2, 3, NULL),
(10, 1, 'Publicité de yaourt délice', 'Tunis', NULL, NULL, '2021-03-01', '2022-05-29', NULL, 200, 120, 'yarout.jpg', 0, 0, 0, NULL),
(20, 1, 'Publicité danup', 'Monastir', NULL, NULL, '2021-04-10', '2022-03-18', 0, 100, 60, 'images.jpg', 0, 0, 0, NULL),
(29, 1, 'Publicité de la bouteille de lait', 'Tunis', NULL, NULL, '2020-11-04', '2022-11-12', 0, 2, 50, '4ffc678a-dabf-4387-8038-e9674e167b16.png', 0, 0, 0, NULL),
(31, 1, 'Publicité de la bouteille d\'eau délice', 'Ariana', NULL, NULL, '2021-03-18', '2022-03-26', 0, 2, 48, '328f05b7-f5b0-4bfa-a821-d83f7b293661.jpeg', 0, 0, 0, NULL),
(32, 1, 'publicite de danette', 'Monastir', NULL, NULL, '2021-03-10', '2022-03-17', 0, 44, 26, 'a1a72b02-9150-4521-ad4b-2502f6c9958f.png', 0, 0, 0, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `payment`
--

DROP TABLE IF EXISTS `payment`;
CREATE TABLE IF NOT EXISTS `payment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `idAnnonceur` int(11) NOT NULL,
  `date` date NOT NULL,
  `somme` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_id_annonceur` (`idAnnonceur`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `payment`
--

INSERT INTO `payment` (`id`, `idAnnonceur`, `date`, `somme`) VALUES
(1, 1, '2021-08-14', 100),
(5, 1, '2021-01-21', 100),
(6, 1, '2021-08-14', 100),
(7, 1, '2021-11-14', 100),
(8, 1, '2021-04-21', 100),
(9, 1, '2021-04-21', 100),
(10, 1, '2021-04-21', 300);

-- --------------------------------------------------------

--
-- Structure de la table `ratingoffre`
--

DROP TABLE IF EXISTS `ratingoffre`;
CREATE TABLE IF NOT EXISTS `ratingoffre` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `idautomobiliste` int(11) NOT NULL,
  `idoffre` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idautomobilistefk` (`idautomobiliste`),
  KEY `fkoffre` (`idoffre`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `ratingoffre`
--

INSERT INTO `ratingoffre` (`id`, `idautomobiliste`, `idoffre`) VALUES
(3, 4, 32);

-- --------------------------------------------------------

--
-- Structure de la table `reclamation`
--

DROP TABLE IF EXISTS `reclamation`;
CREATE TABLE IF NOT EXISTS `reclamation` (
  `idRec` int(11) NOT NULL AUTO_INCREMENT,
  `idAnnonceur` int(11) NOT NULL,
  `typeRec` varchar(255) NOT NULL,
  `contenuRec` varchar(255) NOT NULL,
  `idAuto` int(11) DEFAULT NULL,
  PRIMARY KEY (`idRec`),
  KEY `idAnnonceur` (`idAnnonceur`),
  KEY `idAuto` (`idAuto`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `revenu`
--

DROP TABLE IF EXISTS `revenu`;
CREATE TABLE IF NOT EXISTS `revenu` (
  `idOffre` int(11) NOT NULL,
  `idAuto` int(11) NOT NULL,
  `solde` decimal(10,2) NOT NULL,
  PRIMARY KEY (`idOffre`,`idAuto`),
  KEY `idAuto` (`idAuto`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `revenu`
--

INSERT INTO `revenu` (`idOffre`, `idAuto`, `solde`) VALUES
(10, 4, '722242.00'),
(3, 5, '0.00');

-- --------------------------------------------------------

--
-- Structure de la table `users_location`
--

DROP TABLE IF EXISTS `users_location`;
CREATE TABLE IF NOT EXISTS `users_location` (
  `idAuto` int(11) NOT NULL,
  `latitude` decimal(11,8) NOT NULL,
  `longitude` decimal(10,8) NOT NULL,
  `isOnline` tinyint(1) NOT NULL,
  PRIMARY KEY (`idAuto`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `users_location`
--

INSERT INTO `users_location` (`idAuto`, `latitude`, `longitude`, `isOnline`) VALUES
(4, '36.78560270', '10.19378500', 1);

-- --------------------------------------------------------

--
-- Structure de la table `utilisateur`
--

DROP TABLE IF EXISTS `utilisateur`;
CREATE TABLE IF NOT EXISTS `utilisateur` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `unique_id` varchar(60) NOT NULL,
  `encrypted_password` varchar(128) NOT NULL,
  `salt` varchar(16) NOT NULL,
  `created_at` date NOT NULL,
  `updated_at` date NOT NULL,
  `etat` varchar(30) NOT NULL,
  `verification_code` int(11) NOT NULL,
  `email` varchar(30) NOT NULL,
  `nbrdefois` int(11) NOT NULL,
  `role` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `utilisateur`
--

INSERT INTO `utilisateur` (`id`, `unique_id`, `encrypted_password`, `salt`, `created_at`, `updated_at`, `etat`, `verification_code`, `email`, `nbrdefois`, `role`) VALUES
(7, '079f71ad-cd94-4a22-953c-b05be71b897b', '812c2e6202a72d8a0d13e5c58c4949707f6635dd330aa4be585c46fdd8d25f119c9c4fec37c73b19d80c9ba036ca5965d9ec7e3c25dedbe98988b601a52f3e8a', 'c83fa5102b951d96', '2021-02-20', '2021-02-20', '0', 68300, 'youssef.benhissi@esprit.tn', 0, 0),
(12, '079f71ad-cd94-4a22-953c-b05be71b897b', '812c2e6202a72d8a0d13e5c58c4949707f6635dd330aa4be585c46fdd8d25f119c9c4fec37c73b19d80c9ba036ca5965d9ec7e3c25dedbe98988b601a52f3e8a', 'c83fa5102b951d96', '2021-02-20', '2021-02-20', '0', 68300, 'mohamedbaha.benslama@esprit.tn', 0, 0),
(66, '079f71ad-cd94-4a22-953c-b05be71b897b', '812c2e6202a72d8a0d13e5c58c4949707f6635dd330aa4be585c46fdd8d25f119c9c4fec37c73b19d80c9ba036ca5965d9ec7e3c25dedbe98988b601a52f3e8a', 'c83fa5102b951d96', '2021-02-20', '2021-02-20', '0', 68300, 'delice@delice.tn', 0, 1),
(93, 'aefb87f3-f4d3-4082-bcb8-ff761b58771d', 'cd5a7626a5a5d549ffb2c1163bddcd1d598faf89b577100d6f340309a6d3bca072e3ad993ed4f01f98219ae32741258c603464e45f685e7a96deac1f959b2573', '611f54469e0cac5b', '2021-05-12', '2021-05-12', '1', 9182, 'youssefbenhissi@yahoo.fr', 0, 1),
(94, 'b4e98e63-0b41-4730-82a6-34ea5576d39f', '9928f118d4b4f3352a43040fb015c08dfc0b6306a65b8f36a26df351400228e094f86b303a74a2f0ba2d60144e61f3bbfbcbaa7f0b7f9de6d8bd00b0ab246852', '9f4f5e9369b9af9e', '2021-05-14', '2021-05-14', '0', 8313, 'delice@esprit.tn', 0, 0),
(95, '2e154549-24ce-41c2-b427-87be8f5d97fe', '051eba548b1b418d197073c92fdfacc7f806925b5ea3031b25731f892f7db149bd9439e8c631a50d8d1d3879d3ab96024d24ea5e6ba75a3e735814562d86e86d', '52a344ab3cf1d297', '2021-05-14', '2021-05-14', '0', 1654, 'nefzi.mediheb@esprit.tn', 0, 0),
(97, '01b9b179-c4af-4821-874e-0553bf630bc5', 'e5e7837b85641c600f73c1a39c41ec213d75c4c9c7050c489eaa06fbbb0100a1ca75df1156ce66cfc29c3e163c17752f838c170af639dc2f4686cdb24f1cd760', '6ee08103beb6bfa0', '2021-05-14', '2021-05-14', '0', 8129, 'baha@esprit.tn', 0, 0),
(98, '1f5aff88-098d-46d9-a252-b0441d0c3f55', '5b130a3fcdcf434f9bf34c5dbd770b6ce41ea0079f05632d07946ce9ea9826fa658bfcbcef49caf3e9acbddf7c256d4f379ce0fb4ca72c9f7aa05bac9e1f56f2', 'cccb90cd47ab14a7', '2021-05-14', '2021-05-14', '0', 4689, 'youssef.benhissi@esprit.t', 0, 0),
(99, 'bc2b9d5f-ef9a-4191-b401-daa29015d4e9', 'b0beb799d4965ac1b517c4038e38f4c9838b3e2f5b0295f7d335ed53bf5cd1d3dfc3b4b2b1050c48a9babe4daa54d02eaf6c0511730d5b3095277b8d64120831', '4a927ce9ae4b3887', '2021-05-14', '2021-05-14', '0', 1890, 'youssef.benhissi@esprit.t', 0, 0),
(100, '4e48b51b-3d72-4c8a-bbeb-e2e9e65a8979', '0e06dbbb2cb9c64c8d78365e8c7b4753fa51f5ca1b434fe2c01cfb4e870f6dceda362c5dac32920a32ec134559975322d7ff65c782bdb03544978a7b6ae40a82', '77eeabe40988b1ae', '2021-05-14', '2021-05-14', '0', 5505, 'youssef.benhissi@esprit.t', 0, 0),
(101, 'f6c86555-40cf-42de-afa7-e109e900d867', 'e276480b616c37fdb7c4593efdc7a9201814284b408e499e74db17e740001d4f2b2583c7287d8b7c0df89bbc15e00f9eadad1dd200b16d853ab74147b0ca6204', 'a8a3c0647742b874', '2021-05-14', '2021-05-14', '0', 6358, 'youssef.benhissi@esprit.t', 0, 0),
(102, '1864d652-3855-43d2-8d19-d4f24a5b5cd9', 'c4335373ce3e9e0ff1b92868b0d5da0b53afcea8b04dcf060ecd0a529a24f438ee1bf16180f342c327d85e2d2e84340de741d16b2a6f411f38fcd0bbf17d6dae', 'a2b2d94485807429', '2021-05-14', '2021-05-14', '0', 9314, 'youssef.benhissi@esprit.t', 0, 0),
(103, '48c0fc39-6d7a-465b-bf44-9588e8443cf7', '3da7c94d28384cb4c15af28512a67dabc955282295d028f3600cb343567825ce05970c749f8b091d2bf5a84ab376ec8abf0aa262ab22bc55c10b201abdc6ab3a', '1c1e761821b65f6b', '2021-05-14', '2021-05-14', '0', 3475, 'bahhhhha@espppprit.tn', 0, 0);

-- --------------------------------------------------------

--
-- Structure de la table `verificationcodes`
--

DROP TABLE IF EXISTS `verificationcodes`;
CREATE TABLE IF NOT EXISTS `verificationcodes` (
  `idAuto` int(11) NOT NULL,
  `VerifCode` int(11) NOT NULL,
  PRIMARY KEY (`idAuto`,`VerifCode`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `verificationcodes`
--

INSERT INTO `verificationcodes` (`idAuto`, `VerifCode`) VALUES
(4, 16685),
(4, 65752);

-- --------------------------------------------------------

--
-- Structure de la table `voiture`
--

DROP TABLE IF EXISTS `voiture`;
CREATE TABLE IF NOT EXISTS `voiture` (
  `idVoiture` int(11) NOT NULL AUTO_INCREMENT,
  `idAuto` int(11) NOT NULL,
  `type` varchar(255) NOT NULL,
  `marque` varchar(255) NOT NULL,
  `model` varchar(255) NOT NULL,
  `annee` int(11) DEFAULT NULL,
  PRIMARY KEY (`idVoiture`),
  KEY `idAuto` (`idAuto`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `voiture`
--

INSERT INTO `voiture` (`idVoiture`, `idAuto`, `type`, `marque`, `model`, `annee`) VALUES
(1, 4, 'Utilitaire', 'Honda', 'Odyssey', 2012),
(2, 5, 'Taxi', 'Volkswagen', 'Polo', NULL);

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `candidature`
--
ALTER TABLE `candidature`
  ADD CONSTRAINT `idautmobili` FOREIGN KEY (`idautomobiliste`) REFERENCES `automobiliste` (`idAuto`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `notif`
--
ALTER TABLE `notif`
  ADD CONSTRAINT `fk_id_auto_notif` FOREIGN KEY (`idAuto`) REFERENCES `automobiliste` (`idAuto`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `payment`
--
ALTER TABLE `payment`
  ADD CONSTRAINT `fk_id_annonceur` FOREIGN KEY (`idAnnonceur`) REFERENCES `annonceur` (`idAnnonceur`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `ratingoffre`
--
ALTER TABLE `ratingoffre`
  ADD CONSTRAINT `fkoffre` FOREIGN KEY (`idoffre`) REFERENCES `offre` (`idOffre`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `idautomobilistefk` FOREIGN KEY (`idautomobiliste`) REFERENCES `automobiliste` (`idAuto`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
