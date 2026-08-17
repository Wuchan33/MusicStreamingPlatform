USE SPOTIFY;
GO
------------------------------------------------
--------------------MEDIA-----------------------
CREATE PROCEDURE StreamSong
    @UserID INT,
    @SongID INT,
    @DeviceTypeID INT = 1
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO PlaybackHistory (UserID, PlaybackDate, DurationPlayedSeconds, DeviceTypeID, MediaType, MediaID)
    SELECT 
        @UserID, 
        GETDATE(), 
        s.DurationSeconds, 
        @DeviceTypeID, 
        'SONG', 
        s.SongID
    FROM Songs s
    WHERE s.SongID = @SongID;
END;
GO


CREATE PROCEDURE StreamAlbum
    @UserID INT,
    @AlbumID INT,
    @DeviceTypeID INT = 1
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO PlaybackHistory (UserID, PlaybackDate, DurationPlayedSeconds, DeviceTypeID, MediaType, MediaID)
    SELECT 
        @UserID, 
        GETDATE(), 
        s.DurationSeconds, 
        @DeviceTypeID, 
        'SONG', 
        s.SongID
    FROM Songs s
    WHERE AlbumID = @AlbumID;
END;
GO


CREATE PROCEDURE StreamDiscography
    @UserID INT,
    @ArtistID INT,
    @DeviceTypeID INT = 1
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO PlaybackHistory (UserID, PlaybackDate, DurationPlayedSeconds, DeviceTypeID, MediaType, MediaID)
    SELECT 
        @UserID, 
        GETDATE(), 
        s.DurationSeconds, 
        @DeviceTypeID, 
        'SONG', 
        s.SongID
    FROM Songs s
    JOIN SongCreators sc ON s.SongID = sc.SongID
    WHERE sc.ArtistID = @ArtistID;
END;
GO


CREATE OR ALTER PROCEDURE LikeAlbum
    @UserID INT,
    @AlbumID INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO SongLikes (UserID, SongID, LikeDate)
    SELECT @UserID, SongID, GETDATE()
    FROM Songs
    WHERE AlbumID = @AlbumID
        AND SongID NOT IN (
            SELECT SongID FROM SongLikes WHERE UserID = @UserID
        );
END;
GO


CREATE OR ALTER PROCEDURE FollowLabel
    @UserID INT,
    @LabelID INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO FollowsArtists (UserID, ArtistID, FollowDate)
    SELECT @UserID, ArtistID, GETDATE()
    FROM Artists
    WHERE LabelID = @LabelID
        AND ArtistID NOT IN (
            SELECT ArtistID FROM FollowsArtists WHERE UserID = @UserID
        );
END;
GO
--------------------MEDIA-----------------------
------------------------------------------------




------------------------------------------------
---------------UPDATE ISACTIVE------------------

-- this procedure should be executed everyday at 00:00

CREATE OR ALTER PROCEDURE UpdateIsActive
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE UserSubscriptions
    SET IsActive = 0
    WHERE IsActive = 1 
        AND EndDate < CAST(GETDATE() AS DATE);

END;
GO
---------------UPDATE ISACTIVE------------------
------------------------------------------------
