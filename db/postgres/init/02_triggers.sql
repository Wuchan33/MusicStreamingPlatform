--  DATE VALIDATION

CREATE FUNCTION reject_future_date() RETURNS TRIGGER AS $$
DECLARE
    v_column TEXT := TG_ARGV[0];
    v_value TIMESTAMPTZ;
BEGIN
    v_value := (to_jsonb(NEW) ->> v_column)::TIMESTAMPTZ;

    IF v_value IS NOT NULL AND v_value > now() THEN
        RAISE EXCEPTION 'Validation Error: %.% cannot be a future date (got: %)',
            TG_TABLE_NAME, v_column, v_value
            USING ERRCODE = 'check_violation';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_users_date_of_birth_not_future
    BEFORE INSERT OR UPDATE OF date_of_birth ON users
    FOR EACH ROW EXECUTE FUNCTION reject_future_date('date_of_birth');

CREATE TRIGGER trg_albums_release_date_not_future
    BEFORE INSERT OR UPDATE OF release_date ON albums
    FOR EACH ROW EXECUTE FUNCTION reject_future_date('release_date');

CREATE TRIGGER trg_songs_release_date_not_future
    BEFORE INSERT OR UPDATE OF release_date ON songs
    FOR EACH ROW EXECUTE FUNCTION reject_future_date('release_date');

CREATE TRIGGER trg_podcast_episodes_release_date_not_future
    BEFORE INSERT OR UPDATE OF release_date ON podcast_episodes
    FOR EACH ROW EXECUTE FUNCTION reject_future_date('release_date');

CREATE TRIGGER trg_follows_artists_follow_date_not_future
    BEFORE INSERT OR UPDATE OF follow_date ON follows_artists
    FOR EACH ROW EXECUTE FUNCTION reject_future_date('follow_date');

CREATE TRIGGER trg_follows_podcasts_follow_date_not_future
    BEFORE INSERT OR UPDATE OF follow_date ON follows_podcasts
    FOR EACH ROW EXECUTE FUNCTION reject_future_date('follow_date');

CREATE TRIGGER trg_song_likes_like_date_not_future
    BEFORE INSERT OR UPDATE OF like_date ON song_likes
    FOR EACH ROW EXECUTE FUNCTION reject_future_date('like_date');

CREATE TRIGGER trg_episode_likes_like_date_not_future
    BEFORE INSERT OR UPDATE OF like_date ON episode_likes
    FOR EACH ROW EXECUTE FUNCTION reject_future_date('like_date');

CREATE TRIGGER trg_playback_history_playback_date_not_future
    BEFORE INSERT OR UPDATE OF playback_date ON playback_history
    FOR EACH ROW EXECUTE FUNCTION reject_future_date('playback_date');


--  SUBSCRIPTION END DATE

CREATE FUNCTION set_subscription_end_date() RETURNS TRIGGER AS $$
DECLARE
    v_duration_months INT;
BEGIN
    IF TG_OP = 'INSERT' THEN
        IF NEW.end_date IS NOT NULL THEN
            RETURN NEW;
        END IF;
    ELSIF NEW.end_date IS DISTINCT FROM OLD.end_date THEN
        RETURN NEW;
    END IF;

    SELECT duration_months INTO v_duration_months
    FROM subscription_types
    WHERE subscription_type_id = NEW.subscription_type_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Validation Error: subscription_type_id % does not exist',
            NEW.subscription_type_id
            USING ERRCODE = 'foreign_key_violation';
    END IF;

    NEW.end_date :=
        (NEW.start_date + make_interval(months => v_duration_months))::DATE;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_user_subscriptions_set_end_date
    BEFORE INSERT OR UPDATE OF start_date, subscription_type_id ON user_subscriptions
    FOR EACH ROW EXECUTE FUNCTION set_subscription_end_date();


--  PODCAST EPISODE COUNT

CREATE FUNCTION maintain_podcast_episode_count() RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE podcasts
        SET episode_count = episode_count + 1
        WHERE podcast_id = NEW.podcast_id;
    ELSIF TG_OP = 'UPDATE' THEN
        IF NEW.podcast_id IS DISTINCT FROM OLD.podcast_id THEN
            UPDATE podcasts
            SET episode_count = episode_count - 1
            WHERE podcast_id = OLD.podcast_id;

            UPDATE podcasts
            SET episode_count = episode_count + 1
            WHERE podcast_id = NEW.podcast_id;
        END IF;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE podcasts
        SET episode_count = episode_count - 1
        WHERE podcast_id = OLD.podcast_id;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_podcast_episodes_maintain_episode_count
    AFTER INSERT OR DELETE OR UPDATE OF podcast_id ON podcast_episodes
    FOR EACH ROW EXECUTE FUNCTION maintain_podcast_episode_count();


--  PLAYBACK HISTORY

CREATE FUNCTION validate_playback_history() RETURNS TRIGGER AS $$
DECLARE
    v_media_duration INT;
BEGIN
    IF TG_OP = 'UPDATE' THEN
        RAISE EXCEPTION 'Validation Error: playback history is append-only, '
                        'rows cannot be modified'
        USING ERRCODE = 'check_violation';
    END IF;

    CASE NEW.media_type
        WHEN 'SONG' THEN
            SELECT duration_seconds INTO v_media_duration
            FROM songs WHERE song_id = NEW.media_id;
        WHEN 'EPISODE' THEN
            SELECT duration_seconds INTO v_media_duration
            FROM podcast_episodes WHERE episode_id = NEW.media_id;
        WHEN 'AD' THEN
            SELECT duration_seconds INTO v_media_duration
            FROM ads WHERE ad_id = NEW.media_id;
    END CASE;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Validation Error: no % with id %',
        NEW.media_type, NEW.media_id
        USING ERRCODE = 'foreign_key_violation';
    END IF;

    IF NEW.media_type = 'AD' THEN
        IF NEW.duration_played_seconds <> v_media_duration THEN
            RAISE EXCEPTION 'Validation Error: an ad must be played in full '
                            '(% of % seconds)',
            NEW.duration_played_seconds, v_media_duration
            USING ERRCODE = 'check_violation';
        END IF;
    ELSIF NEW.duration_played_seconds > v_media_duration THEN
        RAISE EXCEPTION 'Validation Error: played % seconds of a % that is '
                        'only % seconds long',
        NEW.duration_played_seconds, NEW.media_type, v_media_duration
        USING ERRCODE = 'check_violation';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_playback_history_validate
    BEFORE INSERT OR UPDATE ON playback_history
    FOR EACH ROW EXECUTE FUNCTION validate_playback_history();


CREATE FUNCTION maintain_playback_details() RETURNS TRIGGER AS $$
DECLARE
    v_row playback_history;
    v_delta INT;
BEGIN
    IF TG_OP = 'INSERT' THEN
        v_row := NEW;
        v_delta := 1;

        CASE NEW.media_type
            WHEN 'SONG' THEN
                INSERT INTO song_playback_details (playback_id, song_id)
                VALUES (NEW.playback_id, NEW.media_id);
            WHEN 'EPISODE' THEN
                INSERT INTO episode_playback_details (playback_id, episode_id)
                VALUES (NEW.playback_id, NEW.media_id);
            WHEN 'AD' THEN
                INSERT INTO ad_playback_details (playback_id, ad_id)
                VALUES (NEW.playback_id, NEW.media_id);
        END CASE;
    ELSIF TG_OP = 'DELETE' THEN
        v_row := OLD;
        v_delta := -1;
    END IF;

    CASE v_row.media_type
        WHEN 'SONG' THEN
            UPDATE songs
            SET stream_count = stream_count + v_delta
            WHERE song_id = v_row.media_id
              AND (v_row.duration_played_seconds >= 30
                   OR v_row.duration_played_seconds >= duration_seconds * 0.5);
        WHEN 'EPISODE' THEN
            UPDATE podcast_episodes
            SET stream_count = stream_count + v_delta
            WHERE episode_id = v_row.media_id
              AND (v_row.duration_played_seconds >= 300
                   OR v_row.duration_played_seconds >= duration_seconds * 0.5);
        WHEN 'AD' THEN
            UPDATE ads
            SET stream_count = stream_count + v_delta
            WHERE ad_id = v_row.media_id;
    END CASE;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_playback_history_maintain_details
    AFTER INSERT OR DELETE ON playback_history
    FOR EACH ROW EXECUTE FUNCTION maintain_playback_details();