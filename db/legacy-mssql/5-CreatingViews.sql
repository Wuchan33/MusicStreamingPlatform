USE SPOTIFY;
GO

CREATE VIEW VW_SongLibrary AS
SELECT 
    a.ArtistID,
    a.Name AS ArtistName,
    alb.AlbumType,
    alb.Title AS AlbumTitle,
    s.Title AS SongTitle,
    s.DurationSeconds,
    g.Name AS GenreName,
    s.ReleaseDate,
    s.StreamCount
FROM Artists a
JOIN SongCreators sc ON a.ArtistID = sc.ArtistID
JOIN Songs s ON sc.SongID = s.SongID
LEFT JOIN Albums alb ON s.AlbumID = alb.AlbumID
LEFT JOIN Genres g ON s.GenreID = g.GenreID
GO


CREATE VIEW VW_ActivePremiumUsers
AS
SELECT 
    u.UserID AS UserID,
    u.Username AS Username,
    u.Email AS Email,
    st.Name AS CurrentSubscriptionType,
    us.StartDate AS StartDate,
    us.EndDate AS EndDate
FROM Users u
JOIN UserSubscriptions us 
    ON u.UserID = us.UserID
JOIN SubscriptionTypes st 
    ON us.SubscriptionTypeID = st.SubscriptionTypeID
WHERE us.IsActive = 1 
GO


CREATE VIEW VW_PlaybacksByDevice
AS
SELECT 
    dt.Name AS DeviceName,
    COUNT(ph.PlaybackID) AS PlaybackCount
FROM PlaybackHistory ph
JOIN DeviceTypes dt 
    ON ph.DeviceTypeID = dt.DeviceTypeID
GROUP BY dt.Name;
GO


CREATE VIEW VW_PlaybacksByGenre
AS
SELECT 
    g.Name AS GenreName,
    COUNT(ph.PlaybackID) AS PlaybackCount
FROM PlaybackHistory ph
JOIN SongPlaybackDetails spd 
    ON ph.PlaybackID = spd.PlaybackID
JOIN Songs s 
    ON spd.SongID = s.SongID
JOIN Genres g 
    ON s.GenreID = g.GenreID
GROUP BY g.Name;
GO


CREATE VIEW VW_PlaybacksByPodcastCategory
AS
SELECT 
    pc.Name AS CategoryName,
    COUNT(ph.PlaybackID) AS PlaybackCount
FROM PlaybackHistory ph
JOIN EpisodePlaybackDetails epd 
    ON ph.PlaybackID = epd.PlaybackID
JOIN PodcastEpisodes pe 
    ON epd.EpisodeID = pe.EpisodeID
JOIN Podcasts p 
    ON pe.PodcastID = p.PodcastID
JOIN PodcastCategories pc 
    ON p.CategoryID = pc.CategoryID
GROUP BY pc.Name;
GO
