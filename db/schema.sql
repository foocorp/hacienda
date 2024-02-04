--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: chk(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION chk(text) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$ declare v text; begin v := ''||$1; return false; exception when others then return true; end; $_$;


ALTER FUNCTION public.chk(text) OWNER TO postgres;

--
-- Name: populate_user_stats(); Type: FUNCTION; Schema: public; Owner: librefm
--

CREATE FUNCTION populate_user_stats() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE 
        uid int;
        s_count int;
BEGIN   
        FOR uid in SELECT uniqueid FROM Users ORDER BY uniqueid LOOP
                BEGIN
                SELECT count(userid) INTO s_count FROM Scrobbles WHERE userid = uid;
                INSERT INTO User_Stats(userid, scrobble_count) VALUES(uid, s_count);
                EXCEPTION WHEN unique_violation THEN
                        -- do nothing
                END;
        END LOOP;
END;
$$;


ALTER FUNCTION public.populate_user_stats() OWNER TO librefm;

--
-- Name: update_user_stats_scrobble_count(); Type: FUNCTION; Schema: public; Owner: librefm
--

CREATE FUNCTION update_user_stats_scrobble_count() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
                        DECLARE s_count int;
                        BEGIN
                                UPDATE User_Stats SET scrobble_count = scrobble_count + 1 WHERE userid = NEW.userid;
                                IF found THEN
                                        RETURN NULL;
                                END IF;
                                BEGIN
                                        -- userid not in User_Stats table, get current scrobble count from Scrobbles
                                        -- and insert userid into User_Stats
                                        SELECT COUNT(userid) into s_count FROM Scrobbles WHERE userid = NEW.userid;
                                        INSERT INTO User_Stats(userid, scrobble_count) VALUES(NEW.userid, s_count);
                                        RETURN NULL;
                                END;
                        END;
                        $$;


ALTER FUNCTION public.update_user_stats_scrobble_count() OWNER TO librefm;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accountactivation; Type: TABLE; Schema: public; Owner: librefm; Tablespace: 
--

CREATE TABLE accountactivation (
    username character varying(64),
    authcode character varying(32),
    expires integer
);


ALTER TABLE accountactivation OWNER TO librefm;

--
-- Name: album; Type: TABLE; Schema: public; Owner: librefm; Tablespace: 
--

CREATE TABLE album (
    name character varying(255) DEFAULT ''::character varying NOT NULL,
    artist_name character varying(255) DEFAULT ''::character varying NOT NULL,
    mbid character varying(36) DEFAULT NULL::character varying,
    releasedate integer,
    albumurl character varying(255) DEFAULT NULL::character varying,
    image character varying(255) DEFAULT NULL::character varying,
    artwork_license character varying(255) DEFAULT NULL::character varying,
    downloadurl character varying(255) DEFAULT NULL::character varying,
    id integer NOT NULL
);


ALTER TABLE album OWNER TO librefm;

--
-- Name: album_id_seq; Type: SEQUENCE; Schema: public; Owner: librefm
--

CREATE SEQUENCE album_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE album_id_seq OWNER TO librefm;

--
-- Name: album_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: librefm
--

ALTER SEQUENCE album_id_seq OWNED BY album.id;


--
-- Name: artist; Type: TABLE; Schema: public; Owner: librefm; Tablespace: 
--

CREATE TABLE artist (
    name character varying(255) NOT NULL,
    mbid character varying(36) DEFAULT NULL::character varying,
    streamable integer,
    bio_published integer,
    bio_content text,
    bio_summary text,
    image_small character varying(255) DEFAULT NULL::character varying,
    image_medium character varying(255) DEFAULT NULL::character varying,
    image_large character varying(255) DEFAULT NULL::character varying,
    homepage character varying(255) DEFAULT NULL::character varying,
    imbid integer,
    origin character varying(255),
    id integer NOT NULL,
    hashtag character varying(255),
    flattr_uid character varying(255)
);


ALTER TABLE artist OWNER TO librefm;

--
-- Name: artist_bio; Type: TABLE; Schema: public; Owner: librefm; Tablespace: 
--

CREATE TABLE artist_bio (
    artist integer,
    bio text
);


ALTER TABLE artist_bio OWNER TO librefm;

--
-- Name: artist_id_seq; Type: SEQUENCE; Schema: public; Owner: librefm
--

CREATE SEQUENCE artist_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE artist_id_seq OWNER TO librefm;

--
-- Name: artist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: librefm
--

ALTER SEQUENCE artist_id_seq OWNED BY artist.id;


--
-- Name: auth; Type: TABLE; Schema: public; Owner: librefm; Tablespace: 
--

CREATE TABLE auth (
    token character varying(32) NOT NULL,
    sk character varying(32) DEFAULT NULL::character varying,
    expires integer,
    username character varying(64) DEFAULT NULL::character varying
);


ALTER TABLE auth OWNER TO librefm;

--
-- Name: banned_tracks; Type: TABLE; Schema: public; Owner: librefm; Tablespace: 
--

CREATE TABLE banned_tracks (
    userid integer,
    track character varying(255),
    artist character varying(255),
    "time" integer
);


ALTER TABLE banned_tracks OWNER TO librefm;

--
-- Name: clientcodes; Type: TABLE; Schema: public; Owner: librefm; Tablespace: 
--

CREATE TABLE clientcodes (
    code character(3) DEFAULT ''::bpchar NOT NULL,
    name character varying(32) DEFAULT NULL::character varying,
    url character varying(256) DEFAULT NULL::character varying,
    free character(1) DEFAULT 'N'::bpchar
);


ALTER TABLE clientcodes OWNER TO librefm;

--
-- Name: countries; Type: TABLE; Schema: public; Owner: librefm; Tablespace: 
--

CREATE TABLE countries (
    country character varying(2) NOT NULL,
    country_name character varying(200),
    wikipedia_en character varying(120)
);


ALTER TABLE countries OWNER TO librefm;

--
-- Name: delete_request; Type: TABLE; Schema: public; Owner: librefm; Tablespace: 
--

CREATE TABLE delete_request (
    code character varying(300) NOT NULL,
    expires integer,
    username character varying(64)
);


ALTER TABLE delete_request OWNER TO librefm;

--
-- Name: domain_blacklist; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE domain_blacklist (
    domain text NOT NULL,
    expires integer
);


ALTER TABLE domain_blacklist OWNER TO postgres;

--
-- Name: error; Type: TABLE; Schema: public; Owner: librefm; Tablespace: 
--

CREATE TABLE error (
    msg text,
    data text,
    "time" integer,
    id integer NOT NULL
);


ALTER TABLE error OWNER TO librefm;

--
-- Name: error_id_seq; Type: SEQUENCE; Schema: public; Owner: librefm
--

CREATE SEQUENCE error_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE error_id_seq OWNER TO librefm;

--
-- Name: error_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: librefm
--

ALTER SEQUENCE error_id_seq OWNED BY error.id;


--
-- Name: scrobble_track; Type: TABLE; Schema: public; Owner: librefm; Tablespace: 
--

CREATE TABLE scrobble_track (
    id integer NOT NULL,
    artist character varying(255) NOT NULL,
    album character varying(255),
    name character varying(255) NOT NULL,
    mbid character varying(36),
    track integer NOT NULL
);


ALTER TABLE scrobble_track OWNER TO librefm;

--
-- Name: scrobbles; Type: TABLE; Schema: public; Owner: librefm; Tablespace: 
--

CREATE TABLE scrobbles (
    track character varying(255) DEFAULT ''::character varying NOT NULL,
    artist character varying(255) DEFAULT ''::character varying NOT NULL,
    "time" integer DEFAULT 0 NOT NULL,
    mbid character varying(36) DEFAULT NULL::character varying,
    album character varying(255) DEFAULT NULL::character varying,
    source character varying(6) DEFAULT NULL::character varying,
    rating character(1) DEFAULT NULL::bpchar,
    length integer,
    stid integer,
    userid integer NOT NULL,
    track_tsv tsvector,
    artist_tsv tsvector
);


ALTER TABLE scrobbles OWNER TO librefm;

--
-- Name: track; Type: TABLE; Schema: public; Owner: librefm; Tablespace: 
--

CREATE TABLE track (
    name character varying(255) DEFAULT ''::character varying NOT NULL,
    artist_name character varying(255) DEFAULT ''::character varying NOT NULL,
    album_name character varying(255) DEFAULT NULL::character varying,
    mbid character varying(36) DEFAULT NULL::character varying,
    duration integer,
    streamable integer DEFAULT 0,
    license character varying(255) DEFAULT NULL::character varying,
    downloadurl character varying(255) DEFAULT NULL::character varying,
    streamurl character varying(255) DEFAULT NULL::character varying,
    otherid character varying(16) DEFAULT NULL::character varying,
    id integer NOT NULL
);


ALTER TABLE track OWNER TO librefm;

--
-- Name: free_scrobbles; Type: VIEW; Schema: public; Owner: librefm
--

CREATE VIEW free_scrobbles AS
 SELECT s.userid,
    s.track,
    s.artist,
    s."time",
    s.mbid,
    s.album,
    s.source,
    s.rating,
    s.length
   FROM ((scrobbles s
     JOIN scrobble_track st ON ((s.stid = st.id)))
     JOIN track t ON ((st.track = t.id)))
  WHERE (t.streamable = 1);


ALTER TABLE free_scrobbles OWNER TO librefm;

--
-- Name: group_members; Type: TABLE; Schema: public; Owner: librefm; Tablespace: 
--

CREATE TABLE group_members (
    joined integer NOT NULL,
    grp integer NOT NULL,
    member integer NOT NULL
);


ALTER TABLE group_members OWNER TO librefm;

--
-- Name: groups; Type: TABLE; Schema: public; Owner: librefm; Tablespace: 
--

CREATE TABLE groups (
    groupname character varying(64) NOT NULL,
    fullname character varying(255),
    bio text,
    homepage character varying(255),
    created integer NOT NULL,
    modified integer,
    avatar_uri character varying(255),
    grouptype integer,
    id integer NOT NULL,
    owner integer
);


ALTER TABLE groups OWNER TO librefm;

--
-- Name: groups_id_seq; Type: SEQUENCE; Schema: public; Owner: librefm
--

CREATE SEQUENCE groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE groups_id_seq OWNER TO librefm;

--
-- Name: groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: librefm
--

ALTER SEQUENCE groups_id_seq OWNED BY groups.id;


--
-- Name: invitation_request; Type: TABLE; Schema: public; Owner: librefm; Tablespace: 
--

CREATE TABLE invitation_request (
    email character varying(255) NOT NULL,
    "time" integer,
    status integer DEFAULT 0
);


ALTER TABLE invitation_request OWNER TO librefm;

--
-- Name: invitations; Type: TABLE; Schema: public; Owner: librefm; Tablespace: 
--

CREATE TABLE invitations (
    inviter character varying(64) DEFAULT ''::character varying NOT NULL,
    invitee character varying(64) DEFAULT ''::character varying NOT NULL,
    code character varying(32) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE invitations OWNER TO librefm;

--
-- Name: loved_tracks; Type: TABLE; Schema: public; Owner: librefm; Tablespace: 
--

CREATE TABLE loved_tracks (
    userid integer,
    track character varying(255),
    artist character varying(255),
    "time" integer
);


ALTER TABLE loved_tracks OWNER TO librefm;

--
-- Name: manages; Type: TABLE; Schema: public; Owner: librefm; Tablespace: 
--

CREATE TABLE manages (
    userid integer,
    artist character varying(255),
    authorised integer
);


ALTER TABLE manages OWNER TO librefm;

--
-- Name: now_playing; Type: TABLE; Schema: public; Owner: librefm; Tablespace: 
--

CREATE TABLE now_playing (
    track character varying(255) DEFAULT NULL::character varying,
    artist character varying(255) DEFAULT NULL::character varying,
    expires integer,
    mbid character varying(36) DEFAULT NULL::character varying,
    sessionid character varying(32) DEFAULT NULL::character varying NOT NULL,
    album character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE now_playing OWNER TO librefm;

--
-- Name: places; Type: TABLE; Schema: public; Owner: librefm; Tablespace: 
--

CREATE TABLE places (
    location_uri character varying(255) DEFAULT NULL::character varying NOT NULL,
    latitude double precision,
    longitude double precision,
    country character(2) DEFAULT NULL::bpchar
);


ALTER TABLE places OWNER TO librefm;

--
-- Name: radio_sessions; Type: TABLE; Schema: public; Owner: librefm; Tablespace: 
--

CREATE TABLE radio_sessions (
    username character varying(64) DEFAULT ''::character varying NOT NULL,
    session character varying(32) DEFAULT ''::character varying NOT NULL,
    url character varying(255) DEFAULT NULL::character varying,
    expires integer DEFAULT 0 NOT NULL
);


ALTER TABLE radio_sessions OWNER TO librefm;

--
-- Name: recovery_request; Type: TABLE; Schema: public; Owner: librefm; Tablespace: 
--

CREATE TABLE recovery_request (
    username character varying(64) NOT NULL,
    email character varying(255),
    code character varying(32),
    expires integer
);


ALTER TABLE recovery_request OWNER TO librefm;

--
-- Name: relationship_flags; Type: TABLE; Schema: public; Owner: librefm; Tablespace: 
--

CREATE TABLE relationship_flags (
    flag character varying(12) NOT NULL
);


ALTER TABLE relationship_flags OWNER TO librefm;

--
-- Name: scrobble_sessions; Type: TABLE; Schema: public; Owner: librefm; Tablespace: 
--

CREATE TABLE scrobble_sessions (
    sessionid character varying(32) DEFAULT ''::character varying NOT NULL,
    expires integer,
    client character(3) DEFAULT NULL::bpchar,
    userid integer,
    api_key character varying(32)
);


ALTER TABLE scrobble_sessions OWNER TO librefm;

--
-- Name: scrobble_track_id_seq; Type: SEQUENCE; Schema: public; Owner: librefm
--

CREATE SEQUENCE scrobble_track_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE scrobble_track_id_seq OWNER TO librefm;

--
-- Name: scrobble_track_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: librefm
--

ALTER SEQUENCE scrobble_track_id_seq OWNED BY scrobble_track.id;


--
-- Name: service_connections; Type: TABLE; Schema: public; Owner: librefm; Tablespace: 
--

CREATE TABLE service_connections (
    userid integer,
    webservice_url character varying(255),
    remote_key character varying(255),
    remote_username character varying(255),
    forward integer DEFAULT 1
);


ALTER TABLE service_connections OWNER TO librefm;

--
-- Name: similar_artist; Type: TABLE; Schema: public; Owner: librefm; Tablespace: 
--

CREATE TABLE similar_artist (
    name_a character varying(255) DEFAULT ''::character varying NOT NULL,
    name_b character varying(255) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE similar_artist OWNER TO librefm;

--
-- Name: tags; Type: TABLE; Schema: public; Owner: librefm; Tablespace: 
--

CREATE TABLE tags (
    tag character varying(64) DEFAULT ''::character varying NOT NULL,
    artist character varying(255) DEFAULT ''::character varying NOT NULL,
    album character varying(255) DEFAULT ''::character varying NOT NULL,
    track character varying(255) DEFAULT ''::character varying NOT NULL,
    userid integer
);


ALTER TABLE tags OWNER TO librefm;

--
-- Name: track_id_seq; Type: SEQUENCE; Schema: public; Owner: librefm
--

CREATE SEQUENCE track_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE track_id_seq OWNER TO librefm;

--
-- Name: track_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: librefm
--

ALTER SEQUENCE track_id_seq OWNED BY track.id;


--
-- Name: user_relationship_flags; Type: TABLE; Schema: public; Owner: librefm; Tablespace: 
--

CREATE TABLE user_relationship_flags (
    uid1 integer NOT NULL,
    uid2 integer NOT NULL,
    flag character varying(12) NOT NULL
);


ALTER TABLE user_relationship_flags OWNER TO librefm;

--
-- Name: user_relationships; Type: TABLE; Schema: public; Owner: librefm; Tablespace: 
--

CREATE TABLE user_relationships (
    uid1 integer NOT NULL,
    uid2 integer NOT NULL,
    established integer NOT NULL
);


ALTER TABLE user_relationships OWNER TO librefm;

--
-- Name: user_stats; Type: TABLE; Schema: public; Owner: librefm; Tablespace: 
--

CREATE TABLE user_stats (
    userid integer NOT NULL,
    scrobble_count integer NOT NULL
);


ALTER TABLE user_stats OWNER TO librefm;

--
-- Name: users; Type: TABLE; Schema: public; Owner: librefm; Tablespace: 
--

CREATE TABLE users (
    username character varying(64) NOT NULL,
    password character varying(32) NOT NULL,
    email character varying(255) DEFAULT NULL::character varying,
    fullname character varying(255) DEFAULT NULL::character varying,
    bio text,
    homepage character varying(255) DEFAULT NULL::character varying,
    location character varying(255) DEFAULT NULL::character varying,
    created integer NOT NULL,
    modified integer,
    userlevel integer DEFAULT 0,
    webid_uri character varying(255) DEFAULT NULL::character varying,
    avatar_uri character varying(255) DEFAULT NULL::character varying,
    location_uri character varying(255) DEFAULT NULL::character varying,
    uniqueid integer NOT NULL,
    active integer DEFAULT 1,
    laconica_profile character varying(255),
    journal_rss character varying(255),
    anticommercial integer DEFAULT 0,
    public_export integer DEFAULT 0,
    openid_url character varying(100),
    receive_emails integer DEFAULT 1
);


ALTER TABLE users OWNER TO librefm;

--
-- Name: users_uniqueid_seq; Type: SEQUENCE; Schema: public; Owner: librefm
--

CREATE SEQUENCE users_uniqueid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users_uniqueid_seq OWNER TO librefm;

--
-- Name: users_uniqueid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: librefm
--

ALTER SEQUENCE users_uniqueid_seq OWNED BY users.uniqueid;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: librefm
--

ALTER TABLE ONLY album ALTER COLUMN id SET DEFAULT nextval('album_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: librefm
--

ALTER TABLE ONLY artist ALTER COLUMN id SET DEFAULT nextval('artist_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: librefm
--

ALTER TABLE ONLY error ALTER COLUMN id SET DEFAULT nextval('error_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: librefm
--

ALTER TABLE ONLY groups ALTER COLUMN id SET DEFAULT nextval('groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: librefm
--

ALTER TABLE ONLY scrobble_track ALTER COLUMN id SET DEFAULT nextval('scrobble_track_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: librefm
--

ALTER TABLE ONLY track ALTER COLUMN id SET DEFAULT nextval('track_id_seq'::regclass);


--
-- Name: uniqueid; Type: DEFAULT; Schema: public; Owner: librefm
--

ALTER TABLE ONLY users ALTER COLUMN uniqueid SET DEFAULT nextval('users_uniqueid_seq'::regclass);


--
-- Name: album_pkey; Type: CONSTRAINT; Schema: public; Owner: librefm; Tablespace: 
--

ALTER TABLE ONLY album
    ADD CONSTRAINT album_pkey PRIMARY KEY (id);


--
-- Name: artist_pkey; Type: CONSTRAINT; Schema: public; Owner: librefm; Tablespace: 
--

ALTER TABLE ONLY artist
    ADD CONSTRAINT artist_pkey PRIMARY KEY (id);


--
-- Name: auth_pkey; Type: CONSTRAINT; Schema: public; Owner: librefm; Tablespace: 
--

ALTER TABLE ONLY auth
    ADD CONSTRAINT auth_pkey PRIMARY KEY (token);


--
-- Name: banned_tracks_userid_key; Type: CONSTRAINT; Schema: public; Owner: librefm; Tablespace: 
--

ALTER TABLE ONLY banned_tracks
    ADD CONSTRAINT banned_tracks_userid_key UNIQUE (userid, track, artist);


--
-- Name: clientcodes_pkey; Type: CONSTRAINT; Schema: public; Owner: librefm; Tablespace: 
--

ALTER TABLE ONLY clientcodes
    ADD CONSTRAINT clientcodes_pkey PRIMARY KEY (code);


--
-- Name: countries_pkey; Type: CONSTRAINT; Schema: public; Owner: librefm; Tablespace: 
--

ALTER TABLE ONLY countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (country);


--
-- Name: delete_request_pkey; Type: CONSTRAINT; Schema: public; Owner: librefm; Tablespace: 
--

ALTER TABLE ONLY delete_request
    ADD CONSTRAINT delete_request_pkey PRIMARY KEY (code);


--
-- Name: domain_blacklist_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY domain_blacklist
    ADD CONSTRAINT domain_blacklist_pkey PRIMARY KEY (domain);


--
-- Name: error_pkey; Type: CONSTRAINT; Schema: public; Owner: librefm; Tablespace: 
--

ALTER TABLE ONLY error
    ADD CONSTRAINT error_pkey PRIMARY KEY (id);


--
-- Name: group_members_pkey; Type: CONSTRAINT; Schema: public; Owner: librefm; Tablespace: 
--

ALTER TABLE ONLY group_members
    ADD CONSTRAINT group_members_pkey PRIMARY KEY (grp, member);


--
-- Name: groups_pkey; Type: CONSTRAINT; Schema: public; Owner: librefm; Tablespace: 
--

ALTER TABLE ONLY groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: invitation_request_pkey; Type: CONSTRAINT; Schema: public; Owner: librefm; Tablespace: 
--

ALTER TABLE ONLY invitation_request
    ADD CONSTRAINT invitation_request_pkey PRIMARY KEY (email);


--
-- Name: invitations_pkey; Type: CONSTRAINT; Schema: public; Owner: librefm; Tablespace: 
--

ALTER TABLE ONLY invitations
    ADD CONSTRAINT invitations_pkey PRIMARY KEY (inviter, invitee, code);


--
-- Name: loved_tracks_userid_key; Type: CONSTRAINT; Schema: public; Owner: librefm; Tablespace: 
--

ALTER TABLE ONLY loved_tracks
    ADD CONSTRAINT loved_tracks_userid_key UNIQUE (userid, track, artist);


--
-- Name: now_playing_pkey; Type: CONSTRAINT; Schema: public; Owner: librefm; Tablespace: 
--

ALTER TABLE ONLY now_playing
    ADD CONSTRAINT now_playing_pkey PRIMARY KEY (sessionid);


--
-- Name: places_pkey; Type: CONSTRAINT; Schema: public; Owner: librefm; Tablespace: 
--

ALTER TABLE ONLY places
    ADD CONSTRAINT places_pkey PRIMARY KEY (location_uri);


--
-- Name: radio_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: librefm; Tablespace: 
--

ALTER TABLE ONLY radio_sessions
    ADD CONSTRAINT radio_sessions_pkey PRIMARY KEY (username, session);


--
-- Name: recovery_request_pkey; Type: CONSTRAINT; Schema: public; Owner: librefm; Tablespace: 
--

ALTER TABLE ONLY recovery_request
    ADD CONSTRAINT recovery_request_pkey PRIMARY KEY (username);


--
-- Name: relationship_flags_pkey; Type: CONSTRAINT; Schema: public; Owner: librefm; Tablespace: 
--

ALTER TABLE ONLY relationship_flags
    ADD CONSTRAINT relationship_flags_pkey PRIMARY KEY (flag);


--
-- Name: scrobble_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: librefm; Tablespace: 
--

ALTER TABLE ONLY scrobble_sessions
    ADD CONSTRAINT scrobble_sessions_pkey PRIMARY KEY (sessionid);


--
-- Name: scrobble_track_pkey; Type: CONSTRAINT; Schema: public; Owner: librefm; Tablespace: 
--

ALTER TABLE ONLY scrobble_track
    ADD CONSTRAINT scrobble_track_pkey PRIMARY KEY (id);


--
-- Name: similar_artist_pkey; Type: CONSTRAINT; Schema: public; Owner: librefm; Tablespace: 
--

ALTER TABLE ONLY similar_artist
    ADD CONSTRAINT similar_artist_pkey PRIMARY KEY (name_a, name_b);


--
-- Name: tags_artist_album_track_userid_key; Type: CONSTRAINT; Schema: public; Owner: librefm; Tablespace: 
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_artist_album_track_userid_key UNIQUE (tag, artist, album, track, userid);


--
-- Name: track_pkey; Type: CONSTRAINT; Schema: public; Owner: librefm; Tablespace: 
--

ALTER TABLE ONLY track
    ADD CONSTRAINT track_pkey PRIMARY KEY (id);


--
-- Name: user_relationship_flags_pkey; Type: CONSTRAINT; Schema: public; Owner: librefm; Tablespace: 
--

ALTER TABLE ONLY user_relationship_flags
    ADD CONSTRAINT user_relationship_flags_pkey PRIMARY KEY (uid1, uid2, flag);


--
-- Name: user_relationships_pkey; Type: CONSTRAINT; Schema: public; Owner: librefm; Tablespace: 
--

ALTER TABLE ONLY user_relationships
    ADD CONSTRAINT user_relationships_pkey PRIMARY KEY (uid1, uid2);


--
-- Name: user_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: librefm; Tablespace: 
--

ALTER TABLE ONLY user_stats
    ADD CONSTRAINT user_stats_pkey PRIMARY KEY (userid);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: librefm; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (uniqueid);


--
-- Name: album_album_name_idx; Type: INDEX; Schema: public; Owner: librefm; Tablespace: 
--

CREATE INDEX album_album_name_idx ON album USING btree (lower((name)::text));


--
-- Name: album_artist_name_idx; Type: INDEX; Schema: public; Owner: librefm; Tablespace: 
--

CREATE INDEX album_artist_name_idx ON album USING btree (lower((artist_name)::text));


--
-- Name: album_name_idx; Type: INDEX; Schema: public; Owner: librefm; Tablespace: 
--

CREATE INDEX album_name_idx ON album USING btree (name);


--
-- Name: aritst_name_idx; Type: INDEX; Schema: public; Owner: librefm; Tablespace: 
--

CREATE INDEX aritst_name_idx ON artist USING btree (lower((name)::text));


--
-- Name: artist_name_idx; Type: INDEX; Schema: public; Owner: librefm; Tablespace: 
--

CREATE INDEX artist_name_idx ON artist USING btree (name);


--
-- Name: groups_groupname_idx; Type: INDEX; Schema: public; Owner: librefm; Tablespace: 
--

CREATE UNIQUE INDEX groups_groupname_idx ON groups USING btree (lower((groupname)::text));


--
-- Name: scrobble_track_album_idx; Type: INDEX; Schema: public; Owner: librefm; Tablespace: 
--

CREATE INDEX scrobble_track_album_idx ON scrobble_track USING btree (album);


--
-- Name: scrobble_track_artist_idx; Type: INDEX; Schema: public; Owner: librefm; Tablespace: 
--

CREATE INDEX scrobble_track_artist_idx ON scrobble_track USING btree (artist);


--
-- Name: scrobble_track_mbid_idx; Type: INDEX; Schema: public; Owner: librefm; Tablespace: 
--

CREATE INDEX scrobble_track_mbid_idx ON scrobble_track USING btree (mbid);


--
-- Name: scrobble_track_name_idx; Type: INDEX; Schema: public; Owner: librefm; Tablespace: 
--

CREATE INDEX scrobble_track_name_idx ON scrobble_track USING btree (name);


--
-- Name: scrobble_track_track_idx; Type: INDEX; Schema: public; Owner: librefm; Tablespace: 
--

CREATE INDEX scrobble_track_track_idx ON scrobble_track USING btree (track);


--
-- Name: scrobbles_Artist_idx; Type: INDEX; Schema: public; Owner: librefm; Tablespace: 
--

CREATE INDEX "scrobbles_Artist_idx" ON scrobbles USING btree (artist);


--
-- Name: scrobbles_artist_idx; Type: INDEX; Schema: public; Owner: librefm; Tablespace: 
--

CREATE INDEX scrobbles_artist_idx ON scrobbles USING btree (lower((artist)::text));


--
-- Name: scrobbles_artist_track_idx; Type: INDEX; Schema: public; Owner: librefm; Tablespace: 
--

CREATE INDEX scrobbles_artist_track_idx ON scrobbles USING btree (artist, track);


--
-- Name: scrobbles_artist_tsv; Type: INDEX; Schema: public; Owner: librefm; Tablespace: 
--

CREATE INDEX scrobbles_artist_tsv ON scrobbles USING gin (artist_tsv);


--
-- Name: scrobbles_stid_idx; Type: INDEX; Schema: public; Owner: librefm; Tablespace: 
--

CREATE INDEX scrobbles_stid_idx ON scrobbles USING btree (stid);


--
-- Name: scrobbles_time_desc_idx; Type: INDEX; Schema: public; Owner: librefm; Tablespace: 
--

CREATE INDEX scrobbles_time_desc_idx ON scrobbles USING btree ("time" DESC);


--
-- Name: scrobbles_track_idx; Type: INDEX; Schema: public; Owner: librefm; Tablespace: 
--

CREATE INDEX scrobbles_track_idx ON scrobbles USING btree (lower((track)::text));


--
-- Name: scrobbles_track_tsv; Type: INDEX; Schema: public; Owner: librefm; Tablespace: 
--

CREATE INDEX scrobbles_track_tsv ON scrobbles USING gin (track_tsv);


--
-- Name: scrobbles_userid_artist_idx; Type: INDEX; Schema: public; Owner: librefm; Tablespace: 
--

CREATE INDEX scrobbles_userid_artist_idx ON scrobbles USING btree (userid, artist);


--
-- Name: scrobbles_userid_idx; Type: INDEX; Schema: public; Owner: librefm; Tablespace: 
--

CREATE INDEX scrobbles_userid_idx ON scrobbles USING btree (userid);


--
-- Name: scrobbles_userid_time_desc_idx; Type: INDEX; Schema: public; Owner: librefm; Tablespace: 
--

CREATE INDEX scrobbles_userid_time_desc_idx ON scrobbles USING btree (userid, "time" DESC);


--
-- Name: scrobbles_userid_time_idx; Type: INDEX; Schema: public; Owner: librefm; Tablespace: 
--

CREATE INDEX scrobbles_userid_time_idx ON scrobbles USING btree (userid, "time");


--
-- Name: tags_album_idx; Type: INDEX; Schema: public; Owner: librefm; Tablespace: 
--

CREATE INDEX tags_album_idx ON tags USING btree (album);


--
-- Name: tags_artist_idx; Type: INDEX; Schema: public; Owner: librefm; Tablespace: 
--

CREATE INDEX tags_artist_idx ON tags USING btree (artist);


--
-- Name: tags_tag_idx; Type: INDEX; Schema: public; Owner: librefm; Tablespace: 
--

CREATE INDEX tags_tag_idx ON tags USING btree (tag);


--
-- Name: tags_track_idx; Type: INDEX; Schema: public; Owner: librefm; Tablespace: 
--

CREATE INDEX tags_track_idx ON tags USING btree (track);


--
-- Name: track_Album_idx; Type: INDEX; Schema: public; Owner: librefm; Tablespace: 
--

CREATE INDEX "track_Album_idx" ON track USING btree (album_name);


--
-- Name: track_album_idx; Type: INDEX; Schema: public; Owner: librefm; Tablespace: 
--

CREATE INDEX track_album_idx ON track USING btree (lower((album_name)::text));


--
-- Name: track_artist_idx; Type: INDEX; Schema: public; Owner: librefm; Tablespace: 
--

CREATE INDEX track_artist_idx ON track USING btree (lower((artist_name)::text));


--
-- Name: track_artist_idx2; Type: INDEX; Schema: public; Owner: librefm; Tablespace: 
--

CREATE INDEX track_artist_idx2 ON track USING btree (artist_name);


--
-- Name: track_name_album_artist_idx; Type: INDEX; Schema: public; Owner: librefm; Tablespace: 
--

CREATE INDEX track_name_album_artist_idx ON track USING btree (name, album_name, artist_name);


--
-- Name: track_name_idx; Type: INDEX; Schema: public; Owner: librefm; Tablespace: 
--

CREATE INDEX track_name_idx ON track USING btree (lower((name)::text));


--
-- Name: track_streamable_idx; Type: INDEX; Schema: public; Owner: librefm; Tablespace: 
--

CREATE INDEX track_streamable_idx ON track USING btree (streamable);


--
-- Name: users_uniq_idx; Type: INDEX; Schema: public; Owner: librefm; Tablespace: 
--

CREATE UNIQUE INDEX users_uniq_idx ON users USING btree (lower((username)::text));


--
-- Name: update_user_stats_scrobble_count; Type: TRIGGER; Schema: public; Owner: librefm
--

CREATE TRIGGER update_user_stats_scrobble_count AFTER INSERT ON scrobbles FOR EACH ROW EXECUTE PROCEDURE update_user_stats_scrobble_count();


--
-- Name: artist_bio_artist_fkey; Type: FK CONSTRAINT; Schema: public; Owner: librefm
--

ALTER TABLE ONLY artist_bio
    ADD CONSTRAINT artist_bio_artist_fkey FOREIGN KEY (artist) REFERENCES artist(id);


--
-- Name: now_playing_sessionid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: librefm
--

ALTER TABLE ONLY now_playing
    ADD CONSTRAINT now_playing_sessionid_fkey FOREIGN KEY (sessionid) REFERENCES scrobble_sessions(sessionid) ON DELETE CASCADE;


--
-- Name: scrobble_sessions_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: librefm
--

ALTER TABLE ONLY scrobble_sessions
    ADD CONSTRAINT scrobble_sessions_userid_fkey FOREIGN KEY (userid) REFERENCES users(uniqueid);


--
-- Name: scrobbles_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: librefm
--

ALTER TABLE ONLY scrobbles
    ADD CONSTRAINT scrobbles_userid_fkey FOREIGN KEY (userid) REFERENCES users(uniqueid);


--
-- Name: service_connections_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: librefm
--

ALTER TABLE ONLY service_connections
    ADD CONSTRAINT service_connections_userid_fkey FOREIGN KEY (userid) REFERENCES users(uniqueid);


--
-- Name: user_relationship_flags_flag_fkey; Type: FK CONSTRAINT; Schema: public; Owner: librefm
--

ALTER TABLE ONLY user_relationship_flags
    ADD CONSTRAINT user_relationship_flags_flag_fkey FOREIGN KEY (flag) REFERENCES relationship_flags(flag);


--
-- Name: user_relationship_flags_uid1_fkey; Type: FK CONSTRAINT; Schema: public; Owner: librefm
--

ALTER TABLE ONLY user_relationship_flags
    ADD CONSTRAINT user_relationship_flags_uid1_fkey FOREIGN KEY (uid1, uid2) REFERENCES user_relationships(uid1, uid2);


--
-- Name: user_relationships_uid1_fkey; Type: FK CONSTRAINT; Schema: public; Owner: librefm
--

ALTER TABLE ONLY user_relationships
    ADD CONSTRAINT user_relationships_uid1_fkey FOREIGN KEY (uid1) REFERENCES users(uniqueid) ON DELETE CASCADE;


--
-- Name: user_relationships_uid2_fkey; Type: FK CONSTRAINT; Schema: public; Owner: librefm
--

ALTER TABLE ONLY user_relationships
    ADD CONSTRAINT user_relationships_uid2_fkey FOREIGN KEY (uid2) REFERENCES users(uniqueid) ON DELETE CASCADE;


--
-- Name: user_stats_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: librefm
--

ALTER TABLE ONLY user_stats
    ADD CONSTRAINT user_stats_userid_fkey FOREIGN KEY (userid) REFERENCES users(uniqueid) ON DELETE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: populate_user_stats(); Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON FUNCTION populate_user_stats() FROM PUBLIC;
REVOKE ALL ON FUNCTION populate_user_stats() FROM librefm;
GRANT ALL ON FUNCTION populate_user_stats() TO librefm;
GRANT ALL ON FUNCTION populate_user_stats() TO PUBLIC;


--
-- Name: update_user_stats_scrobble_count(); Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON FUNCTION update_user_stats_scrobble_count() FROM PUBLIC;
REVOKE ALL ON FUNCTION update_user_stats_scrobble_count() FROM librefm;
GRANT ALL ON FUNCTION update_user_stats_scrobble_count() TO librefm;
GRANT ALL ON FUNCTION update_user_stats_scrobble_count() TO PUBLIC;


--
-- Name: accountactivation; Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON TABLE accountactivation FROM PUBLIC;
REVOKE ALL ON TABLE accountactivation FROM librefm;
GRANT ALL ON TABLE accountactivation TO librefm;


--
-- Name: album; Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON TABLE album FROM PUBLIC;
REVOKE ALL ON TABLE album FROM librefm;
GRANT ALL ON TABLE album TO librefm;


--
-- Name: album_id_seq; Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON SEQUENCE album_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE album_id_seq FROM librefm;
GRANT ALL ON SEQUENCE album_id_seq TO librefm;


--
-- Name: artist; Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON TABLE artist FROM PUBLIC;
REVOKE ALL ON TABLE artist FROM librefm;
GRANT ALL ON TABLE artist TO librefm;


--
-- Name: artist_bio; Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON TABLE artist_bio FROM PUBLIC;
REVOKE ALL ON TABLE artist_bio FROM librefm;
GRANT ALL ON TABLE artist_bio TO librefm;


--
-- Name: artist_id_seq; Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON SEQUENCE artist_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE artist_id_seq FROM librefm;
GRANT ALL ON SEQUENCE artist_id_seq TO librefm;


--
-- Name: auth; Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON TABLE auth FROM PUBLIC;
REVOKE ALL ON TABLE auth FROM librefm;
GRANT ALL ON TABLE auth TO librefm;


--
-- Name: banned_tracks; Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON TABLE banned_tracks FROM PUBLIC;
REVOKE ALL ON TABLE banned_tracks FROM librefm;
GRANT ALL ON TABLE banned_tracks TO librefm;


--
-- Name: clientcodes; Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON TABLE clientcodes FROM PUBLIC;
REVOKE ALL ON TABLE clientcodes FROM librefm;
GRANT ALL ON TABLE clientcodes TO librefm;


--
-- Name: countries; Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON TABLE countries FROM PUBLIC;
REVOKE ALL ON TABLE countries FROM librefm;
GRANT ALL ON TABLE countries TO librefm;


--
-- Name: delete_request; Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON TABLE delete_request FROM PUBLIC;
REVOKE ALL ON TABLE delete_request FROM librefm;
GRANT ALL ON TABLE delete_request TO librefm;


--
-- Name: domain_blacklist; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE domain_blacklist FROM PUBLIC;
REVOKE ALL ON TABLE domain_blacklist FROM postgres;
GRANT ALL ON TABLE domain_blacklist TO postgres;
GRANT ALL ON TABLE domain_blacklist TO librefm;


--
-- Name: error; Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON TABLE error FROM PUBLIC;
REVOKE ALL ON TABLE error FROM librefm;
GRANT ALL ON TABLE error TO librefm;


--
-- Name: error_id_seq; Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON SEQUENCE error_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE error_id_seq FROM librefm;
GRANT ALL ON SEQUENCE error_id_seq TO librefm;


--
-- Name: scrobble_track; Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON TABLE scrobble_track FROM PUBLIC;
REVOKE ALL ON TABLE scrobble_track FROM librefm;
GRANT ALL ON TABLE scrobble_track TO librefm;


--
-- Name: scrobbles; Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON TABLE scrobbles FROM PUBLIC;
REVOKE ALL ON TABLE scrobbles FROM librefm;
GRANT ALL ON TABLE scrobbles TO librefm;


--
-- Name: track; Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON TABLE track FROM PUBLIC;
REVOKE ALL ON TABLE track FROM librefm;
GRANT ALL ON TABLE track TO librefm;


--
-- Name: free_scrobbles; Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON TABLE free_scrobbles FROM PUBLIC;
REVOKE ALL ON TABLE free_scrobbles FROM librefm;
GRANT ALL ON TABLE free_scrobbles TO librefm;


--
-- Name: group_members; Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON TABLE group_members FROM PUBLIC;
REVOKE ALL ON TABLE group_members FROM librefm;
GRANT ALL ON TABLE group_members TO librefm;


--
-- Name: groups; Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON TABLE groups FROM PUBLIC;
REVOKE ALL ON TABLE groups FROM librefm;
GRANT ALL ON TABLE groups TO librefm;


--
-- Name: groups_id_seq; Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON SEQUENCE groups_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE groups_id_seq FROM librefm;
GRANT ALL ON SEQUENCE groups_id_seq TO librefm;


--
-- Name: invitation_request; Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON TABLE invitation_request FROM PUBLIC;
REVOKE ALL ON TABLE invitation_request FROM librefm;
GRANT ALL ON TABLE invitation_request TO librefm;


--
-- Name: invitations; Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON TABLE invitations FROM PUBLIC;
REVOKE ALL ON TABLE invitations FROM librefm;
GRANT ALL ON TABLE invitations TO librefm;


--
-- Name: loved_tracks; Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON TABLE loved_tracks FROM PUBLIC;
REVOKE ALL ON TABLE loved_tracks FROM librefm;
GRANT ALL ON TABLE loved_tracks TO librefm;


--
-- Name: manages; Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON TABLE manages FROM PUBLIC;
REVOKE ALL ON TABLE manages FROM librefm;
GRANT ALL ON TABLE manages TO librefm;


--
-- Name: now_playing; Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON TABLE now_playing FROM PUBLIC;
REVOKE ALL ON TABLE now_playing FROM librefm;
GRANT ALL ON TABLE now_playing TO librefm;


--
-- Name: places; Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON TABLE places FROM PUBLIC;
REVOKE ALL ON TABLE places FROM librefm;
GRANT ALL ON TABLE places TO librefm;


--
-- Name: radio_sessions; Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON TABLE radio_sessions FROM PUBLIC;
REVOKE ALL ON TABLE radio_sessions FROM librefm;
GRANT ALL ON TABLE radio_sessions TO librefm;


--
-- Name: recovery_request; Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON TABLE recovery_request FROM PUBLIC;
REVOKE ALL ON TABLE recovery_request FROM librefm;
GRANT ALL ON TABLE recovery_request TO librefm;


--
-- Name: relationship_flags; Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON TABLE relationship_flags FROM PUBLIC;
REVOKE ALL ON TABLE relationship_flags FROM librefm;
GRANT ALL ON TABLE relationship_flags TO librefm;


--
-- Name: scrobble_sessions; Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON TABLE scrobble_sessions FROM PUBLIC;
REVOKE ALL ON TABLE scrobble_sessions FROM librefm;
GRANT ALL ON TABLE scrobble_sessions TO librefm;


--
-- Name: scrobble_track_id_seq; Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON SEQUENCE scrobble_track_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE scrobble_track_id_seq FROM librefm;
GRANT ALL ON SEQUENCE scrobble_track_id_seq TO librefm;


--
-- Name: service_connections; Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON TABLE service_connections FROM PUBLIC;
REVOKE ALL ON TABLE service_connections FROM librefm;
GRANT ALL ON TABLE service_connections TO librefm;


--
-- Name: similar_artist; Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON TABLE similar_artist FROM PUBLIC;
REVOKE ALL ON TABLE similar_artist FROM librefm;
GRANT ALL ON TABLE similar_artist TO librefm;


--
-- Name: tags; Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON TABLE tags FROM PUBLIC;
REVOKE ALL ON TABLE tags FROM librefm;
GRANT ALL ON TABLE tags TO librefm;


--
-- Name: track_id_seq; Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON SEQUENCE track_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE track_id_seq FROM librefm;
GRANT ALL ON SEQUENCE track_id_seq TO librefm;


--
-- Name: user_relationship_flags; Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON TABLE user_relationship_flags FROM PUBLIC;
REVOKE ALL ON TABLE user_relationship_flags FROM librefm;
GRANT ALL ON TABLE user_relationship_flags TO librefm;


--
-- Name: user_relationships; Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON TABLE user_relationships FROM PUBLIC;
REVOKE ALL ON TABLE user_relationships FROM librefm;
GRANT ALL ON TABLE user_relationships TO librefm;


--
-- Name: user_stats; Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON TABLE user_stats FROM PUBLIC;
REVOKE ALL ON TABLE user_stats FROM librefm;
GRANT ALL ON TABLE user_stats TO librefm;


--
-- Name: users; Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON TABLE users FROM PUBLIC;
REVOKE ALL ON TABLE users FROM librefm;
GRANT ALL ON TABLE users TO librefm;


--
-- Name: users_uniqueid_seq; Type: ACL; Schema: public; Owner: librefm
--

REVOKE ALL ON SEQUENCE users_uniqueid_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE users_uniqueid_seq FROM librefm;
GRANT ALL ON SEQUENCE users_uniqueid_seq TO librefm;


--
-- PostgreSQL database dump complete
--

