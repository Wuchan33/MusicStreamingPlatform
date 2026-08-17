USE SPOTIFY;
GO

CREATE FUNCTION GetUserMostStreamedGenre (@UserID INT)
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @Result NVARCHAR(100);
    SELECT TOP 1 @Result = g.Name
    FROM PlaybackHistory ph
    JOIN SongPlaybackDetails spd ON ph.PlaybackID = spd.PlaybackID
    JOIN Songs s ON spd.SongID = s.SongID
    JOIN Genres g ON s.GenreID = g.GenreID
    WHERE ph.UserID = @UserID
    GROUP BY g.GenreID, g.Name
    ORDER BY COUNT(*) DESC;
    RETURN @Result;
END;
GO


CREATE FUNCTION GetUserMostStreamedArtist (@UserID INT)
RETURNS NVARCHAR(150)
AS
BEGIN
    DECLARE @Result NVARCHAR(150);
    SELECT TOP 1 @Result = a.Name
    FROM PlaybackHistory ph
    JOIN SongPlaybackDetails spd ON ph.PlaybackID = spd.PlaybackID
    JOIN SongCreators sc ON spd.SongID = sc.SongID
    JOIN Artists a ON sc.ArtistID = a.ArtistID
    WHERE ph.UserID = @UserID
    GROUP BY a.ArtistID, a.Name
    ORDER BY COUNT(*) DESC;
    RETURN @Result;
END;
GO


CREATE FUNCTION GetUserMostStreamedAlbum (@UserID INT)
RETURNS NVARCHAR(200)
AS
BEGIN
    DECLARE @Result NVARCHAR(200);
    SELECT TOP 1 @Result = alb.Title
    FROM PlaybackHistory ph
    JOIN SongPlaybackDetails spd ON ph.PlaybackID = spd.PlaybackID
    JOIN Songs s ON spd.SongID = s.SongID
    JOIN Albums alb ON s.AlbumID = alb.AlbumID
    WHERE ph.UserID = @UserID
        AND alb.AlbumType = 'ALBUM'
    GROUP BY alb.AlbumID, alb.Title
    ORDER BY COUNT(*) DESC;
    RETURN @Result;
END;
GO


CREATE FUNCTION GetUserMostStreamedSong (@UserID INT)
RETURNS NVARCHAR(200)
AS
BEGIN
    DECLARE @Result NVARCHAR(200);
    SELECT TOP 1 @Result = s.Title
    FROM PlaybackHistory ph
    JOIN SongPlaybackDetails spd ON ph.PlaybackID = spd.PlaybackID
    JOIN Songs s ON spd.SongID = s.SongID
    WHERE ph.UserID = @UserID
    GROUP BY s.SongID, s.Title
    ORDER BY COUNT(*) DESC;
    RETURN @Result;
END;
GO


CREATE FUNCTION GetUserMostStreamedPodcast (@UserID INT)
RETURNS NVARCHAR(50)
AS
BEGIN
    DECLARE @Result NVARCHAR(50);
    SELECT TOP 1 @Result = p.Name
    FROM PlaybackHistory ph
    JOIN EpisodePlaybackDetails epd ON ph.PlaybackID = epd.PlaybackID
    JOIN PodcastEpisodes pe ON epd.EpisodeID = pe.EpisodeID
    JOIN Podcasts p ON pe.PodcastID = p.PodcastID
    WHERE ph.UserID = @UserID
    GROUP BY p.PodcastID, p.Name
    ORDER BY COUNT(*) DESC;
    RETURN @Result;
END;
GO


CREATE FUNCTION GetUserMostStreamedPodcastCategory (@UserID INT)
RETURNS NVARCHAR(50)
AS
BEGIN
    DECLARE @Result NVARCHAR(50);
    SELECT TOP 1 @Result = pc.Name
    FROM PlaybackHistory ph
    JOIN EpisodePlaybackDetails epd ON ph.PlaybackID = epd.PlaybackID
    JOIN PodcastEpisodes pe ON epd.EpisodeID = pe.EpisodeID
    JOIN Podcasts p ON pe.PodcastID = p.PodcastID
    JOIN PodcastCategories pc ON p.CategoryID = pc.CategoryID
    WHERE ph.UserID = @UserID
    GROUP BY pc.CategoryID, pc.Name
    ORDER BY COUNT(*) DESC;
    RETURN @Result;
END;
GO


CREATE FUNCTION GetUserListeningStats
(
    @UserID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        CAST(ISNULL(SUM(ph.DurationPlayedSeconds) / 60.0, 0) AS DECIMAL(10, 1)) AS TotalListeningMinutes,
        CAST(ISNULL(SUM(CASE WHEN ph.MediaType = 'SONG' THEN DurationPlayedSeconds ELSE 0 END) / 60.0, 0) AS DECIMAL(10, 1)) AS SongsMinutes,
        CAST(ISNULL(SUM(CASE WHEN ph.MediaType = 'EPISODE' THEN DurationPlayedSeconds ELSE 0 END) / 60.0, 0) AS DECIMAL(10, 1)) AS PodcastsMinutes,
        CAST(ISNULL(SUM(CASE WHEN ph.MediaType = 'AD' THEN DurationPlayedSeconds ELSE 0 END) / 60.0, 0) AS DECIMAL(10, 1)) AS AdsMinutes
    FROM PlaybackHistory ph
    WHERE UserID = @UserID
);
GO


CREATE FUNCTION GetArtistTotalStreams (@ArtistID INT)
RETURNS INT
AS
BEGIN
    DECLARE @TotalStreams INT;

    SELECT @TotalStreams = COUNT(ph.PlaybackID)
    FROM PlaybackHistory ph
    JOIN SongPlaybackDetails spd ON ph.PlaybackID = spd.PlaybackID
    JOIN SongCreators sc ON spd.SongID = sc.SongID
    WHERE sc.ArtistID = @ArtistID;

    RETURN ISNULL(@TotalStreams, 0);
END;
GO


CREATE FUNCTION GetPodcastTotalStreams (@PodcastID INT)
RETURNS INT
AS
BEGIN
    DECLARE @TotalStreams INT;

    SELECT @TotalStreams = COUNT(ph.PlaybackID)
    FROM PlaybackHistory ph
    JOIN EpisodePlaybackDetails epd ON ph.PlaybackID = epd.PlaybackID
    JOIN PodcastEpisodes pe ON epd.EpisodeID = pe.EpisodeID
    WHERE pe.PodcastID = @PodcastID;

    RETURN ISNULL(@TotalStreams, 0);
END;
GO