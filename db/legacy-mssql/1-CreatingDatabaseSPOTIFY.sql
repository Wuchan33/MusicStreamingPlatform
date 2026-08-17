------------------------------------------------
------------CREATING DATABASE-------------------
USE MASTER;
GO
IF DB_ID('SPOTIFY') IS NOT NULL
    DROP DATABASE SPOTIFY
CREATE DATABASE SPOTIFY
GO
USE SPOTIFY;
GO
------------CREATING DATABASE-------------------
------------------------------------------------




------------------------------------------------
----------------OTHER---------------------------
CREATE TABLE Languages (
	LanguageID INT PRIMARY KEY,
 	Name NVARCHAR(50) NOT NULL,
  	
  	CONSTRAINT UQ_Languages_Name UNIQUE(Name)
);
GO


CREATE TABLE Countries (
	CountryID INT PRIMARY KEY,
  	Name NVARCHAR(50) NOT NULL,
  	
  	CONSTRAINT UQ_Countries_Name UNIQUE(Name)
);
GO
----------------OTHER---------------------------
------------------------------------------------





--------------------------------------------------
-------------------USERS--------------------------
CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    Username NVARCHAR(50) NOT NULL,
    Email NVARCHAR(50) NOT NULL,
	DateOfBirth DATE NOT NULL,
	RegistrationDate DATETIME DEFAULT GETDATE() NOT NULL,
	CountryID INT NOT NULL,

	CONSTRAINT UQ_Users_Username UNIQUE(Username),
	CONSTRAINT UQ_Users_Email UNIQUE(Email),

	CONSTRAINT CK_Users_DateOfBirth
		CHECK (DateOfBirth <= GETDATE()),
	CONSTRAINT CK_Users_Email_Format
        CHECK (Email LIKE '%_@_%._%'),

	CONSTRAINT FK_Users_Countries
		FOREIGN KEY (CountryID)
        REFERENCES Countries(CountryID)
);
GO


CREATE TABLE SubscriptionTypes (
    SubscriptionTypeID INT PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL,
    Price MONEY NOT NULL,
    DurationMonths INT NOT NULL,
  	
  	CONSTRAINT UQ_SubscriptionTypes_Name UNIQUE (Name),

  	CONSTRAINT CK_SubscriptionTypes_Price
  		CHECK (Price >= 0),
  	CONSTRAINT CK_SubscriptionTypes_DurationMonths
  		CHECK (DurationMonths > 0)
);
GO


CREATE TABLE UserSubscriptions (
    UserSubscriptionID INT PRIMARY KEY,
    UserID INT NOT NULL,                         
    SubscriptionTypeID INT NOT NULL,             
    StartDate DATE DEFAULT CAST(GETDATE() AS DATE) NOT NULL,                    
    EndDate DATE,
    IsActive BIT,

	CONSTRAINT FK_UserSubscriptions_Users
		FOREIGN KEY (UserID)
		REFERENCES Users(UserID),
	CONSTRAINT FK_UserSubscriptions_SubscriptionTypes
		FOREIGN KEY (SubscriptionTypeID)
		REFERENCES SubscriptionTypes(SubscriptionTypeID)
);
GO


CREATE TABLE DeviceTypes (
    DeviceTypeID INT PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL,
  
 	CONSTRAINT UQ_DeviceTypes_Name UNIQUE (Name)
);
GO
-------------------USERS--------------------------
--------------------------------------------------





--------------------------------------------------
--------------------MUSIC-------------------------
CREATE TABLE Labels (
    LabelID INT PRIMARY KEY,
    Name NVARCHAR(200) NOT NULL,
    CountryID INT NOT NULL,
    ContactEmail NVARCHAR(255) NULL,

    CONSTRAINT UQ_Labels_Name UNIQUE (Name),

    CONSTRAINT CK_Labels_ContactEmail_Format
        CHECK (
			ContactEmail IS NULL OR
			(ContactEmail LIKE '%_@_%._%')
			),

	CONSTRAINT FK_Labels_Countries
		FOREIGN KEY (CountryID)
        REFERENCES Countries(CountryID)
);
GO


CREATE TABLE Genres (
    GenreID INT PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    PopularityFromYear INT NOT NULL,
    PopularityToYear INT NOT NULL,

	CONSTRAINT UQ_Genres_Name UNIQUE (Name),

    CONSTRAINT CK_Genres_PopularityRange
        CHECK (PopularityFromYear <= PopularityToYear)
);
GO


CREATE TABLE Producers (
    ProducerID INT PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    CountryID INT NOT NULL,

	CONSTRAINT FK_Producers_Countries
		FOREIGN KEY (CountryID)
        REFERENCES Countries(CountryID)
);
GO


CREATE TABLE Artists (
    ArtistID INT PRIMARY KEY,
    Name NVARCHAR(150) NOT NULL,
    CountryID INT NOT NULL,
    LabelID INT NULL,

    CONSTRAINT FK_Artists_Labels
        FOREIGN KEY (LabelID) 
		REFERENCES Labels(LabelID),
	CONSTRAINT FK_Artists_Countries
		FOREIGN KEY (CountryID)
        REFERENCES Countries(CountryID)
);
GO


CREATE TABLE Albums (
    AlbumID INT PRIMARY KEY,
    Title NVARCHAR(200) NOT NULL,
    ReleaseDate DATETIME DEFAULT GETDATE(),
    AlbumType NVARCHAR(20) NOT NULL,

    CONSTRAINT CK_Albums_AlbumType
        CHECK (AlbumType IN ('ALBUM', 'SINGLE')),
    CONSTRAINT CK_Albums_ReleaseDate
        CHECK (ReleaseDate <= GETDATE())
);
GO


CREATE TABLE Songs (
    SongID INT PRIMARY KEY,
    Title NVARCHAR(200) NOT NULL,
    DurationSeconds INT NOT NULL,
    IsExplicit BIT NOT NULL DEFAULT 0,
    ReleaseDate DATETIME DEFAULT GETDATE(),
    AlbumID INT NULL,
    GenreID INT NULL,
    ProducerID INT NOT NULL,
    StreamCount INT NOT NULL DEFAULT 0,

    CONSTRAINT CK_Songs_DurationSeconds
        CHECK (DurationSeconds > 0),
    CONSTRAINT CK_Songs_ReleaseDate
        CHECK (ReleaseDate <= GETDATE()),

	CONSTRAINT FK_Songs_Albums
        FOREIGN KEY (AlbumID)
        REFERENCES Albums(AlbumID),
    CONSTRAINT FK_Songs_Genres
        FOREIGN KEY (GenreID)
        REFERENCES Genres(GenreID),
	CONSTRAINT FK_Songs_Producers
        FOREIGN KEY (ProducerID)
        REFERENCES Producers(ProducerID)
);
GO


CREATE TABLE SongCreators (
    SongID INT NOT NULL,
    ArtistID INT NOT NULL,

	PRIMARY KEY (SongID, ArtistID),

    CONSTRAINT FK_SongCreators_Songs
        FOREIGN KEY (SongID)
        REFERENCES Songs(SongID),
    CONSTRAINT FK_SongCreators_Artists
        FOREIGN KEY (ArtistID)
        REFERENCES Artists(ArtistID)
);
GO


CREATE TABLE AlbumCreators (
    AlbumID INT NOT NULL,
    ArtistID INT NOT NULL,

	PRIMARY KEY (AlbumID, ArtistID),

    CONSTRAINT FK_AlbumCreators_Albums
        FOREIGN KEY (AlbumID)
        REFERENCES Albums(AlbumID),
    CONSTRAINT FK_AlbumCreators_Artists
        FOREIGN KEY (ArtistID)
        REFERENCES Artists(ArtistID)
);
GO
--------------------MUSIC-------------------------
--------------------------------------------------





--------------------------------------------------
--------------------PODCASTS----------------------
CREATE TABLE PodcastCategories (
    CategoryID INT PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL,

	CONSTRAINT UQ_PodcastCategories_Name UNIQUE (Name)
);
GO


CREATE TABLE Podcasts (
    PodcastID INT PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL,
    CategoryID INT,
    LanguageID INT,
    EpisodeCount INT NOT NULL DEFAULT 0,

	CONSTRAINT UQ_Podcasts_Name UNIQUE (Name),

	CONSTRAINT FK_Podcasts_PodcastCategories
        FOREIGN KEY (CategoryID)
        REFERENCES PodcastCategories(CategoryID),
	CONSTRAINT FK_Podcasts_Languages
        FOREIGN KEY (LanguageID)
        REFERENCES Languages(LanguageID)
);
GO


CREATE TABLE PodcastEpisodes (
    EpisodeID INT PRIMARY KEY,
    PodcastID INT NOT NULL,
    Title NVARCHAR(100) NOT NULL,
    DurationSeconds INT,
    ReleaseDate DATETIME DEFAULT GETDATE(),
    StreamCount INT NOT NULL DEFAULT 0,

	CONSTRAINT CK_PodcastEpisodes_DurationSeconds
        CHECK (DurationSeconds > 0),
	CONSTRAINT CK_PodcastEpisodes_ReleaseDate
        CHECK (ReleaseDate <= GETDATE()),

    CONSTRAINT FK_PodcastEpisodes_Podcasts
        FOREIGN KEY (PodcastID)
        REFERENCES Podcasts(PodcastID)
);
GO
--------------------PODCASTS----------------------
--------------------------------------------------





--------------------------------------------------
--------------------ADS---------------------------
CREATE TABLE Advertisers (
    AdvertiserID INT PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    CountryID INT NOT NULL,
  	
  	CONSTRAINT UQ_Advertisers_Name UNIQUE (Name),

 	CONSTRAINT FK_Advertisers_Countries
  		FOREIGN KEY (CountryID)
  		REFERENCES Countries(CountryID)
);
GO


CREATE TABLE Ads (
    AdID INT PRIMARY KEY,
    AdvertiserID INT NOT NULL,
    Title NVARCHAR(100) NOT NULL,
    DurationSeconds INT NOT NULL,
    StreamCount INT NOT NULL DEFAULT 0,
  
 	CONSTRAINT CK_Ads_DurationSeconds
  		CHECK (DurationSeconds > 0),

	CONSTRAINT FK_Ads_Advertisers
  		FOREIGN KEY (AdvertiserID)
  		REFERENCES Advertisers(AdvertiserID)
);
GO
--------------------ADS---------------------------
--------------------------------------------------





--------------------------------------------------
--------------------FOLLOWS-LIKES-----------------
CREATE TABLE FollowsArtists (
	UserID INT NOT NULL,
	ArtistID INT NOT NULL,
    FollowDate DATETIME DEFAULT GETDATE(),

	PRIMARY KEY (UserID, ArtistID),

	CONSTRAINT CK_FollowsArtists_FollowDate
        CHECK (FollowDate <= GETDATE()),

	CONSTRAINT FK_FollowsArtists_Users
        FOREIGN KEY (UserID)
        REFERENCES Users(UserID),
	CONSTRAINT FK_FollowsArtists_Artists
        FOREIGN KEY (ArtistID)
        REFERENCES Artists(ArtistID)
);
GO


CREATE TABLE FollowsPodcasts (
	UserID INT NOT NULL,
	PodcastID INT NOT NULL,
    FollowDate DATETIME DEFAULT GETDATE(),

	PRIMARY KEY (UserID, PodcastID),

	CONSTRAINT CK_FollowsPodcasts_FollowDate
        CHECK (FollowDate <= GETDATE()),

	CONSTRAINT FK_FollowsPodcasts_Users
        FOREIGN KEY (UserID)
        REFERENCES Users(UserID),
	CONSTRAINT FK_FollowsPodcasts_Podcasts
        FOREIGN KEY (PodcastID)
        REFERENCES Podcasts(PodcastID)
);
GO


CREATE TABLE SongLikes (
	UserID INT NOT NULL,
	SongID INT NOT NULL,
    LikeDate DATETIME DEFAULT GETDATE(),

	PRIMARY KEY (UserID, SongID),

	CONSTRAINT CK_SongLikes_LikeDate
        CHECK (LikeDate <= GETDATE()),

	CONSTRAINT FK_SongLikes_Users
        FOREIGN KEY (UserID)
        REFERENCES Users(UserID),
	CONSTRAINT FK_SongLikes_Songs
        FOREIGN KEY (SongID)
        REFERENCES Songs(SongID)
);
GO


CREATE TABLE EpisodeLikes (
	UserID INT NOT NULL,
	EpisodeID INT NOT NULL,
    LikeDate DATETIME DEFAULT GETDATE(),

	PRIMARY KEY (UserID, EpisodeID),

	CONSTRAINT CK_EpisodeLikes_LikeDate
        CHECK (LikeDate <= GETDATE()),

	CONSTRAINT FK_EpisodeLikes_Users
        FOREIGN KEY (UserID)
        REFERENCES Users(UserID),
	CONSTRAINT FK_EpisodeLikes_PodcastEpisodes
        FOREIGN KEY (EpisodeID)
        REFERENCES PodcastEpisodes(EpisodeID)
);
GO
--------------------FOLLOWS-LIKES-----------------
--------------------------------------------------





--------------------------------------------------
-----------------PLAYBACK HISTORY-----------------
CREATE TABLE PlaybackHistory (
    PlaybackID INT IDENTITY PRIMARY KEY,
    UserID INT NOT NULL,
    PlaybackDate DATETIME DEFAULT GETDATE() NOT NULL,
    DurationPlayedSeconds INT NOT NULL,
	DeviceTypeID INT NOT NULL,
    MediaType NVARCHAR(15) NOT NULL,
    MediaID INT NOT NULL,

	CONSTRAINT CK_PlaybackHistory_PlaybackDate
        CHECK (PlaybackDate <= GETDATE()),
  	CONSTRAINT CK_PlaybackHistory_DurationPlayedSeconds 
  		CHECK (DurationPlayedSeconds >= 0),
    CONSTRAINT CK_PlaybackHistory_MediaType
        CHECK (MediaType IN ('SONG', 'EPISODE', 'AD')),
	
	CONSTRAINT FK_PlaybackHistory_Users 
  		FOREIGN KEY (UserID)
  		REFERENCES Users(UserID),
	CONSTRAINT FK_PlaybackHistory_DeviceTypes
  		FOREIGN KEY (DeviceTypeID)
  		REFERENCES DeviceTypes(DeviceTypeID)
);
GO


CREATE TABLE SongPlaybackDetails (
    PlaybackID INT PRIMARY KEY,
    SongID INT NOT NULL,

	CONSTRAINT FK_SongPlaybackDetails_PlaybackHistory
  		FOREIGN KEY (PlaybackID)
  		REFERENCES PlaybackHistory(PlaybackID),
    CONSTRAINT FK_PlaybackDetails_Songs 
  		FOREIGN KEY (SongID)
  		REFERENCES Songs(SongID)
);
GO


CREATE TABLE EpisodePlaybackDetails (
    PlaybackID INT PRIMARY KEY,
    EpisodeID INT NOT NULL,

	CONSTRAINT FK_EpisodePlaybackDetails_PlaybackHistory
  		FOREIGN KEY (PlaybackID)
  		REFERENCES PlaybackHistory(PlaybackID),
    CONSTRAINT FK_EpisodePlaybackDetails_PodcastEpisodes 
  		FOREIGN KEY (EpisodeID)
  		REFERENCES PodcastEpisodes(EpisodeID)
);
GO

CREATE TABLE AdPlaybackDetails (
    PlaybackID INT PRIMARY KEY,
    AdID INT NOT NULL,

	CONSTRAINT FK_AdPlaybackDetails_PlaybackHistory
  		FOREIGN KEY (PlaybackID)
  		REFERENCES PlaybackHistory(PlaybackID),
    CONSTRAINT FK_AdPlaybackDetails_Ads
  		FOREIGN KEY (AdID)
  		REFERENCES Ads(AdID)
);
GO
-----------------PLAYBACK HISTORY-----------------
--------------------------------------------------




--------------------------------------------------
--------------------INDEXES-----------------------
CREATE INDEX IDX_PlaybackHistory_UserID
ON PlaybackHistory (UserID);
GO

CREATE INDEX IDX_PlaybackHistory_PlaybackDate
ON PlaybackHistory (PlaybackDate);
GO

CREATE INDEX IDX_PlaybackHistory_DeviceTypeID
ON PlaybackHistory (DeviceTypeID);
GO

CREATE INDEX IDX_Songs_GenreID
ON Songs (GenreID);
GO

CREATE INDEX IDX_UserSubscriptions_UserID
ON UserSubscriptions (UserID);
GO

CREATE INDEX IDX_SongCreators_ArtistID
ON SongCreators (ArtistID);
GO

CREATE INDEX IDX_AlbumCreators_ArtistID
ON AlbumCreators (ArtistID);
GO
--------------------INDEXES-----------------------
--------------------------------------------------
