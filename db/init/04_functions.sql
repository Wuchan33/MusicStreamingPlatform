--  MOST STREAMED

CREATE FUNCTION get_user_most_streamed_genre(p_user_id INT) RETURNS TEXT AS $$
    SELECT g.name
    FROM playback_history ph
    JOIN song_playback_details spd USING (playback_id)
    JOIN songs s USING (song_id)
    JOIN genres g USING (genre_id)
    WHERE ph.user_id = p_user_id
    GROUP BY g.genre_id
    ORDER BY COUNT(*) DESC, g.name
    LIMIT 1;
$$ LANGUAGE sql STABLE;

CREATE FUNCTION get_user_most_streamed_artist(p_user_id INT) RETURNS TEXT AS $$
    SELECT a.name
    FROM playback_history ph
    JOIN song_playback_details spd USING (playback_id)
    JOIN song_creators sc USING (song_id)
    JOIN artists a USING (artist_id)
    WHERE ph.user_id = p_user_id
    GROUP BY a.artist_id
    ORDER BY COUNT(*) DESC, a.name
    LIMIT 1;
$$ LANGUAGE sql STABLE;

CREATE FUNCTION get_user_most_streamed_song(p_user_id INT) RETURNS TEXT AS $$
    SELECT s.title
    FROM playback_history ph
    JOIN song_playback_details spd USING (playback_id)
    JOIN songs s USING (song_id)
    WHERE ph.user_id = p_user_id
    GROUP BY s.song_id
    ORDER BY COUNT(*) DESC, s.title
    LIMIT 1;
$$ LANGUAGE sql STABLE;

CREATE FUNCTION get_user_most_streamed_album(p_user_id INT) RETURNS TEXT AS $$
    SELECT alb.title
    FROM playback_history ph
    JOIN song_playback_details spd USING (playback_id)
    JOIN songs s USING (song_id)
    JOIN albums alb USING (album_id)
    WHERE ph.user_id = p_user_id AND alb.release_type = 'ALBUM'
    GROUP BY alb.album_id
    ORDER BY COUNT(*) DESC, alb.title
    LIMIT 1;
$$ LANGUAGE sql STABLE;

CREATE FUNCTION get_user_most_streamed_podcast(p_user_id INT) RETURNS TEXT AS $$
    SELECT p.name
    FROM playback_history ph
    JOIN episode_playback_details epd USING (playback_id)
    JOIN podcast_episodes pe USING (episode_id)
    JOIN podcasts p USING (podcast_id)
    WHERE ph.user_id = p_user_id
    GROUP BY p.podcast_id
    ORDER BY COUNT(*) DESC, p.name
    LIMIT 1;
$$ LANGUAGE sql STABLE;

CREATE FUNCTION get_user_most_streamed_episode(p_user_id INT) RETURNS TEXT AS $$
    SELECT pe.title
    FROM playback_history ph
    JOIN episode_playback_details epd USING (playback_id)
    JOIN podcast_episodes pe USING (episode_id)
    WHERE ph.user_id = p_user_id
    GROUP BY pe.episode_id
    ORDER BY COUNT(*) DESC, pe.title
    LIMIT 1;
$$ LANGUAGE sql STABLE;

CREATE FUNCTION get_user_most_streamed_podcast_category(p_user_id INT)
RETURNS TEXT AS $$
    SELECT pc.name
    FROM playback_history ph
    JOIN episode_playback_details epd USING (playback_id)
    JOIN podcast_episodes pe USING (episode_id)
    JOIN podcasts p USING (podcast_id)
    JOIN podcast_categories pc USING (category_id)
    WHERE ph.user_id = p_user_id
    GROUP BY pc.category_id
    ORDER BY COUNT(*) DESC, pc.name
    LIMIT 1;
$$ LANGUAGE sql STABLE;


--  LISTENING STATS

CREATE FUNCTION get_user_listening_stats(p_user_id INT)
RETURNS TABLE (
    total_minutes    NUMERIC(10,1),
    songs_minutes    NUMERIC(10,1),
    podcasts_minutes NUMERIC(10,1),
    ads_minutes      NUMERIC(10,1)
) AS $$
    SELECT
        round(COALESCE(sum(duration_played_seconds), 0) / 60.0, 1),
        round(COALESCE(sum(duration_played_seconds)
                       FILTER (WHERE media_type = 'SONG'), 0) / 60.0, 1),
        round(COALESCE(sum(duration_played_seconds)
                       FILTER (WHERE media_type = 'EPISODE'), 0) / 60.0, 1),
        round(COALESCE(sum(duration_played_seconds)
                       FILTER (WHERE media_type = 'AD'), 0) / 60.0, 1)
    FROM playback_history
    WHERE user_id = p_user_id;
$$ LANGUAGE sql STABLE;


--  TOTAL STREAMS

CREATE FUNCTION get_artist_total_streams(p_artist_id INT) RETURNS BIGINT AS $$
    SELECT count(*)
    FROM song_playback_details spd
    JOIN song_creators sc USING (song_id)
    WHERE sc.artist_id = p_artist_id;
$$ LANGUAGE sql STABLE;

CREATE FUNCTION get_podcast_total_streams(p_podcast_id INT) RETURNS BIGINT AS $$
    SELECT count(*)
    FROM episode_playback_details epd
    JOIN podcast_episodes pe USING (episode_id)
    WHERE pe.podcast_id = p_podcast_id;
$$ LANGUAGE sql STABLE;


--  SUMMARIES

CREATE FUNCTION get_podcast_summary(p_podcast_id INT)
RETURNS TABLE (
    podcast_name        TEXT,
    episode_count       INT,
    total_streams       BIGINT,
    avg_episode_minutes NUMERIC(10,1)
) AS $$
    SELECT
        p.name,
        p.episode_count,
        get_podcast_total_streams(p.podcast_id),
        (SELECT round(COALESCE(avg(duration_seconds), 0) / 60.0, 1)
         FROM podcast_episodes
         WHERE podcast_id = p.podcast_id)
    FROM podcasts p
    WHERE p.podcast_id = p_podcast_id;
$$ LANGUAGE sql STABLE;

CREATE FUNCTION get_artist_summary(p_artist_id INT)
RETURNS TABLE (
    artist_name    TEXT,
    song_count     BIGINT,
    album_count    BIGINT,
    total_streams  BIGINT,
    follower_count BIGINT
) AS $$
    SELECT
        a.name,
        (SELECT count(*) FROM song_creators WHERE artist_id = a.artist_id),
        (SELECT count(*) FROM album_creators WHERE artist_id = a.artist_id),
        get_artist_total_streams(a.artist_id),
        (SELECT count(*) FROM follows_artists WHERE artist_id = a.artist_id)
    FROM artists a
    WHERE a.artist_id = p_artist_id;
$$ LANGUAGE sql STABLE;
