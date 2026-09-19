--  LIBRARIES

CREATE VIEW vw_song_library AS
SELECT
    a.artist_id,
    a.name AS artist_name,
    alb.release_type,
    alb.title AS album_title,
    s.title AS song_title,
    s.duration_seconds,
    g.name AS genre_name,
    s.release_date,
    s.stream_count
FROM artists a
JOIN song_creators sc USING (artist_id)
JOIN songs s USING (song_id)
LEFT JOIN albums alb USING (album_id)
LEFT JOIN genres g USING (genre_id);

CREATE VIEW vw_podcast_library AS
SELECT
    p.podcast_id,
    p.name AS podcast_name,
    pc.name AS category_name,
    l.name AS language_name,
    pe.title AS episode_title,
    pe.duration_seconds,
    pe.release_date,
    pe.stream_count
FROM podcasts p
JOIN podcast_episodes pe USING (podcast_id)
LEFT JOIN podcast_categories pc USING (category_id)
LEFT JOIN languages l USING (language_id);


--  SUBSCRIPTIONS

CREATE VIEW vw_active_subscribers AS
SELECT
    u.user_id,
    u.username,
    u.email,
    st.name AS subscription_type,
    st.price,
    us.start_date,
    us.end_date
FROM users u
JOIN user_subscriptions us USING (user_id)
JOIN subscription_types st USING (subscription_type_id)
WHERE CURRENT_DATE >= us.start_date
  AND CURRENT_DATE < us.end_date;


--  PLAYBACK BREAKDOWNS

CREATE VIEW vw_playbacks_by_device AS
SELECT
    dt.name AS device_name,
    count(*) AS playback_count
FROM playback_history ph
JOIN device_types dt USING (device_type_id)
GROUP BY dt.device_type_id;

CREATE VIEW vw_playbacks_by_genre AS
SELECT
    g.name AS genre_name,
    count(*) AS playback_count
FROM playback_history ph
JOIN song_playback_details spd USING (playback_id)
JOIN songs s USING (song_id)
JOIN genres g USING (genre_id)
GROUP BY g.genre_id;

CREATE VIEW vw_playbacks_by_podcast_category AS
SELECT
    pc.name AS category_name,
    count(*) AS playback_count
FROM playback_history ph
JOIN episode_playback_details epd USING (playback_id)
JOIN podcast_episodes pe USING (episode_id)
JOIN podcasts p USING (podcast_id)
JOIN podcast_categories pc USING (category_id)
GROUP BY pc.category_id;
