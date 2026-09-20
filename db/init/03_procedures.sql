--  PLAYBACK

CREATE PROCEDURE stream_song(
    p_user_id INT,
    p_song_id INT,
    p_device_type_id INT DEFAULT 1
)
AS $$
BEGIN
    INSERT INTO playback_history
        (user_id, duration_played_seconds, device_type_id, media_type, media_id)
    SELECT p_user_id, duration_seconds, p_device_type_id, 'SONG', song_id
    FROM songs
    WHERE song_id = p_song_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Validation Error: no song with id %',
            p_song_id
            USING ERRCODE = 'foreign_key_violation';
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE PROCEDURE stream_episode(
    p_user_id INT,
    p_episode_id INT,
    p_device_type_id INT DEFAULT 1
)
AS $$
BEGIN
    INSERT INTO playback_history
        (user_id, duration_played_seconds, device_type_id, media_type, media_id)
    SELECT p_user_id, duration_seconds, p_device_type_id, 'EPISODE', episode_id
    FROM podcast_episodes
    WHERE episode_id = p_episode_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Validation Error: no episode with id %',
            p_episode_id
            USING ERRCODE = 'foreign_key_violation';
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE PROCEDURE stream_ad(
    p_user_id INT,
    p_ad_id INT,
    p_device_type_id INT DEFAULT 1
)
AS $$
BEGIN
    INSERT INTO playback_history
        (user_id, duration_played_seconds, device_type_id, media_type, media_id)
    SELECT p_user_id, duration_seconds, p_device_type_id, 'AD', ad_id
    FROM ads
    WHERE ad_id = p_ad_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Validation Error: no ad with id %',
            p_ad_id
            USING ERRCODE = 'foreign_key_violation';
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE PROCEDURE stream_album(
    p_user_id INT,
    p_album_id INT,
    p_device_type_id INT DEFAULT 1
)
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM albums WHERE album_id = p_album_id) THEN
        RAISE EXCEPTION 'Validation Error: no album with id %',
            p_album_id
            USING ERRCODE = 'foreign_key_violation';
    END IF;

    INSERT INTO playback_history
        (user_id, duration_played_seconds, device_type_id, media_type, media_id)
    SELECT p_user_id, duration_seconds, p_device_type_id, 'SONG', song_id
    FROM songs
    WHERE album_id = p_album_id;
END;
$$ LANGUAGE plpgsql;

CREATE PROCEDURE stream_discography(
    p_user_id INT,
    p_artist_id INT,
    p_device_type_id INT DEFAULT 1
)
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM artists WHERE artist_id = p_artist_id) THEN
        RAISE EXCEPTION 'Validation Error: no artist with id %',
            p_artist_id
            USING ERRCODE = 'foreign_key_violation';
    END IF;

    INSERT INTO playback_history
        (user_id, duration_played_seconds, device_type_id, media_type, media_id)
    SELECT p_user_id, duration_seconds, p_device_type_id, 'SONG', song_id
    FROM songs
    JOIN song_creators USING (song_id)
    WHERE artist_id = p_artist_id;
END;
$$ LANGUAGE plpgsql;

CREATE PROCEDURE stream_podcast(
    p_user_id INT,
    p_podcast_id INT,
    p_device_type_id INT DEFAULT 1
)
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM podcasts WHERE podcast_id = p_podcast_id) THEN
        RAISE EXCEPTION 'Validation Error: no podcast with id %',
            p_podcast_id
            USING ERRCODE = 'foreign_key_violation';
    END IF;

    INSERT INTO playback_history
        (user_id, duration_played_seconds, device_type_id, media_type, media_id)
    SELECT p_user_id, duration_seconds, p_device_type_id, 'EPISODE', episode_id
    FROM podcast_episodes
    WHERE podcast_id = p_podcast_id;
END;
$$ LANGUAGE plpgsql;


--  LIKES AND FOLLOWS

CREATE PROCEDURE like_album(
    p_user_id INT,
    p_album_id INT
)
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM albums WHERE album_id = p_album_id) THEN
        RAISE EXCEPTION 'Validation Error: no album with id %',
            p_album_id
            USING ERRCODE = 'foreign_key_violation';
    END IF;

    INSERT INTO song_likes (user_id, song_id)
    SELECT p_user_id, song_id
    FROM songs
    WHERE album_id = p_album_id
    ON CONFLICT DO NOTHING;
END;
$$ LANGUAGE plpgsql;

CREATE PROCEDURE like_podcast(
    p_user_id INT,
    p_podcast_id INT
)
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM podcasts WHERE podcast_id = p_podcast_id) THEN
        RAISE EXCEPTION 'Validation Error: no podcast with id %',
            p_podcast_id
            USING ERRCODE = 'foreign_key_violation';
    END IF;

    INSERT INTO episode_likes (user_id, episode_id)
    SELECT p_user_id, episode_id
    FROM podcast_episodes
    WHERE podcast_id = p_podcast_id
    ON CONFLICT DO NOTHING;
END;
$$ LANGUAGE plpgsql;

CREATE PROCEDURE follow_label(
    p_user_id INT,
    p_label_id INT
)
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM labels WHERE label_id = p_label_id) THEN
        RAISE EXCEPTION 'Validation Error: no label with id %',
            p_label_id
            USING ERRCODE = 'foreign_key_violation';
    END IF;

    INSERT INTO follows_artists (user_id, artist_id)
    SELECT p_user_id, artist_id
    FROM artists
    WHERE label_id = p_label_id
    ON CONFLICT DO NOTHING;
END;
$$ LANGUAGE plpgsql;
