USE SPOTIFY;
GO
------------------------------------------------
--------------------MEDIA-----------------------
CREATE TRIGGER TR_PlaybackHistory_InsertWithValidation
ON PlaybackHistory
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1 FROM inserted i
        LEFT JOIN Songs s ON i.MediaID = s.SongID AND i.MediaType = 'SONG'
        LEFT JOIN PodcastEpisodes e ON i.MediaID = e.EpisodeID AND i.MediaType = 'EPISODE'
        LEFT JOIN Ads a ON i.MediaID = a.AdID AND i.MediaType = 'AD'
        WHERE 
            (i.MediaType = 'SONG' AND s.SongID IS NULL) OR
            (i.MediaType = 'EPISODE' AND e.EpisodeID IS NULL) OR
            (i.MediaType = 'AD' AND a.AdID IS NULL) OR

            (i.MediaType = 'SONG' AND i.DurationPlayedSeconds > s.DurationSeconds) OR
            (i.MediaType = 'EPISODE' AND i.DurationPlayedSeconds > e.DurationSeconds) OR
            (i.MediaType = 'AD' AND i.DurationPlayedSeconds <> a.DurationSeconds)
    )
    BEGIN
        RAISERROR ('Validation Error: Invalid MediaID for the specified type or DurationPlayedSeconds exceeds media length.', 16, 1);
        RETURN;
    END

    DECLARE @NewIDs TABLE (
        PlaybackID INT,
        MediaID INT,
        MediaType NVARCHAR(15)
    );

    INSERT INTO PlaybackHistory (UserID, PlaybackDate, DurationPlayedSeconds, DeviceTypeID, MediaType, MediaID)
    OUTPUT inserted.PlaybackID, inserted.MediaID, inserted.MediaType INTO @NewIDs
    SELECT UserID, PlaybackDate, DurationPlayedSeconds, DeviceTypeID, MediaType, MediaID
    FROM inserted;

    INSERT INTO SongPlaybackDetails (PlaybackID, SongID)
    SELECT PlaybackID, MediaID FROM @NewIDs WHERE MediaType = 'SONG';

    INSERT INTO EpisodePlaybackDetails (PlaybackID, EpisodeID)
    SELECT PlaybackID, MediaID FROM @NewIDs WHERE MediaType = 'EPISODE';

    INSERT INTO AdPlaybackDetails (PlaybackID, AdID)
    SELECT PlaybackID, MediaID FROM @NewIDs WHERE MediaType = 'AD';
END;
GO


CREATE TRIGGER TR_PlaybackHistory_UpdateStreamCounts
ON PlaybackHistory
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE s
    SET s.StreamCount = s.StreamCount + sub.CountAdded
    FROM Songs s
    JOIN (
        SELECT i.MediaID, COUNT(*) AS CountAdded
        FROM inserted i
        JOIN Songs s2 ON i.MediaID = s2.SongID
        WHERE i.MediaType = 'SONG'
          AND (i.DurationPlayedSeconds >= 30 
               OR i.DurationPlayedSeconds >= (s2.DurationSeconds * 0.5))
        GROUP BY i.MediaID
    ) sub ON s.SongID = sub.MediaID;

    UPDATE pe
    SET pe.StreamCount = pe.StreamCount + sub.CountAdded
    FROM PodcastEpisodes pe
    JOIN (
        SELECT i.MediaID, COUNT(*) AS CountAdded
        FROM inserted i
        JOIN PodcastEpisodes pe2 ON i.MediaID = pe2.EpisodeID
        WHERE i.MediaType = 'EPISODE'
          AND (i.DurationPlayedSeconds >= 300 
               OR i.DurationPlayedSeconds >= (pe2.DurationSeconds * 0.5))
        GROUP BY i.MediaID
    ) sub ON pe.EpisodeID = sub.MediaID;

    UPDATE a
    SET a.StreamCount = a.StreamCount + sub.CountAdded
    FROM Ads a
    JOIN (
        SELECT i.MediaID, COUNT(*) AS CountAdded
        FROM inserted i
        WHERE i.MediaType = 'AD'
        GROUP BY i.MediaID
    ) sub ON a.AdID = sub.MediaID;
END;
GO


CREATE TRIGGER TR_PodcastEpisodes_UpdateCount
ON PodcastEpisodes
AFTER INSERT, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM inserted)
    BEGIN
        UPDATE p
        SET p.EpisodeCount = p.EpisodeCount + sub.NewEpisodes
        FROM Podcasts p
        JOIN (
            SELECT PodcastID, COUNT(*) AS NewEpisodes
            FROM inserted
            GROUP BY PodcastID
        ) sub ON p.PodcastID = sub.PodcastID;
    END
END;
GO
--------------------MEDIA-----------------------
------------------------------------------------



------------------------------------------------
----------------SUBSCRIPTIONS-------------------
CREATE TRIGGER TR_UserSubscriptions_InsertWithValidation
ON UserSubscriptions
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1 
        FROM UserSubscriptions us
        JOIN inserted i ON us.UserID = i.UserID
        WHERE us.IsActive = 1
    )
    BEGIN
        RAISERROR ('Validation Error: User already has an active subscription.', 16, 1);
        RETURN;
    END

    INSERT INTO UserSubscriptions (UserSubscriptionID, UserID, SubscriptionTypeID, StartDate)
    SELECT UserSubscriptionID, UserID, SubscriptionTypeID, StartDate
    FROM inserted;
END;
GO


CREATE TRIGGER TR_UserSubscriptions_SetEndDate
ON UserSubscriptions
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE us
    SET 
        us.EndDate = DATEADD(MONTH, st.DurationMonths, i.StartDate),
        us.IsActive = 1
    FROM UserSubscriptions us
    JOIN inserted i ON us.UserSubscriptionID = i.UserSubscriptionID
    JOIN SubscriptionTypes st ON i.SubscriptionTypeID = st.SubscriptionTypeID;
END;
GO
----------------SUBSCRIPTIONS-------------------
------------------------------------------------

