USE SPOTIFY;
GO


INSERT INTO Languages (LanguageID, Name) VALUES
(1, 'Polish'),
(2, 'English'),
(3, 'German'),
(4, 'Spanish'),
(5, 'Portuguese'),
(6, 'Russian'),
(7, 'Japanese'),
(8, 'Italian');


INSERT INTO Countries (CountryID, Name) VALUES
(1, 'Poland'),
(2, 'Germany'),
(3, 'United States'),
(4, 'United Kingdom'),
(5, 'Spain'),
(6, 'Brazil'),
(7, 'Portugal'),
(8, 'Italy'),
(9, 'Russia'),
(10, 'Japan'),
(11, 'Mexico'),
(12, 'Argentina'),
(13, 'Canada'),
(14, 'Australia'),
(15, 'Austria'),
(16, 'Switzerland');


INSERT INTO SubscriptionTypes (SubscriptionTypeID, Name, Price, DurationMonths) VALUES
(1, 'Monthly', 15, 1),
(2, 'Quarterly', 35, 3),
(3, 'Semi-annual', 60, 6),
(4, 'Annual', 100, 12);


INSERT INTO DeviceTypes (DeviceTypeID, Name) VALUES
(1, 'Phone'),
(2, 'TV'),
(3, 'Desktop'),
(4, 'Car'),
(5, 'Gaming Console');


INSERT INTO Labels (LabelID, Name, CountryID, ContactEmail) VALUES
(1, 'Griselda Records', 3, 'contact@griselda.com'),
(2, 'Sony Music Entertainment', 3, 'global@sonymusic.com'),
(4, 'Universal Music Group', 3, 'legal@umg.com'),
(5, 'Atlantic Records', 3, 'contact@atlanticrecords.com'),
(6, 'Avex Group', 10, 'info@avex.jp'),
(7, 'Rimas Entertainment', 11, 'info@rimasmusic.com'),
(8, 'Opium', 3, 'contact@opium.com'),
(9, 'Warner Records', 3, 'contact@warnerrecords.com');


INSERT INTO Artists (ArtistID, Name, CountryID, LabelID) VALUES
(1, 'Westside Gunn', 3, 1),
(2, 'Benny The Butcher', 3, 1),
(3, 'Maneskin', 8, 2),
(4, 'Margaret', 1, 2),
(5, 'Sting', 4, 4),
(6, 'Justin Bieber', 13, 4),
(7, 'Lil Uzi Vert', 3, 5),
(8, 'Cardi B', 3, 5),
(9, 'Ayumi Hamasaki', 10, 6),
(10, 'Daichi Miura', 10, 6),
(11, 'Bad Bunny', 11, 7),
(12, 'Arcangel', 11, 7),
(13, 'Playboi Carti', 3, 8),
(14, 'Ken Carson', 3, 8),
(15, 'Destroy Lonely', 3, 8),
(16, 'Homixide Gang', 3, 8),
(17, 'Addison Rae', 3, 2),
(18, 'PinkPantheress', 4, 9);


INSERT INTO Producers (ProducerID, Name, CountryID) VALUES
(1, 'The Alchemist', 3),
(2, 'Daringer', 3),
(3, 'Max Martin', 13),
(4, 'Fabrizio Ferraguzzo', 8),
(5, 'Hugh Padgham', 4),
(6, 'Metro Boomin', 3),
(7, 'Murda Beatz', 13),
(8, 'Tainy', 11),
(9, 'Yasutaka Nakata', 10),
(10, 'Mark Ronson', 4),
(11, 'F1lthy', 3),
(12, 'Cardo', 3),
(13, 'Bnyx', 3);


INSERT INTO Genres (GenreID, Name, PopularityFromYear, PopularityToYear) VALUES
(1, 'Hip-Hop', 1973, 2026),
(2, 'Pop', 1950, 2026),
(3, 'Rock', 1950, 2015),
(4, 'Trap', 2010, 2026),
(5, 'R&B', 1990, 2026),
(6, 'J-Pop', 1980, 2026),
(7, 'Dance Pop', 1995, 2026),
(8, 'Reggaeton', 1990, 2026),
(9, 'Latin Pop', 2015, 2026);


INSERT INTO Albums (AlbumID, Title, ReleaseDate, AlbumType) VALUES
(1, 'Pray for Paris', '2020-04-17', 'ALBUM'),
(2, 'Lotto', '2020-03-27', 'SINGLE'),
(3, 'Tana Talk 4', '2022-03-11', 'ALBUM'),
(4, 'The Plugs I Met', '2019-06-21', 'ALBUM'),
(5, 'Rush!', '2023-01-20', 'ALBUM'),
(6, 'Mammamia', '2021-10-08', 'SINGLE'),
(7, 'Supermodel', '2022-05-13', 'SINGLE'),
(8, 'Add the Blonde', '2014-08-27', 'ALBUM'),
(9, 'Cool Me Down', '2016-02-19', 'SINGLE'),
(10, 'Thank You Very Much', '2013-02-21', 'SINGLE'),
(11, 'The Soul Cages', '1991-01-17', 'ALBUM'),
(12, 'The Bridge', '2021-11-19', 'ALBUM'),
(13, 'Desert Rose', '1999-12-04', 'SINGLE'),
(14, 'Purpose', '2015-11-13', 'ALBUM'),
(15, 'Justice', '2021-03-19', 'ALBUM'),
(16, 'Stay', '2021-07-09', 'SINGLE'),
(17, 'Luv Is Rage 2', '2017-08-25', 'ALBUM'),
(18, 'Pink Tape', '2023-06-30', 'ALBUM'),
(19, 'Just Wanna Rock', '2022-10-17', 'SINGLE'),
(20, 'Invasion of Privacy', '2018-04-06', 'ALBUM'),
(21, 'Bodak Yellow', '2017-06-16', 'SINGLE'),
(22, 'LOVEppears', '1999-11-10', 'ALBUM'),
(23, 'SEASONS', '2000-06-07', 'SINGLE'),
(24, 'FEVER', '2015-09-02', 'ALBUM'),
(25, 'music', '2015-06-17', 'SINGLE'),
(26, 'YHLQMDLG', '2020-02-29', 'ALBUM'),
(27, 'Un Verano Sin Ti', '2022-05-06', 'ALBUM'),
(28, 'Dákiti', '2020-10-30', 'SINGLE'),
(29, 'Ares', '2018-07-13', 'ALBUM'),
(30, 'Historias de un Capricornio', '2019-12-20', 'ALBUM'),
(31, 'All Red', '2024-09-13', 'SINGLE'),
(32, 'Whole Lotta Red', '2020-12-25', 'ALBUM'),
(33, 'Die Lit', '2018-05-11', 'ALBUM'),
(34, 'Music', '2025-03-14', 'ALBUM'),
(35, 'If Looks Could Kill', '2023-05-05', 'ALBUM'),
(36, 'NO STYLIST', '2022-08-12', 'ALBUM'),
(37, 'X', '2022-07-08', 'ALBUM'),
(38, 'More Chaos', '2023-10-13', 'ALBUM'),
(39, 'Homixide Lifestyle', '2022-11-22', 'ALBUM'),
(40, 'Snot or Not', '2023-04-27', 'ALBUM'),
(41, 'Addison', '2023-08-18', 'ALBUM'),
(42, 'Take Me Home', '2022-12-16', 'SINGLE'),
(43, 'Heaven Knows', '2023-11-10', 'ALBUM'),
(44, 'Fancy That', '2025-05-09', 'ALBUM');

INSERT INTO Songs (SongID, Title, DurationSeconds, IsExplicit, ReleaseDate, AlbumID, GenreID, ProducerID) VALUES
(1, 'George Bondo', 254, 1, '2020-04-17', 1, 1, 2),
(2, '327', 347, 1, '2020-04-17', 1, 1, 1),
(3, 'French Toast', 286, 1, '2020-04-17', 1, 1, 2),
(4, 'Allah Sent Me', 290, 1, '2020-04-17', 1, 1, 2),
(5, 'Euro Step', 108, 1, '2020-04-17', 1, 1, 2),
(6, 'Lotto', 212, 1, '2020-03-27', 2, 1, 2),

(7, 'Johnny Ps Caddy', 225, 1, '2022-03-11', 3, 1, 1),
(8, 'Back 2x', 201, 1, '2022-03-11', 3, 1, 2),
(9, '10 More Commandments', 234, 1, '2022-03-11', 3, 1, 2),
(10, 'Tyson vs Ali', 198, 1, '2022-03-11', 3, 1, 2),
(11, 'Uncle Bun', 182, 1, '2022-03-11', 3, 1, 1),
(12, 'Crowns for Kings', 223, 1, '2019-06-21', 4, 1, 1),
(13, 'Dirty Harry', 214, 1, '2019-06-21', 4, 1, 1),
(14, '5 to 50', 238, 1, '2019-06-21', 4, 1, 1),
(15, 'Sunday School', 201, 1, '2019-06-21', 4, 1, 1),

(16, 'Own My Mind', 191, 0, '2023-01-20', 5, 3, 4),
(17, 'Gossip', 168, 0, '2023-01-20', 5, 3, 4),
(18, 'Timezone', 179, 0, '2023-01-20', 5, 3, 4),
(19, 'Baby Said', 164, 0, '2023-01-20', 5, 3, 4),
(20, 'The Loneliest', 247, 0, '2023-01-20', 5, 3, 4),
(21, 'Mammamia', 186, 0, '2021-10-08', 6, 3, 4),
(22, 'Supermodel', 148, 0, '2022-05-13', 7, 3, 4),

(23, 'Wasted', 190, 0, '2014-08-27', 8, 2, 3),
(24, 'Heartbeat', 199, 0, '2014-08-27', 8, 2, 3),
(25, 'Broke But Happy', 222, 0, '2014-08-27', 8, 2, 3),
(26, 'Too Little of Happy', 186, 0, '2014-08-27', 8, 2, 3),
(27, 'Cool Me Down', 179, 0, '2016-02-19', 9, 2, 3),
(28, 'Thank You Very Much', 190, 0, '2013-02-21', 10, 2, 3),

(29, 'Mad About You', 233, 0, '1991-01-17', 11, 3, 5),
(30, 'All This Time', 294, 0, '1991-01-17', 11, 3, 5),
(31, 'Island of Souls', 401, 0, '1991-01-17', 11, 3, 5),
(32, 'Why Should I Cry For You', 286, 0, '1991-01-17', 11, 3, 5),
(33, 'Rushing Water', 197, 0, '2021-11-19', 12, 3, 5),
(34, 'If Its Love', 194, 0, '2021-11-19', 12, 3, 5),
(35, 'The Bridge', 153, 0, '2021-11-19', 12, 3, 5),
(36, 'Loving You', 264, 0, '2021-11-19', 12, 3, 5),
(37, 'Desert Rose', 285, 0, '1999-12-04', 13, 2, 5),

(38, 'Sorry', 200, 0, '2015-11-13', 14, 2, 3),
(39, 'Love Yourself', 233, 0, '2015-11-13', 14, 2, 3),
(40, 'What Do You Mean', 205, 0, '2015-11-13', 14, 2, 3),
(41, 'Company', 208, 0, '2015-11-13', 14, 2, 3),
(42, 'Peaches', 198, 1, '2021-03-19', 15, 2, 3),
(43, 'Ghost', 153, 0, '2021-03-19', 15, 2, 3),
(44, 'Hold On', 170, 0, '2021-03-19', 15, 2, 3),
(45, 'Lonely', 149, 0, '2021-03-19', 15, 2, 3),
(46, 'Stay', 141, 0, '2021-07-09', 16, 2, 3),

(47, 'XO TOUR Llif3', 180, 1, '2017-08-25', 17, 4, 1),
(48, 'The Way Life Goes', 221, 1, '2017-08-25', 17, 4, 2),
(49, 'Sauce It Up', 207, 1, '2017-08-25', 17, 4, 2),
(50, 'Flooded The Face', 192, 1, '2023-06-30', 18, 4, 1),
(51, 'Nakamura', 210, 1, '2023-06-30', 18, 4, 2),
(52, 'Fire Alarm', 191, 1, '2023-06-30', 18, 4, 2),
(53, 'Just Wanna Rock', 122, 0, '2022-10-17', 19, 4, 2),

(54, 'I Like It', 253, 1, '2018-04-06', 20, 1, 3),
(55, 'Be Careful', 211, 0, '2018-04-06', 20, 1, 3),
(56, 'Bartier Cardi', 194, 1, '2018-04-06', 20, 1, 3),
(57, 'Bodak Yellow', 223, 1, '2017-06-16', 21, 1, 3),

(58, 'Boys & Girls', 231, 0, '1999-11-10', 22, 7, 4),
(59, 'Appears', 338, 0, '1999-11-10', 22, 7, 4),
(60, 'SEASONS', 347, 0, '2000-06-07', 23, 7, 4),

(61, 'FEVER', 238, 0, '2015-09-02', 24, 6, 4),
(62, 'Anchor', 256, 0, '2015-09-02', 24, 6, 4),
(63, 'music', 242, 0, '2015-06-17', 25, 6, 4),

(64, 'Yo Perreo Sola', 172, 0, '2020-02-29', 26, 8, 1),
(65, 'Safaera', 295, 1, '2020-02-29', 26, 8, 1),
(66, 'La Difícil', 163, 0, '2020-02-29', 26, 8, 1),
(67, 'Moscow Mule', 245, 0, '2022-05-06', 27, 8, 1),
(68, 'Me Porto Bonito', 178, 1, '2022-05-06', 27, 8, 1),
(69, 'Tití Me Preguntó', 244, 1, '2022-05-06', 27, 8, 1),
(70, 'Dákiti', 205, 0, '2020-10-30', 28, 8, 1),

(71, 'Atmósfera', 254, 1, '2018-07-13', 29, 9, 2),
(72, 'Se Supone', 208, 1, '2018-07-13', 29, 9, 2),
(73, 'Original', 246, 1, '2018-07-13', 29, 9, 2),
(74, 'Mi Testimonio', 285, 1, '2019-12-20', 30, 9, 2),
(75, 'Al Volante', 200, 1, '2019-12-20', 30, 9, 2),
(76, 'Rehén', 175, 1, '2019-12-20', 30, 9, 2),
(77, 'Ponte Bonita', 193, 1, '2019-12-20', 30, 9, 2),
(78, 'Sigues con él', 210, 1, '2019-12-20', 30, 9, 2),

(79, 'ALL RED', 148, 1, '2024-09-13', 31, 1, 11),
(80, 'Go2DaMoon', 119, 1, '2020-12-25', 32, 1, 12),
(81, 'Stop Breathing', 218, 1, '2020-12-25', 32, 1, 11),
(82, 'New N3on', 116, 1, '2020-12-25', 32, 1, 11),
(83, 'Rockstar Made', 193, 1, '2020-12-25', 32, 1, 11),
(84, 'M3tamorphosis', 312, 1, '2020-12-25', 32, 1, 12),
(85, 'R.I.P.', 192, 1, '2018-05-11', 33, 1, 11),
(86, 'Old Money', 135, 1, '2018-05-11', 33, 1, 11),
(87, 'Poke It Out', 269, 1, '2018-05-11', 33, 1, 11),
(88, 'Shoota', 153, 1, '2018-05-11', 33, 1, 13),
(89, 'No Time', 219, 1, '2018-05-11', 33, 1, 13),
(90, 'OVERLY', 180, 1, '2025-03-14', 34, 1, 13),
(91, 'K POP', 175, 1, '2025-03-14', 34, 1, 13),
(92, 'HBA', 210, 1, '2025-03-14', 34, 1, 12),
(93, 'FINE SHIT', 165, 1, '2025-03-14', 34, 1, 11),
(94, '2024', 129, 1, '2025-03-14', 34, 1, 12),

(95, 'chris paul', 154, 1, '2023-05-05', 35, 1, 13),
(96, 'if looks could kill', 187, 1, '2023-05-05', 35, 1, 13),
(97, 'new new', 142, 1, '2023-05-05', 35, 1, 11),
(98, 'promo', 161, 1, '2023-05-05', 35, 1, 11),
(99, 'blitz', 128, 1, '2023-05-05', 35, 1, 11),
(100, 'NOSTYLIST', 174, 1, '2022-08-12', 36, 1, 11),
(101, 'JETLGGD', 152, 1, '2022-08-12', 36, 1, 11),
(102, '<3MYGNG', 148, 1, '2022-08-12', 36, 1, 11),
(103, 'ONTHETABLE', 160, 1, '2022-08-12', 36, 1, 11),

(104, 'New', 155, 1, '2022-07-08', 37, 1, 11),
(105, 'Gems', 142, 1, '2022-07-08', 37, 1, 11),
(106, 'Shoot', 168, 1, '2022-07-08', 37, 1, 11),
(107, 'MDMA (feat. Destroy Lonely)', 195, 1, '2022-07-08', 37, 1, 11),
(108, 'Delinquent (feat. Homixide Gang)', 172, 1, '2022-07-08', 37, 1, 11),
(109, 'Money Spread', 162, 1, '2023-10-13', 38, 1, 11),
(110, '2000', 145, 1, '2023-10-13', 38, 1, 11),
(111, 'Ghoul', 158, 1, '2023-10-13', 38, 1, 11),
(112, 'Off The Meter', 140, 1, '2023-10-13', 38, 1, 11),

(113, 'Lifestyle', 145, 1, '2022-11-22', 39, 1, 11),
(114, 'V-Friends', 132, 1, '2022-11-22', 39, 1, 11),
(115, 'Stunt', 128, 1, '2022-11-22', 39, 1, 11),
(116, 'Homixide Language', 150, 1, '2023-04-27', 40, 1, 11),
(117, 'Uzi Work', 138, 1, '2023-04-27', 40, 1, 11),

(118, 'Aquamarine', 165, 0, '2023-08-18', 41, 2, 3),
(119, 'In The Rain', 178, 0, '2023-08-18', 41, 2, 3),
(120, 'High Fashion', 155, 0, '2023-08-18', 41, 2, 3),

(121, 'Take Me Home', 145, 0, '2022-12-16', 42, 7, 4),
(122, 'Tonight', 162, 0, '2025-05-09', 44, 7, 4),
(123, 'Girl Like Me', 158, 0, '2025-05-09', 44, 7, 4),
(124, 'Stars', 170, 0, '2025-05-09', 44, 7, 4),
(125, 'True Romance', 136, 0, '2023-11-10', 43, 4, 7),
(126, 'Feelings', 150, 0, '2023-11-10', 43, 4, 7),
(127, 'Capable of love', 223, 0, '2023-11-10', 43, 4, 7);


INSERT INTO SongCreators (SongID, ArtistID) VALUES
(1,1),(2,1),(3,1),(4,1),(5,1),(6,1),
(7,2),(8,2),(9,2),(10,2),(11,2),(12,2),(13,2),(14,2),(15,2),
(16,3),(17,3),(18,3),(19,3),(20,3),(21,3),(22,3),
(23,4),(24,4),(25,4),(26,4),(27,4),(28,4),
(29,5),(30,5),(31,5),(32,5),(33,5),(34,5),(35,5),(36,5),(37,5),
(38,6),(39,6),(40,6),(41,6),(42,6),(43,6),(44,6),(45,6),(46,6),
(47,7),(48,7),(49,7),(50,7),(51,7),(52,7),(53,7),
(54,8),(55,8),(56,8),(57,8),
(58,9),(59,9),(60,9),
(61,10),(62,10),(63,10),
(64,11),(65,11),(66,11),(67,11),(68,11),(69,11),(70,11),
(71,12),(72,12),(73,12),(74,12),(75,12),(76,12),(77,12),(78,12),
(79,13),(80,13),(81,13),(82,13),(83,13),(84,13),(85,13),(86,13),(87,13),(88,13),(89,13),(90,13),(91,13),(92,13),(93,13),(94,13),
(95,15),(96,15),(97,15),(98,15),(99,15),(100,15),(101,15),(102,15),(103,15),
(104,14),(105,14),(106,14),
(107,14),(107,15),
(108,14),(108,16),
(109,14),(110,14),(111,14),(112,14),
(113,16),(114,16),(115,16),(116,16),(117,16),
(118,17),(119,17),(120,17),
(121,18),(122,18),(123,18),(124,18), (125, 18), (126, 18), (127, 18);


INSERT INTO AlbumCreators (AlbumID, ArtistID) VALUES
(1, 1),(2, 1),
(3, 2),(4, 2),
(5, 3),(6, 3),(7, 3),
(8, 4),(9, 4),(10, 4),
(11, 5),(12, 5),(13, 5),
(14, 6),(15, 6),(16, 6),
(17, 7),(18, 7),(19, 7),
(20, 8),(21, 8),
(22, 9),(23, 9),
(24, 10),(25, 10),
(26, 11),(27, 11),(28, 11),
(29, 12),(30, 12),
(31, 13),(32, 13),(33, 13),(34, 13),
(35, 15),(36, 15),
(37, 14),(38, 14),
(39, 16),(40, 16),
(41, 17),
(42, 18),(43, 18),(44, 18);


INSERT INTO PodcastCategories (CategoryID, Name) VALUES
(1, 'True Crime'),
(2, 'Technology'),
(3, 'Comedy'),
(4, 'Business'),
(5, 'Health'),
(6, 'Sports'),
(7, 'Education'),
(8, 'Music'),
(9, 'Science');


INSERT INTO Podcasts (PodcastID, Name, CategoryID, LanguageID) VALUES
(1, 'Kryminatorium', 1, 1),
(2, 'Lex Fridman Podcast', 2, 2),
(3, 'The Joe Rogan Experience', 3, 2),
(4, 'Darknet Diaries', 2, 2),
(5, 'Huberman Lab', 5, 2),
(6, 'The Tim Ferriss Show', 4, 2),
(7, 'No Such Thing As A Fish', 3, 2),
(8, 'Raport o stanie świata', 7, 1),
(9, 'Nauka To Lubię', 9, 1),
(10, 'Unfiltered Urban Legends', 3, 2),
(11, 'The Angler''s Mindset', 6, 2);


INSERT INTO PodcastEpisodes (EpisodeID, PodcastID, Title, DurationSeconds, ReleaseDate) VALUES
(1, 1, 'Zbrodnia na zamku', 2400, '2023-10-01'),
(2, 1, 'Tajemnica szafy', 2150, '2023-10-08'),
(3, 1, 'Ucieczka z wiezienia', 2700, '2023-10-15'),
(4, 1, 'Nierozwiazana sprawa', 2300, '2023-10-22'),
(5, 1, 'Sladami mordercy', 2550, '2023-10-29'),

(6, 2, 'Elon Musk on Mars', 7200, '2023-11-01'),
(7, 2, 'Sam Altman and OpenAI', 5400, '2023-11-10'),
(8, 2, 'The Future of Robotics', 6100, '2023-11-15'),
(9, 2, 'Physics of the Universe', 6800, '2023-11-20'),
(10, 2, 'History of Humanity', 5900, '2023-11-25'),

(11, 3, 'Duncan Trussell Returns', 10800, '2023-12-01'),
(12, 3, 'Health and Longevity', 9200, '2023-12-05'),
(13, 3, 'Comedy in LA', 8500, '2023-12-10'),
(14, 3, 'Deep Sea Exploration', 11200, '2023-12-15'),
(15, 3, 'The Art of Fighting', 7800, '2023-12-20'),

(16, 4, 'Xbox Underground', 3600, '2023-09-15'),
(17, 4, 'The Beirut Bank Job', 4200, '2023-09-29'),
(18, 4, 'Mariposa Botnet', 3900, '2023-10-13'),

(19, 5, 'How to Improve Sleep', 7200, '2023-10-02'),
(20, 5, 'The Science of Focus', 6800, '2023-10-16'),
(21, 5, 'Optimizing Hormones', 7500, '2023-10-30'),

(22, 6, 'Tools of Top Performers', 5400, '2023-09-20'),
(23, 6, 'Building Wealth', 6000, '2023-10-04'),
(24, 6, 'Learning Faster', 5700, '2023-10-18'),

(25, 7, 'The Fish That Fell From Space', 2400, '2023-09-22'),
(26, 7, 'Facts That Should Not Exist', 2500, '2023-10-06'),
(27, 7, 'Ridiculous World Records', 2600, '2023-10-20'),

(28, 8, 'Bliski Wschod po nowemu', 3600, '2023-09-25'),
(29, 8, 'Europa w kryzysie', 3900, '2023-10-09'),
(30, 8, 'Globalna polityka USA', 4200, '2023-10-23'),

(31, 9, 'Czy AI mysli?', 1800, '2023-09-18'),
(32, 9, 'Tajemnice kosmosu', 2100, '2023-10-02'),
(33, 9, 'Jak dziala mozg', 2000, '2023-10-16'),

(34, 10, 'My Baby Mama is a Loser', 2850, '2024-01-10'),
(35, 10, 'The Lock on the Juice Box', 3120, '2024-01-17'),
(36, 10, 'The DNA Test That Broke the Block', 3400, '2024-01-24'),

(37, 11, 'Patience and Peace: Why Fishing is Therapy', 2700, '2024-02-01'),
(38, 11, 'The Thrill of the Catch: Adrenaline on the Water', 3150, '2024-02-08'),
(39, 11, 'Conservation and Community: Protecting our Rivers', 2900, '2024-02-15');


INSERT INTO Advertisers (AdvertiserID, Name, CountryID) VALUES
(1, 'Coca-Cola Global', 3),
(2, 'Allegro Polska', 1),
(3, 'Nike Inc.', 3),
(4, 'Spotify AB', 16),
(5, 'Samsung Electronics', 10),
(6, 'McDonald''s Corporation', 3),
(7, 'Red Bull GmbH', 15),
(8, 'Winiary', 1),
(9, 'Browar Perla', 1);


INSERT INTO Ads (AdID, AdvertiserID, Title, DurationSeconds) VALUES
(1, 1, 'Taste the Feeling - Summer Edit', 30),
(2, 1, 'Holidays are Coming', 60),
(3, 2, 'Allegro - Najwiekszy Wybor', 15),
(4, 2, 'Smart Week Promo', 20),
(5, 3, 'Nike – Just Do It', 30),
(6, 3, 'Nike Air Max Campaign', 45),
(7, 4, 'Spotify Premium – No Ads', 30),
(8, 4, 'Spotify Wrapped', 60),
(9, 5, 'Samsung Galaxy Launch', 30),
(10, 5, 'Samsung Smart Life', 45),
(11, 6, 'McDonald''s New Menu', 30),
(12, 6, 'McDelivery Anytime', 20),
(13, 7, 'Red Bull Gives You Wings', 30),
(14, 7, 'Red Bull Extreme Sports', 45),
(15, 8, 'Winiary - Dekoracyjny do salatek', 15),
(16, 8, 'Pomysl na... Szybki obiad', 30),
(17, 8, 'Winiary - Wspolne sniadanie wielkanocne', 45),
(18, 9, 'Perla - Chmielowa swiezosc', 20),
(19, 9, 'Perla Export - Smak Lubelszczyzny', 30),
(20, 9, 'Perla - Idealna na grilla', 15);
